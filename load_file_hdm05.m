function [F,file,filename] = load_file_hdm05(path,representation,dsframe,pred_clusters)
%=================================
%Read all the amc files exsit in a given 
%file folder and all the sub-folders.
%T files, n frames every file, 62DoFs every
%frame.
%Matrix M: T*n by 62 matrix.

labelresult = computelabel(representation,pred_clusters);

h = waitbar(0, '初始化...');
resultframe = 1;
%F = [];
p = genpath(path);% 获得文件夹data下所有子文件的路径，这些路径存在字符串p中，以';'分割
length_p = size(p,2);%字符串p的长度
path = {};%建立一个单元数组，数组的每个单元中包含一个目录
temp = [];
%dsframe = [];
filenumsum=1;
for i = 1:length_p %寻找分割符';'，一旦找到，则将路径temp写入path数组中
    if p(i) ~= ';'
        temp = [temp p(i)];
    else 
        temp = [temp '\']; %在路径的最后加入 '\'
        path = [path ; temp];
        temp = [];
    end
end 
clear p length_p temp;
%至此获得data文件夹及其所有子文件夹（及子文件夹的子文件夹）的路径，存于数组path中。
%下面是逐一文件夹中读取图像
file_num = size(path,1);% 子文件夹的个数
%Fcount = 1;
F = cell(file_num,4);
file = zeros(1,file_num);
for i = 1:file_num
    file_path =  path{i}; % 图像文件夹路径
    img_path_list = dir(strcat(file_path,'*.amc'));
    img_num = length(img_path_list); %该文件夹中图像数量
    file(1,i)=img_num;
    if img_num > 0
        str = sprintf('读取第%d/%d个文件夹',i, file_num);
        waitbar(0, h, str);
        for j = 1:img_num
            image_name = img_path_list(j).name;% 图像名
            %image =  imread(strcat(file_path,image_name));
            %fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));% 显示正在处理的路径和图像名
            %图像处理过程 省略
            %temp = amc_to_matrix(strcat(file_path,image_name));
            %framenum=size(temp,1);
            
            
            %framenum=amc_to_matrix_frame(strcat(file_path,image_name));
            framenum = dsframe(filenumsum,1);
            F{filenumsum,2} = framenum;
            n=framenum;
            s=zeros(1,n);
            for k = 1:n
                s(k)=labelresult(resultframe,1);
                resultframe = resultframe+1;
            end
            %dsframe = [dsframe n];
            
            
%             %M = [M temp'];
%             OMPtemp = temp';
%             A =OMP(Dictionary,OMPtemp,3);
%             %读字符串
%             [~,n]=size(A);
%             s=zeros(1,n);
%             for k = 1:n
%                 [~, Y] = max(abs(A(:,k)));
%                 s(k) = Y;
%             end
            
            indlas = strfind(image_name,'.');%Jiang提取名字作为返回值
            filename{filenumsum,1} = image_name(1:indlas-1);

            %字符串去单字重复
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
            F{filenumsum,2} = 0;
            %F{filenumsum,2} = q(2,:);
            F{filenumsum,3} = i-1;
            F{filenumsum,4} = j;
            filenumsum = filenumsum + 1;
            %Fcount = Fcount + 1;
            waitbar(j/img_num, h, str);
        end
        waitbar(1, h, str);
    end
end
%fprintf('totalframe %d\n',resultframe);
countwww = 0;
for www = 1:200
    countwww = size(F{www,1},2)-1+countwww;
end 
fprintf('%d\n',countwww);
close(h);
%dsframe = dsframe';
%fprintf('dadsadsa');
%save ('hdm05frame', 'dsframe');