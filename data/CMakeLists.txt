find_package(amgcl)
find_package(VexCL)
find_package(Boost COMPONENTS program_options)

add_executable(reuse reuse.cpp)
target_link_libraries(reuse amgcl::amgcl Boost::program_options)

add_executable(reuse_gpu reuse.cpp)
target_compile_definitions(reuse_gpu PRIVATE SOLVER_BACKEND_VEXCL)
target_link_libraries(reuse_gpu amgcl::amgcl VexCL::OpenCL Boost::program_options)
