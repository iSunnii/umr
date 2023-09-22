%runcode
%HDM05.quat

logpath = '.\retr\log.txt';

windowmin = 2;
windowmax = 2;%not less than 2

iffoldcross = 0;%0 or 1

testnum = 99;%upper limit
weighttype = 1;%1=STA type
metrictype = 1;%euclidean

realnoise = zeros(11,5);
ifdumb = 0;
dumbsuperi = 1;
dumbsuperk = 1;
dumbsuperii = 20;

%dsname = 'HDM05_Test10_20';
dsname = 'HDM05_Test10_20+28_ap';

% dsfname = ['quat' dsname 'frame.mat'];
% load(dsfname);
load(['quat' dsname 'frame.mat']);

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

if ifdumb == 0
    dumbsuperi = 1;
    dumbsuperk = 1;
    dumbsuperii = 1;
end
    
for dumbsuper = dumbsuperi:dumbsuperk:dumbsuperii
    dumbk =dumbsuper;

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
    representation2 = representation;
    
    
%     %噪声
%     dumbk =3;
%     for dumb = 1:floor(size(representation,1)/50)
%         dumbrand = randperm(49);
%         for dumbii = 1:dumbk
%         dumbr = dumbrand(dumbii);
%         for dumbi = 1:4
%             representation(50*dumb-dumbr,dumbi)=8*rand(1)-4;
%         end
%         end
%     end

if ifdumb ~= 0
%     噪声,STA演示
%     dumbk =1;
    

    for dumb = 1:floor(size(representation,1)/800)
        dumbrand = randperm(40);
        for dumbii = 1:dumbk
        dumbr = dumbrand(dumbii);
        dumbrandall = ceil(rand(1)*(size(representation,1)-21)+21);
        for dumbi = 1:6
            for dumbframe = 1:20
                representation(800*(dumb-1)+20*dumbr-dumbframe+1,dumbi)=representation2(dumbrandall-dumbframe,dumbi);

% % noise 2
%     for dumb = 1:floor(size(representation,1)/200)
%         dumbrand = randperm(40);
%         for dumbii = 1:1
%         dumbr = dumbrand(dumbii);
%         dumbrandall = ceil(rand(1)*(size(representation,1)-5*dumbsuper-1)+5*dumbsuper+1);
%         for dumbi = 1:6
%             for dumbframe = 1:5*dumbsuper
%                 representation(200*(dumb-1)+5*dumbsuper-dumbframe+1+3*dumbr,dumbi)=representation2(dumbrandall-dumbframe,dumbi);

%             representation(400*dumb-10*dumbr+5,dumbi)=representation2(dumbrandall,dumbi);
%             representation(400*dumb-10*dumbr+4,dumbi)=representation2(dumbrandall-1,dumbi);
%             representation(400*dumb-10*dumbr+3,dumbi)=representation2(dumbrandall-2,dumbi);
%             representation(400*dumb-10*dumbr+2,dumbi)=representation2(dumbrandall-3,dumbi);
%             representation(400*dumb-10*dumbr+1,dumbi)=representation2(dumbrandall-4,dumbi);
%             representation(400*dumb-10*dumbr-5,dumbi)=representation2(dumbrandall-5,dumbi);
%             representation(400*dumb-10*dumbr-6,dumbi)=representation2(dumbrandall-6,dumbi);
%             representation(400*dumb-10*dumbr-7,dumbi)=representation2(dumbrandall-7,dumbi);
%             representation(400*dumb-10*dumbr-8,dumbi)=representation2(dumbrandall-8,dumbi);
%             representation(400*dumb-10*dumbr-9,dumbi)=representation2(dumbrandall-9,dumbi);
            end
        end
        end
    end
