clear 
close all
clc

%%%% add the path of the functionality toolbox to the MATLAB path:
    old_path = pwd;
    cd ..
    cd ..
    p01 = [pwd, '\functionality']
    addpath(p01);
    cd (old_path)
    clear old_path
%%%%


data = load('X_Y_Zn.txt');

x = data(:,1);
y = data(:,2);
v = data(:,3);

clear data

pos_known = [x,y];
val_known = v;


%%% something goes here... see >>manual svgram_exp


figure('position',[51   119   651   400])

subplot('position', [0.14, 0.14, 0.77, 0.75])

plot(h_array,gamma_array,'+k','markersize',5)
 
set(gca,'tickdir','out',...
          'xtick', h_array+h_array(1),... % sets tick marks at the bin boundaries
     'xticklabel', [],...
     'yticklabel', [],...     
          'xgrid', 'on',...
           'ylim', [70000,170000],...  % sets the x axis limits
           'xlim', [0,4500])           % sets the y axis limits

      
xlabel('\ith')
ylabel('\it\gamma (h)')


warning([10 '% No automatic updating of the axis labels after using' 10,...
            '% the "zoom" function on the figure toolbar!' ])
reformat_ticks(gca, 'x','%8.0f')
reformat_ticks(gca, 'y','%8.0f')

% Add labels to the axis:
addlabels(h_array,gamma_array,count_array)





