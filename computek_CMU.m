function [k1,avgclass,avgall] = computek_CMU(queryresultall,F,testnum,ordernum)
k1=zeros(8,testnum);
k_label=zeros(8,1);
mtype = [4 5 6 7 9 10 12 13];

for x = 1:8
    for y = 1:testnum
        if ~isempty(queryresultall{x,y})
            X = queryresultall{x,y};
            [~,A] = sort(X);
            %if F{A(2),3} == x
            for zz = 1:ordernum
            %if F{A(zz),3} == x
            if ismember(mtype(x),F{A(zz),3})
                k1(x,y) = k1(x,y)+1;
            else
                k1(x,y) = k1(x,y)+0;
            end
            end
            k1(x,y) = k1(x,y)/ordernum;
            
            k_label(x,1) = y;
        end
    end
end

avgclass = sum(k1,2);
for z = 1:8
    avgclass(z,1) = avgclass(z,1) / k_label(z,1);
end

avgall = mean(avgclass);     