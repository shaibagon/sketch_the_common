function [W grid_sz img_sz] = self_sim_correlation_matrix(thumbs, cntr)
%
% compute self similarity correlation matrix for thumbs
%

NF = numel(thumbs);
desc = cell(NF,1);
locs = cell(NF,1);
img = cell(NF,1);


sz = cellfun( @(x) size(x(:,:,1)), thumbs, 'UniformOutput', false);

if nargin < 2 || isempty(cntr)
    cntr = cellfun( @(x) .5*x, sz, 'UniformOutput', false);
end


% generate common grid
img_sz = max(vertcat(sz{:}),[], 1);
AS = min(300/max(img_sz), max(1, 200/min(img_sz))); % additional scale
img_sz = round(AS*img_sz);
GM = 45; % margins
GS = 4; % sample rate, compute desc every GS pixels
[r c] = ndgrid( ceil((-.5*img_sz(1)+GM)) : GS : floor(.5*img_sz(1)-GM),...
    ceil((-.5*img_sz(2)+GM)) : GS : floor(.5*img_sz(2)-GM) );

grid_sz = size(r);

r = r - ceil(-.5*img_sz(1));
c = c - ceil(-.5*img_sz(2));
alocs = [r(:) c(:)];
clear r c GM GS em om;


% extract "aligned" descriptors 
for fi=1:NF
    
    os = -AS*cntr{fi} + .5*img_sz;
    img{fi} = my_tformarray(thumbs{fi}, maketform('affine',[AS*eye(2); os ]),...
        makeresampler('linear','symmetric'), 1:2, 1:2, img_sz, [], []);
    
    
    [desc{fi} locs{fi}] = self_sim_win(img{fi}, alocs); % extract desc/ location from image
end


clear fi os; 

% common ensemble
md = median( cat(3, desc{:}), 3);
W = self_sim_connectivity(alocs.', md);


