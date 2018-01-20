function CUR_genLoc(condition,nPatchesAnalyzed,nPatchesPerLoop,startingPatchLoopIdx,maxSize)

% This script allows to break up localization code and parallelize
% computation. It parallelizes on the patches.

%% Global setup
dbstop if error;

if (nargin < 4)
    nPatchesAnalyzed     = 50000;
    nPatchesPerLoop      = 2000;
    startingPatchLoopIdx = 1;
end

if (nargin < 1)
    condition = 'annulusExptFixedContrast/simulation5/training/';
end

% nImgsAnalyzed        = 720;
if (nargin < 5)
    % maxSize              = 579;
    maxSize              = 1067;
end
splitID              = 'lfwSingle50000'; %display('SANDBOX CONDITION');
% tasks = {'patchSetAdam','patchSet_1x2','patchSet_2x1','patchSet_1x3','patchSet_3x1','patchSet_2x3','patchSet_3x2'};
tasks = {'patchSet_3x2'};
% patchSizes = [2,1,2,1,3,2,3;...
%               2,2,1,3,1,3,2;...
%               4,4,4,4,4,4,4;...
%               nPatchesAnalyzed,nPatchesAnalyzed,nPatchesAnalyzed,...
%               nPatchesAnalyzed,nPatchesAnalyzed,nPatchesAnalyzed,...
%               nPatchesAnalyzed];
patchSizes = [3;...
              2;...
              4;...
              nPatchesAnalyzed];

wedgeInDeg = [90,45,30,20,15,10]; % This is the angle of the FULL wedge.

if ~ispc
    if ~isempty(gcp('nocreate'))
        delete(gcp)
    end
    parpool(25)
end

for iTask = 1:numel(tasks)
    %% Define variables before loop starts.
    % So they don't get defined every time within the loop.
    
    if ispc
        home = 'C:/Users/Levan/HMAX/';
    else
        home = '/home/levan/HMAX';
    end
%     display('Remember to edit back the high contrast condition');
    saveLoc   = fullfile(home,condition,'data',tasks{iTask},splitID,'fixedLocalization');
    loadLoc   = fullfile(home,condition,'data',tasks{iTask},splitID);
    
    if ~exist(saveLoc)
        mkdir(saveLoc)
    end
    
    diary(fullfile(saveLoc,'diary.mat'));
    
%     mkdir(fullfile(saveLoc,'responseOverlays','hits'));
%     mkdir(fullfile(saveLoc,'responseOverlays','misses'));     
    
    if mod(nPatchesAnalyzed,nPatchesPerLoop)~=0
        input = 'loopping messed up'; %#ok<*NASGU>
    else
        nPatchLoops = nPatchesAnalyzed/nPatchesPerLoop;
    end
    
    % Define patch sizes.
    currentPatchSizes = patchSizes(:,iTask);
    
    % Load and transform facesLoc.mat file
    load(fullfile(loadLoc,'facesLoc.mat')); %variable in workspace called 'facesLoc']
    facesLoc = convertFacesLocAnnulusFixedContrast(facesLoc,ispc); %Convert the linux file paths to windows file paths, and vice-versa if needed.
    if ~exist('nImgsAnalyzed','var')
        nImgsAnalyzed = length(facesLoc{1});
    end
    
    % ADJUST THE BEST LOC VALUES BASED ON RESIZING DONE AT C2 CALCULATION
    
    % Check if the file already exist
    if exist(fullfile(saveLoc,'dimensions_and_SF.mat'))
        load(fullfile(saveLoc,'dimensions_and_SF.mat'))
    else
        
        % ySizeOrig and xSizeOrig are dimensions of images that were presented to
        % subjects during psychophysical experiments. All the face-location data
        % given by Florence is relative to these dimensions.
        
        % Predefine the variables
        dimsOrig       = zeros(length(facesLoc{1}),2);
        dimsResized    = zeros(length(facesLoc{1}),2);
        scalingFactors = zeros(length(facesLoc{1}),1);
        
        for iImg = 1:nImgsAnalyzed %length(facesLoc{1})
            if mod(iImg,100) == 0
                display(['Calculating scaling factors. iImg = ' int2str(iImg)]);
            end
            dimsOrig   (iImg,1:2) = size(imread(facesLoc{1}{iImg}));
            % These are the dimensions of images pushed through HMAX.
            dimsResized(iImg,1:2) = size(resizeImage(imread(facesLoc{1}{iImg}),maxSize));
            
            % Now obtain the scaling factor for bestLoc variables, so they can be
            % transformed to be relative to dimensions of the images seen by subjects.
            % Then they can be compared to face location values.
            scalingFactors(iImg,1) = dimsOrig(iImg,1)/dimsResized(iImg,1);
            assert(isequal(round(scalingFactors(iImg,1),2),round(dimsOrig(iImg,2)/dimsResized(iImg,2),2)),'somethings not right with image resizing');
        end
        save(fullfile(saveLoc,'dimensions_and_SF.mat'),'dimsOrig','dimsResized','scalingFactors');
    end
    
    %% Save parameter space.
    runDateTime = datetime('now');
    outputOfPWD = pwd;
    scriptName  = mfilename('fullpath');
    runParameterComments = 'none'; %input('Any comments about run?\n');
    save(fullfile(saveLoc,'locParameters.mat'),...
        'runDateTime',...
        'outputOfPWD',...
        'runParameterComments',...
        'home',...
        'nPatchesAnalyzed',...
        'nPatchesPerLoop',...
        'startingPatchLoopIdx',...
        'condition',...
        'scriptName',...
        'patchSizes',...
        'saveLoc',...
        'loadLoc',...
        'maxSize'...
        );
    
    %% Start Loop
    display(['Starting the parallel loop for ' tasks{iTask}]);
    parfor iPatchLoop = startingPatchLoopIdx:nPatchLoops % not sure if starting fomr random patchLoopIdx is gonna be ok. So don't use it so far.
%             display('Parfor is Off!!!!');
        tic
        %     display(['Starting to run ' tasks{iTask}]);
        
        CUR_annulus_FaceBox_and_AngularDegree_Calculation(...
            iPatchLoop,...
            nPatchesPerLoop,...
            currentPatchSizes,...
            loadLoc,...
            fullfile(home,condition),...
            saveLoc,...
            facesLoc,...
            nImgsAnalyzed,...
            dimsOrig,...
            dimsResized,...
            scalingFactors)
        
        display(['Loop #' int2str(iPatchLoop) ' done in '  num2str(toc)]);
    end
    
    %% Concatenate the output
    display(['Concatenating output for ' tasks{iTask}])
    concatinateOutput_loc(saveLoc,nPatchesPerLoop,nPatchesAnalyzed)
    
    %% Now calculate the imgHitsWedge maps for various sized wedges
    display(['Making hits maps for ' tasks{iTask}])
    CUR_annulus_Wedge_Calculation(...
        saveLoc,...
        saveLoc,...
        wedgeInDeg)
    
    %% Now calculate performance of the patches
    display(['Concatenating performances for ' tasks{iTask}])
    patchPerformanceInfo_FaceBox(...
        saveLoc,...
        saveLoc)
    
    patchPerformanceInfo_Wedge(...
        saveLoc,...
        saveLoc)
    
end % iTask


end


