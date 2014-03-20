% Example 1: Synthesis of a "text" texture image, using
% Portilla-Simoncelli texture analysis/synthesis code, based on
% alternate projections onto statistical constraints in a complex
% overcomplete wavelet representation.
%
% See Readme.txt, and headers of textureAnalysis.m and
% textureSynthesis.m for more details.
%
% Javier Portilla (javier@decsai.ugr.es).  March, 2001

close all

im0 = pgmRead('text.pgm');	% im0 is a double float matrix!

Nsc = 4; % Number of scales
Nor = 4; % Number of orientations
Na = 9;  % Spatial neighborhood is Na x Na coefficients
	 % It must be an odd number!

params = textureAnalysis(im0, Nsc, Nor, Na);

Niter = 25;	% Number of iterations of synthesis loop
Nsx = 192;	% Size of synthetic image is Nsy x Nsx
Nsy = 128;	% WARNING: Both dimensions must be multiple of 2^(Nsc+2)

res = cell(12,1);

res{1} = textureSynthesis(params, [Nsy Nsx], Niter, [1 1 1 1]); % I should fix the output so that I won't get error when tuning cmask...
%res = textureSynthesis(params, [Nsy Nsx], Niter, [0 0 0 0]); % not allowed
res{2} = textureSynthesis(params, [Nsy Nsx], Niter, [0 0 0 1]);
res{3} = textureSynthesis(params, [Nsy Nsx], Niter, [0 0 1 0]);
res{4} = textureSynthesis(params, [Nsy Nsx], Niter, [0 0 1 1]);
%res = textureSynthesis(params, [Nsy Nsx], Niter, [0 1 0 0]); % not allowed
res{5} = textureSynthesis(params, [Nsy Nsx], Niter, [0 1 0 1]);
res{6} = textureSynthesis(params, [Nsy Nsx], Niter, [0 1 1 0]);
res{7} = textureSynthesis(params, [Nsy Nsx], Niter, [0 1 1 1]);
% res = textureSynthesis(params, [Nsy Nsx], Niter, [1 0 0 0]);% not allowed
res{8} = textureSynthesis(params, [Nsy Nsx], Niter, [1 0 0 1]);
res{9} = textureSynthesis(params, [Nsy Nsx], Niter, [1 0 1 0]);
res{10} = textureSynthesis(params, [Nsy Nsx], Niter, [1 0 1 1]);
%res = textureSynthesis(params, [Nsy Nsx], Niter, [1 1 0 0]); % not allowed
res{11} = textureSynthesis(params, [Nsy Nsx], Niter, [1 1 0 1]);
res{12} = textureSynthesis(params, [Nsy Nsx], Niter, [1 1 1 0]);


close all
figure(1)
showIm(im0, 'auto', 1, 'Original texture');
figure(2)
% showIm(res, 'auto', 1, 'Synthesized texture');

% Can you read the NEW text? ;-)
