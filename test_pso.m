 function [bestc,bestg,fit_gen] = test_pso(train,train_out,c1,c2,maxgen,sizepop)

popcmax=10^(3);% popcmax:��ʼΪ1000,SVM ����c�ı仯�����ֵ.
popcmin=0.1;% popcmin:��ʼΪ0.1,SVM ����c�ı仯����Сֵ.
popgmax=10^(2);% popgmax:��ʼΪ1000,SVM ����g�ı仯�����ֵ
popgmin=1;% popgmin:��ʼΪ0.01,SVM ����c�ı仯����Сֵ.
k = 0.5; % k belongs to [0.1,1.0];
Vcmax = k*popcmax;%���� c �����ٶ����ֵ
Vcmin = -Vcmax ;
Vgmax = k*popgmax;%���� g �����ٶ����ֵ
Vgmin = -Vgmax ; 
eps = 10^(-8);

%% ������ʼ���Ӻ��ٶ�
pop = [];
fitness = [];
fit_gen = [];
for i=1:sizepop   
   % ���������Ⱥ
    pop(i,1) = (popcmax-popcmin)*rand(1,1)+popcmin ;  % ��ʼ��Ⱥ
    pop(i,2) = (popgmax-popgmin)*rand(1,1)+popgmin;
    V(i,1)=Vcmax*rands(1,1);                      % ��ʼ���ٶ�
    V(i,2)=Vgmax*rands(1,1);
    
    % �����ʼ��Ӧ��
    gam=pop(i,1);
    sig2=pop(i,2);
    fitness(i)=adapt(gam,sig2,train,train_out);   %�Բ��Լ���Ԥ��ֵ����ľ�����Ϊ��Ӧ��ֵ
end

% �Ҽ�ֵ�ͼ�ֵ��
[global_fitness bestindex] = min(fitness); % ȫ�ּ�ֵ
local_fitness = fitness;                  % ���弫ֵ��ʼ�� 

global_x = pop(bestindex,:);             % ȫ�ּ�ֵ��
local_x = pop;                           % ���弫ֵ���ʼ��

% ÿһ����Ⱥ��ƽ����Ӧ��
avgfitness_gen = zeros(1,maxgen);

tic
%% ����Ѱ��
for i=1:maxgen
    for j=1:sizepop 
        %�ٶȸ���
        wV = 0.5; % wV best belongs to [0.8,1.2]Ϊ���ʸ��¹�ʽ���ٶ�ǰ��ĵ���ϵ��
        V(j,:) = wV*V(j,:) + c1*rand*(local_x(j,:) - pop(j,:)) + c2*rand*(global_x - pop(j,:));
        if V(j,1) > Vcmax     %���¼�������ʽ��Ϊ���޶��ٶ��������С֮��
            V(j,1) = Vcmax;
        end
        if V(j,1) < Vcmin
            V(j,1) = Vcmin;
        end
        if V(j,2) > Vgmax
            V(j,2) = Vgmax;
        end
        if V(j,2) < Vgmin
            V(j,2) = Vgmin;    %���ϼ�������ʽ��Ϊ���޶��ٶ��������С֮��
        end
        %��Ⱥ����
        
        pop(j,1)= V(j,1);
        pop(j,2) = pop(j,2) + V(j,2);
        if pop(j,1) > popcmax    %���¼�������ʽ��Ϊ���޶� c �������С֮��
            pop(j,1) = popcmax;
        end
        if pop(j,1) < popcmin
            pop(j,1) = popcmin;
        end
        if pop(j,2) > popgmax     %���¼�������ʽ��Ϊ���޶� g �������С֮��
            pop(j,2) = popgmax;
        end
        if pop(j,2) < popgmin
            pop(j,2) = popgmin;
        end 
        % ����Ӧ���ӱ���
        if rand>0.5
            k=ceil(2*rand);%ceil ������������Ĵ�����Բ��

            if k == 1
                pop(j,k) = (20-1)*rand+1;
            end
            if k == 2
                pop(j,k) = (popgmax-popgmin)*rand+popgmin;
            end 
       
           %��������Ӧ��ֵ
            gam=pop(j,1);
            sig2=pop(j,2);
            fitness(j)=adapt(gam,sig2,train,train_out);
        end
    
        %�������Ÿ���
        if fitness(j) < local_fitness(j)
            local_x(j,:) = pop(j,:);
            local_fitness(j) = fitness(j);
        end

        if fitness(j) == local_fitness(j) && pop(j,1) < local_x(j,1)
            local_x(j,:) = pop(j,:);
            local_fitness(j) = fitness(j);
        end        
        
        %Ⱥ�����Ÿ���
        if fitness(j) < global_fitness
            global_x = pop(j,:);
            global_fitness = fitness(j);
        end

        if abs( fitness(j)-global_fitness )<=eps && pop(j,1) < global_x(1)
            global_x = pop(j,:);
            global_fitness = fitness(j);
        end
    end
    fit_gen(i)=global_fitness;   
    avgfitness_gen(i) = sum(fitness)/sizepop;
    [i,global_x,global_fitness]
end
bestc = global_x(1);
bestg = global_x(2);
end