function g = calc_gamma(svmodel, hvec)
% see >> manual calc_gamma

if nargin==0
    s = mfilename;
	eval(['manual ' s])
    return
end

str = ['sv_nugget(hvec,' num2str(svmodel{1,1}.c0) ') + '];

if strcmp(lower(svmodel{1,1}.type),'exp')
    str =[str,'sv_exponential('];
elseif strcmp(lower(svmodel{1,1}.type),'gau')
    str =[str,'sv_gaussian('];
elseif strcmp(lower(svmodel{1,1}.type),'sph')
    str =[str,'sv_spherical('];
else
    error('This should not happen')
end 
    
str = ['g = ' str,'hvec,' num2str(svmodel{1,1}.c1),...
                         ',' num2str(svmodel{1,1}.range),');' ];
eval(str)
