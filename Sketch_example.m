function Sketch_example()
%
% An example of sketching the common
%
% Requires installation of sketching package first (see mexall.m)
%


% read example images
fls = dir(fullfile('example_img','*.png'));
NI = numel(fls);
thumbs = cell(NI,1);

figure('Name','Inputs');
for fi=1:NI
    thumbs{fi} = imread(fullfile('example_img',fls(fi).name));

    % show the inputs
    subplot(3,2,fi);
    imshow(thumbs{fi});
    title(sprintf('Input thumb %d',fi));  
end
% read center of shape for each image
load(fullfile('example_img','peace_cntr.mat'));

% sketch the common
sketch = sketch_the_common_CVPR10(thumbs, cntr);


figure('Name','Output Sketch');
imshow(sketch,[]); title('Sketch');
