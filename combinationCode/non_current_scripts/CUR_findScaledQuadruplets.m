% find complementary patches
function findScaledQuadruplets_CUR(nTPatchesLoad,nCPatchesLoad,nTPatches,nCPatches)

%% GLOBAL STUFF
% clear; clc;
dbstop if error;
runParameterComments = 'none';%input('Any comments about the run?\n'); %#ok<*NASGU>

if (nargin < 1)
    nTPatchesLoad = 100;
    nCPatchesLoad = 100;
    nTPatches = 10;
    nCPatches = 10;   
end
nDoublets = nTPatchesLoad*nCPatchesLoad;
nTriplets = nTPatches*nCPatches;
loadFolder = ['trainingRuns/patchSetAdam/lfwSingle50000/scaling/'     int2str(nTPatchesLoad) 'TPatches' int2str(nCPatchesLoad) 'CPatches'];
saveFolder = ['trainingRuns/patchSetAdam/lfwSingle50000/scaling/sandbox/' int2str(nTPatches) 'TPatches' int2str(nCPatches) 'CPatches'];

if ispc == 1
    loadLoc    = ['C:\Users\Levan\HMAX\annulusExpt\' loadFolder '\'];
    saveLoc    = ['C:\Users\Levan\HMAX\annulusExpt\' saveFolder '\'];
else    
    loadLoc    = ['/home/levan/HMAX/annulusExpt/' loadFolder '/'];
    saveLoc    = ['/home/levan/HMAX/annulusExpt/' saveFolder '/'];
end

if ~exist(saveLoc,'dir')
    mkdir(saveLoc)
end
load([loadLoc 'combMatrix']);
doubletCombMatrix = combMatrix; % redefine because new combMatrix is created for triplets.

if exist([loadLoc 'imageDifficultyData_Wedge_' int2str(nDoublets) '_Patches.mat']) == 0
   imageDifficultyMapWedgeLocalization('DOUBLETS','f',loadFolder,0);
end
load([loadLoc 'imageDifficultyData_Wedge_' int2str(nDoublets) '_Patches'],'IndPatch');
load([loadLoc 'imgHitsWedge.mat']);
load([loadLoc 'c2f.mat']);
nImgs = size(c2f,2);

%% START TP LOOP
tic;
combMatrix = zeros(nTPatches*nCPatches,5);
for i = 1:nTPatches
    i

% Preprocessing
idxTopDoublet = IndPatch(i);

idxHardImgs = find(imgHitsWedge(idxTopDoublet,:) == 0);
idxEasyImgs = find(imgHitsWedge(idxTopDoublet,:) == 1);

hardImgMap = imgHitsWedge(:,idxHardImgs);
easyImgMap = imgHitsWedge(:,idxEasyImgs);
nHardImgs = length(idxHardImgs);
nEasyImgs = length(idxEasyImgs);

                                                                                                                                    % Some sanity checks.
                                                                                                                                    assert(nHardImgs == 480 - nEasyImgs);
                                                                                                                                    allSuccesses = nnz(imgHitsWedge(:));
                                                                                                                                    hardSuccesses = nnz(hardImgMap(:));
                                                                                                                                    easySuccesses = nnz(easyImgMap(:));
                                                                                                                                    assert(allSuccesses == hardSuccesses + easySuccesses);

%% Now find patches that do well on hard images.
sumStats_CPatch = zeros(1,nDoublets); % preallocated
for iPatch = 1:nDoublets
    sumStats_CPatch(iPatch) = nnz(hardImgMap(iPatch,:));
end
[sortSumStats_CPatch,idxCPatches] = sort(sumStats_CPatch,'descend');

% Construct info about complementary patches.
CPInfo.idxPatches = idxCPatches(1:nCPatches);
CPInfo.nHardImgsHit = sortSumStats_CPatch(1:nCPatches);
for j = 1:nCPatches
    CPInfo.nAllImgsHit(j) = nnz(imgHitsWedge(CPInfo.idxPatches(j),:));
    CPInfo.nEasyImgsHit(j) = CPInfo.nAllImgsHit(j) - CPInfo.nHardImgsHit(j);
end
assert(isequal(CPInfo.nAllImgsHit,CPInfo.nHardImgsHit + CPInfo.nEasyImgsHit)==1);

%% Now determine the range of SF
bestLoc    = zeros(1,nCPatches); % preallocate
idxBestLoc = zeros(1,nCPatches); % preallocate
bestSF     = zeros(1,nCPatches); % preallocate

for iCPatch = 1:nCPatches
%     iCPatch
    idxiCPatch = CPInfo.idxPatches(iCPatch);
    newC2 = [c2f(idxTopDoublet,:); c2f(idxiCPatch,:)];
    newImgHitsWedge = [imgHitsWedge(idxTopDoublet,:); imgHitsWedge(idxiCPatch,:)];

    % Subtract c-patch C2 values from b-patch C2 values. 
    sfArray = newC2(1,:) ./ newC2(2,:); % DIVIDE TP C2 values by CP C2 values

    allSF = sort(sfArray);
    pushValue = 0.001;


%     fprintf([int2str(length(allSF)) ' scaling factors!!!!\n']);

        % Run through the SF range to find the optimal value.
        newLoc = zeros(1,length(allSF)); % preallocate
        for ii = 1:length(allSF)
%             ii
            iSF = allSF(ii);
            newC2_Scaled = newC2;
            if iSF < 1
                newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* iSF) - pushValue;
            else
                newC2_Scaled(2,:) = (newC2_Scaled(2,:) .* iSF) + pushValue;                
            end
            
            [newC2_Scaled_min(1,:),chosenPatchIdx(1,:)] = min(newC2_Scaled,[],1);
            
%                                                                                                                                     hold on
%                                                                                                                                     plot(newC2_Scaled(1,:))
%                                                                                                                                     plot(newC2_Scaled(2,:))
%                                                                                                                                     plot(newC2_Scaled_min(1,:)+0.05)
%                                                                                                                                     legend('BP','CP','Scaled CP')
%                                                                                                                                     close;
            
            newImgHitsWedge_Scaled = zeros(1,nImgs);
            
                for iImg = 1:nImgs
                    newImgHitsWedge_Scaled(1,iImg) = newImgHitsWedge(chosenPatchIdx(1,iImg),iImg);
                end

            newLoc(ii) = nnz(newImgHitsWedge_Scaled);
            
            % clear variables
            newC2_Scaled = [];
            chosenPatchIdx = [];
        end % SF LOOP
%                                                                                                                                      plotSFarrays(newC2,sfArray,newLoc)
%                                                                                                                                        close;
%                                                                                                                                        plot(newLoc)
%                                                                                                                                        hold on
%                                                                                                                                        title('Localization for Each SF');
%                                                                                                                                        xlabel('SF values')
%                                                                                                                                        axis([0 480 0 400])

        [bestLoc(iCPatch),idxBestLoc(iCPatch)] = max(newLoc);
        bestSF(iCPatch) = allSF(idxBestLoc(iCPatch));
        
        % clear variables
        newC2 = [];
        newImgHitsWedge = [];
        sfArray = [];
        allSF = [];
end

%create an output matrix
%                                                                                                                                      plot(bestLoc);
% combMatrixLoop = [repmat(idxTopPatch,nCPatches,1) CPInfo.idxPatches' bestSF' bestLoc'];
% combMatrix = [combMatrix; combMatrixLoop];
combMatrix(  ((i-1)*nCPatches+1):i*nCPatches,:) = [repmat(doubletCombMatrix(idxTopDoublet,1:2),nCPatches,1) CPInfo.idxPatches' bestSF' bestLoc'];

% combMatrixLoop = [];

if mod(iCPatch,500) == 0
    save([saveLoc 'combMatrix'],'combMatrix');
end
iToc = toc
end % nTPaches loop

overallMaxLoc = max(combMatrix(:,5))/nImgs*100

%% SAVE VARIABLES

save([saveLoc 'combMatrix'],'combMatrix');
% make_scaledDoublet_c2_imgHits_CUR(loadLoc,saveLoc,nTPatches,nCPatches,pushValue)
runTime = toc

runDateTime = datetime('now');
outputOfPWD = pwd;
scriptName  = mfilename('fullpath');
save([saveLoc 'runParameters.mat'],...
    'runDateTime',...
    'scriptName',...
    'outputOfPWD',...
    'runParameterComments',...
    'nTPatches',...
    'nCPatches',...
    'nTPatchesLoad',...
    'nCPatchesLoad',...
    'saveLoc',...
    'loadLoc',...
    'runTime',...
    'pushValue'...
    );

end

function plotSFarrays(newC2,sfArray,newLoc)
%     hold off
    subplot(2,2,1)
    plot(newC2(1,:));
    hold on
    plot(newC2(2,:));
    title('BP and CP C2 Values','FontSize',25)
    legend('BP','CP')
    axis([0 480 0 1])
    hold off
    
    subplot(2,2,2)
    plot(sfArray)
%     plot(allSF)
    axis([0 480 0 6])
    title('Scaling Factors Considered');
    
    subplot(2,2,3)
    plot(newLoc)
    hold on
    title('Localization for Each SF');
    xlabel('SF values')
    axis([0 480 0 400])
%     hold off
end