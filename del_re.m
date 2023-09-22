function [delp] = del_re(p)
m = size(p,2);
delp = [];
i = 1;
%upper limit is considerable
while(i<m-1)
    jump = 0;
    is_re = 1;
    round = 0;
    for j = i+2:i+6;
        if j >= m
            break;
        end
        if p(1,j) ~= p(1,i)
            continue;
        end
        jump = j-i;
        
        while 1
            for k = 1:jump
                if i+1-k+jump*(round+1) >= m;
                    is_re = 0;
                    break;
                end
                is_re = is_re&&(p(1,i+k-1)==p(1,i+k-1+jump*(round+1)));
            end
            if is_re == 1;
                round = round + 1;
            else
                break;
            end
        end
        if round >= 1
            break;
        end
        jump = 0;
        is_re = 1;
        round = 0;
    end
    if round >= 1
        temp = p(2,i);
        for s = i:i+jump*round-1
            p(2,s)= -1;
        end
        p(2,i+jump*round) = temp;
        for s = i+jump*round+1:i+jump*(round+1)-1
            p(2,s) = 0;
        end
        i = i + (round+1)*jump;
    else i = i + 1;
    end
end
i=1;
j=1;
while(p(1,i) ~= -1)
    if p(2,i) ~= -1
        delp(1,j) = p(1,i);
        delp(2,j) = p(2,i);
        j = j + 1;
    end
    i = i + 1;
end
delp(1,j) = p(1,i);
delp(2,j) = p(2,i);
