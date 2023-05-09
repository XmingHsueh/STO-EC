# Does Optimized Solution Always Help? A Comprehensive Investigation of Transfer Evolutionary Algorithms

This repository provides the MATLAB implementations of a comprehensive empirical investigation of transfer evolutionary algorithms. Particularly, a wide variety of techniques surrounding the three central issues in knowledge transfer, i.e., what to transfer, when to transfer, and how to transfer, are separately studied in this work, which are summarized as follows:

|Central Issue|Description|Abbreviation|
|:-|:-|:-|
|What to Transfer|The hamming distance between intermediate solutions [1]<br>The Euclidean distance between the population means [2-4]<br>The KLD distance [5,6]<br>The WD distance [7,8]<br>The ordinal correlation [9-11]<br>The relaxed ordinal correlation [12,13]<br>The subspace alignment [14,15]|H<br>M1<br>KLD<br>WD<br>OC<br>ROC<br>SA|
|When to Transfer| The fixed generation interval for knowledge transfer [16-19]<br>The estimated transfer intensity based on the mixture model [20]<br>The estimated transfer intensity based on the population distributions [21]<br>The estimated transfer intensity based on the representation models [22]|F-G_t<br>D-M<br>D-P<br>D-G|
|How to Transfer|The translation transformation based on the elite solutions [2]<br>The translation transformation based on the randomly selected solutions [3]<br>The translation transformation based on the population means<br>The multiplication transformation based on the estimated means [4]<br>The affine transformation [8]<br>The linear transformation [23]<br>The affine transformation [16]<br>The kernelized mapping [11]<br>The neural network model [10,17]<br>The linear transformations connected by a latent space [12,13]<br>The linear transformations connected by the subspaces [14,15]|M1-Te<br>M1-Tr<br>M1-Tm<br>M1-M<br>M2-A<br>OC-L<br>OC-A<br>OC-K<br>OC-N<br>ROC-L<br>SA-L|


