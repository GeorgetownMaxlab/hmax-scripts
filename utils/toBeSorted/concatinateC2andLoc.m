%This code is simply to restore the original structure of C2 matrixes and
%Location arrays, since the code for comparison to behavior was built for
%the original types of data structures.

function concatinateC2andLoc(patchType, loadPath, savePath)

if (nargin < 2)
    loadPath = ('/home/levan/HMAX/choiceAnalysis/lfwBlurTriples/');
	savePath = (['/home/levan/HMAX/choiceAnalysis/' patchType '/']);
end
%:::::::::::Concatinate the C2 matrixes:::::::::;::
load([loadPath 'configuralLoc.mat']);
load([loadPath 'emptyLoc.mat']);
load([loadPath 'facesLoc.mat']);
load([loadPath 'housesLoc.mat']);
load([loadPath 'invertedLoc.mat']);
load([loadPath 'scrambledLoc.mat']);

% configuralLoc2 = load([loadPath2 'configuralLoc.mat']); configuralLoc2 = configuralLoc2.configuralLoc;
% emptyLoc2      = load([loadPath2 'emptyLoc.mat']);      emptyLoc2      = emptyLoc2.emptyLoc; 
% facesLoc2      = load([loadPath2 'facesLoc.mat']);      facesLoc2      = facesLoc2.facesLoc;
% housesLoc2     = load([loadPath2 'housesLoc.mat']);     housesLoc2     = housesLoc2.housesLoc;
% invertedLoc2   = load([loadPath2 'invertedLoc.mat']);   invertedLoc2   = invertedLoc2.invertedLoc;
% scrambledLoc2  = load([loadPath2 'scrambledLoc.mat']);  scrambledLoc2  = scrambledLoc2.scrambledLoc;

facesLocOrig      = [facesLoc{1,1} facesLoc{1,2} ...
                 facesLoc{1,3} facesLoc{1,4}]; %#ok<*USENS,*NASGU>
emptyLocOrig      = [emptyLoc{1,1} emptyLoc{1,2} ...
                 emptyLoc{1,3} emptyLoc{1,4} ];
scrambledLocOrig  = [scrambledLoc{1,1} scrambledLoc{1,2} ...
                 scrambledLoc{1,3} scrambledLoc{1,4}];
housesLocOrig     = [housesLoc{1,1} housesLoc{1,2} ...
                 housesLoc{1,3} housesLoc{1,4}];
invertedLocOrig   = [invertedLoc{1,1} invertedLoc{1,2} ...
                 invertedLoc{1,3} invertedLoc{1,4}];
configuralLocOrig = [configuralLoc{1,1} configuralLoc{1,2} ...
                 configuralLoc{1,3} configuralLoc{1,4}];

             
%:::::::::::Concatinate the C2 matrixes:::::::::;::
    c2f1 = load([loadPath 'c2f1.mat']); c2f1 = c2f1.c2f;
%            load([loadPath2 'c2f1.mat']); c2f1 = [c2f1 c2f];

    c2f2 = load([loadPath 'c2f2.mat']); c2f2 = c2f2.c2f;
%            load([loadPath2 'c2f2.mat']); c2f2 = [c2f2 c2f];

    c2f3 = load([loadPath 'c2f3.mat']); c2f3 = c2f3.c2f;
%            load([loadPath2 'c2f3.mat']); c2f3 = [c2f3 c2f];

    c2f4 = load([loadPath 'c2f4.mat']); c2f4 = c2f4.c2f;
%            load([loadPath2 'c2f4.mat']); c2f4 = [c2f4 c2f];
    c2f = [c2f1 c2f2 c2f3 c2f4];

c2e1 = load([loadPath 'c2e1.mat']); c2e1 = c2e1.c2e;
%        load([loadPath2 'c2e1.mat']); c2e1 = [c2e1 c2e];

c2e2 = load([loadPath 'c2e2.mat']); c2e2 = c2e2.c2e;
%        load([loadPath2 'c2e2.mat']); c2e2 = [c2e2 c2e];

c2e3 = load([loadPath 'c2e3.mat']); c2e3 = c2e3.c2e;
%        load([loadPath2 'c2e3.mat']); c2e3 = [c2e3 c2e];

