function oimg = my_tformarray(img, varargin)

% oimg = tformarray(img(:,:,1), varargin{:});
% 
% if size(img,3)==1
%     return;
% end
oimg = zeros([varargin{5} size(img,3)],class(img));
for ci=1:size(img,3)
    oimg(:,:,ci) = tformarray(img(:,:,ci), varargin{:});
    msk = tformarray(zeros(size(img(:,:,ci))), varargin{1}, makeresampler('nearest','fill'), varargin{3:end-1}, 1);
    oimg(:,:,ci) = roifill(oimg(:,:,ci), msk);
end
