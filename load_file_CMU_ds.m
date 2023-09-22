function [F,file,filename] = load_file_CMU_ds(representation,dsframe,pred_clusters)
%=================================
%Read all the amc files exsit in a given 
%file folder and all the sub-folders.
%T files, n frames every file, 62DoFs every
%frame.
%Matrix M: T*n by 62 matrix.
load CMU2000name.mat file_names;
load CMUlabel_8.mat CMUlabel;
labelresult = computelabel(representation,pred_clusters);
filenumsum=1;
resultframe = 1;
F = cell(2000,4);
file = 'undetermined';

h = waitbar(0, '初始化...');

for i = 1:2000
    str = sprintf('读取第%d/%d个文件夹',i, 2000);
    framenum = dsframe(filenumsum,1);
    F{filenumsum,2} = framenum;
    n=framenum;
    s=zeros(1,n);
    for k = 1:n
        s(k)=labelresult(resultframe,1);
        resultframe = resultframe+1;
    end
    filename{filenumsum,1} = file_names(filenumsum);
    count = 1;
    p = 0;
    p(1,1) = s(1);
    p(2,1) = 1;
    for k = 2:n
        if s(k) ~= p(1,count)
            count = count + 1;
            p(1,count) = s(k);
            p(2,count) = k;
        end
    end
    count = count + 1;
    p(1,count) = -1;
    p(2,count) = n+1;
    q = del_re(p);
    %F{i,j,1} = q(1,:);
    %F{i,j,2} = q(2,:);
    F{filenumsum,1} = q(:,:);
    %F{filenumsum,2} = q(2,:);
    %F{filenumsum,3} = i-1;
    %F{filenumsum,4} = j;
    F{filenumsum,3} = CMUlabel{filenumsum};
    filenumsum = filenumsum + 1;
    %Fcount = Fcount + 1;
    waitbar(i/2000, h, str);
end
str = sprintf('读取第%d/%d个文件夹',i, 2000);
waitbar(1, h, str);

close(h);
