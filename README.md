# Does Experience Always Help? Revisiting Evolutionary Sequential Transfer Optimization

This repository contains all the MATLAB implementations used in the above article, which consists of the following four main parts:

* generation of S-ESTO problems
* revisiting a variety of S-ESTO algorithms on the generated problems
* analysis and visualization of the obtained results
* illustrative examples

## Generation of S-ESTO Problems
A solution-based sequential transfer optimization problem (S-ESTOP) can be built by configuring six aspects: target instance, transfer scenario, source generation scheme, the parameter that governs optimum coverage, problem dimension, and the number of source instances. Their realizations in the above article are given by:

* target instance: `Sphere`, `Ellipsoid`, `Schwefel`, `Quartic`, `Ackley`, `Rastrigin`, `Griewank`, and `Levy`
* transfer scenario: `intra-family transfer` and `inter-family transfer`
* source generation scheme: `constrained generation` and `unconstrained generation`
* the parameter that governs optimum coverage: `0`, `0.1`, `0.3`, `0.7`, and `1`
* problem dimension: `5`, `10`, and `20`
* the number of source instances: `1000`

In this way, 480 independent S-ESTOPs can be instantiated using the class [SESTOP](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/utils/SESTOP.m). The script of generating the 480 S-ESTOPs is [main_generation_sestop](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_generation_sestop.m).

## Revisiting S-ESTO Algorithms
In this work, we revisited a variety of S-ESTO algorithms by answering five central research questions (RQs) on the generated problems, which are given as follows:

* ***RQ1***: How do S-ESTO algorithms driven by solution selection perform across various problems?
* ***RQ2***: Which property of similarity metrics used for solution selection is essential to their effectivenesses?
* ***RQ3***: How do S-ESTO algorithms driven by solution adaptation perform across various problems?
* ***RQ4***: Which property of solution adaptation models is essential to their effectivenesses?
* ***RQ5***: How to properly integrate solution selection and solution adaptation?

The 
