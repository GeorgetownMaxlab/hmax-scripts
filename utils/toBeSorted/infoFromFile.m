function [emptyInfo, scrambledInfo, housesInfo, invertedInfo, configuralInfo, facesInfo] = infoFromFile(patchType, trialType, loadPath, savePath);
%Creates an Info file for each LocOrig file:
% - First row is the same, the name of the file.
% - Second row is the subjects #.
% - Third row is the session #.
% - Fourth - absolute trial #.
% - Fifth - quadrant number (position within the trial)
% - Sixth - type of quadrant. 
% - Seventh - type of condition on that trial.
% clear;clc;

if (nargin < 2)
	loadPath = (['/home/levan/HMAX/choiceAnalysis/' patchType '/']);
	savePath = (['/home/levan/HMAX/choiceAnalysis/' patchType '/locationFiles/']);
	load('/home/levan/HMAX/choiceAnalysis/Matrix_Design/info_distr/trialType.mat');
end

% load([loadPath 'Locations/configuralLocOrig.mat']);
% load([loadPath 'LocOrigations/emptyLocOrig.mat']);
% load([loadPath 'LocOrigations/facesLocOrig.mat']);
% load([loadPath 'LocOrigations/housesLocOrig.mat']);
% load([loadPath 'LocOrigations/invertedLocOrig.mat']);
% load([loadPath 'LocOrigations/scrambledLocOrig.mat']);
load([loadPath '/locationFiles/locOrigFiles.mat']);

    for i = 1:size(emptyLocOrig,2);
        fileName = emptyLocOrig{1,i}(1:end-4);
        C = strsplit(fileName, 'quad');
        B = strsplit(C{1,1}, '_');
        emptyLocOrig{2,i} = str2num(B{1,2});
        emptyLocOrig{3,i} = str2num(B{1,4});
        emptyLocOrig{4,i} = (emptyLocOrig{3,i}-1) * 72 + str2num(B{1,6});
        emptyLocOrig{5,i} = str2num(C{1,2});
        emptyLocOrig{6,i} = 1;
        emptyLocOrig{7,i} = trialType{1,emptyLocOrig{2,i}}(emptyLocOrig{4,i});
    end
    emptyInfo = emptyLocOrig;
%     save([savePath 'emptyInfo'],'emptyInfo');


for i = 1:size(scrambledLocOrig,2);
    fileName = scrambledLocOrig{1,i}(1:end-4);
    C = strsplit(fileName, 'quad');
    B = strsplit(C{1,1}, '_');
    scrambledLocOrig{2,i} = str2num(B{1,2});
    scrambledLocOrig{3,i} = str2num(B{1,4});
    scrambledLocOrig{4,i} = (scrambledLocOrig{3,i}-1) * 72 + str2num(B{1,6});
    scrambledLocOrig{5,i} = str2num(C{1,2});
    scrambledLocOrig{6,i} = 2;
    scrambledLocOrig{7,i} = trialType{1,scrambledLocOrig{2,i}}(scrambledLocOrig{4,i});
end
scrambledInfo = scrambledLocOrig;
% save([savePath 'scrambledInfo'],'scrambledInfo');

    for i = 1:size(housesLocOrig,2);
    fileName = housesLocOrig{1,i}(1:end-4);
    C = strsplit(fileName, 'quad');
    B = strsplit(C{1,1}, '_');
    housesLocOrig{2,i} = str2num(B{1,2});
    housesLocOrig{3,i} = str2num(B{1,4});
    housesLocOrig{4,i} = (housesLocOrig{3,i}-1) * 72 + str2num(B{1,6});
    housesLocOrig{5,i} = str2num(C{1,2});
    housesLocOrig{6,i} = 3;
    housesLocOrig{7,i} = trialType{1,housesLocOrig{2,i}}(housesLocOrig{4,i});
    end
    housesInfo = housesLocOrig;
%     save([savePath 'housesInfo'],'housesInfo');

for i = 1:size(invertedLocOrig,2);
fileName = invertedLocOrig{1,i}(1:end-4);
C = strsplit(fileName, 'quad');
B = strsplit(C{1,1}, '_');
invertedLocOrig{2,i} = str2num(B{1,2});
invertedLocOrig{3,i} = str2num(B{1,4});
invertedLocOrig{4,i} = (invertedLocOrig{3,i}-1) * 72 + str2num(B{1,6});
invertedLocOrig{5,i} = str2num(C{1,2});
invertedLocOrig{6,i} = 4;
invertedLocOrig{7,i} = trialType{1,invertedLocOrig{2,i}}(invertedLocOrig{4,i});
end
invertedInfo = invertedLocOrig;
% save([savePath 'invertedInfo'],'invertedInfo');

    for i = 1:size(configuralLocOrig,2);
    fileName = configuralLocOrig{1,i}(1:end-4);
    C = strsplit(fileName, 'quad');
    B = strsplit(C{1,1}, '_');
    configuralLocOrig{2,i} = str2num(B{1,2});
    configuralLocOrig{3,i} = str2num(B{1,4});
    configuralLocOrig{4,i} = (configuralLocOrig{3,i}-1) * 72 + str2num(B{1,6});
    configuralLocOrig{5,i} = str2num(C{1,2});
    configuralLocOrig{6,i} = 5;
    configuralLocOrig{7,i} = trialType{1,configuralLocOrig{2,i}}(configuralLocOrig{4,i});
    end
    configuralInfo = configuralLocOrig;
%     save([savePath 'configuralInfo'],'configuralInfo');
    
 for i = 1:size(facesLocOrig,2);
fileName = facesLocOrig{1,i}(1:end-4);
C = strsplit(fileName, 'quad');
B = strsplit(C{1,1}, '_');
facesLocOrig{2,i} = str2num(B{1,2});
facesLocOrig{3,i} = str2num(B{1,4});
facesLocOrig{4,i} = (facesLocOrig{3,i}-1) * 72 + str2num(B{1,6});
facesLocOrig{5,i} = str2num(C{1,2});
facesLocOrig{6,i} = 6;
facesLocOrig{7,i} = trialType{1,facesLocOrig{2,i}}(facesLocOrig{4,i});
end
facesInfo = facesLocOrig;
% save([savePath 'facesInfo'],'facesInfo');
save([savePath 'infoFiles.mat'],'emptyInfo','facesInfo','scrambledInfo', ...
    'housesInfo','invertedInfo','configuralInfo');
end
