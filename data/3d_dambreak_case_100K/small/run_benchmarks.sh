#!/bin/bash
pushd ../..
source .env
popd

params="precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6"

for i in 0 2; do
    reuse     $params -i ${i} -s 4 -f 2>cpu-${i}-full.time | tee cpu-${i}-full.log
    reuse     $params -i ${i} -s 4    2>cpu-${i}-part.time | tee cpu-${i}-part.log
    reuse_gpu $params -i ${i} -s 4 -f 2>gpu-${i}-full.time | tee gpu-${i}-full.log
    reuse_gpu $params -i ${i} -s 4    2>gpu-${i}-part.time | tee gpu-${i}-part.log
done
