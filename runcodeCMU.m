%runcodeCMU
logpath = '.\retr\log.txt';

windowmin = 2;
windowmax = 2;%not less than 2
isdesc=1;

testnum = 15;%upper limit
weighttype = 1;%1=STA type
metrictype = 1;%euclidean

dsname = 'CMU_ds_';

load(['quat' dsname 'frame.mat']);
load('CMU2000name.mat');

path = gendictpath(['.\retr\' dsname ]);

fid = fopen(logpath,'at');

if weighttype == 1
    typestr = 'normalweight';
elseif weighttype == 2
    typestr = 'selfweighted';
elseif weighttype == 3
    typestr = 'xia';
elseif weighttype == 4
    typestr = 'DTW';
else 
    error('weighttype wrong!')
end

result = cell(13,windowmax,size(path,1));
%result2 = zeros(p,5);

for p = 1:size(path,1)
    fprintf(fid,'\ndate: %s\ntype: %s\n',datestr(now,31),typestr);
    fprintf(fid,'dictionary path %s\n',path{p,1});
    result(1:13,1,p)=resultname(); 
    
    STR = sprintf('%spred_clusters.csv',path{p,1});
    pred_clusters=csvread(STR);
    [Distance] = cal_distance(pred_clusters,metrictype);
    
    STR = sprintf('%srepresentation.csv',path{p,1});
    %labelresult=csvread('pred_label_t.csv');
    representation=csvread(STR);
    %labelresult = labelresult + 1;
    
    dspath = ['.\dataset\' 'CMU'];
    [F,file,filename] = load_file_CMU_ds(representation,dsframe,pred_clusters);
    %toc;
    %fprintf('hdm05 label loaded\n');
    
    for window =windowmin:windowmax
        
        [E,Enum] = genECMU(F,testnum,isdesc);
        %fprintf('F loaded as examples\n');
        
        [result1,queryresultall,map,mapoverall] = query_unfoldCMU(Distance,window,F,E,0.5,testnum,Enum,weighttype,fid,p);
        result(:,window,p)= result1(:,1);
        
        fprintf('');
        for kk = 1:5
            result2(p,kk)=result1{kk};
        end
    end
    
    STR = sprintf('%sResult-%s-%s.mat',path{p,1},datestr(now,30),typestr);
    %save(STR, 'result');
    fprintf(fid,'dictionary %d done at %s\n',p,datestr(now,31));
end
csvwrite('result.csv',result2)
fclose(fid);