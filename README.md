# How to Exploit Optimization Experience? Revisiting Evolutionary Sequential Transfer Optimization: Part B - Empirical Studies

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
|Distance-based metric|The Euclidean distance|S-M1|
|Distance-based metric|The Kullback-Leibler divergence|S-KLD|
|Distance-based metric|The Wasserstein distance|S-WD|
|Correlation-based metric|The ordinal correlation|S-OC|
|Correlation-based metric|The relaxed ordinal correlation|S-ROC|
|Correlation-based metric|The subspace alignment|S-SA|

## Solution Adaptation
In solution adaptation, eleven adaptation models are investigated in this study, which are given by,
|Adaptation Objective|Description|Abbreviation|
|:-|:-|:-|
|The first moment|Translation transformation based on the estimated means of elite solutions|A-M1-Tp|
|The first moment|Translation transformation based on the randomly selected elite individuals|A-M1-Tr|
|The first moment|Translation transformation based on the population means|A-M1-Tm|
|The first moment|Multiplication transformation using the estimated means of selected solutions|A-M1-M|
|The first two moments|Affine transformation|A-M2-A|
|The ordinal correlation|Linear transformation|A-OC-L|
|The ordinal correlation|Affine transformation|A-OC-A|
|The ordinal correlation|Kernealization|A-OC-K|
|The ordinal correlation|Linear transformations connected by a latent space|A-ROC-L|
|The subspace alignment|Linear transformations connected by the subspaces|A-SA-L|

## Integration of Solution Selection and Solution Adaptation
Three S+A integrations are investigated in this study, which are provided as follows:
|Integration|Similarity Metric|Adaptation Objective|
|:-|:-|:-|
|S-WD+A-OC-A|S-WD|A-OC-A|
|S-M1+A-M1-Tm|S-M1|A-M1-Tm|
|S-WD+A-M2-A|S-WD|A-M2-A|

## References
[1] **Learning with case-injected genetic algorithms.** TEVC 2004. [paper](https://ieeexplore.ieee.org/abstract/document/1324694)

    *S. J. Louis, J. McDonnell.* 

[2] **Learning with case-injected genetic algorithms.** TEVC 2004. [paper](https://ieeexplore.ieee.org/abstract/document/1324694)

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
