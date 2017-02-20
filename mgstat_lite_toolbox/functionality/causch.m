function OUT = causch(svmodel, xvmodel, lagvec)
% tests whether the cauchy-schwartz condition is met over the domain "lagvec".
% see >>manual causch

if nargin==0
    s = mfilename;
	eval(['manual ' s])
    return
end

Ix = find(lagvec>0);

lagvec = lagvec(Ix);


sv_U = calc_gamma(svmodel(1), lagvec);
sv_V = calc_gamma(svmodel(2), lagvec);
sv_UV = calc_gamma(xvmodel(1), lagvec);

% figure
% subplot(4,1,1)
% plot(lagvec,sv_U,'-b.')
% title(['sv_U'])
% 
% subplot(4,1,2)
% plot(lagvec,sv_V,'-r.')
% title(['sv_V'])
% 
% subplot(4,1,3)
% plot(lagvec,abs(sv_UV),'-m.')
% title(['abs(sv_UV)'])


A = abs(sv_UV); 
B = sqrt(sv_U .* sv_V);

% subplot(4,1,4)
% plot(lagvec,A,'-m.',lagvec,B,'-g.')
% legend(['A = abs(sv_UV)'],['B = sqrt(sv_U .* sv_V)'])
% axis([0,max(lagvec),0,1.1*max([A(:);B(:)])])


if all(A<B)
    
    OUT = logical(1);
    
else
    
    OUT = logical(0);
    
end
