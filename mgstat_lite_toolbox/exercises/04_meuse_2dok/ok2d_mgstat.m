

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

%see >>manual mgstat_lite
svmodel{1,1}.c0 = % XXX        
svmodel{1,1}.c1 = % XXX 
svmodel{1,1}.type = % XXX 
svmodel{1,1}.range = % XXX 
svmodel{1,1}.longname = 'Meuse zinc data 2d ordinary kriging';
svmodel{1,1}.shortname = 'zinc';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Load your data.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = load('X_Y_Zn.txt');

x = data(:,1);
y = data(:,2);
v = data(:,3);

clear data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Define your filenames array.                                 %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fnames.data{1} = ['obs_' svmodel{1,1}.shortname '.eas'];
fnames.pred = 'pred_pos.eas';
fnames.cmd =  'ok2d.cmd';
fnames.out =  'ok2d.out';
fnames.log =  'ok2d.log'



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Calculate interpolation locations.                           %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

extent_x = [178000:25:182000];
extent_y = [329500:25:334000];

[Xg,Yg] = meshgrid(extent_x,extent_y);

pos_known = [x,y];
val_known = v;

pos_est = [Xg(:),Yg(:)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Write loaded data and interpolation locations to file        %%
%% in *eas format.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_eas(fnames.data{1,1},[pos_known val_known],...
    {'x-coord','y-coord','observed zinc value'},'%10u%10u%10u');
write_eas(fnames.pred,pos_est,{'x-coord','y-coord'},'%10u%10u');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Call mgstat with the correct options.                        %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


G = mgstat_lite() % something goes here


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Read the gstat data back into MATLAB; visualize and analyze  %%
%% your results.                                                %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



pre = reshape(G(:,3),size(Xg));
var = reshape(G(:,4),size(Xg));

% as an alternative to the visualization scheme below, you might 
% want to use "imagesc" for quick & easy visualization.

figure('position',[50   463   500   467])
imagesc_plot(pre,x/1000,y/1000, [extent_x(1),500,extent_x(end)]/1000,...
                                [extent_y(1),500,extent_y(end)]/1000)

reformat_ticks(gca, 'x','%8.1f')
xlabel('E-W distance [km]')
reformat_ticks(gca, 'y','%8.1f')
ylabel('N-S distance [km]')
title('Location map - ordinary kriging predictions')
grid on
colormap(flipud(summer))


figure('position',[558   463   504   467])
imagesc_plot(var,x/1000,y/1000, [extent_x(1),500,extent_x(end)]/1000,...
                                [extent_y(1),500,extent_y(end)]/1000)

reformat_ticks(gca, 'x','%8.1f')
xlabel('E-W distance [km]')
reformat_ticks(gca, 'y','%8.1f')
ylabel('N-S distance [km]')
title('Location map - estimation variances')
grid on
colormap(copper)

