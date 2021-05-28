#include <iostream>
#include <sstream>
#include <memory>
#include <vector>
#include <tuple>

#include <boost/program_options.hpp>
#include <boost/property_tree/ptree.hpp>

#if defined(SOLVER_BACKEND_VEXCL)
#  include <amgcl/backend/vexcl.hpp>
#else
#  include <amgcl/backend/builtin.hpp>
#endif

#include <amgcl/make_solver.hpp>
#include <amgcl/amg.hpp>
#include <amgcl/relaxation/runtime.hpp>
#include <amgcl/coarsening/runtime.hpp>
#include <amgcl/solver/runtime.hpp>
#include <amgcl/adapter/crs_tuple.hpp>
#include <amgcl/profiler.hpp>
#include <amgcl/io/binary.hpp>

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

    bool rebuild = vm["full-rebuild"].as<bool>();
    prm.put("precond.allow_rebuild", !rebuild);

    // Define the backend and solver types:
#if defined(SOLVER_BACKEND_VEXCL)
    typedef amgcl::backend::vexcl<double> Backend;
#else
    typedef amgcl::backend::builtin<double> Backend;
#endif

    Backend::params bprm;

#if defined(SOLVER_BACKEND_VEXCL)
    vex::Context ctx(vex::Filter::Env);
    std::cout << ctx << std::endl;
    bprm.q = ctx;
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

    size_t rows;
    std::vector<ptrdiff_t> ptr, col;
    std::vector<double> val, rhs;

    for(int time = 0; ; ++time) {
        // Read the next system
        try {
            auto t = prof.scoped_tic("reading");
            rows = read_problem(time, ptr, col, val, rhs);
        } catch(...) {
            std::cout << "done";
            break;
        }

        auto A = std::tie(rows, ptr, col, val);

        // Rebuild the solver, if necessary
        if ( rebuild || !solve || solve->size() != rows ) {
            // Rebuild the solver
            auto t = prof.scoped_tic("setup");
            solve = std::make_shared<Solver>(A, prm, bprm);
        } else {
            auto t = prof.scoped_tic("rebuild");
            solve->precond().rebuild(A, bprm);
        }

        auto f = Backend::copy_vector(rhs, bprm);
        auto x = Backend::create_vector(rows, bprm);
        amgcl::backend::clear(*x);

        // solve the problem:
        {
            auto t = prof.scoped_tic("solve");
            std::tie(iters, error) = (*solve)(*f, *x);
        }

        std::cout << time << "\t" << iters << "\t" << error << std::endl;
    }

    std::cout << prof << std::endl;
}
