function [gamma]=sv_spherical(h,c1,a)

Ix = find((h>=0) & (h<=a));

gamma=c1*ones(size(h));

gamma(Ix) = c1*((3/2)*(h(Ix)/a) - (1/2)*(h(Ix)/a).^3 );






