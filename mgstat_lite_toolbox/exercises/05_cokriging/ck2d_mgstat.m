

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

svmodel{1,1}.c0 = %;
svmodel{1,1}.c1 = %;
svmodel{1,1}.type = %;
svmodel{1,1}.range = %;
svmodel{1,1}.longname = 'LN of zinc concentration [ppm]';
svmodel{1,1}.shortname = 'LN_zinc';

svmodel{2,1}.c0 = %;
svmodel{2,1}.c1 = %;
svmodel{2,1}.type = %;
svmodel{2,1}.range = %;
svmodel{2,1}.longname = 'normalized distance [m]';
svmodel{2,1}.shortname = 'ndist';

xvmodel{1,1}.c0 = %;
xvmodel{1,1}.c1 = %;
xvmodel{1,1}.type = %;
xvmodel{1,1}.range = %;
xvmodel{1,1}.longname = 'cross-variogram';
xvmodel{1,1}.shortname = 'LNZn_x_nD';


if ~causch(svmodel, xvmodel, linspace(0,1000,10000))
    error('Cauchy-Schwartz condition not met.')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Load your data.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read untransformed zinc values:
[x01,y01,zinc] = textread('X_Y_Zn.csv', '%u%u%u',...
                   'headerlines',1, 'delimiter', ',');   
               
% Read normalized distance-to-river values:               
[x02,y02,ndist] = textread('X_Y_D250.csv', '%u%u%f',...
                   'headerlines', 1, 'delimiter', ',');
               
% transformations here...
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Define your filenames array.                                 %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii=1:length(svmodel)
    fnames.data{ii,1} = ['obs_' svmodel{ii,1}.shortname '.eas'];
end

fnames.pred = 'pred_pos.eas';
fnames.cmd =  'ck2dm.cmd';
fnames.out =  'ck2dm.out';
fnames.log =  'ck2dm.log'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Calculate interpolation locations.                           %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



extent_x = [178000:50:182000];
extent_y = [329500:50:334000];

[Xg,Yg] = meshgrid(extent_x,extent_y);

pos_est = [Xg(:),Yg(:)];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Write loaded data and interpolation locations to file        %%
%% in *eas format.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_eas(fnames.data{1,1},[x01,y01,LN_zinc],...
    {'xcoord','ycoord','zinc'},'%10u%10u%10.5f');

write_eas(fnames.data{2,1},[x02,y02,ndist2],...
    {'xcoord','ycoord','ndist2'},'%10u%10u%10.5f');

write_eas(fnames.pred,pos_est,...
    {'xcoord','ycoord'},'%10u%10u');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Call mgstat with the correct options.                        %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



G = mgstat_lite(svmodel,xvmodel,fnames,'dims', 2,...
                                     'MisVal', '-1',...
                                     'showcmdfile','on',...
                                     'cmdcomments','off');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Read the gstat data back into MATLAB; visualize and analyze  %%
%% your results.                                                %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pred_ln_zinc = reshape(G(:,3),size(Xg));
 var_ln_zinc = reshape(G(:,4),size(Xg));

figure
imagesc(pred_ln_zinc)
set(gca, 'ydir','normal')
axis image 
colorbar

figure
imagesc(var_ln_zinc)
set(gca, 'ydir','normal')
axis image 
colorbar

%if everthing is working you may uncomment the command below:
% return

figure('position',[50   463   500   467])
imagesc_plot(exp(pred_ln_zinc),x01/1000,y01/1000, [extent_x(1),500,extent_x(end)]/1000,...
                                [extent_y(1),500,extent_y(end)]/1000)

reformat_ticks(gca, 'x','%8.1f')
xlabel('E-W distance [km]')
reformat_ticks(gca, 'y','%8.1f')
ylabel('N-S distance [km]')
title(['Location map' 10 'cokriging prediction'])
grid on
colormap(jet)



figure('position',[558   463   504   467])
imagesc_plot(var_ln_zinc,x01/1000,y01/1000, [extent_x(1),500,extent_x(end)]/1000,...
                                [extent_y(1),500,extent_y(end)]/1000)

reformat_ticks(gca, 'x','%8.1f')
xlabel('E-W distance [km]')
reformat_ticks(gca, 'y','%8.1f')
ylabel('N-S distance [km]')
title(['Location map' 10 'cokriging estimation variances'])
grid on
colormap(jet)

