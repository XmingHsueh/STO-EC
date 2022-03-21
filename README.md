# How to Utilize Optimization Experience? Revisiting Evolutionary Sequential Transfer Optimization

This repository contains all the MATLAB implementations used in the above article, which consists of the following four main steps:

* ***Step 1***: generation of black-box STO problems
* ***Step 2***: revisiting a variety of S-ESTO algorithms on the generated problems
* ***Step 3***: analysis and visualization of the obtained results
* ***Step 4***: illustrative examples

## Step 1: Generation of Black-Box STO Problems
A black-box sequential transfer optimization problem (STOP) can be built by configuring the following six aspects: target task, transfer scenario, generation scheme, the parameter of controlling optimum coverage, problem dimension, and the number of source tasks. Their realizations in the above article are given by:

* target task: `Sphere`, `Ellipsoid`, `Schwefel`, `Quartic`, `Ackley`, `Rastrigin`, `Griewank`, and `Levy`
* transfer scenario: `intra-family transfer` and `inter-family transfer`
* generation scheme: `constrained generation` and `unconstrained generation`
* the parameter of controlling optimum coverage: `0`, `0.1`, `0.3`, `0.7`, and `1`
* problem dimension: `5`, `10`, and `20`
* the number of source tasks: `1000`

In this way, 480 independent problems can be instantiated using the class [STOP](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/utils/SESTOP.m). The script of generating the 480 problems is [main_generation_stop](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_generation_sestop.m).

## Step 2: Revisiting S-ESTO Algorithms
In this work, we revisited a variety of S-ESTO algorithms by answering five central research questions (RQs) on the generated problems, which are given as follows:

* ***RQ1***: How do similarity metrics in solution selection perform across various problems?
* ***RQ2***: Which property is essential to the effectiveness of similarity metrics?
* ***RQ3***: How do adaptation techniques in solution adaptation perform across various problems?
* ***RQ4***: Which property of solution adaptation models is essential to their effectiveness?
* ***RQ5***: How to properly integrate solution selection and solution adaptation?

Specifically, the first two RQs are about solution selection while the the third and fourth RQs focus on solution adaptation. The integration of solution selection and solution adaptation is investigated by the last RQ. From the perspective of the two core components, we divide the RQs and their implementations into three groups:

|Solution Selection|Solution Adaptation|Integration|
|:-|:-|:-|
|***RQ1***, ***RQ2***|***RQ3***, ***RQ4***|***RQ5***|
|[main_RQ1](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ1.m), [main_RQ2_corr](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ2_corr.m), [main_RQ2_ccc](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ2_ccc.m)|[main_RQ3](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ3.m), [main_RQ4_example1d](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ4_example1d.m), [main_RQ4_mappings](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ4_mappings.m)|[main_RQ5](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ5.m)|

## Step 3: Analysis and Visualization of the Results
For clarity, we analyzed and visualized the results of the five RQs independently. These postprocessing scripts are summarized as follows:

|***RQ1***|***RQ2***|***RQ3***|***RQ4***|***RQ5***|
|:-|:-|:-|:-|:-|
|[rq1_convergence_curves](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq1_convergence_curves.m), [rq1_performance_ranks_boxplots](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq1_performance_ranks_boxplots.m), [rq1_performance_ranks_radars](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq1_performance_ranks_radars.m), [rq1_success_rates_bars](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq1_success_rates_bars.m)|[rq2_ccc_curves](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq2_ccc_curves.m), [rq2_corr_scatters](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq2_corr_scatters.m)|[rq3_convergence_curves](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq3_convergence_curves.m), [rq3_performance_ranks_boxplots](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq3_performance_ranks_boxplots.m), [rq3_performance_ranks_radars](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq3_performance_ranks_radars.m), [rq3_success_rates_bars](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq3_success_rates_bars.m)|[main_RQ4_example1d](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ4_example1d.m), [main_RQ4_mappings](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/main_RQ4_mappings.m)|[rq5_convergence_curves](https://github.com/XmingHsueh/Revisiting-S-ESTOs/blob/main/experimental%20studies/rq5_convergence_curves.m)|

## Step 4: Illustrative Examples
A number of illustrative examples used in the main paper and the supplementary document are provided in this repository, which can be found in the folder '.\illustrative examples'.

## Citation

If you find this repo useful for your research, please consider to cite:
```latex
@article{Xue2022,
title = {Does Experience Always Help? Revisiting Evolutionary Sequential Transfer Optimization},
author = {Xue, Xiaoming and Hu, Yao and Yang, Cuie and Feng, Liang and Chen, Guodong and Zhang, Kai and Song, Linqi and Tan, Kay Chen}
journal = {...},
volume = {1},
pages = {1 - 20},
year = {2022},
doi = {https://...},
url = {http://...},
}
```

## Acknowledgments

...
