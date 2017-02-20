

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

