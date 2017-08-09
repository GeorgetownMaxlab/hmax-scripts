%% extracting images from annulus expt data

clear; clc; close;
dbstop if error;
saveLoc = 'C:\Users\Levan\HMAX\annulusExpt\';
saveFolder = 'Images_Faces_Backgrounds\background_with_faces_without_annulus_no_luminance_normalization\';
    if ~exist([saveLoc saveFolder],'dir')
        mkdir([saveLoc saveFolder])
    end
    
filesToLoad = lsDir([saveLoc 'raw_data'],{'mat'});

for iFile = 1:length(filesToLoad)    
load(filesToLoad{iFile},'trialOutput','exptdesign')

            for iTrial = 1:length(trialOutput.trials)
                tsize=2.34;
                tecc=7;
                tangle = trialOutput.trials(iTrial).angle;
                params = exptdesign;
                ResScreen = exptdesign.resScreen;
                ScreenSize = exptdesign.sizeScreen;
                bg = strrep(trialOutput.trials(iTrial).bg,...
                    '/home/scholl/Desktop/Florence/Expt_Model_Loc_Sept2015/AnnulusBackground1/',...
                    'C:\Users\Levan\HMAX\annulusExpt\Images_Faces_Backgrounds\AllBackgrounds\');
                
                mskfce = strrep(trialOutput.trials(iTrial).NameMaskVisage,...
                    '/home/scholl/Desktop/Florence/Expt_Model_Loc_Sept2015/Mask3/',...
                    'C:\Users\Levan\HMAX\annulusExpt\Images_Faces_Backgrounds\Mask3\');
                
                NameVisage = strrep(trialOutput.trials(iTrial).NameVisage,...
                    '/home/scholl/Desktop/Florence/Expt_Model_Loc_Sept2015/Faces3/',...
                    'C:\Users\Levan\HMAX\annulusExpt\Images_Faces_Backgrounds\Faces3\');
                
                fce = imread(NameVisage);
                [fce,bg,pastedimage,coords1,X1,Y1,vignette1]= ... 
                    CodePaste1StimsDefinitif_full_attention_localizer(tsize,tecc,tangle,params,bg,fce,mskfce,iTrial,ResScreen,ScreenSize);
           
            imwrite(uint8(pastedimage),...
            [saveLoc saveFolder filesToLoad{iFile}(end-28:end-18) '_image'...
            int2str(iTrial) '.jpeg'], 'jpeg');
            end
end