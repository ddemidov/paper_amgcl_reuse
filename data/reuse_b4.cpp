#include <iostream>
#include <sstream>
#include <memory>
#include <vector>
#include <tuple>

#include <boost/program_options.hpp>
#include <boost/property_tree/ptree.hpp>

#include <amgcl/make_solver.hpp>
#include <amgcl/amg.hpp>
#include <amgcl/relaxation/runtime.hpp>
#include <amgcl/coarsening/runtime.hpp>
#include <amgcl/solver/runtime.hpp>
#include <amgcl/adapter/crs_tuple.hpp>
#include <amgcl/profiler.hpp>
#include <amgcl/io/binary.hpp>

#include <amgcl/adapter/block_matrix.hpp>
#include <amgcl/value_type/static_matrix.hpp>

#if defined(SOLVER_BACKEND_VEXCL)
#  include <amgcl/backend/vexcl.hpp>
#  include <amgcl/backend/vexcl_static_matrix.hpp>
#else
#  include <amgcl/backend/builtin.hpp>
#endif

using amgcl::precondition;

//---------------------------------------------------------------------------
ptrdiff_t read_problem(int k,
        std::vector<ptrdiff_t> &ptr,
        std::vector<ptrdiff_t> &col,
        std::vector<double>    &val,
        std::vector<double>    &rhs
        )
{
    namespace io = amgcl::io;

    std::ostringstream Afile, bfile;
    Afile << "A-" << k << ".bin";
    bfile << "b-" << k << ".bin";

    ptrdiff_t rows, n, m;
    io::read_crs(Afile.str(), rows, ptr, col, val);
    io::read_dense(bfile.str(), n, m, rhs);

    precondition(rows == n && m == 1, "Wrong input sizes");
    return rows;
}

//---------------------------------------------------------------------------
int main(int argc, char *argv[]) {
    namespace po = boost::program_options;
    po::options_description desc("Options");
    desc.add_options()
        ("help,h", "Show this help.")
        (
         "prm,p",
         po::value<std::vector<std::string> >()->multitoken(),
         "Parameters specified as name=value pairs. "
         "May be provided multiple times. Examples:\n"
         "  -p solver.tol=1e-3\n"
         "  -p precond.coarse_enough=300"
        )
        (
         "full-rebuild,f",
         po::bool_switch()->default_value(false),
         "Full rebuild on every iteration. "
        )
        (
         "init,i",
         po::value<int>()->default_value(0),
         "First input matrix"
        )
        (
         "step,s",
         po::value<int>()->default_value(1),
         "Stride over input matrices"
        )
        (
         "renew,n",
         po::value<int>()->default_value(10),
         "Renew hierarchy every n steps"
        )
        ;

    po::positional_options_description p;
    p.add("prm", -1);

    po::variables_map vm;
    po::store(po::command_line_parser(argc, argv).options(desc).positional(p).run(), vm);
    po::notify(vm);

    if (vm.count("help")) {
        std::cout << desc << std::endl;
        return 0;
    }

    boost::property_tree::ptree prm;
    if (vm.count("prm")) {
        for(const auto &v : vm["prm"].as<std::vector<std::string> >()) {
            amgcl::put(prm, v);
        }
    }

    int init = vm["init"].as<int>();
    int step = vm["step"].as<int>();
    int renew = vm["renew"].as<int>();
    bool rebuild = vm["full-rebuild"].as<bool>();
    prm.put("precond.allow_rebuild", !rebuild);

    // Define the backend and solver types:
    const int B = 4;
    typedef amgcl::static_matrix<double, B, B> mat_type;
    typedef amgcl::static_matrix<double, B, 1> vec_type;

#if defined(SOLVER_BACKEND_VEXCL)
    typedef amgcl::backend::vexcl<mat_type> Backend;
#else
    typedef amgcl::backend::builtin<mat_type> Backend;
#endif

    Backend::params bprm;

#if defined(SOLVER_BACKEND_VEXCL)
    vex::Context ctx(vex::Filter::Env);
    bprm.q = ctx;

    vex::scoped_program_header header(ctx,
            amgcl::backend::vexcl_static_matrix_declaration<double,B>());
#endif

    typedef amgcl::make_solver<
        amgcl::amg<
            Backend,
            amgcl::runtime::coarsening::wrapper,
            amgcl::runtime::relaxation::wrapper
            >,
        amgcl::runtime::solver::wrapper<Backend>
        > Solver;

    std::shared_ptr<Solver> solve;
    amgcl::profiler<> prof;
    size_t iters = 0;
    double error;

    size_t rows, b_rows;
    std::vector<ptrdiff_t> ptr, col;
    std::vector<double> val, rhs;

    for(int time = init, j = 0; ; time += step, ++j) {
        // Read the next system
        try {
            auto t = prof.scoped_tic("reading");
            rows = read_problem(time, ptr, col, val, rhs);
        } catch(...) {
            break;
        }

        auto A = std::tie(rows, ptr, col, val);
        auto Ab = amgcl::adapter::block_matrix<mat_type>(A);
        b_rows = amgcl::backend::rows(Ab);

        // Rebuild the solver, if necessary
        bool full = false;
        if ( rebuild || !solve || solve->size() != b_rows || j % renew == 0 ) {
            full = true;
            auto t1 = prof.scoped_tic("amgcl");
            auto t2 = prof.scoped_tic("setup");
            auto t3 = prof.scoped_tic("full");
            solve = std::make_shared<Solver>(Ab, prm, bprm);
        } else {
            auto t1 = prof.scoped_tic("amgcl");
            auto t2 = prof.scoped_tic("setup");
            auto t3 = prof.scoped_tic("partial");
            solve->precond().rebuild(Ab, bprm);
        }

        auto f = Backend::create_vector(b_rows, bprm);
        auto fptr = reinterpret_cast<const vec_type*>(&rhs[0]);
#if defined(SOLVER_BACKEND_VEXCL)
        vex::copy(fptr, fptr + b_rows, f->begin());
#else
        std::copy(fptr, fptr + b_rows, &(*f)[0]);
#endif

        auto x = Backend::create_vector(b_rows, bprm);
        amgcl::backend::clear(*x);

        // solve the problem:
        {
            auto t1 = prof.scoped_tic("amgcl");
            auto t2 = prof.scoped_tic("solve");
            std::tie(iters, error) = (*solve)(*f, *x);
        }

        std::cout << time << "\t" << full << "\t" << iters << "\t" << error << std::endl;
    }

    std::cerr << prof << std::endl;
}
