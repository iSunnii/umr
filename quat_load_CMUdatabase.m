function [M] = quat_load_CMUdatabase(path)
%=================================
%Read all the amc files exsit in a given 
%file folder and all the sub-folders.
%T files, n frames every file, 62DoFs every
%frame.
%Matrix M: T*n by 62 matrix.
load CMU2000name.mat file_names;
C = strsplit(path,'\');
savestr = strcat(C{1,size(C,2)},'frame');
dsframe = [];

h = waitbar(0, '初始化...');
M = [];
% p = genpath(path);% 获得文件夹data下所有子文件的路径，这些路径存在字符串p中，以';'分割
% length_p = size(p,2);%字符串p的长度
% path = {};%建立一个单元数组，数组的每个单元中包含一个目录
% temp = [];
% for i = 1:length_p %寻找分割符';'，一旦找到，则将路径temp写入path数组中
%     if p(i) ~= ';'
%         temp = [temp p(i)];
%     else 
%         temp = [temp '\']; %在路径的最后加入 '\'
%         path = [path ; temp];
%         temp = [];
%     end
% end  
% clear p length_p temp;
% %至此获得data文件夹及其所有子文件夹（及子文件夹的子文件夹）的路径，存于数组path中。
% %下面是逐一文件夹中读取图像
% file_num = size(path,1);% 子文件夹的个数
% for i = 1:file_num
%     file_path =  path{i}; % 图像文件夹路径
%     img_path_list = dir(strcat(file_path,'*.amc'));
%     img_num = length(img_path_list); %该文件夹中图像数量
%     if img_num > 0
%         str = sprintf('第%d/%d个文件夹',i, file_num);
%         waitbar(0, h, str);
%         for j = 1:img_num
%             image_name = img_path_list(j).name;% 图像名
%             %image =  imread(strcat(file_path,image_name));
%             %fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));% 显示正在处理的路径和图像名
%             %图像处理过程 省略
%             [temp, frame] = quat_amc_to_matrix(strcat(file_path,image_name));
%             M = [M temp'];
%             dsframe = [dsframe frame];
%             waitbar(j/img_num, h, str);
%         end
%         waitbar(1, h, str);
%     end
% end

for j = 1:2000
    image_name = strcat(file_names{j,1},'.amc');
    folder = strsplit(file_names{j,1},'_');
    [temp, frame] = quat_amc_to_matrix(strcat(path,'\',folder{1},'\',image_name));
    M = [M temp'];
    dsframe = [dsframe frame];
    str = sprintf('第%d/%d个文件',j, 2000);
    waitbar(j/2000, h, str);
end

dsframe = dsframe';
savestr = ['quat' savestr];
save (savestr, 'dsframe');
close(h);
