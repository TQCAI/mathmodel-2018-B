function ga_TSP(linenum)
% mainly amended by Chen Zhen, 2012~2016
CiteNum = 12;
BitNum=(CiteNum-1)*CiteNum/2; %you chan choose 10, 30, 50, 75
[Clist,CityLoc,CityPop]=testcase;
inn=50; %��ʼ��Ⱥ��С
gnmax=500;
%������
pc=0.8; %�������
pm=0.8; %�������
%������ʼ��Ⱥ
s=zeros(inn,BitNum);
for i=1:inn
    s(i,:)=randperm(BitNum);
end
[~,p]=objf(s,Clist,CityPop,linenum);
gn=1;
ymean=zeros(gn,1);
ymax=zeros(gn,1);
xmax=zeros(inn,BitNum);
scnew=zeros(inn,BitNum);
smnew=zeros(inn,BitNum);
while gn<gnmax+1
    for j=1:2:inn
        seln=sel(p);
        %ѡ�����
        scro=cro(s,seln,pc);
        %�������
        scnew(j,:)=scro(1,:);
        scnew(j+1,:)=scro(2,:);
        smnew(j,:)=mut(scnew(j,:),pm);
        %�������
        smnew(j+1,:)=mut(scnew(j+1,:),pm);
    end
    s=smnew;
    %�������µ���Ⱥ
    [f,p]=objf(s,Clist,CityPop,linenum);
    %��������Ⱥ����Ӧ��
    %��¼��ǰ����ú�ƽ������Ӧ��
    [fmax,nmax]=max(f);
    ymean(gn)=1000/mean(f);
    ymax(gn)=1000/fmax;
    %��¼��ǰ������Ѹ���
    x=s(nmax,:);
    xmax(gn,:)=x;
    gn=gn+1;
    fopt(gn) = fobj(x(end,1:linenum),Clist,CityPop);
end
[f,X]=fobj(xmax(end,1:linenum),Clist,CityPop);
figure;clf;hold on;
plot(CityLoc(:,2),CityLoc(:,1),'rs');
for ii=1:CiteNum
    for jj=1:CiteNum
        if (X(ii,jj)==1)
            plot([CityLoc(ii,2) CityLoc(jj,2)],...
                [CityLoc(ii,1) CityLoc(jj,1)],'b-');
        end
    end
end
title(['����Ϊ' num2str(f)])
ylabel('γ��');
xlabel('����');
figure;
plot(fopt);
ylabel('�����ֵ');
xlabel('��������');
title(['������Ϊ' num2str(linenum)]);
pause(0.01);
figure;
end
%------------------------------------------------
%����������Ⱥ����Ӧ��
function [f,p]=objf(s,Clist,CityPop,linenum)
inn=size(s,1);
%��ȡ��Ⱥ��С
f=zeros(inn,1);
for i=1:inn
    f(i)=fobj(s(i,1:linenum),Clist,CityPop);
    %���㺯��ֵ������Ӧ��
end
f=f'; %ȡ���뵹��
%���ݸ������Ӧ�ȼ����䱻ѡ��ĸ���
fsum=0;
for i=1:inn
    fsum=fsum+f(i)^15;% ����Ӧ��Խ�õĸ��屻ѡ�����Խ��
end
ps=zeros(inn,1);
for i=1:inn
    ps(i)=f(i)^15/fsum;
end
%�����ۻ�����
p=zeros(inn,1);
p(1)=ps(1);
for i=2:inn
    p(i)=p(i-1)+ps(i);
end
p=p';
end
%--------------------------------------------------
%���ݱ�������ж��Ƿ����
function pcc=pro(pc)
test(1:100)=0;
l=round(100*pc);
test(1:l)=1;
n=round(rand*99)+1;
pcc=test(n);
end
%--------------------------------------------------
%��ѡ�񡱲���
function seln=sel(p)
seln=zeros(2,1);
%����Ⱥ��ѡ���������壬��ò�Ҫ����ѡ��ͬһ������
for i=1:2
    r=rand;
    %����һ�������
    prand=p-r;
    j=1;
    while prand(j)<0
        j=j+1;
    end
    seln(i)=j; %ѡ�и�������
    if i==2&&j==seln(i-1)
        %%����ͬ����ѡһ��
        r=rand;
        %����һ�������
        prand=p-r;
        j=1;
        while prand(j)<0
            j=j+1;
        end
    end
