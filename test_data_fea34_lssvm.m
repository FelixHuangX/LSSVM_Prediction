%This code is using to normalize vibration signal 
clc 
clear all
close all

%% initial parameters
fs = 750;
I = 375;
tau_max = 200;
c1 = 1.5; % c1 belongs to [0,2]  
c2 = 1.7; % c2 belongs to [0,2]  
maxgen=100;   
sizepop=30;   
Nstd = 0.2;
NR = 100;
MaxIter = 100;


X = load('ecg.csv');   
X_norm = zscore(X);   %Z-Score
x_f_after_PCA = pca_fea_34(X_norm,fs,I,Nstd,NR,MaxIter);
figure,plot(x_f_after_PCA),title('The first principal component of vibration siganl ')
[predict2,MSE2] = lssvm_psr_pso(x_f_after_PCA,tau_max,c1,c2,maxgen,sizepop);

