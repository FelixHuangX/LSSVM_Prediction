 function [bestc,bestg,fit_gen] = test_pso(train,train_out,c1,c2,maxgen,sizepop)

popcmax=10^(3);% popcmax:初始为1000,SVM 参数c的变化的最大值.
popcmin=0.1;% popcmin:初始为0.1,SVM 参数c的变化的最小值.
popgmax=10^(2);% popgmax:初始为1000,SVM 参数g的变化的最大值
popgmin=1;% popgmin:初始为0.01,SVM 参数c的变化的最小值.
k = 0.5; % k belongs to [0.1,1.0];
Vcmax = k*popcmax;%参数 c 迭代速度最大值
Vcmin = -Vcmax ;
Vgmax = k*popgmax;%参数 g 迭代速度最大值
Vgmin = -Vgmax ; 
eps = 10^(-8);

%% 产生初始粒子和速度
pop = [];
fitness = [];
fit_gen = [];
for i=1:sizepop   
   % 随机产生种群
    pop(i,1) = (popcmax-popcmin)*rand(1,1)+popcmin ;  % 初始种群
    pop(i,2) = (popgmax-popgmin)*rand(1,1)+popgmin;
    V(i,1)=Vcmax*rands(1,1);                      % 初始化速度
    V(i,2)=Vgmax*rands(1,1);
    
    % 计算初始适应度
    gam=pop(i,1);
    sig2=pop(i,2);
    fitness(i)=adapt(gam,sig2,train,train_out);   %以测试集的预测值计算的均方差为适应度值
end

% 找极值和极值点
[global_fitness bestindex] = min(fitness); % 全局极值
local_fitness = fitness;                  % 个体极值初始化 

global_x = pop(bestindex,:);             % 全局极值点
local_x = pop;                           % 个体极值点初始化

% 每一代种群的平均适应度
avgfitness_gen = zeros(1,maxgen);

tic
%% 迭代寻优
for i=1:maxgen
    for j=1:sizepop 
        %速度更新
        wV = 0.5; % wV best belongs to [0.8,1.2]为速率更新公式中速度前面的弹性系数
        V(j,:) = wV*V(j,:) + c1*rand*(local_x(j,:) - pop(j,:)) + c2*rand*(global_x - pop(j,:));
        if V(j,1) > Vcmax     %以下几个不等式是为了限定速度在最大最小之间
            V(j,1) = Vcmax;
        end
        if V(j,1) < Vcmin
            V(j,1) = Vcmin;
        end
        if V(j,2) > Vgmax
            V(j,2) = Vgmax;
        end
        if V(j,2) < Vgmin
            V(j,2) = Vgmin;    %以上几个不等式是为了限定速度在最大最小之间
        end
        %种群更新
        
        pop(j,1)= V(j,1);
        pop(j,2) = pop(j,2) + V(j,2);
        if pop(j,1) > popcmax    %以下几个不等式是为了限定 c 在最大最小之间
            pop(j,1) = popcmax;
        end
        if pop(j,1) < popcmin
            pop(j,1) = popcmin;
        end
        if pop(j,2) > popgmax     %以下几个不等式是为了限定 g 在最大最小之间
            pop(j,2) = popgmax;
        end
        if pop(j,2) < popgmin
            pop(j,2) = popgmin;
        end 
        % 自适应粒子变异
        if rand>0.5
            k=ceil(2*rand);%ceil 是向离它最近的大整数圆整

            if k == 1
                pop(j,k) = (20-1)*rand+1;
            end
            if k == 2
                pop(j,k) = (popgmax-popgmin)*rand+popgmin;
            end 
       
           %新粒子适应度值
            gam=pop(j,1);
            sig2=pop(j,2);
            fitness(j)=adapt(gam,sig2,train,train_out);
        end
    
        %个体最优更新
        if fitness(j) < local_fitness(j)
            local_x(j,:) = pop(j,:);
            local_fitness(j) = fitness(j);
        end

        if fitness(j) == local_fitness(j) && pop(j,1) < local_x(j,1)
            local_x(j,:) = pop(j,:);
            local_fitness(j) = fitness(j);
        end        
        
        %群体最优更新
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