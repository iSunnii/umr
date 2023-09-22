function [F0,Ft] = split2fold(F)
filenum = size(F,1);

sizeF0 = 0;
sizeFt = 0;
rightnum = zeros(F{size(F,1),3},1);
randtable = cell(F{size(F,1),3},2);
for p = 1:F{size(F,1),3}
    for q = 1:filenum
        if F{q,3} == p
            rightnum(p) = rightnum(p) + 1;
        end
    end
    if rightnum(p) ~= 1
        randoneclass = randperm(rightnum(p));
    else
        randoneclass = [1 1];
    end
    rp = floor(size(randoneclass,2)/2);
    randtable{p,1} = sort(randoneclass(1:rp));
    randtable{p,2} = sort(randoneclass(rp+1:size(randoneclass,2)));
    sizeF0 = sizeF0 + size(randtable{p,1},2);
    sizeFt = sizeFt + size(randtable{p,2},2);
end

F0 = cell(sizeF0,5);
Ft = cell(sizeFt,5);
%F0(:,4) = mat2cell(zeros(sizeF0,1),ones(1,sizeF0),1);
F0(:,4) = num2cell(zeros(sizeF0,1));
Ft(:,4) = num2cell(zeros(sizeFt,1));
F0count = 0;
Ftcount = 0;

for i = 1:filenum
    x = find(randtable{F{i,3},1}==F{i,4});
    y = find(randtable{F{i,3},2}==F{i,4});
    if (x)
        F0count = F0count + 1;
        F0(F0count,1:3) = F(i,1:3);
        F0{F0count,4} = x;
        F0(F0count,5) = F(i,4);
    end
    if (y)
        Ftcount = Ftcount + 1;
        Ft(Ftcount,1:3) = F(i,1:3);
        Ft{Ftcount,4} = y;
        Ft(Ftcount,5) = F(i,4);
    end
end
if (sizeF0 == F0count && sizeFt == Ftcount)
    fprintf('F0 & Ft solved rightly, F0 @ %d, Ft @ %d\n',sizeF0,sizeFt);
else
    fprintf('F0 & Ft is wrong\n')
end


% randtable{p,}
% 
% 
% for i = 1:F{size(F,1),3}
    
    
    
