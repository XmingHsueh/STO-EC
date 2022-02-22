# Does Experience Always Help? Revisiting Evolutionary Sequential Transfer Optimization

This repository contains all the MATLAB implementations used in the above article, which consists of the following four main parts:

* generation of S-ESTO problems
* revisiting a variety of S-ESTO algorithms on the generated problems
* analysis and visualization of the obtained results
* illustrative examples

## Generation of S-ESTO problems
A solution-based sequential transfer optimization problem (S-ESTOP) can be built by configuring five aspects: target instance, transfer scenario, source generation scheme, the parameter that governs optimum coverage, problem dimension, and the number of source instances. Their realizations in the above article are given by:

* target instance: `Sphere`, `Ellipsoid`, `Schwefel`, `Quartic`, `Ackley`, `Rastrigin`, `Griewank`, and `Levy`
