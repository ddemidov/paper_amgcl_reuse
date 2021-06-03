solver_vexcl_cuda -B -A A-3.bin -f b-3.bin precond.coarse_enough=1000 precond.coarsening.type=aggregation precond.coarsening.aggr.eps_strong=0 precond.relax.type=damped_jacobi solver.tol=1e-6 -b4
1. NVIDIA GeForce GTX 1050 Ti

Solver
======
Type:             BiCGStab
Unknowns:         104401
Memory footprint: 22.30 M

Preconditioner
==============
Number of levels:    3
Operator complexity: 1.06
Grid complexity:     1.07
Memory footprint:    246.58 M

level     unknowns       nonzeros      memory
---------------------------------------------
    0       104401        1331279    223.70 M (94.02%)
    1         6860          78820     13.58 M ( 5.57%)
    2          520           5794      9.30 M ( 0.41%)

Iterations: 39
Error:      7.25675e-07

[Profile:                    1.646 s] (100.00%)
[ self:                      0.084 s] (  5.09%)
[  reading:                  0.179 s] ( 10.86%)
[  setup:                    0.305 s] ( 18.55%)
[   self:                    0.081 s] (  4.92%)
[    coarse operator:        0.038 s] (  2.29%)
[    coarsest level:         0.037 s] (  2.28%)
[    move to backend:        0.105 s] (  6.39%)
[    relaxation:             0.012 s] (  0.74%)
[    transfer operators:     0.032 s] (  1.94%)
[     self:                  0.006 s] (  0.38%)
[      aggregates:           0.023 s] (  1.42%)
[      interpolation:        0.002 s] (  0.15%)
[        tentative:          0.002 s] (  0.14%)
[  solve:                    1.078 s] ( 65.51%)
[    axpby:                  0.001 s] (  0.04%)
[    axpbypcz:               0.001 s] (  0.04%)
[    clear:                  0.001 s] (  0.05%)
[    coarse:                 0.558 s] ( 33.90%)
[    copy:                   0.002 s] (  0.15%)
[    inner_product:          0.503 s] ( 30.56%)
[    relax:                  0.005 s] (  0.33%)
[      residual:             0.001 s] (  0.08%)
[      vmul:                 0.004 s] (  0.25%)
[    residual:               0.001 s] (  0.04%)
[    spmv:                   0.006 s] (  0.36%)


