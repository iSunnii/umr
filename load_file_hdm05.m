function [F,file,filename] = load_file_hdm05(path,representation,dsframe,pred_clusters)
%=================================
%Read all the amc files exsit in a given 
%file folder and all the sub-folders.
%T files, n frames every file, 62DoFs every
%frame.
%Matrix M: T*n by 62 matrix.

labelresult = computelabel(representation,pred_clusters);

h = waitbar(0, '��ʼ��...');
resultframe = 1;
%F = [];
p = genpath(path);% ����ļ���data���������ļ���·������Щ·�������ַ���p�У���';'�ָ�
length_p = size(p,2);%�ַ���p�ĳ���
path = {};%����һ����Ԫ���飬�����ÿ����Ԫ�а���һ��Ŀ¼
temp = [];
%dsframe = [];
filenumsum=1;
for i = 1:length_p %Ѱ�ҷָ��';'��һ���ҵ�����·��tempд��path������
    if p(i) ~= ';'
        temp = [temp p(i)];
    else 
        temp = [temp '\']; %��·���������� '\'
        path = [path ; temp];
        temp = [];
    end
end 
clear p length_p temp;
%���˻��data�ļ��м����������ļ��У������ļ��е����ļ��У���·������������path�С�
%��������һ�ļ����ж�ȡͼ��
file_num = size(path,1);% ���ļ��еĸ���
%Fcount = 1;
F = cell(file_num,4);
file = zeros(1,file_num);
for i = 1:file_num
    file_path =  path{i}; % ͼ���ļ���·��
    img_path_list = dir(strcat(file_path,'*.amc'));
    img_num = length(img_path_list); %���ļ�����ͼ������
    file(1,i)=img_num;
    if img_num > 0
        str = sprintf('��ȡ��%d/%d���ļ���',i, file_num);
        waitbar(0, h, str);
        for j = 1:img_num
            image_name = img_path_list(j).name;% ͼ����
            %image =  imread(strcat(file_path,image_name));
            %fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));% ��ʾ���ڴ����·����ͼ����
            %ͼ������� ʡ��
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
%             %���ַ���
%             [~,n]=size(A);
%             s=zeros(1,n);
%             for k = 1:n
%                 [~, Y] = max(abs(A(:,k)));
%                 s(k) = Y;
%             end
            
            indlas = strfind(image_name,'.');%Jiang��ȡ������Ϊ����ֵ
            filename{filenumsum,1} = image_name(1:indlas-1);

            %�ַ���ȥ�����ظ�
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