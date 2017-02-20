clc
clear 
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                              %%
%% Add directory to the MATLAB path in order to be able to      %%
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
%% Load your data.                                              %%
%%                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = load('X_Y_Buzzards.txt');

x = data(:,1);
y = data(:,2);
v = data(:,3);

clear data


