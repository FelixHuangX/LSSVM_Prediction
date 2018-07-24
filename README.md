# LSSVM_Prediction
Signal prediction by using LSSVM with PSO and PSR

# Paper Source
Shaojiang Dong,Tianhong Luo,Bearing degradation process prediction based on the PCA and optimized LS-SVM model,_Measurement_,2013.06

# Preparatory Work
matlab,LSSVM toolbox,EMD toolbox

# Execution
1.Add the LSSVM toolbox to this path:D:\Program Files\MATLAB\R2015b\toolbox\, and set this folder's path in matlab;

2.Open pack_emd\package_emd,run: 'install_emd.m'

3.Open this code: 'test_psr_pso.m'

4.Choosing the ECG dataset to run the code

# Result
![image](https://github.com/FelixHuangX/LSSVM_Prediction/blob/master/ecg.jpg)

We focus on the green line ,the blue is raw data after PCA,and this orange line is single step prediction,but the green line is multi step prediction.
From this result ,wo find that LSSVM is good at capture the feature of ecg data.

# Supplementary Instruction
This LSSVM model using PSR(Phase Space Reconstruction) algorithm to choose best embedding dimension of input,and PSO(Particle Swarm Optimization) algorithm to give best parameters of LSSVM.
