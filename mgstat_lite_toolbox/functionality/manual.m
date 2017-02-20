function manual(inputname)

if nargin==0
    manual contents
    return
end

p = mfilename('fullpath');
L = length(mfilename);
s = which(mfilename);
str = [s(1:end-L-2) '..\documentation\' inputname '.html'];


if exist(str,'file')==2
    eval(['web(' 39 'file:' str 39, ',' ,39,'-helpbrowser',39,')'] )
else
    eval(['doc ' inputname ])
end
