function allQuadAllTrialsNaturalFaces(patchType, incr, lastPatch)

%This code is an adaptation of allQuadAllTrials.m code for the 400 images
%that Florence gave us with natural face images pasted in them. That
%database was not shown to human subjects, and didn't have multiple
%conditions, just faces pasted on backgrounds. 

if (nargin<1)
    patchType = 'DONT OVERWRITE';
    incr = 500;
    lastPatch = 19600;
end

%::::::::::Get info about each image:::::::::::::::::
% [emptyInfo, scrambledInfo, housesInfo, ...
%     invertedInfo, configuralInfo, facesInfo] = infoFromFile(trialType, loadPath, savePath);
	  load([loadPath 'locationFiles/infoFiles.mat']); 
      fprintf('Loaded location info files\n');
    %load([savePath 'emptyInfo.mat']);
    %load([savePath 'scrambledInfo.mat']);
    %load([savePath 'housesInfo.mat']);
    %load([savePath 'invertedInfo.mat']);
    %load([savePath 'configuralInfo.mat']);
    %load([savePath 'facesInfo.mat']);
%:::::::::::::::::::::::::::::::::::::::::::::::::::
    
%:::::::::::Replace File Names with 0:::::::::
for i = 1:size(emptyInfo,2)
    emptyInfo{1,i} = 0;%#ok<*SAGROW> 
end
for i = 1:size(scrambledInfo,2)
    scrambledInfo{1,i} = 0;%#ok<*SAGROW> 
end
for i = 1:size(housesInfo,2)
    housesInfo{1,i} = 0;%#ok<*SAGROW> 
end
for i = 1:size(invertedInfo,2)
    invertedInfo{1,i} = 0;%#ok<*SAGROW> 
end
for i = 1:size(configuralInfo,2)
    configuralInfo{1,i} = 0;%#ok<*SAGROW> 
end
for i = 1:size(facesInfo,2)
    facesInfo{1,i} = 0;%#ok<*SAGROW> 
end
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%::::::::::Convert Cells to Matrices, easier to work with:::::::::::::::::
emptyInfo      = cell2mat(emptyInfo);
scrambledInfo  = cell2mat(scrambledInfo);
housesInfo     = cell2mat(housesInfo);
invertedInfo   = cell2mat(invertedInfo);
configuralInfo = cell2mat(configuralInfo);
facesInfo      = cell2mat(facesInfo);
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%:::::Create individual rows, for loop and parfor loop will be faster:::::
eSubjNum = emptyInfo(2,:);  
sSubjNum = scrambledInfo(2,:);
hSubjNum = housesInfo(2,:);
iSubjNum = invertedInfo(2,:);
cSubjNum = configuralInfo(2,:);
fSubjNum = facesInfo(2,:);

eTrialNum = emptyInfo(4,:);  
sTrialNum = scrambledInfo(4,:);
hTrialNum = housesInfo(4,:);
iTrialNum = invertedInfo(4,:);
cTrialNum = configuralInfo(4,:);
fTrialNum = facesInfo(4,:);

% eQuadPos = emptyInfo(5,:);  
% sQuadPos = scrambledInfo(5,:);
% hQuadPos = housesInfo(5,:);
% iQuadPos = invertedInfo(5,:);
% cQuadPos = configuralInfo(5,:);
% fQuadPos = facesInfo(5,:);

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

allQuads = {};
allQuadsTrials = {};
startPatch = 1
lastPatch = size(c2e,1)
fprintf('Done with preprocessing, starting the loops\n');

for p = 1:size(c2e,1)
    tic
    p
     for subj = 1:8

        trialsE = facesInfo(4,find(fSubjNum == subj & isnan(facesInfo(7,:)) == 1)); trialsE = unique(trialsE); %#ok<*FNDSB>
        trialsS = facesInfo(4,find(fSubjNum == subj & facesInfo(7,:) == 2));        trialsS = unique(trialsS);
        trialsH = facesInfo(4,find(fSubjNum == subj & facesInfo(7,:) == 3));        trialsH = unique(trialsH);
        trialsI = facesInfo(4,find(fSubjNum == subj & facesInfo(7,:) == 4));        trialsI = unique(trialsI);
        trialsC = facesInfo(4,find(fSubjNum == subj & facesInfo(7,:) == 5));        trialsC = unique(trialsC);
        
        if p == 1 %Trials matrix is the same for all patches, so record it only once. 
            allQuadsTrials{1,subj,1} = trialsE; %#ok<*AGROW>
            allQuadsTrials{1,subj,2} = trialsS;
            allQuadsTrials{1,subj,3} = trialsH;
            allQuadsTrials{1,subj,4} = trialsI;
            allQuadsTrials{1,subj,5} = trialsC;
        end
        c2fp = c2f(p,:); c2ep = c2e(p,:); c2sp = c2s(p,:); c2hp = c2h(p,:); c2ip = c2i(p,:);  c2cp = c2c(p,:);

        for j = 1:size(trialsE,2)
            fTrialIndexes = find(fTrialNum == trialsE(1,j) & fSubjNum == subj); %indexes of trials of EMPTY condition within the facesInfo file. 
            eTrialIndexes = find(eTrialNum == trialsE(1,j) & eSubjNum == subj);
            draftE{j}(:,1) = [c2fp(fTrialIndexes) c2ep(eTrialIndexes)];
            draftE{j}(:,2) = [ones(1,size(fTrialIndexes,2))*6 ones(1,size(eTrialIndexes,2))];
