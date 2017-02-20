function OUT = mgstat_lite(varargin)


if nargin==0
    s = mfilename;
	eval(['manual ' s])
    return
end

AuthorizedOptions = {'radius', 'min', 'max', 'dims', 'avgidentical',...
                     'xblocksize', 'yblocksize', 'zblocksize',...
                     'misval', 'showcmdfile', 'cmdcomments','mode', 'pop_mean'};

svmodel = varargin{1};

if length(svmodel)==1
    
    xvmodel = [];
    fnames = varargin{2};

    if length(varargin)>2
        for ii=3:2:length(varargin)
              if ~any(strcmp(lower(varargin{ii}), AuthorizedOptions))
                                                    
                     error(['Unauthorized parameter name ' 39 varargin{ii} 39 ' in parameter/value',...
                             10 ' pairs of function: ', 39 mfilename 39 '. ',...
                            'Try: ' 10 10 '>>manual ' mfilename 10 'for an overview ',...
                            'of allowed parameter names.'])
                        
              else
                  if isnumeric(varargin{ii+1})
                      eval(['P_' lower(varargin{ii}) ' = ' num2str(varargin{ii+1}),';'  ])
                  else
                      eval(['P_' lower(varargin{ii}) ' = ' 39 lower(varargin{ii+1}) 39,';'  ])
                  end
              end
        end
        clear ii
    end
    
    
elseif length(svmodel)==2
    
    xvmodel = varargin{2};    
    fnames = varargin{3};
    if length(varargin)>3
        for ii=4:2:length(varargin)
              if ~any(strcmp(lower(varargin{ii}), AuthorizedOptions))
                                                    
                     error(['Unauthorized parameter name ' 39 varargin{ii} 39 ' in parameter/value',...
                             10 'pairs of function: ', 39 mfilename 39 '. ',...
                            'Try: ' 10 10 '>>manual ' mfilename 10 'for an overview ',...
                            'of allowed parameter names.'])
                        
              else
                  if isnumeric(varargin{ii+1})
                      eval(['P_' lower(varargin{ii}) ' = ' num2str(varargin{ii+1}) ,';' ])
                  else
                      eval(['P_' lower(varargin{ii}) ' = ' 39 lower(varargin{ii+1}) 39,';'  ])
                  end
              end
        end
        clear ii
    end
    
elseif length(svmodel)>2
    error('More than two variograms not supported.')
end

%%%% CHECK THE INTEGRITY OF THE INPUT ARGUMENTS:

    if ~exist('P_dims')
        error(['Value of parameter ' 39 'dims' 39 ' must be specified.'])
    end

    if ~exist('P_misval') | (exist('P_misval')& ~isnumeric(str2num(P_misval)))
        error(['Value of parameter ' 39 'misval' 39,... 
            ' must be a char array representation of ' 10,...
            'a numeric value (such as ' 39 '-1' 39 ') in order to enable the use of',...
            10 'function ' 39 'read_eas' 39 ' later on.'])
    end

    if ~exist('P_radius','var')==0 && ~isnumeric(P_radius)
        error(['Value of parameter ' 39 'radius' 39 ' should be numeric.'])
    end

    if ~exist('P_dims','var')==0 && ~isnumeric(P_dims)
        error(['Value of parameter ' 39 'dims' 39 ' should be numeric.'])
    end

    if ~exist('P_min','var')==0 && ~isnumeric(P_min)
        error(['Value of parameter ' 39 'min' 39 ' should be numeric.'])
    end

    if ~exist('P_max','var')==0 && ~isnumeric(P_max)
        error(['Value of parameter ' 39 'max' 39 ' should be numeric.'])
    end

    if ~exist('P_xblocksize','var')==0 && ~isnumeric(P_xblocksize)
        error(['Value of parameter ' 39 'xblocksize' 39 ' should be numeric.'])
    end

    if ~exist('P_yblocksize','var')==0 && ~isnumeric(P_yblocksize)
        error(['Value of parameter ' 39 'yblocksize' 39 ' should be numeric.'])
    end

    if ~exist('P_zblocksize','var')==0 && ~isnumeric(P_zblocksize)
        error(['Value of parameter ' 39 'zblocksize' 39 ' should be numeric.'])
    end

    if ~exist('P_avgidentical','var')==0 && ~any(strcmp(P_avgidentical,{'on','off'}))
        error(['Value of parameter ' 39 'AvgIdentical' 39 ' should be either ' 39 'on' 39 ' or ' 39 'off' 39 '.'])    
    end    

    if ~exist('P_showcmdfile','var')==0
        if ~any(strcmp(P_showcmdfile,{'on','off'}))
            error(['Value of parameter ' 39 'ShowCmdFile' 39 ' should be either ' 39 'on' 39 ' or ' 39 'off' 39 '.'])        
        end
    else
        P_showcmdfile = 'off';
    end

    if exist('P_cmdcomments')
        if ~any(strcmp(P_cmdcomments,{'on','off'}))
            error(['Value of parameter ' 39 'CmdComments' 39 ' should be either ' 39 'on' 39 ' or ' 39 'off' 39 '.'])        
        end
    else
        P_cmdcomments = 'off';
    end

    if exist('P_mode')
        if ~any(strcmp(P_mode,{'p','cs','us'}))
            error(['Value of parameter ' 39 'mode' 39 ' should be either ' 10 39,...
                                               'p' 39 ' (prediction), ',...
                                               'cs' 39 ' (conditional simulation), ' 10,...
                                    'or ' 39 'us' 39 ' (unconditional simulation).'])
        end
    else
        P_mode = 'p';
    end

    if exist('P_pop_mean','var') && ~isnumeric(P_pop_mean)
        error(['Value of parameter ' 39 'pop_mean' 39 ' should be numeric.'])
    end

    if exist('P_mode','var') && strcmp(P_mode,'us')
        if ~exist('P_pop_mean','var')
            error(['Value of parameter ' 39 'pop_mean' 39 ' must be specified' 10 'when using unconditional simulation.'])
        end
    end
    
