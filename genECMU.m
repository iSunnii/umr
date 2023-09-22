function [E,Enum] = genECMU(Ft,testnum,isdesc)
mtype = [4 5 6 7 9 10 12 13];
filenum = size(Ft,1);
E=cell(8,testnum);
Enum = [];
%Enumall = zeros(8,testnum);
if isdesc == 0
    for x = 1:8
        typecount = 0;
        for y = 1:filenum
            if ismember(mtype(x),Ft{y,3})
                typecount =typecount + 1;
                q=Ft{y,1};
                E{x,typecount}=q;
            end
            if typecount == testnum
                break;
            end
        end
        Enum = [Enum typecount];
    end
else
    for x = 1:8
        typecount = 0;
        for y = 1:filenum
            if ismember(mtype(x),Ft{2001-y,3})
                typecount =typecount + 1;
                q=Ft{2001-y,1};
                E{x,typecount}=q;
            end
            if typecount == testnum
                break;
            end
        end
        Enum = [Enum typecount];
    end
end