c2e4 = load([loadPath 'c2e4.mat']); c2e4 = c2e4.c2e;
%        load([loadPath2 'c2e4.mat']); c2e4 = [c2e4 c2e];
c2e = [c2e1 c2e2 c2e3 c2e4];

    c2s1 = load([loadPath 'c2s1.mat']); c2s1 = c2s1.c2s;
%            load([loadPath2 'c2s1.mat']); c2s1 = [c2s1 c2s];

    c2s2 = load([loadPath 'c2s2.mat']); c2s2 = c2s2.c2s;
%            load([loadPath2 'c2s2.mat']); c2s2 = [c2s2 c2s];

    c2s3 = load([loadPath 'c2s3.mat']); c2s3 = c2s3.c2s;
%            load([loadPath2 'c2s3.mat']); c2s3 = [c2s3 c2s];

    c2s4 = load([loadPath 'c2s4.mat']); c2s4 = c2s4.c2s;
%            load([loadPath2 'c2s4.mat']); c2s4 = [c2s4 c2s];
    c2s = [c2s1 c2s2 c2s3 c2s4];

c2h1 = load([loadPath 'c2h1.mat']); c2h1 = c2h1.c2h;
%        load([loadPath2 'c2h1.mat']); c2h1 = [c2h1 c2h];

c2h2 = load([loadPath 'c2h2.mat']); c2h2 = c2h2.c2h;
%        load([loadPath2 'c2h2.mat']); c2h2 = [c2h2 c2h];

c2h3 = load([loadPath 'c2h3.mat']); c2h3 = c2h3.c2h;
%        load([loadPath2 'c2h3.mat']); c2h3 = [c2h3 c2h];

c2h4 = load([loadPath 'c2h4.mat']); c2h4 = c2h4.c2h;
%        load([loadPath2 'c2h4.mat']); c2h4 = [c2h4 c2h];
c2h = [c2h1 c2h2 c2h3 c2h4];

    c2i1 = load([loadPath 'c2i1.mat']); c2i1 = c2i1.c2i;
%            load([loadPath2 'c2i1.mat']); c2i1 = [c2i1 c2i];

    c2i2 = load([loadPath 'c2i2.mat']); c2i2 = c2i2.c2i;
%            load([loadPath2 'c2i2.mat']); c2i2 = [c2i2 c2i];

    c2i3 = load([loadPath 'c2i3.mat']); c2i3 = c2i3.c2i;
%            load([loadPath2 'c2i3.mat']); c2i3 = [c2i3 c2i];

    c2i4 = load([loadPath 'c2i4.mat']); c2i4 = c2i4.c2i;
%            load([loadPath2 'c2i4.mat']); c2i4 = [c2i4 c2i];
    c2i = [c2i1 c2i2 c2i3 c2i4];

c2c1 = load([loadPath 'c2c1.mat']); c2c1 = c2c1.c2c;
%        load([loadPath2 'c2c1.mat']); c2c1 = [c2c1 c2c];

c2c2 = load([loadPath 'c2c2.mat']); c2c2 = c2c2.c2c;
%        load([loadPath2 'c2c2.mat']); c2c2 = [c2c2 c2c];

c2c3 = load([loadPath 'c2c3.mat']); c2c3 = c2c3.c2c;
%        load([loadPath2 'c2c3.mat']); c2c3 = [c2c3 c2c];

c2c4 = load([loadPath 'c2c4.mat']); c2c4 = c2c4.c2c;
%        load([loadPath2 'c2c4.mat']); c2c4 = [c2c4 c2c];
c2c = [c2c1 c2c2 c2c3 c2c4];
%:::::::::::::::::::::::::::::::::::::::::::::::::::
    
save ([savePath 'C2/allC2LFWBorder'], 'c2e', 'c2f', 'c2s', 'c2h', 'c2i', 'c2c');
save ([savePath 'locationFiles/locOrigFiles'], 'facesLocOrig', 'emptyLocOrig', 'scrambledLocOrig', 'housesLocOrig', 'invertedLocOrig', 'configuralLocOrig');

end
