

function Tau=autocorrelation(data,tau_max)
%data:输入的时间序列
%tau_max:最大时间延迟
%Tau:返回所求时间序列的时间延迟
N=length(data);
%时间序列长度
x_mean=mean(data);
%时间序列的平均值
data=data-x_mean;
SSd=dot(data,data);
R_xx=zeros(1,tau_max);
%自相关函数初始化
for tau=1:tau_max
%计算自相关函数
    for ii=1:N-tau
        R_xx(tau)=R_xx(tau)+data(ii)*data(ii+tau);
    end
    R_xx(tau)=R_xx(tau)/SSd;
end
% plot(1:tau_max,R_xx);
% hold on
% %作自相关函数图
% line([1 tau_max],[0 0])
% title('自相关法求时间延迟');
% ylabel('自相关函数');
% xlabel('时间延迟');
Tau=0;
for jj=2:tau_max
%求时间序列的时间延迟  
    if R_xx(jj-1)*R_xx(jj)<=0
       if abs(R_xx(jj-1))>abs(R_xx(jj))
           Tau=jj;break
       else
           Tau=jj-1;break
       end
    end
end 