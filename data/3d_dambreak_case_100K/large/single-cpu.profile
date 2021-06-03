solver -B -A A-3.bin -f b-3.bin precond.coarse_enough=1000 precond.coarsening.type=aggregation precond.coarsening.aggr.eps_strong=0 precond.relax.type=damped_jacobi solver.tol=1e-6 -b4
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
Memory footprint:    246.54 M

level     unknowns       nonzeros      memory
---------------------------------------------
    0       104401        1331279    223.70 M (94.02%)
    1         6860          78820     13.58 M ( 5.57%)
    2          520           5794      9.27 M ( 0.41%)

Iterations: 39
Error:      7.25675e-07

[Profile:                    3.964 s] (100.00%)
[  reading:                  0.177 s] (  4.47%)
[  setup:                    0.186 s] (  4.70%)
[   self:                    0.071 s] (  1.80%)
[    coarse operator:        0.041 s] (  1.03%)
[    coarsest level:         0.034 s] (  0.87%)
[    move to backend:        0.001 s] (  0.02%)
[    relaxation:             0.007 s] (  0.17%)
[    transfer operators:     0.033 s] (  0.82%)
[     self:                  0.006 s] (  0.14%)
[      aggregates:           0.026 s] (  0.64%)
[      interpolation:        0.001 s] (  0.04%)
[        tentative:          0.001 s] (  0.03%)
[  solve:                    3.598 s] ( 90.78%)
[    axpby:                  0.030 s] (  0.76%)
[    axpbypcz:               0.076 s] (  1.93%)
[    clear:                  0.025 s] (  0.64%)
[    coarse:                 0.050 s] (  1.27%)
[    copy:                   0.001 s] (  0.04%)
[    inner_product:          0.062 s] (  1.57%)
[    relax:                  1.716 s] ( 43.28%)
[      residual:             1.528 s] ( 38.54%)
[      vmul:                 0.188 s] (  4.73%)
[    residual:               0.765 s] ( 19.30%)
[    spmv:                   0.871 s] ( 21.97%)


