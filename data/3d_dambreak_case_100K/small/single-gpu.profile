solver_vexcl_cuda -B -A A-3.bin -f b-3.bin precond.coarse_enough=500 precond.coarsening.type=aggregation precond.relax.type=damped_jacobi solver.tol=1e-6
1. NVIDIA GeForce GTX 1050 Ti

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
    3          219           2117     96.80 K ( 0.14%)

Iterations: 16
Error:      1.56552e-07

[Profile:                    0.197 s] (100.00%)
[ self:                      0.078 s] ( 39.62%)
[  reading:                  0.014 s] (  7.21%)
[  setup:                    0.045 s] ( 22.87%)
[   self:                    0.007 s] (  3.55%)
[    coarse operator:        0.009 s] (  4.50%)
[    coarsest level:         0.000 s] (  0.09%)
[    move to backend:        0.017 s] (  8.38%)
[    relaxation:             0.001 s] (  0.71%)
[    transfer operators:     0.011 s] (  5.64%)
[     self:                  0.001 s] (  0.35%)
[      aggregates:           0.010 s] (  5.07%)
[      interpolation:        0.000 s] (  0.23%)
[        tentative:          0.000 s] (  0.20%)
[  solve:                    0.060 s] ( 30.29%)
[    axpby:                  0.000 s] (  0.11%)
[    axpbypcz:               0.000 s] (  0.17%)
[    clear:                  0.000 s] (  0.19%)
[    coarse:                 0.026 s] ( 13.04%)
[    copy:                   0.000 s] (  0.16%)
[    inner_product:          0.030 s] ( 15.02%)
[    relax:                  0.001 s] (  0.68%)
[      residual:             0.001 s] (  0.27%)
[      vmul:                 0.001 s] (  0.38%)
[    residual:               0.000 s] (  0.24%)
[    spmv:                   0.001 s] (  0.63%)


