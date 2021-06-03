solver -B -A A-3.bin -f b-3.bin precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6
Solver
======
Type:             BiCGStab
Unknowns:         104401
Memory footprint: 5.58 M

Preconditioner
==============
Number of levels:    4
Operator complexity: 1.11
Grid complexity:     1.12
Memory footprint:    31.46 M

level     unknowns       nonzeros      memory
---------------------------------------------
    0       104401        1331279     28.20 M (90.01%)
    1        10768         129346      2.81 M ( 8.75%)
    2         1474          16330    372.05 K ( 1.10%)
    3          219           2117     93.38 K ( 0.14%)

Iterations: 16
Error:      1.56552e-07

[Profile:                    0.249 s] (100.00%)
[ self:                      0.001 s] (  0.35%)
[  reading:                  0.012 s] (  4.85%)
[  setup:                    0.031 s] ( 12.63%)
[   self:                    0.006 s] (  2.26%)
[    coarse operator:        0.009 s] (  3.74%)
[    coarsest level:         0.000 s] (  0.08%)
[    move to backend:        0.000 s] (  0.10%)
[    relaxation:             0.001 s] (  0.59%)
[    transfer operators:     0.015 s] (  5.87%)
[     self:                  0.004 s] (  1.49%)
[      aggregates:           0.010 s] (  4.10%)
[      interpolation:        0.001 s] (  0.28%)
[        tentative:          0.000 s] (  0.19%)
[  solve:                    0.204 s] ( 82.17%)
[   self:                    0.000 s] (  0.13%)
[    axpby:                  0.002 s] (  0.82%)
[    axpbypcz:               0.004 s] (  1.74%)
[    clear:                  0.000 s] (  0.17%)
[    coarse:                 0.000 s] (  0.13%)
[    copy:                   0.000 s] (  0.05%)
[    inner_product:          0.008 s] (  3.25%)
[    relax:                  0.095 s] ( 38.39%)
[      residual:             0.088 s] ( 35.59%)
[      vmul:                 0.007 s] (  2.72%)
[    residual:               0.045 s] ( 17.96%)
[    spmv:                   0.049 s] ( 19.54%)


