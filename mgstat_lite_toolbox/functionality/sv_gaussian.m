function [gamma]=sv_gaussian(h,c1,a)
% Gaussian semivariogram model
%
% example:
% hv = [0:0.1:250]
% c1 = 20
% a = 50
% 
% [gv]=sv_gaussian(hv,c1,a)
% plot(hv,gv,'k-')

gamma = c1.*(1-exp(-(h/a).^2));



