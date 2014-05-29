function parseargtest(varargin)
% PARSEARGTEST ...
%
%   ...
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 28-May-2014 16:34:23 $
%% DEVELOPED : 8.1.0.604 (R2013a)
%% FILENAME  : parseargtest.m

%define the acceptable named arguments and assign default values
Args=struct('Holdaxis',100, ...
    'SpacingVertical',0.05,'SpacingHorizontal',0.05, ...
    'PaddingLeft',0,'PaddingRight',0,'PaddingTop',0,'PaddingBottom',0, ...
    'MarginLeft',.1,'MarginRight',.1,'MarginTop',.1,'MarginBottom',.1, ...
    'rows',[],'cols',[]);

%The capital letters define abrreviations.
% Eg. parseargtest('spacingvertical',0) is equivalent to parseargtest('sv',0)

Args=parseArgs(varargin,Args, ... % fill the arg-struct with values entered by the user
    {'Holdaxis'}, ... %this argument has no value (flag-type)
    {'Spacing' {'sh','sv'}; 'Padding' {'pl','pr','pt','pb'}; 'Margin' {'ml','mr','mt','mb'}});

disp(Args)


end








% Created with NEWFCN.m by Frank González-Morphy
% Contact...: frank.gonzalez-morphy@mathworks.de
% ===== EOF ====== [parseargtest.m] ======