%%%% END OF INTEGRITY CHECK


fid = fopen(fnames.cmd,'w');

fprintf(fid,[ 35 ' Mgstat Lite command file generated on: ' datestr(now) '\r\n']);
if strcmp(P_mode,'p')
    fprintf(fid,[ 35 ' mode: prediction\r\n\r\n']);
elseif strcmp(P_mode,'cs')
    fprintf(fid,[ 35 ' mode: conditional simulation\r\n\r\n']);
elseif strcmp(P_mode,'us')
    fprintf(fid,[ 35 ' mode: unconditional simulation\r\n\r\n']);
end    

for ii=1:length(svmodel)
    
    if strcmp(P_cmdcomments,'on')
        fprintf(fid,['# data of variable "' svmodel{ii,1}.shortname '":\r\n']);    
    end
    

    if strcmp(P_mode,'us')
        str = [ 'data(' svmodel{ii,1}.shortname '): dummy' ];    
    else
        str = [ 'data(' svmodel{ii,1}.shortname '): ' 39 fnames.data{ii,1} 39 ];    
    end

    

    if strcmp(P_mode,'us')
        str = [str, ', sk_mean = ' num2str(P_pop_mean) ];
    else
        if exist('P_pop_mean','var')
            % simple kriging
            str = [str, ', sk_mean = ' num2str(P_pop_mean) ];            
        end
        if P_dims>=1
            str= [str, ', x=1'];
        end
        if P_dims>=2
            str= [str, ', y=2'];
        end
        if P_dims>=3
            str= [str, ', z=3'];
        end
        str= [str, ', v=' num2str(P_dims+1)];
    end
    
    if exist('P_min')==1
        str = [str, ', min=' num2str(P_min)];
    end
    if exist('P_max')==1
        str = [str, ', max=' num2str(P_max)];
    end
    if exist('P_radius')==1
        str = [str, ', radius=' num2str(P_radius)];
    end
    if exist('P_avgidentical')==1 & strcmp(P_avgidentical,'on')
        str = [str, ', average'];
    end
    
    str = [str,';\r\n'];
    
    fprintf(fid,str);
    
    clear str 
end
clear ii

fprintf(fid,'\r\n');