## References
[1] **Learning with case-injected genetic algorithms.** *S. J. Louis and J. McDonnell.* *TEVC* 2004. [paper](https://ieeexplore.ieee.org/abstract/document/1324694)

[2] **Generalized multitasking for evolutionary optimization of expensive problems.** *J. Ding, C. Yang, Y. Jin, and T. Chai.* *TEVC* 2019. [paper](https://ieeexplore.ieee.org/abstract/document/8231172)

[3] **Multifactorial evolutionary algorithm enhanced with cross-task search direction.** *J. Yin, A. Zhu, Z. Zhu, Y. Yu, and X. Ma.* *CEC* 2019. [paper](https://ieeexplore.ieee.org/abstract/document/8789959)

[4] **A hybrid of genetic transform and hyper-rectangle search strategies for evolutionary multi-tasking.** *Z. Liang, J. Zhang, L. Feng, and Z. Zhu.* *ESWA* 2019. [paper](https://www.sciencedirect.com/science/article/pii/S0957417419304944)

[5] **An adaptive archive-based evolutionary framework for many-task optimization.** *Y. Chen, J. Zhong, L. Feng, and J. Zhang.* *TETCI* 2020. [paper](https://ieeexplore.ieee.org/abstract/document/8727933)

[6] **Surrogate-assisted evolutionary framework with adaptive knowledge transfer for multi-task optimization.** *S. Huang, J. Zhong, and W.-J. Yu.* *TETC* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/8863918)

[7] **Multisource selective transfer framework in multiobjective optimization problems.** *J. Zhang, W. Zhou, X. Chen, W. Yao, and L. Cao.* *TEVC* 2020. [paper](https://ieeexplore.ieee.org/abstract/document/8752421)

[8] **Affine transformation-enhanced multifactorial optimization for heterogeneous problems.** *X. Xue, K. Zhang, K. C. Tan, L. Feng, J. Wang, G. Chen, X. Zhao, L. Zhang, and J. Yao.* *TCYB* 2022. [paper](https://ieeexplore.ieee.org/abstract/document/9295394)

[9] **Evolutionary multitasking via explicit autoencoding.** *L. Feng, L. Zhou, J. Zhong, A. Gupta, Y.-S. Ong, K.-C. Tan, and A. K. Qin.* *TCYB* 2018. [paper](https://ieeexplore.ieee.org/abstract/document/8401802)

[10] **Solution representation learning in multi-objective transfer evolutionary optimization.** *R. Lim, L. Zhou, A. Gupta, Y.-S. Ong, and A. N. Zhang.* *IEEE Access* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/9377001)

[11] **Learnable evolutionary search across heterogeneous problems via kernelized autoencoding.** *L. Zhou, L. Feng, A. Gupta, and Y.-S. Ong.* *TEVC* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/9344841)

[12] **Evolutionary sequential transfer optimization for objective-heterogeneous problems.** *X. Xue, C. Yang, Y. Hu, K. Zhang, Y.-M. Cheung, L. Song, and K. C. Tan.* *TEVC* 2022. [paper](https://ieeexplore.ieee.org/abstract/document/9644585)

[13] **Learning task relationships in evolutionary multitasking for multiobjective continuous optimization.** *Z. Chen, Y. Zhou, X. He, and J. Zhang.* *TCYB* 2022. [paper](https://ieeexplore.ieee.org/abstract/document/9262898)

[14] **Regularized evolutionary multitask optimization: Learning to intertask transfer in aligned subspace.** *Z. Tang, M. Gong, Y. Wu, W. Liu, and Y. Xie.* *TEVC* 2021. [paper](https://ieeexplore.ieee.org/abstract/document/9195010)

[15] **Evolutionary multitasking for multiobjective optimization with subspace alignment and adaptive differential evolution.** *Z. Liang, H. Dong, C. Liu, W. Liang, and Z. Zhu.* *TCYB* 2022. [paper](https://ieeexplore.ieee.org/abstract/document/9123962)

[16] **Autoencoding evolutionary search with learning across heterogeneous problems.** *L. Feng, Y. Ong, S. Jiang, and A. Gupta.* *TEVC* 2017. [paper](https://ieeexplore.ieee.org/abstract/document/7879282)

[17] **Non-linear domain adaptation in transfer evolutionary optimization.** *R. Lim, A. Gupta, Y.-S. Ong, L. Feng, and A. N. Zhang.* *Cognitive Computation* 2021. [paper](https://link.springer.com/article/10.1007/s12559-020-09777-7)

[18] **Multitasking multiobjective optimization based on transfer component analysis.** *Z. Hu, Y. Li, H. Sun, and X. Ma.* *Information Sciences* 2022. [paper](https://www.sciencedirect.com/science/article/pii/S0020025522004571)

[19] **Multitasking optimization via an adaptive solver multitasking evolutionary framework.** *Y. Li, W. Gong, and S. Li.* *Information Sciences* 2023. [paper](https://www.sciencedirect.com/science/article/pii/S0020025522012191)

[20] **Multifactorial Evolutionary Algorithm With Online Transfer Parameter Estimation: MFEA-II.** *K. K. Bali, Y. S. Ong, A. Gupta, and P. S. Tan.* *TEVC* 2019. [paper](https://ieeexplore.ieee.org/abstract/document/8672822)

[21] **Evolutionary multi-task optimization with hybrid knowledge transfer strategy.** *Y. Cai, D. Peng, P. Liu, and J. Guo.* *Information Sciences* 2021. [paper](https://www.sciencedirect.com/science/article/pii/S002002552100952X)

[22] **Self-adaptive multifactorial evolutionary algorithm for multitasking production optimization.** *J. Yao, Y. Nie, Z. Zhao, X. Xue, K. Zhang, C. Yao, L. Zhang, J. Wang, and Y. Yang.* *JPSE* 2021. [paper](https://www.sciencedirect.com/science/article/pii/S0920410521005611)

[23] **Linearized domain adaptation in evolutionary multitasking.** *K. K. Bali, A. Gupta, L. Feng, Y. S. Ong, and T. P. Siew.* *CEC* 2017. [paper](https://ieeexplore.ieee.org/abstract/document/7969454)



## Citation

If you find this repo useful for your research, please consider to cite:
```latex
@article{Xue2023,
title = {Does Optimized Solution Always Help? A Comprehensive Investigation of Transfer Evolutionary Algorithms},
author = {Xue, Xiaoming and Yang, Cuie and Feng, Liang and Zhang, Kai and Song, Linqi and Tan, Kay Chen}
journal = {...},
volume = {...},
pages = {...},
year = {2023},
doi = {https://...},
url = {http://...},
}
```

## Acknowledgments

...