%             draftE{j}(:,3) = [ones(1,size(fTrialIndexes,2))*6 ones(1,size(eTrialIndexes,2))];
        end
        allQuads{p-startPatch+1,subj,1} = draftE;
%             fprintf('done EMPTY; ')

        for j = 1:size(trialsS,2)
            fTrialIndexes = find(fTrialNum == trialsS(1,j) & fSubjNum == subj);
            eTrialIndexes = find(eTrialNum == trialsS(1,j) & eSubjNum == subj);
            sTrialIndexes = find(sTrialNum == trialsS(1,j) & sSubjNum == subj);
            draftS{j}(:,1) = [c2fp(fTrialIndexes) c2ep(eTrialIndexes) c2sp(sTrialIndexes)];
            draftS{j}(:,2) = [ones(1,size(fTrialIndexes,2))*6 ones(1,size(eTrialIndexes,2)) ones(1,size(sTrialIndexes,2))*2];
        end
        allQuads{p-startPatch+1,subj,2} = draftS;
%             fprintf('done SCRAMBLED; ')

         for j = 1:size(trialsH,2)
            fTrialIndexes = find(fTrialNum == trialsH(1,j) & fSubjNum == subj);
            eTrialIndexes = find(eTrialNum == trialsH(1,j) & eSubjNum == subj);
            hTrialIndexes = find(hTrialNum == trialsH(1,j) & hSubjNum == subj);
            draftH{j}(:,1) = [c2fp(fTrialIndexes) c2ep(eTrialIndexes) c2hp(hTrialIndexes)];
            draftH{j}(:,2) = [ones(1,size(fTrialIndexes,2))*6 ones(1,size(eTrialIndexes,2)) ones(1,size(hTrialIndexes,2))*3];
         end
         allQuads{p-startPatch+1,subj,3} = draftH;
%              fprintf('done HOUSES; ')

         if subj == 3
             draftI{1}(1,1) = NaN;
             draftI{1}(1,2) = NaN;
         else
         for j = 1:size(trialsI,2)
            fTrialIndexes = find(fTrialNum == trialsI(1,j) & fSubjNum == subj);
            eTrialIndexes = find(eTrialNum == trialsI(1,j) & eSubjNum == subj);
            iTrialIndexes = find(iTrialNum == trialsI(1,j) & iSubjNum == subj);
            draftI{j}(:,1) = [c2fp(fTrialIndexes) c2ep(eTrialIndexes) c2ip(iTrialIndexes)];
            draftI{j}(:,2) = [ones(1,size(fTrialIndexes,2))*6 ones(1,size(eTrialIndexes,2)) ones(1,size(iTrialIndexes,2))*4];
         end
         end
         allQuads{p-startPatch+1,subj,4} = draftI;
%              fprintf('done INVERTED; ')

         for j = 1:size(trialsC,2)
            fTrialIndexes = find(fTrialNum == trialsC(1,j) & fSubjNum == subj);
            eTrialIndexes = find(eTrialNum == trialsC(1,j) & eSubjNum == subj);
            cTrialIndexes = find(cTrialNum == trialsC(1,j) & cSubjNum == subj);
            draftC{j}(:,1) = [c2fp(fTrialIndexes) c2ep(eTrialIndexes) c2cp(cTrialIndexes)];
            draftC{j}(:,2) = [ones(1,size(fTrialIndexes,2))*6 ones(1,size(eTrialIndexes,2)) ones(1,size(cTrialIndexes,2))*5];
         end
         allQuads{p-startPatch+1,subj,5} = draftC;
%              fprintf('done CONFIGURAL; ')

         draftE = {}; draftS = {}; draftH = {}; draftI = {}; draftC = {};
    end %SUBJ

    
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%::::::::::::::::::::START SAVING THE FILES THAT ARE DONE:::::::::::::::::
if p == size(c2f,1)
	fprintf(['Done with the last patch (' num2str(p) ')\n']);
	save([savePath 'allQuads' num2str(startPatch) '-' num2str(p) '.mat'],'allQuads');
	save([savePath 'allQuadsTrials' num2str(startPatch) '-' num2str(p) '.mat'],'allQuadsTrials');
        
            innerP = p;
            getWinnerQuadStatisticsConcat(allQuads, innerP, incr, lastPatch, savePath);
            toc;

    allQuads = {};
	allQuadsTrials = {};
elseif mod(p,incr) == 0 
    fprintf(['Done with another' num2str(incr) 'patches\n']);
    toc;   
        save([savePath 'allQuads' num2str(startPatch) '-' num2str(p) '.mat'],'allQuads');
        save([savePath 'allQuadsTrials' num2str(startPatch) '-' num2str(p) '.mat'],'allQuadsTrials');
        
            innerP = p;
            getWinnerQuadStatisticsConcat(allQuads, innerP, incr, lastPatch, savePath);
            toc;
        
    startPatch = p+1;
    allQuads = {};
    allQuadsTrials = {};
end
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

end %PATCH
end %FILE
