function sketch = sketch_the_common_CVPR10(thumbs, cntr)
%
% Code implementing the sketching part of described in
% Bagon, Brostovsky, Galun and Irani "Detecting and Sketching the Common", CVPR 2010
%
% Usage:
%   sketch = sketch_the_common_CVPR10(thumbs, cntr)
%
% Inputs:
%   thumbs - cell array with images of common part
%   cntr   - cell array of the center of the common part at each thumb
%
% Outputs:
%   sketch - A (close to) binary sketch of the common object in thumbs
%
% This code uses some mex functions. Use mexall.m function to compile them
%
%
%   This code was written by Shai Bagon (shai.bagon@weizmann.ac.il).
%   Department of Computer Science and Applied Mathmatics
%   Wiezmann Institute of Science
%   http://www.wisdom.weizmann.ac.il/
%
%   This software can be used only for research purposes, you should  cite 
%   the aforementioned paper in any resulting publication.
%   If you wish to use this software (or the algorithms described in the
%   aforementioned paper) for commercial purposes, you should be aware that 
%   there is a US patent:
%
%       Eli Shechtman and Michal Irani
%       "METHOD AND APPARATUS FOR MATCHING LOCAL SELF-SIMILARITIES"
%
%
%   The Software is provided "as is", without warranty of any kind.
%
%   Jan, 2011
%

% compute the self-similarity correlation matrix for thumb images:
% invovles computing the self-sim descriptors on a grid, extracting the
% common ensemble and computing self-sim-corr-matrix W
[W grid_sz img_sz] = self_sim_correlation_matrix(thumbs, cntr);

% crude initial guess
ig = -ones(grid_sz);
ig(3:end-2,3:end-2) = 0;

% minimize quadratic functional
v = LaplacianLinf(W, ig(:)); 

% output sketch the size of images
sketch = reshape(v, grid_sz);

% to enlarge the sketch to the original size of the common part
% use:
% sketch = imresize(sketch, img_sz, 'bilinear');






