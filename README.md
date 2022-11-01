# How to Exploit Optimization Experience? Revisiting Evolutionary Sequential Transfer Optimization: Part B - Algorithm Analysis

This repository provides the MATLAB implementations of empirically investigating a wide variety of knowledge transfer techniques in the context of S-ESTO via five research questions (RQs). Particularly, different knowledge transfer techniques associated with the five RQs are organized from a component perspective of S-ESTO, including solution selection, solution adaptation, and the integration of them. The five RQs are organized from the component perspective and provided as follows:

|Component|Research Questions|
|:-|:-|
|Solution Selection|RQ1: How do existing similarity metrics perform in solution selection for S-ESTO?|
|Solution Selection|RQ2: Which factor is essential to the effectiveness of similarity metrics in S-ESTO?|
|Solution Adaptation|RQ3: How do existing adaptation techniques perform in solution adaptation for S-ESTO?|
|Solution Adaptation|RQ4: What contributes to the effectiveness of solution adaptation models in S-ESTO?|
|Integration of Selection and Adaptation|RQ5:  How to integrate solution selection and solution adaptation for S-ESTO?|

The first two RQs aim to investigate similarity metrics in selection-based approaches while the third and fourth RQs focus on adaptation models in adaptation-based approaches. To curb the negative transfer, solution selection and solution adaptation can be integrated. The last RQ focuses on investigating this integration.

## Solution Selection
In solution selection, seven similarity metrics are investigated in this study, which are given by,
|Similarity Metric|Description|Abbreviation|
|:-|:-|:-|
|Distance-based metric|The hamming distance [1]|S-C|
|Distance-based metric|The Euclidean distance [2-4]|S-M1|
|Distance-based metric|The Kullback-Leibler divergence [5, 6]|S-KLD|
|Distance-based metric|The Wasserstein distance [7, 8]|S-WD|
|Correlation-based metric|The ordinal correlation [9-14]|S-OC|
|Correlation-based metric|The relaxed ordinal correlation [15, 16]|S-ROC|
|Correlation-based metric|The subspace alignment [17, 18]|S-SA|

## Solution Adaptation
In solution adaptation, eleven adaptation models are investigated in this study, which are given by,
|Adaptation Objective|Description|Abbreviation|
|:-|:-|:-|
|The first moment|Translation transformation based on the estimated means of elite solutions [2]|A-M1-Tp|
|The first moment|Translation transformation based on the randomly selected elite individuals [3]|A-M1-Tr|
|The first moment|Translation transformation based on the population means|A-M1-Tm|
|The first moment|Multiplication transformation using the estimated means of selected solutions [4]|A-M1-M|
|The first two moments|Affine transformation [8]|A-M2-A|
|The ordinal correlation|Linear transformation [13]|A-OC-L|
|The ordinal correlation|Affine transformation [9]|A-OC-A|
|The ordinal correlation|Kernealization [10]|A-OC-K|
|The ordinal correlation|Neural network model [11, 12]|A-OC-N|
|The ordinal correlation|Linear transformations connected by a latent space [15, 16]|A-ROC-L|
|The subspace alignment|Linear transformations connected by the subspaces [17, 18]|A-SA-L|

## Integration of Solution Selection and Solution Adaptation
Three S+A integrations are investigated in this study, which are provided as follows:
|Integration|Similarity Metric|Adaptation Objective|
|:-|:-|:-|
|S-WD+A-OC-A [7]|S-WD|A-OC-A|
|S-M1+A-M1-Tm|S-M1|A-M1-Tm|
|S-WD+A-M2-A|S-WD|A-M2-A|

