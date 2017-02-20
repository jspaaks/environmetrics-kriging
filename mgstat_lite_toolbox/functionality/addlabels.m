function addlabels(h, gamma, count)

for ii = 1:length(count)
    
    if h(ii)<max(get(gca,'Xlim'))
        
        text(h(ii),gamma(ii),[10,num2str(count(ii),'%8.0f')],...
            'verticalalign','top',...
            'horizontalalign','center',... 
            'fontsize', 10)
    end
    
end
