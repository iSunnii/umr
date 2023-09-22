% Reads data from an AMC motion file into a Matlab matrix variable. 
% AMC file has to be in the AMC format used in the online CMU motion capture library.
% number of dimensions = number of columns = 62
% function D = amc_to_matrix(fname)
% fname = name of disk input file, in AMC format
% Example:
% D = amc_to_matrix(fname)
%

% Jernej Barbic
% CMU
% March 2003
% Databases Course
function [D,frame] = quat_amc_to_matrix_ds(fname)


fid=fopen(fname, 'rt');
if fid == -1,
 fprintf('Error, can not open file %s.\n', fname);
 return;
end;

% read-in header
line=fgetl(fid);
while ~strcmp(line,':DEGREES')
  line=fgetl(fid);
end

D=[];
dims =[6 3 3 2 3 1 1 2 3 1 1 3 1 2 3 1 2];
locations = [1 7 10 13 16 19 22 25 28 31 34 37 40 43 46 49 52];


% read-in data
% labels can be in any order
frame=1;
while ~feof(fid)
%  if rem(frame,100) == 0
% disp('Reading frame: ');
% disp(frame);
%  end;

  row = zeros(54,1);
  quatrow = zeros(68,1);

  % read frame number
  line = fscanf(fid,'%s\n',1);
  linenum = str2num(line);
  if mod(linenum,4)~=1
      for jump = 1:29
          line = fgetl(fid);
      end
      continue
  end

  for i=1:29

 % read angle label
 id = fscanf (fid,'%s',1);

 switch (id)
   case 'root', index = 1;
   case 'lowerback', templine = fgetl(fid);continue;
   case 'upperback', templine = fgetl(fid);continue;
   case 'thorax', index = 2; 
   case 'lowerneck', templine = fgetl(fid);continue;
   case 'upperneck', templine = fgetl(fid);continue;
   case 'head', index = 3;
   case 'rclavicle', index = 4; 
   case 'rhumerus', index = 5;
   case 'rradius', index = 6;
   case 'rwrist', index = 7;
   case 'rhand', templine = fgetl(fid);continue;
   case 'rfingers', templine = fgetl(fid);continue;
   case 'rthumb', templine = fgetl(fid);continue;
   case 'lclavicle', index = 8; 
   case 'lhumerus', index = 9;
   case 'lradius', index = 10;
   case 'lwrist', index = 11;
   case 'lhand', templine = fgetl(fid);continue;
   case 'lfingers', templine = fgetl(fid);continue;
   case 'lthumb', templine = fgetl(fid);continue;
   case 'rfemur', index = 12;
   case 'rtibia', index = 13;
   case 'rfoot', index = 14;
   case 'rtoes', templine = fgetl(fid);continue;
   case 'lfemur', index = 15;
   case 'ltibia', index = 16;
   case 'lfoot', index = 17;
   case 'ltoes', templine = fgetl(fid);continue;
 otherwise
    fprintf('Error, labels in the amc are not correct.\n');
    return;
 end
 
 % where to put the data
 location = locations(index);
 len = dims(index);

 if len == 6
   x = fscanf (fid,'%f %f %f %f %f %f\n',6);
 else 
   if len == 3
  x = fscanf (fid,'%f %f %f\n',3);
   else 
  if len == 2
    x = fscanf (fid,'%f %f\n',2);
  else 
    if len == 1
   x = fscanf (fid,'%f\n',1);
    end
  end
   end
 end
 
 row(location:location+len-1,1) = x;
  end
  
  row(15,1) = row(14,1);
  row(14,1) = row(13,1);
  row(13,1) = 0;
  row(23,1) = row(22,1);
  row(22,1) = 0;
  
  row(27,1) = row(26,1);
  row(26,1) = row(25,1);
  row(25,1) = 0;
  row(35,1) = row(34,1);
  row(34,1) = 0;
  
  row(45,1) = row(44,1);
  row(44,1) = 0;
  
  row(54,1) = row(53,1);
  row(53,1) = 0;
  
  for i = 1:17
      alpha = row(3*i+1);
      beta = row(3*i+2);
      gamma = row(3*i+3);
      q0 = cosd(alpha/2)*cosd(beta/2)*cosd(gamma/2) + sind(alpha/2)*sind(beta/2)*sind(gamma/2);
      q1 = sind(alpha/2)*cosd(beta/2)*cosd(gamma/2) - cosd(alpha/2)*sind(beta/2)*sind(gamma/2);
      q2 = cosd(alpha/2)*sind(beta/2)*cosd(gamma/2) + sind(alpha/2)*cosd(beta/2)*sind(gamma/2);
      q3 = cosd(alpha/2)*cosd(beta/2)*sind(gamma/2) - sind(alpha/2)*sind(beta/2)*cosd(gamma/2);
      %同正处理
      if q0 >= 0
          quatrow(4*(i-1)+1) = q0;
          quatrow(4*(i-1)+2) = q1;
          quatrow(4*(i-1)+3) = q2;
          quatrow(4*(i-1)+4) = q3;
      else
          quatrow(4*(i-1)+1) = -q0;
          quatrow(4*(i-1)+2) = -q1;
          quatrow(4*(i-1)+3) = -q2;
          quatrow(4*(i-1)+4) = -q3;
      end
      
  end
  
  quatrow = quatrow';
  D = [D; quatrow];
  frame = frame + 1;
end

%jiang
frame = frame -1;
%disp('Total number of frames read: ');
%disp(frame);

fclose(fid);