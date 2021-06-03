find_package(amgcl)
find_package(VexCL)
find_package(Boost COMPONENTS program_options)

add_executable(reuse reuse.cpp)
target_link_libraries(reuse amgcl::amgcl Boost::program_options)

add_executable(reuse_gpu reuse.cpp)
target_compile_definitions(reuse_gpu PRIVATE SOLVER_BACKEND_VEXCL)
target_link_libraries(reuse_gpu amgcl::amgcl VexCL::CUDA Boost::program_options)

add_executable(reuse_b4 reuse_b4.cpp)
target_link_libraries(reuse_b4 amgcl::amgcl Boost::program_options)

add_executable(reuse_b4_gpu reuse_b4.cpp)
target_compile_definitions(reuse_b4_gpu PRIVATE SOLVER_BACKEND_VEXCL)
target_link_libraries(reuse_b4_gpu amgcl::amgcl VexCL::CUDA Boost::program_options)

add_executable(full full.cpp)
target_link_libraries(full amgcl::amgcl Boost::program_options)

add_executable(full_gpu full.cpp)
target_compile_definitions(full_gpu PRIVATE SOLVER_BACKEND_VEXCL)
target_link_libraries(full_gpu amgcl::amgcl VexCL::CUDA Boost::program_options)

add_executable(full_b4 full_b4.cpp)
target_link_libraries(full_b4 amgcl::amgcl Boost::program_options)

add_executable(full_b4_gpu full_b4.cpp)
target_compile_definitions(full_b4_gpu PRIVATE SOLVER_BACKEND_VEXCL)
target_link_libraries(full_b4_gpu amgcl::amgcl VexCL::CUDA Boost::program_options)

