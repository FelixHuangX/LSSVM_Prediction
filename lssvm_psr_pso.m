
function [predict2,MSE2] = lssvm_psr_pso(data,tau_max,c1,c2,maxgen,sizepop)


Tau = autocorrelation(data,tau_max);
max_d = floor(length(data)/Tau) + 1;
[e1] = embedding_dimension(Tau,data,max_d);

% figure,plot(e1),
% title('Select the best embadding dimension')

e2 = diff(e1);
e3 = diff(e2);
% calculate gradient
d = find(abs(e3) == min(abs(e3)),1,'first');

%% slide data
b = [];
for i = 1:1:length(data) - d
    b(i,:) = data(i:i + d);
end

[m,n] = size(b);
train = b(1:m-40,1:d);
train_out = b(1:m-40,d+1);
test = b(m-39:m-25,1:d);
test_out = b(m-39:m-25,d+1);


[bestc,bestg,fit_gen] = test_pso(train,train_out,c1,c2,maxgen,sizepop);
igam = bestc;
isig2 = bestg;

type = 'f';
%% train model
[alpha,b1] = trainlssvm({train,train_out,type,igam,isig2,'RBF_kernel'});

%% prediction single_step
predict1 = simlssvm({train,train_out,type,igam,isig2,'RBF_kernel','preprocess'},{alpha,b1},test);

%% prediction multi_step
predict2 = zeros(15,1);
Z_test = test(1,:);
for i = 1:1:length(predict2)
    predict2(i) = simlssvm({train,train_out,type,igam,isig2,'RBF_kernel','preprocess'},{alpha,b1},Z_test);
    Z_test = [Z_test(2:length(Z_test)),predict2(i)];
end

%% MSE
MSE1 = sum((test_out - predict1).^2)/length(predict1);
MSE2 = sum((test_out - predict2).^2)/length(predict2);

figure,plot(fit_gen)
title('Model MSE Optimization')
figure,plot(test_out)
hold on
plot(predict1)
hold on
plot(predict2,'g')
legend('Actual','predict1','predict2')
title('Single-step and  Multi-step')
end


