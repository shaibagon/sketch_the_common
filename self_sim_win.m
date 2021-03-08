function [desc locs res] = self_sim_win(img, locs)
% 
% extract self similarity descriptors from an image
%
% Usage:
%   [desc locs] = self_sim_win(img, locs)
%
% Inputs:
%   img - input image
%   locs - (optional) 2xN array of desc locations
%
% Outputs:
%   desc - LxN extracted descriptors
%   locs - respective location of each descriptor
%

tmp_name = tempname(); % ['tmp_',int2str(rem(now,1)*1e5)];

img_name = [tmp_name,'.png'];
imwrite(img, img_name);

ss_path = fileparts(which(mfilename));
ss_exe = 'selfsim_cpp_2021';
if ispc()
    ss_exe = [ss_exe,'.exe'];
end

DET_PARAMS_DESC = [' --MinSim=-1 --SparseThresh=-1 --NoPart',...
    ' --BiasFeatures --PreBinningSigma=0 --BinAverageMethod=mean8 ',...
    ' --PointsPerPixel=.03 --ScaleFirstPower=0 --ScaleLastPower=0'];

if nargin==1 || isempty(locs)
    MSK_WIDTH = 38;

    msk = zeros([size(img,1) size(img,2)],'uint8');
    msk( (MSK_WIDTH+1): (size(img,1)-MSK_WIDTH), ...
        (MSK_WIDTH+1): (size(img,2)-MSK_WIDTH) ) = intmax('uint8');
    msk_file_name = [tmp_name,'_mask.png'];
    imwrite(msk, msk_file_name);


    cmd = sprintf('%s --OnlyDesc %s %s %s',...
        fullfile(ss_path, ss_exe), DET_PARAMS_DESC, img_name, msk_file_name);
else
    assert( any(size(locs)==2), 'self_sim_win:locs', 'locs has to be 2xN locations array');
    msk_file_name = [tmp_name,'_locs'];
    if size(locs,2) ~= 2, locs=locs'; end
    dlmwrite(msk_file_name, locs, ' ');
    cmd = sprintf('%s --OnlyDesc %s --FixedPointGenerator=%s %s',...
        fullfile(ss_path, ss_exe), DET_PARAMS_DESC, msk_file_name, img_name);

end
[ignore ignore] = system(cmd);

delete(img_name);
delete(msk_file_name);

% Read the desc file name
fid = fopen([img_name,'.desc']);
A = fscanf(fid, '%d',1);
assert(A == 2785, 'self_sim_win:magic_number','wrong magic number at file header');
desc_len = fscanf(fid,'%d',1); % read desc length
NS = fscanf(fid,'%d',1); % read number fo scales
ig = fscanf(fid,'%d', 4); % read image size and link
ig = fscanf(fid,'%s',1); % read image file name
nd = fscanf(fid, '%d', NS); % read number of descriptors per scale
locs = cell(NS,1);
desc = cell(NS,1);
for sl=1:NS
    locs{sl} = fscanf(fid, '%d', nd(sl)*2);
    locs{sl} = reshape(locs{sl}, 2, nd(sl));
    desc{sl} = fscanf(fid, '%f', nd(sl)*desc_len);
    desc{sl} = reshape(desc{sl}, desc_len, nd(sl));
end

if nargout == 3
    res = [];
    l = fgetl(fid);
    while ischar(l)
        res = sprintf('%s\n%s',res,l);
        l = fgetl(fid);
    end
    res(1)=[]; % discard first character
end
fid = fclose(fid);
delete([img_name,'.desc']);

if NS == 1
    locs = locs{1};
    desc = desc{1};
end
