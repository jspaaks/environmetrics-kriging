

clc
clear 
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Add directories to the MATLAB path in order to be able to    %%
%% use the functions in them.                                   %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

old_path = pwd;
cd ..
cd ..
p01 = [pwd, '\functionality']

addpath(p01);

cd (old_path)
clear old_path


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Define semivariogram model(s) and/or cross-variogram model.  %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


svmodel{1,1}.c0 = 0.1;
svmodel{1,1}.c1 = 500;
svmodel{1,1}.type = 'Gau';
svmodel{1,1}.range = 25;
svmodel{1,1}.longname = 'rockfall model - elevation; conditional simulation';
svmodel{1,1}.shortname = 'cs_rockfall';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Calculate trend                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = [0:75:500]';                           % observation locations  

eps_acc = 10*randn(size(x));     % autocorrelated term epsilon'(s) 

m = 3250+250*sin(2*pi*(x-250)/1000);             % trend term m(s)

y = m + eps_acc;

xHD = [min(x):5:max(x)]';   % high definition x for input to trend

yHD = 3250+250*sin(2*pi*(xHD-250)/1000);   % high definition trend

v = eps_acc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Define your filenames array.                                 %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fnames.data{1,1} = ['obs_' svmodel{1,1}.shortname '.eas'];
fnames.pred = 'pred_pos.eas';
fnames.cmd =  'cs1d.cmd';
fnames.out =  'cs1d.out';
fnames.log =  'cs1d.log'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Calculate interpolation locations.                           %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pos_known = x;
val_known = v;
pos_est = unique([xHD;pos_known]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Write loaded data and interpolation locations to file        %%
%% in *eas format.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_eas(fnames.data{1,1}, [pos_known val_known],...
     {'measurement location (x)','obs_val'}, '%8.2f%10.4f');
write_eas(fnames.pred,pos_est,...
    {'observation location (x)'}, '%8.2f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Call mgstat with the correct options.                        %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

G = mgstat_lite(svmodel,fnames, 'dims',  size(pos_known,2),...
                              'MisVal', '-1',...
                         'showcmdfile', 'on',...
                                'mode', 'cs',...
                         'cmdcomments', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Read the gstat data back into MATLAB; visualize and analyze  %%
%% your results.                                                %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure('position',[50   573   627   357])

[sort_x_cs,Ix] = sort(G(:,1));

m_est = 3250+250*sin(2*pi*(sort_x_cs-250)/1000);

sort_y_cs = m_est + G(Ix,2);

plot(sort_x_cs,sort_y_cs,'k-',pos_known, y,'ok')

axis image    

set(gca,'xlim',[-99,599],...
        'ylim',[2900,3600]) 


xlabel('x')
ylabel('elevation')
title( [svmodel{1,1}.longname])






