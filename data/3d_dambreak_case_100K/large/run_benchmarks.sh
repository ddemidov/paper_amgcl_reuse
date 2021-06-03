#!/bin/bash
pushd ../..
source .env
popd

params="precond.coarse_enough=1000 precond.coarsening.type=aggregation precond.coarsening.aggr.eps_strong=0 precond.relax.type=damped_jacobi solver.tol=1e-6"

reuse_b4     $params -i 0 -s 2 -f 2>cpu-0-none.time | tee cpu-0-none.log
reuse_b4_gpu $params -i 0 -s 2 -f 2>gpu-0-none.time | tee gpu-0-none.log

reuse_b4     $params -i 0 -s 2    2>cpu-0-part.time | tee cpu-0-part.log
reuse_b4_gpu $params -i 0 -s 2    2>gpu-0-part.time | tee gpu-0-part.log

reuse_b4     $params -i 0 -s 2 -n 20 2>cpu-0-part-20.time | tee cpu-0-part-20.log
reuse_b4_gpu $params -i 0 -s 2 -n 20 2>gpu-0-part-20.time | tee gpu-0-part-20.log

full_b4     $params -i 0 -s 2 -l 25 2>cpu-0-full.time | tee cpu-0-full.log
full_b4_gpu $params -i 0 -s 2 -l 25 2>gpu-0-full.time | tee gpu-0-full.log
