function [gamma]=sv_nugget(h,c0)

Ix = find(h>0);

gamma = zeros(size(h));

gamma(Ix) = c0;






