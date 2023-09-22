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

h = waitbar(0, '��ʼ��...');
M = [];
% p = genpath(path);% ����ļ���data���������ļ���·������Щ·�������ַ���p�У���';'�ָ�
% length_p = size(p,2);%�ַ���p�ĳ���
% path = {};%����һ����Ԫ���飬�����ÿ����Ԫ�а���һ��Ŀ¼
% temp = [];
% for i = 1:length_p %Ѱ�ҷָ��';'��һ���ҵ�����·��tempд��path������
%     if p(i) ~= ';'
%         temp = [temp p(i)];
%     else 
%         temp = [temp '\']; %��·���������� '\'
%         path = [path ; temp];
%         temp = [];
%     end
% end  
% clear p length_p temp;
% %���˻��data�ļ��м����������ļ��У������ļ��е����ļ��У���·������������path�С�
% %��������һ�ļ����ж�ȡͼ��
% file_num = size(path,1);% ���ļ��еĸ���
% for i = 1:file_num
%     file_path =  path{i}; % ͼ���ļ���·��
%     img_path_list = dir(strcat(file_path,'*.amc'));
%     img_num = length(img_path_list); %���ļ�����ͼ������
%     if img_num > 0
%         str = sprintf('��%d/%d���ļ���',i, file_num);
%         waitbar(0, h, str);
%         for j = 1:img_num
%             image_name = img_path_list(j).name;% ͼ����
%             %image =  imread(strcat(file_path,image_name));
%             %fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));% ��ʾ���ڴ����·����ͼ����
%             %ͼ������� ʡ��
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
    str = sprintf('��%d/%d���ļ�',j, 2000);
    waitbar(j/2000, h, str);
end

dsframe = dsframe';
savestr = ['quat' savestr];
save (savestr, 'dsframe');
close(h);
