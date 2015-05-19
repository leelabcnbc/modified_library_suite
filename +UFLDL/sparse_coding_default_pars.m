function pars = sparse_coding_default_pars()
% SPARSE_CODING_DEFAULT_PARS ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 01-Feb-2015 19:25:14 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : sparse_coding_default_pars.m 

pars = struct('numFeatures',121,...
    'topography',false,...
    'poolDim',3,... % 
    'epsilon',1e-5,...
    'lambda',0.1,...
    'gamma',1e-2,...
    'optMethod','cg',...
    'optMaxIter',20,...
    'iterationTotal',200,...
    'batchNumPatches',2000,...
    'initSeed',0,... % if set to [], then shuffle.
    'visualize',true,...
    'initMultiplier',1,...
    'initFunction','randn',...
    'timestamp',datestr(now,30)); % the demo used rand to init.

end








% Created with NEWFCN.m by Frank Gonz�lez-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [sparse_coding_default_pars.m] ======  