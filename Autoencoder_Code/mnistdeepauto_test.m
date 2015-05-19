function mnistdeepauto_test()
% MNISTDEEPAUTO_TEST ... 
%  
%   ... 
%
% Yimeng Zhang
% Computer Science Department, Carnegie Mellon University
% zym1010@gmail.com

%% DATE      : 19-May-2015 14:32:55 $ 
%% DEVELOPED : 8.3.0.532 (R2014a) 
%% FILENAME  : mnistdeepauto_test.m 

% a fully deterministic version of mnistdeepauto, with only first layer
% trained, just for making sure my MFBM implementation is correct.
rng('shuffle'); 
% I just want to make sure that this program is properly seeded, ...
% so such a shuffle command won't change it at all.

maxepoch=10; %In the Science paper we use maxepoch=50, but it works just fine. 
numhid=1000; numpen=500; numpen2=250; numopen=30;

fprintf(1,'Converting Raw files into Matlab format \n');
converter_test('/home/leelab_share/datasets/MNIST_original'); 

fprintf(1,'Pretraining a deep autoencoder. \n');
fprintf(1,'The Science paper used 50 epochs. This uses %3i \n', maxepoch);

makebatches;
[numcases numdims numbatches]=size(batchdata);

if ~exist('mnistdeepauto_test_batchdata.mat','file')
    save mnistdeepauto_test_batchdata batchdata testbatchdata batchtargets testbatchtargets;
else
    oldMat = load('mnistdeepauto_test_batchdata.mat');
    assert(isequal(batchdata,oldMat.batchdata));
    assert(isequal(batchtargets,oldMat.batchtargets));
    assert(isequal(testbatchdata,oldMat.testbatchdata));
    assert(isequal(testbatchtargets,oldMat.testbatchtargets));
end

fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid);
restart=1;
% add deterministic thing.
rng(0,'twister');
rbm;
hidrecbiases=hidbiases; 
if ~exist('mnistdeepauto_test_vh.mat','file')
    save mnistdeepauto_test_vh vishid hidrecbiases visbiases;
else
    oldMat = load('mnistdeepauto_test_vh.mat');
    assert(isequal(vishid,oldMat.vishid));
    assert(isequal(hidrecbiases,oldMat.hidrecbiases));
    assert(isequal(visbiases,oldMat.visbiases));
end

end








% Created with NEWFCN.m by Frank González-Morphy 
% Contact...: frank.gonzalez-morphy@mathworks.de  
% ===== EOF ====== [mnistdeepauto_test.m] ======  
