function reformat_ticks(cur_axes, axis, format_str)
% reformats the axis "axis" in the current axes "cur_axes"
% according to the format string "format_str".

if strcmp(axis,'x')
    
    XT = get(cur_axes,'xtick');
    set(cur_axes, 'xticklabel', num2str(XT(:),format_str))
    
elseif strcmp(axis,'y')

    YT = get(cur_axes,'ytick');
    set(cur_axes, 'yticklabel', num2str(YT(:),format_str))
    
else
    
    warning('Axis not formatted.')

end

