#!/bin/bash
source .env

reuse_flow_bm precond.coarsening.type=aggregation solver.{type=cg,tol=1e-6} 2>cpu-reuse.time | tee cpu-reuse.log
reuse_flow_bm precond.coarsening.type=aggregation solver.{type=cg,tol=1e-6} -f 2>cpu-full.time | tee cpu-full.log
