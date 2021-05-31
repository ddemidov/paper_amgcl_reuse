#!/bin/bash
pushd ../..
source .env
popd

for i in 0 2; do
    reuse     precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6 -i ${i} -s 4    2>cpu-${i}-part.time | tee cpu-${i}-part.log
    reuse     precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6 -i ${i} -s 4 -f 2>cpu-${i}-full.time | tee cpu-${i}-full.log
    reuse_gpu precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6 -i ${i} -s 4    2>gpu-${i}-part.time | tee gpu-${i}-part.log
    reuse_gpu precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6 -i ${i} -s 4 -f 2>gpu-${i}-full.time | tee gpu-${i}-full.log
done
