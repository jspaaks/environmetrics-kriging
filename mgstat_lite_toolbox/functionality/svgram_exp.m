function varargout = svgram_exp(pos,val,varargin)
% semivar_exp : Calculate experimental variogram
% see >>manual svgram_exp


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First, test the integrity input variables:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    s = mfilename;
	eval(['manual ' s])
    return
end

L = length(varargin)/2;
if ~isint(L)
    error(['Incomplete parameter/value pairs in function: ' 39 mfilename 39 '.'])
end

for ii=1:L
    if any(strcmp(lower(varargin{2*ii-1}), {'cutoff', 'width', 'nbins','nbins_angle'}))
       varargin{2*ii-1} = lower(varargin{2*ii-1});
       eval([varargin{2*ii-1} '= varargin{2*ii};'])
    else
        error(['Wrong parameter name in parameter/value pairs of function: ',...
                39 mfilename 39 '.' 10 'Parameter name should be one or more of the following: ',...
                39 'cutoff' 39 ', ' 39 'width' 39 ', ' 39 'nbins' 39 ' or ' 39 'nbins_angle' 39 '.'])
    end
       
end
clear varargin L ii

if exist('width') & exist('cutoff') & width>cutoff
    error([10 mfilename ': input variable ' 39 'width' 39 ' should be smaller' 10,...
            ones(1,length(mfilename)+2)*32 ' than variable ' 39 'cutoff' 39 '.' 10])
end

if exist('nbins')==1 & ~isint(nbins)
    error(['Variable ' 39 'nbins' 39 'must be integer in function: ' 39 mfilename 39 '.'])
end


if exist('nbins_angle')==1
    if ~isint(nbins_angle)
        error(['Variable ' 39 'nbins_angle' 39 'must be integer in function: ' 39 mfilename 39 '.'])    
    end
    
    if any(size(pos)==1) & length(size(pos))==2
        error(['Function: ' 39 mfilename 39 ': Parameter ' 39 'angle_bins' 39,...
            ' should only be used with 2-D data.'])        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End of input variables integrity test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





ndata=size(pos,1);
ndims=size(pos,2);

ndata_types=size(val,2);

% First calculate the 'distance' vector
nh=sum(1:1:(ndata-1)); % Find number of pairs of data

h=zeros(nh,1);
dp=zeros(nh,ndims);
z_head=zeros(nh,ndata_types);
z_tail=zeros(nh,ndata_types);
gamma01=zeros(nh,ndata_types);
vang=zeros(nh,1);

i=0;
for i1=1:(ndata-1)
    for i2=(i1+1):ndata
        i=i+1;
        if ((i/20000)==round(i/20000))
            disp(sprintf('semivar_exp : i=%d/%d',i,nh))
        end
        
        p1=[pos(i1,:)];
        p2=[pos(i2,:)];
        dp(i,:)=p1-p2;
        h(i)=sqrt( (p1-p2)*(p1-p2)' );
        z_head(i,:)=val(i1,:);
        z_tail(i,:)=val(i2,:);
        gamma01(i,:)=0.5*(val(i1,:)-val(i2,:)).^2;
        % ANGLE
        aa=sqrt(sum(p1.^2));
        bb=sqrt(sum(p2.^2));
        ab=(p1(:)'*p2(:));
        
        pp=p1-p2;
        
        % WORKS ONLY FOR 2D
        if ndims==2
            if pp(1)==0
                vang(i)=pi/2;
            else
                %    vang(i)=atan(pp(1)./pp(2));
                vang(i)=atan(pp(2)./pp(1));
            end
        end
        
    end
end

if ndims==2
    vang=vang+pi/2;
end

if exist('cutoff')==0

    if exist('nbins')==1 & exist('width')==1
        %only 'nbins' and 'width' are known  
        
        cutoff = nbins*width;
        
    elseif exist('width')==0 & exist('nbins')==0
        % No parameter/value pairs        
        
        nbins = 10;
        cutoff = max(h);
        
    elseif exist('nbins')==0
        % only 'width' is known
        
        cutoff = max(h);
        if isequal(round(cutoff/width),cutoff/width)
            nbins = cutoff/width
        else
            nbins = round(cutoff/width)
            warning([10 10 'Function ' 39 mfilename 39,...
                    ': number of bins rounded to integer value.' 10])
        end
        
    elseif exist('width')==0
        %Only 'nbins' is known

        cutoff = max(h);
        
    end

    
elseif exist('cutoff')==1
        
    if exist('nbins')==1 & exist('width')==1

        error([10 mfilename ': too many parameter/value pairs.'])

    elseif exist('width')==0 & exist('nbins')==0
        
        nbins = 10;
        
    elseif exist('nbins')==0
        
        if isequal(round(cutoff/width),cutoff/width)
            nbins = cutoff/width;
        else
            nbins = round(cutoff/width)
            warning([10 10 'Function ' 39 mfilename 39,...
                    ': number of bins rounded to integer value.' 10])
        end

    elseif exist('width')==0
  
        %variable 'nbins' exists already; do nothing
  
    end
    
else
    
    error([mfilename ': this should not occur.'])
    
end





%%%%%%%%%%%%%%%%%%%%%%%%%%
% BIN INTO ARRAY BINS

h_arr=linspace(0,cutoff,nbins+1);

hc=(h_arr(1:nbins)+h_arr(2:nbins+1))./2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BIN INTO ANGLE BINS

if exist('nbins_angle')==0
    
    nbins_angle = 1;
    
end
    
angle_bounds = linspace(0,pi,nbins_angle+1); % vector with angle bin boundaries

angle_array = (angle_bounds(1:nbins_angle)+angle_bounds(2:nbins_angle+1))./2; % angle bin midpoints
    


% In case parameter 'nbins_angle' has a value >1 at this point, 
% 'garr' becomes a 2-D array instead of a vector. The rows of 
% 'garr' represent the bins of gamma01 (from array 'hc'). 
% The columns of 'garr' represent the bins of angle (from the 
% array 'angle_array'). 'Count' becomes also 2-D.


garr = zeros(length(hc), length(angle_array)); %memory pre-allocation for speed

for j=1:nbins
    for k=1:nbins_angle
           
    
        if k==nbins_angle
            IO_k = vang>=angle_bounds(k) & vang<=angle_bounds(k+1);
        else
            IO_k = vang>=angle_bounds(k) & vang<angle_bounds(k+1);
        end
        
        if j==nbins
            IO_j = h>=h_arr(j) & h<=h_arr(j+1);
        else
            IO_j = h>=h_arr(j) & h<h_arr(j+1);
        end

        f = find(IO_k & IO_j);
        
        if (sum(gamma01(f,:))==0)
            
            garr(j,k)=NaN;
            
        else
            
            garr(j,k)=mean(gamma01(f,:));
            
        end
        
        count(j,k) = length(f);
    end

end


if nbins_angle==1
    varargout = {hc,garr,count};
else
    varargout = {hc,angle_array,garr,count};
end