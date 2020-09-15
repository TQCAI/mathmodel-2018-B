function [f,X]=fobj(XId,CityLoc,CityNum)
CN = size(CityLoc,1);
X = 1-tril(ones(CN,CN),0);
X = X(:);
Ind = find(X==1);
X(Ind)=1:length(Ind);
for ii=1:length(XId)
    X(X==(XId(ii)))=Inf;
end
X=(X==Inf);
X = reshape(X,CN,CN);
X = X+X';
%判断是否连接了所有结点的问题
Xd = sum(sum(X~=0,1)==0);
if (Xd>0)
    f = 0;
    return;
end
f = 0;
SnrReq = [Inf 3000 1200 600];
RateTable = [0 8 16 32];
for ii =1:CN
    for jj=ii+1:CN
        if (X(ii,jj)>=1)
            Dist= norm(CityLoc(ii,:)-CityLoc(jj,:));
            Ind = find(SnrReq>Dist);
            ModRate = RateTable(Ind(end));
            f = f+ sqrt(CityNum(ii)*CityNum(jj))*ModRate;
        end
    end
end