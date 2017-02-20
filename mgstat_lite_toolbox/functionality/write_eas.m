function write_eas(filename,data,header,formatstr);
% see >>manual write_eas
%
% writes a GEO EAS formatted file into Matlab.
%
% Call write_eas(filename,data,header,title);
%
% filename [string]
% data [ndata,natts] 
% header [structure{natts}] : header values for data columns
% title [string] : optional title for EAS file
%
% 
% This file is an modified version of TM Hansen's. (tmh@gfy.ku.dk)


  
if nargin<1
    help write_eas;
    return;
end

if nargin==1
    data=filename;
    filename='dummy.eas';
    fprintf(1,'%s : Filename not set, using ''%s''.',mfilename,filename)
end

if nargin<3
    for i=1:size(data,2);
        header{i}=sprintf('col%d, unknown',i);
    end
end

line1=sprintf('Data written by mGstat %s',datestr(now));

nd=size(data,2);

fid=fopen(filename,'w');

fprintf(fid,'%s\r\n',line1);
fprintf(fid,'%d\r\n',nd);
for ih=1:nd,
    fprintf(fid,'column %d: %s\r\n',ih,header{ih});
end

if exist('formatstr')==1
    for id=1:size(data,1),
        fprintf(fid, formatstr, data(id,:));
        fprintf(fid, '\r\n');
    end
else
    for id=1:size(data,1),
        fprintf(fid,'%11.7f   %11.7f   %11.7f ',data(id,:));
        fprintf(fid, '\r\n');
    end
end
   
fclose(fid);
   