end
    
    
    dspath = ['.\dataset\' dsname];
    [F,file,filename] = load_file_hdm05(dspath,representation,dsframe,pred_clusters);
    %toc;
    %fprintf('hdm05 label loaded\n');
    fprintf('%s\n',path{p,1});
    if iffoldcross==1
        fprintf('labelresult loaded & distance computed & hdm05 label loaded\n');
        [F0,Ft] = split2fold(F);
    end

    
    for window =windowmin:windowmax
        
        if iffoldcross == 0
            [E,Enum] = genE(F,testnum);
            %fprintf('F loaded as examples\n');
            
            [result1,queryresultall,map,mapoverall] = query_unfold(Distance,window,F,E,0.5,testnum,Enum,weighttype,fid,p);
            result(:,window,p)= result1(:,1);
            
            %意义不明
% %             disall = 0;
% %             for disi = 1:20
% %                 disall = disall + queryresultall{1,disi}(2);
% %             end
%             disall = 0;
%             for disi = 1:20
%                 disall = disall + queryresultall{1,disi}(2);
%             end
%             realnoise(dumbsuper+1,window) = disall;
%             fprintf('disall is %f \n',disall);
        
        elseif iffoldcross==1
            for fold = 1:2
                if fold == 1
                    [E,Enum] = genE(Ft,testnum);
                    %toc;
                    fprintf('Ft loaded as examples\n');
                    
                    %[queryresultall] = queryall_hdm05(Distance,6,F,E,0.5,testnum);
                    [queryresultall] = queryall_hdm05(Distance,window,F0,E,0.5,testnum,Enum,weighttype);
                    
                    %[ap,map,mapoverall] = computemap_hdm05(queryresultall,F,testnum);
                    [ap,map,mapoverall] = computemap_hdm05(queryresultall,F0,testnum);
                    
                    %[k1,kclass,kall] = computek_hdm05(queryresultall,F,testnum);
                    [k1,kclass,kall] = computek_hdm05(queryresultall,F0,testnum,1);
                    
                    result{window,5} = mapoverall;
                    result{window,6} = kall;
                    toc;
                    time = toc;
                    fprintf('dictionary %d --- windowsize %d --- fold %d done\n',p,window,fold);
                    fprintf(fid,'windowsize %d --- fold %d\n',window,fold);
                    fprintf('mapoverall %f --- kall %f --- time %d\n',mapoverall,kall,round(time));
                    fprintf(fid,'mapoverall %f --- kall %f --- time %d\n',mapoverall,kall,round(time));
                    result{window,7} = time;
                    
                elseif fold == 2
                    [E,Enum] = genE(F0,testnum);
                    %toc;
                    fprintf('F0 loaded as examples \n');
                    
                    %[queryresultall] = queryall_hdm05(Distance,6,F,E,0.5,testnum);
                    [queryresultall] = queryall_hdm05(Distance,window,Ft,E,0.5,testnum,Enum,weighttype);
                    

                    %[ap,map,mapoverall] = computemap_hdm05(queryresultall,F,testnum);
                    [ap,map,mapoverall] = computemap_hdm05(queryresultall,Ft,testnum);
                    
                    %[k1,kclass,kall] = computek_hdm05(queryresultall,F,testnum);
                    [k1,kclass,kall] = computek_hdm05(queryresultall,Ft,testnum,1);
                    
                    result{window,8} = mapoverall;
                    result{window,2} = (result{window,8} + result{window,5})/2;
                    result{window,9} = kall;
                    result{window,3} = (result{window,9} + result{window,6})/2;
                    
                    toc;
                    time = toc;
                    fprintf('dictionary %d --- windowsize %d --- fold %d done\n',p,window,fold);
                    fprintf(fid,'windowsize %d --- fold %d\n',window,fold);
                    fprintf('mapoverall %f --- kall %f --- time %d\n',mapoverall,kall,round(time));
                    fprintf(fid,'mapoverall %f --- kall %f --- time %d\n',mapoverall,kall,round(time));
                    result{window,4} = round(time);
                    result{window,10} = result{window,4} - result{window,7};
                else
                    fprintf('Fold number overflow \n');
                    
                end
            end
        else
            error('iffoldcross is wrong!')
        end
        
        fprintf('');
    end
    
    STR = sprintf('%sResult-%s-%s.mat',path{p,1},datestr(now,30),typestr);
    %save(STR, 'result');
    fprintf(fid,'dictionary %d done at %s\n',p,datestr(now,31));
end


end

fclose(fid);