end
end
%------------------------------------------------
%�����桱����
function scro=cro(s,seln,pc)
bn=size(s,2);
pcc=pro(pc);
%���ݽ�����ʾ����Ƿ���н��������1 ���ǣ�0 ���
scro(1,:)=s(seln(1),:);
scro(2,:)=s(seln(2),:);
if pcc==1
    c1=round(rand*(bn-2))+1;
    %��[1,bn-1]��Χ���������һ������λ
    c2=round(rand*(bn-2))+1;
    chb1=min(c1,c2);
    chb2=max(c1,c2);
    middle=scro(1,chb1+1:chb2);
    scro(1,chb1+1:chb2)=scro(2,chb1+1:chb2);
    scro(2,chb1+1:chb2)=middle;
    for i=1:chb1 %�ƺ�������
        while find(scro(1,chb1+1:chb2)==scro(1,i))
            zhi=find(scro(1,chb1+1:chb2)==scro(1,i));
            y=scro(2,chb1+zhi);
            scro(1,i)=y;
        end
        while find(scro(2,chb1+1:chb2)==scro(2,i))
            zhi=find(scro(2,chb1+1:chb2)==scro(2,i));
            y=scro(1,chb1+zhi);
            scro(2,i)=y;
        end
    end
    for i=chb2+1:bn
        while find(scro(1,1:chb2)==scro(1,i))
            zhi=logical(scro(1,1:chb2)==scro(1,i));
            y=scro(2,zhi);
            scro(1,i)=y;
        end
        while find(scro(2,1:chb2)==scro(2,i))
            zhi=logical(scro(2,1:chb2)==scro(2,i));
            y=scro(1,zhi);
            scro(2,i)=y;
        end
    end
end
end
%--------------------------------------------------
%�����족����
function snnew=mut(snew,pm)
bn=size(snew,2);
snnew=snew;
pmm=pro(pm);
%���ݱ�����ʾ����Ƿ���б��������1 ���ǣ�0 ���
if pmm==1
    c1=round(rand*(bn-2))+1;
    %��[1,bn-1]��Χ���������һ������λ
    c2=round(rand*(bn-2))+1;
    chb1=min(c1,c2);
    chb2=max(c1,c2);
    x=snew(chb1+1:chb2);
    snnew(chb1+1:chb2)=fliplr(x);
end
end
function [Clist,CityLoc,CityNum]=testcase
CityLoc=[39.91667 116.41667,;
    45.75000 126.63333;
    43.45 87.36;
    34.26667,108.95000;
    34.76667,113.65000;
    31.14 121.29;
    30.35 114.17;
    29.35 106.33;
    30.40 104.04;
    29.39 91.08;
    25.04 102.42;
    23.16667,113.23333];
CityNum = [1961.24 1063.60 311.03 846.78 862.65 2301.91 978.54 2884.62 1404.76...
    55.94 643.20 1035.79];
axesm utm
%����ͶӰ��ʽ������ MATLAT �Դ��� Universal Transverse Mercator ��UTM����ʽ
Z=utmzone(CityLoc);
%utmzone ���� latlon20 ���������ѡ������Ϊ���ʵ�ͶӰ���򣬿�����һ��̨վ�ľ�γ�ȣ�Ҳ����������̨վ�ľ�γ�ȣ���ʱ��ƽ����
setm(gca,'zone',Z)
h = getm(gca);
R=zeros(size(CityLoc));
for i=1:length(CityLoc)
    [x,y]= mfwdtran(h,CityLoc(i,1),CityLoc(i,2));
    Clist(i,:)=[x;y]/1e3;
end
end