#!/bin/bash
pushd ../..
source .env
popd

params="precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6"

for i in 0 2; do
    reuse     $params -i ${i} -s 4 -n 100  -f 2>cpu-${i}-none.time | tee cpu-${i}-none.log
    reuse_gpu $params -i ${i} -s 4 -n 100  -f 2>gpu-${i}-none.time | tee gpu-${i}-none.log

    reuse     $params -i ${i} -s 4 -n 100     2>cpu-${i}-part.time | tee cpu-${i}-part.log
    reuse_gpu $params -i ${i} -s 4 -n 100     2>gpu-${i}-part.time | tee gpu-${i}-part.log

    reuse     $params -i ${i} -s 4 -n 100  -n 20 2>cpu-${i}-part-20.time | tee cpu-${i}-part-20.log
    reuse_gpu $params -i ${i} -s 4 -n 100  -n 20 2>gpu-${i}-part-20.time | tee gpu-${i}-part-20.log
done

full     $params -i 0 -s 4 -l 10 2>cpu-0-full.time | tee cpu-0-full.log
full_gpu $params -i 0 -s 4 -l 10 2>gpu-0-full.time | tee gpu-0-full.log

full     $params -i 2 -s 4 -l 20 2>cpu-2-full.time | tee cpu-2-full.log
full_gpu $params -i 2 -s 4 -l 20 2>gpu-2-full.time | tee gpu-2-full.log
