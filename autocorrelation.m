

function Tau=autocorrelation(data,tau_max)
%data:�����ʱ������
%tau_max:���ʱ���ӳ�
%Tau:��������ʱ�����е�ʱ���ӳ�
N=length(data);
%ʱ�����г���
x_mean=mean(data);
%ʱ�����е�ƽ��ֵ
data=data-x_mean;
SSd=dot(data,data);
R_xx=zeros(1,tau_max);
%����غ�����ʼ��
for tau=1:tau_max
%��������غ���
    for ii=1:N-tau
        R_xx(tau)=R_xx(tau)+data(ii)*data(ii+tau);
    end
    R_xx(tau)=R_xx(tau)/SSd;
end
% plot(1:tau_max,R_xx);
% hold on
% %������غ���ͼ
% line([1 tau_max],[0 0])
% title('����ط���ʱ���ӳ�');
% ylabel('����غ���');
% xlabel('ʱ���ӳ�');
Tau=0;
for jj=2:tau_max
%��ʱ�����е�ʱ���ӳ�  
    if R_xx(jj-1)*R_xx(jj)<=0
       if abs(R_xx(jj-1))>abs(R_xx(jj))
           Tau=jj;break
       else
           Tau=jj-1;break
       end
    end
end 