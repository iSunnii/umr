function [E,Enum] = genE(Ft,testnum)
filenum = size(Ft,1);
E=cell(Ft{size(Ft,1),3},testnum);
Enumall = zeros(Ft{size(Ft,1),3},testnum);
for x = 1:filenum
    F4 = Ft{x,4};
    F3 = Ft{x,3};
    if F4<=testnum
        %y=size(F{x,1},2);
        q=Ft{x,1};
        E{F3,F4}=q;
        Enumall(F3,F4)=F4;
    end
end
Enum = max(Enumall,[],2);