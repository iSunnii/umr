function [k1,avgclass,avgall] = computek_hdm05(queryresultall,F,testnum,ordernum)
k1=zeros(F{size(F,1),3},testnum);
k_label=zeros(F{size(F,1),3},1);
            
for x = 1:F{size(F,1),3}
    for y = 1:testnum
        if ~isempty(queryresultall{x,y})
            X = queryresultall{x,y};
            [~,A] = sort(X);
            %if F{A(2),3} == x
            for zz = 1:ordernum
            if F{A(zz),3} == x
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
for z = 1:F{size(F,1),3}
    avgclass(z,1) = avgclass(z,1) / k_label(z,1);
end

avgall = mean(avgclass);     