## References
[1] **Learning with case-injected genetic algorithms.** *S. J. Louis and J. McDonnell.* *TEVC* 2004. [paper](https://ieeexplore.ieee.org/abstract/document/1324694)

[2] **Generalized multitasking for evolutionary optimization of expensive problems.** *J. Ding, C. Yang, Y. Jin, and T. Chai.* *TEVC* 2019. [paper](https://ieeexplore.ieee.org/abstract/document/8231172)

[3] **Multifactorial evolutionary algorithm enhanced with cross-task search direction.** *J. Yin, A. Zhu, Z. Zhu, Y. Yu, and X. Ma.* *CEC* 2019. [paper](https://ieeexplore.ieee.org/abstract/document/8789959)

[4] **A hybrid of genetic transform and hyper-rectangle search strategies for evolutionary multi-tasking.** *Z. Liang, J. Zhang, L. Feng, and Z. Zhu.* *ESWA* 2019. [paper](https://www.sciencedirect.com/science/article/pii/S0957417419304944)

[5] **An adaptive archive-based evolutionary framework for many-task optimization.** *Y. Chen, J. Zhong, L. Feng, and J. Zhang.* *TETCI* 2020. [paper](https://ieeexplore.ieee.org/abstract/document/8727933)

[6] **Surrogate-assisted evolutionary framework with adaptive knowledge transfer for multi-task optimization.** *S. Huang, J. Zhong, and W.-J. Yu.* *TETC* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/8863918)

[7] **Multisource selective transfer framework in multiobjective optimization problems.** *J. Zhang, W. Zhou, X. Chen, W. Yao, and L. Cao.* *TEVC* 2020. [paper](https://ieeexplore.ieee.org/abstract/document/8752421)

[8] **Affine transformation-enhanced multifactorial optimization for heterogeneous problems.** *X. Xue, K. Zhang, K. C. Tan, L. Feng, J. Wang, G. Chen, X. Zhao, L. Zhang, and J. Yao.* *TCYB* 2022. [paper](https://ieeexplore.ieee.org/abstract/document/9295394)

[9] **Autoencoding evolutionary search with learning across heterogeneous problems.** *L. Feng, Y. Ong, S. Jiang, and A. Gupta.* *TEVC* 2017. [paper](https://ieeexplore.ieee.org/abstract/document/7879282)

[10] **Learnable evolutionary search across heterogeneous problems via kernelized autoencoding.** *L. Zhou, L. Feng, A. Gupta, and Y.-S. Ong.* *TEVC* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/9344841)

[11] **Solution representation learning in multi-objective transfer evolutionary optimization.** *R. Lim, L. Zhou, A. Gupta, Y.-S. Ong, and A. N. Zhang.* *IEEE Access* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/9377001)

[12] **Non-linear domain adaptation in transfer evolutionary optimization.** *R. Lim, A. Gupta, Y.-S. Ong, L. Feng, and A. N. Zhang.* *Cognitive Computation* 2021. [paper](https://link.springer.com/article/10.1007/s12559-020-09777-7)

[13] **Linearized domain adaptation in evolutionary multitasking.** *K. K. Bali, A. Gupta, L. Feng, Y. S. Ong, and T. P. Siew.* *CEC* 2017. [paper](https://ieeexplore.ieee.org/abstract/document/7969454)

[14] **Evolutionary multitasking via explicit autoencoding.** *L. Feng, L. Zhou, J. Zhong, A. Gupta, Y.-S. Ong, K.-C. Tan, and A. K. Qin.* *TCYB* 2018. [paper](https://ieeexplore.ieee.org/abstract/document/8401802)

[15] **Evolutionary sequential transfer optimization for objective-heterogeneous problems.** *X. Xue, C. Yang, Y. Hu, K. Zhang, Y.-M. Cheung, L. Song, and K. C. Tan.* *TEVC* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/9644585)

[16] **Learning task relationships in evolutionary multitasking for multiobjective continuous optimization.** *Z. Chen, Y. Zhou, X. He, and J. Zhang.* *TCYB* 2022. [paper](https://ieeexplore.ieee.org/abstract/document/9262898)

[17] **Regularized evolutionary multitask optimization: Learning to intertask transfer in aligned subspace.** *Z. Tang, M. Gong, Y. Wu, W. Liu, and Y. Xie.* *TEVC* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/9195010)

[18] **Evolutionary multitasking for multiobjective optimization with subspace alignment and adaptive differential evolution.** *Z. Liang, H. Dong, C. Liu, W. Liang, and Z. Zhu.* *TCYB* 2022. [paper](https://ieeexplore.ieee.org/abstract/document/9123962)

## Citation

If you find this repo useful for your research, please consider to cite:
```latex
@article{Xue2022,
title = {How to Exploit Optimization Experience? Revisiting Evolutionary Sequential Transfer Optimization: Part B - Empirical Studies},
author = {Xue, Xiaoming and Yang, Cuie and Feng, Liang and Zhang, Kai and Song, Linqi and Tan, Kay Chen}
journal = {...},
volume = {...},
pages = {...},
year = {2022},
doi = {https://...},
url = {http://...},
}
```

## Acknowledgments

...
