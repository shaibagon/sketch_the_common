function W = self_sim_connectivity(locs, desc)
%
% W = self_sim_connectivity(locs, desc)
%


DL = 45; % descriptor length
ND = size(locs,2); % number of descriptors to consider

desc(DL+1,:) = 1; % add a "fix" for the middle region
desc = 2*desc - 1;


% label the lg-polar mask
lp = []; % show_log_polar_desc_w((0:(DL-1))'./(DL-1));
load show_log_polar_desc_45.mat
dlabel = 1+(round((DL-1)*double(lp)./255)); % label all

dsz = floor(size(dlabel,1)/2);
[r c] = ndgrid(-dsz:dsz, -dsz:dsz);
Rd = sqrt(r.^2 + c.^2);
dlabel(Rd <=6 & dlabel > 15 ) = DL+1; % fix middle
dlabel(Rd >= dsz & dlabel < 30 ) = 0;
mR = max(Rd(dlabel(:)>0)); % maximal effective radius
clear r c Rd lp;

% weights of log-polar mask
sts = regionprops(dlabel,'Area');
dw = dlabel;
dw(dlabel==DL+1)=.25./sts(DL+1).Area;
dw(dlabel>0&dlabel<=15) = .25./sum([sts(1:15).Area]);
dw(dlabel>15&dlabel<=30)=.25./sum([sts(16:30).Area]);
dw(dlabel>30&dlabel<=45)=.25./sum([sts(31:45).Area]);
dw = dw./max(dw(:));
clear sts

% compute offsets between the various locations - lower triangular matrix
OS = loc_offset_mex(locs, mR.*mR, dsz+1);
f = @(x) (2*dsz+2)*(1+j)-x;
asOS = spfun(f, OS.');
[fi ti cc] = find(OS+asOS);
rr = real(cc);
cc = imag(cc);

% linear index into descriptor log-polar map
dlin = [1 size(dlabel,1)]*(double([rr';cc'])-1)+1;
% linear index into row of desc array
di = dlabel(dlin); % 
W = sparse(fi, ti, desc( [1 DL+1]*([di(:)';fi(:)']-1)+1 ).*dw(dlin), ND, ND);


W = W + W';
N = size(W,1);
[ii jj v] = find(W);
v = v./max(abs(v));
W = sparse(ii, jj, v, N, N);

