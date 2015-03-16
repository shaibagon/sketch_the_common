function v = LaplacianLinf(W, ig)
%
% laplacian factorization (with ||v||oo = 1 approxiamte constraint)
%
%   v = LaplacianLinf(W, ig)
%

os = optimset();
os.Display = 'off'; % turn off outputs of quadprog
% os.HessMult = @(H,Y, varargin) spmtimes_mex(Y',H')';

% Laplacian matrix
L = spdiags( sum(W,2), 0, size(W,1), size(W,2) ) - W;

% solve using quadratic programing, approximate the L_\infity norm
N = size(W,1);
v = quadprog(L,zeros(N,1),[],[],[],[],-ones(N,1),ones(N,1), ig, os);