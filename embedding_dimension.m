%This function is using to determine embedding dimension d

function [e1] = embedding_dimension(Tau,data,max_d)

N = length(data);
y = data;
e = [];
for i = 2:1:max_d
    y1 = [];
    for j =1:1:N - (i-1)*Tau
        y1(j,:) = data(j:Tau:j+(i-1)*Tau);
    end
    a = [];
    for k =1:1:N - (i-1)*Tau
        %using knnsearch to find nearest neighbor
        [idx1,d1] = knnsearch(y1,y1(k,:),'k',2,'distance','euclidean');
        [idx2,d2] = knnsearch(y,y(k,:),'k',2,'distance','euclidean');
        a(k) = d1(2)/d2(2);
    end
    e(i-1) = mean(a);
    y = y1;  
end
e1 = [];
for g = 1:1:length(e)-1
    e1(g) = e(g+1)/e(g);
end

end