for ii=1:length(svmodel)
    if strcmp(P_cmdcomments,'on')
        fprintf(fid,['# semivariogram model of variable "' svmodel{ii,1}.shortname '":\r\n']);    
    end
    
    str = [ 'variogram(' svmodel{ii,1}.shortname '): ', num2str(svmodel{ii,1}.c0), ' Nug(0) + ',...
                 num2str(svmodel{ii,1}.c1), ' ', svmodel{ii,1}.type '(',...
                 num2str(svmodel{ii,1}.range), ');\r\n' ];
    fprintf(fid,str);
    
    clear str 
end
clear ii

if ~isempty(xvmodel)
    if strcmp(P_cmdcomments,'on')
        fprintf(fid,['# cross-semivariogram model of variables "' svmodel{1,1}.shortname '" and "' svmodel{2,1}.shortname '":\r\n']);        
    end
    
    fprintf(fid,[ 'variogram(' svmodel{1,1}.shortname  ',' svmodel{2,1}.shortname  '): ',...
                                    '0 Nug(0) + ',...% num2str(xvmodel{1,1}.c0), ' Nug(0) + ',...
                                    num2str(xvmodel{1,1}.c1), ' ', xvmodel{1,1}.type,'(',...
                                    num2str(xvmodel{1,1}.range), ');\r\n' ]);
end
 
fprintf(fid,'\r\n');

if strcmp(P_cmdcomments,'on')
    fprintf(fid,['# prediction locations:\r\n']);
end

str = [ 'data(): ' 39 fnames.pred 39 ];


if P_dims>=1
    str= [str, ', x=1'];
end
if P_dims>=2
    str= [str, ', y=2'];
end
if P_dims>=3
    str= [str, ', z=3'];
end
str = [str,';\r\n\r\n'];

fprintf(fid,str);

clear str 

if exist('P_xblocksize') 
 
    if strcmp(P_cmdcomments,'on')
        fprintf(fid,['# specify block kriging block sizes:\r\n']);    
    end

    str = ['blocksize: dx=' num2str(P_xblocksize)];
    if exist('P_yblocksize') 
        str = [str,', dy=' num2str(P_yblocksize)];
    end
    if exist('P_zblocksize') 
        str = [str, ', dz=' num2str(P_zblocksize)];
    end
    fprintf(fid,'%s;\r\n\r\n',str);
end


if strcmp(P_mode,'cs') | strcmp(P_mode,'us')
    if strcmp(P_cmdcomments,'on')
        fprintf(fid,['# Use Gaussian simulation:\r\n']);    
    end
    fprintf(fid,'%s\r\n\r\n','method: gs;');
    
    if strcmp(P_cmdcomments,'on')
        fprintf(fid,['# Avoid gstat error by setting the zero value from the' 10 35,...
            ' default value (approximately 2e-15) to 1e-8:\r\n']);    
    end
    fprintf(fid,'%s\r\n\r\n','set zero = 1e-8;');
end

if exist('P_misval')==1
    
    if strcmp(P_cmdcomments,'on')
        fprintf(fid,['# Missing value character(s):\r\n']);    
    end
    
    fprintf(fid,[ 'set mv: ' , 39 P_misval, 39, ';\r\n\r\n']);
end


if strcmp(P_cmdcomments,'on')
    fprintf(fid,['# gstat output will be written to:\r\n']);    
end
 
fprintf(fid,[ 'set output: ', 39, fnames.out, 39, ';\r\n\r\n']);

if strcmp(P_cmdcomments,'on')
    fprintf(fid,['# set gstat debug level:\r\n']);    
end

fprintf(fid,[ 'set debug = 2;\r\n\r\n']);

if strcmp(P_cmdcomments,'on')
    fprintf(fid,['# set name of log file to which gstat must write:\r\n']);    
end
fprintf(fid,[ 'set logfile: ', 39, fnames.log, 39, ';\r\n\r\n']);

fclose(fid);

if strcmp(P_showcmdfile,'on')==1
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%% Start of showcmdfile...')
    type(fnames.cmd)
    disp('%% ...end of showcmdfile.')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
end

disp([10 'Running ' 39 'gstat.exe' 39 ' with command file: ' 39 fnames.cmd 39 ' - please wait...' 10])

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('%%% start of output by "gstat.exe"... ')

system([gstat_binary , ' ' , fnames.cmd ]);

disp('%%% ...end of output by "gstat.exe". ')
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')

[OUT] = read_eas(fnames.out);


