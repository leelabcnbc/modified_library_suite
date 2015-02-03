function [imageArray,opts] = generate_synthesized_texture(input, numberOfImages, patchSize, ...
    opts)
% GENERATE_SYNTHESIZED_TEXTURE a wrapper of the example scripts. 
%  
%   input is a gray scale image (better 0-255? I think it doesn't matter...)
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 19-Mar-2014 21:08:55 $ 
%% DEVELOPED : 8.1.0.604 (R2013a) 
%% FILENAME  : generate_synthesized_texture.m 
assert(nargin >= 3,'at least specify input, number of images, and patch size!');

assert(numel(patchSize)==2 || numel(patchSize)==1);

if numel(patchSize)==1
    patchSize(2) = patchSize(1);
end

imageArray = zeros(patchSize(1),patchSize(2),numberOfImages);

if nargin < 4
    opts = struct();
end

if ~isfield(opts,'Nsc') || isempty(opts.Nsc)
    opts.Nsc = 4;
end

if ~isfield(opts,'Nor') || isempty(opts.Nor)
    opts.Nor = 4;
end

if ~isfield(opts,'Na') || isempty(opts.Na)
    opts.Na = 7;
end

if ~isfield(opts,'nIter') || isempty(opts.nIter)
    opts.nIter = 25;
end

if ~isfield(opts,'cmask');
    opts.cmask = [1 1 1 1];
end

display(opts);

params = textureAnalysis(input, opts.Nsc, opts.Nor, opts.Na);

for iImage = 1:numberOfImages
    imageArray(:,:,iImage) = textureSynthesis(params, patchSize, opts.nIter, opts.cmask);
    disp(iImage);
end


end







% Created with NEWFCN.m by Frank Gonz�lez-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [generate_synthesized_texture.m] ======  
