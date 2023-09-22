function [ap,map,mapoverall] = computemap_CMU(queryresultall,F,testnum)
ap=zeros(8,testnum);
ap_label=zeros(8,1);
filenum = size(F,1);
rightnum = zeros(8,1);
mtype = [4 5 6 7 9 10 12 13];

for p = 1:8
    for q = 1:filenum
        if ismember(mtype(p),F{q,3})
            rightnum(p) = rightnum(p) + 1;
        end
    end
end

for x = 1:8
    k = rightnum(x);
    for y = 1:testnum
        count = 0;
        if ~isempty(queryresultall{x,y})
            X = queryresultall{x,y};
            [~,A] = sort(X);
            for i = 1:filenum
                %if F{A(i),3} == x
                if ismember(mtype(x),F{A(i),3})
                    count = count + 1;
                    ap(x,y) = ap(x,y) + count/i;
                end
            end
            ap(x,y) = ap(x,y) / k;
            ap_label(x,1) = y;
        end
    end
end

map = sum(ap,2);
for z = 1:8
    map(z,1) = map(z,1) / ap_label(z,1);
end


mapoverall = mean(map);             
                

% for j = 1:15
%     rightnum(j)=numel(find(file_motion(:,j)==1));
% end
% for j = 1:15
%     count = 0;
%     k=rightnum(j);
%     if k>0
%         X=queryresultall(:,j);
%         [~,A] = sort(X); %X是列向量
%         %B = zeros(size(A));
%         %B(A) = (1:length(A))'; %B(i)是X(i)在X中从小到大的排名
%         for i = 1:2000
%             check = checktf(A(i),j,filename,file_names,file_motion);
%             if check == 1
%                 count = count + 1;
%                 map(1,j) = map(1,j) + count/i;
%             end
%         end
%         map(1,j) = map(1,j)/k;
%     %else map(1,j) = NaN;
%     end
% end
% map(1,1) = NaN;
% map(1,2) = NaN;
% map(1,3) = NaN;
% map(1,8) = NaN;
% map(1,11) = NaN;
% map(1,14) = NaN;
% map(1,15) = NaN;
% %mapoverall = sum(map)/8;
% mapoverall = (map(1,4)+map(1,5)+map(1,6)+map(1,7)+map(1,9)+map(1,10)+map(1,12)+map(1,13))/8;