function varargout=imagesc_plot(M,xdata,ydata, xax, yax)
%combined plotting of imagesc and plot data
% function call: imagesc_plot(M,xdata,ydata, xax, yax)
% M       : 2-D matrix with imagesc data
% xdata   : vector with plot data x
% ydata   : vector with plot data y
% xax     : x axis; format is (1x3 vector) [minimum : interval : maximum]
% yax     : y axis; format is (1x3 vector) [minimum : interval : maximum]
% cornerpoints of xax and yax should correspond with those of M
% 
if nargin==0
    s = mfilename;
	eval(['manual ' s])
    return
end



xax01 = [1:1:size(M,2)];
xax02 = [xax(1):xax(2):xax(3)];

yax01 = [1:1:size(M,1)];
yax02 = [yax(1):yax(2):yax(3)];


%%%%%%%%%%%%%%%%%%%%%%

Ax01 = axes('position', [0.14, 0.14, 0.77, 0.75],'layer','top');
imagesc(M)
axis image
axis off

set(gca,  'xlim', [min(xax01),max(xax01)],...
          'ylim', [min(yax01),max(yax01)],...
          'Ydir','normal')    
Hi = gca;

colorbar


%%%%%%%%%%%%%%%%%%%%%%

Ax02 = axes('position', get(Ax01,'position'));
plot(xdata,ydata,'ok','markersize',5,...
    'markerfacecolor','w',...
    'markeredgecolor','k')

axis image

set(gca,'xtick',xax02,...
        'ytick',yax02,...
        'ylim', [yax(1),yax(3)],...
        'xlim',[xax(1),xax(3)],...
        'color', 'none')

Hp = gca;
    
if nargout==2
    varargout = {Hi,Hp};
end
