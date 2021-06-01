#!/bin/bash
pushd ../..
source .env
popd

params="precond.coarse_enough=500 precond.coarsening.type=aggregation precond.coarsening.aggr.eps_strong=0 precond.relax.type=damped_jacobi solver.tol=1e-6"

reuse_b4     $params -i 0 -s 2 -f 2>cpu-0-full.time | tee cpu-0-full.log
reuse_b4     $params -i 0 -s 2    2>cpu-0-part.time | tee cpu-0-part.log
reuse_b4_gpu $params -i 0 -s 2 -f 2>gpu-0-full.time | tee gpu-0-full.log
reuse_b4_gpu $params -i 0 -s 2    2>gpu-0-part.time | tee gpu-0-part.log
