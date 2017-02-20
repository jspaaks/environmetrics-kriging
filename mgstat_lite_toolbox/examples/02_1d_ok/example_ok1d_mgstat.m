

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


svmodel{1,1}.c0 = 0;
svmodel{1,1}.c1 = 1;
svmodel{1,1}.type = 'Sph';
svmodel{1,1}.range = 2;
svmodel{1,1}.longname = 'test variable ordinary kriging';
svmodel{1,1}.shortname = 'testvar';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Load your data.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = [10:10:75]';
v = [4+round(randn(size(x))*4)]; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Define your filenames array.                                 %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fnames.data{1,1} = ['obs_' svmodel{1,1}.shortname '.eas'];
fnames.pred = 'pred_pos.eas';
fnames.cmd =  'ok1d.cmd';
fnames.out =  'ok1d.out';
fnames.log =  'ok1d.log'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Calculate interpolation locations.                           %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pos_known = x;
val_known = v;
pos_est = unique([[min(x):0.1:max(x)]';pos_known]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Write loaded data and interpolation locations to file        %%
%% in *eas format.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_eas(fnames.data{1,1}, [pos_known val_known],...
    {'measurement location (x)','obs_val'}, '%8.1f%8.1f');

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
                         'cmdcomments', 'on');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Read the gstat data back into MATLAB; visualize and analyze  %%
%% your results.                                                %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure('position',[50   463   500   467])
plot(G(:,1),G(:,2),'-b',G(:,1),G(:,3),'-m',pos_known,val_known,'b.')

xlabel('x')
ylabel('y')
title('1d ordinary kriging predictions and variances')
grid on

