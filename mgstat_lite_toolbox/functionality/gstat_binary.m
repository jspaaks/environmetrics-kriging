% gstat_binary : returns the path to the binary gstat
%
% Call :
%    gstat_bin = gstat_binary;
%
function gstat=gstat_binary;
%commented by JHS2006:
%gstat='/usr/local/bin/gstat';
%end of comment -JHS2006

% YOU CAN EITHER SPECIFY THE PATH TO GSTAT HERE BELOW
%  gstat='/home/tmh/bin/gstat-2.4.0';
%  gstat='/home/tmh/bin/gstat-2.4.3/src/gstat';
% gstat='/home/tmh/RESEARCH/PROGRAMMING/mGstat/gstat/gstat';
%gstat='d:\thomas\Programming\mGstat\gstat.exe';

%decommented by JHS2006:
gstat='';
%end of decomment by JHS2006:


% IF THE gstat VARAIABLE IS ÆEFT EMPTY(DEFAULT)
% IT WILL BE LOCATED ON YOUR SYSTEM IF THE
% GSTAT EXECUTABLE IS SOMEWEHRE IN THE PATH

if isempty(gstat)
    [p,f,s]=fileparts(which('gstat_binary'));
    if ~isempty(p)
        if isunix
            %location of 'gstat.exe' (relative to the location 
            %of the mgstat toolbox) set by JHS2006:
            gstat=sprintf('%s/../gstat_executable/gstat',p);
        else
            %location of 'gstat.exe' (relative to the location 
            %of the mgstat toolbox) set by JHS2006:
            gstat=[sprintf('%s',p),'\gstat.exe'];
        end
    else
        gstat='';
    end
end

if isempty(gstat)
    if isunix
        [s,w]=system('which gstat');


        if isempty(w),
            [p,f,s]=fileparts(which('gstat'));
            gstat=fullfile(p,'gstat');
        else
            gstat=w(1:length(w)-1);
        end
    else
        gstat='gstat.exe';
        %  [p,f,s]=fileparts(which('gstat'));
        %  if isempty(p),
        %    gstat='gstat.exe';
        %  else
        %       gstat=fullfile(p,'gstat.exe');
        %  end
    end

    if exist(gstat)==0,
        gstat='';
    end
end




if isempty(gstat)
    mgstat_verbose('--------------------------------------------------',-1);
    mgstat_verbose('FATAL ERROR !!! ----------------------------------',-1);

    mgstat_verbose('COULD NOT FIND GSTAT EXECUTABLE ',-1);
    mgstat_verbose(sprintf('Please edit ''%s.m'' to point to the',mfilename),-1);
    mgstat_verbose('the location of gstat or put gstat somewhere',-1);
    mgstat_verbose('in the system path !',-1);
    mgstat_verbose('--------------------------------------------------',-1);
    gstat='';
    return;
end

