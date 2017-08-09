%% v2, here correct if the angle of the saccade is at less than 45 degs of the face


%% September 2015-- a face, inverted or upright has been displayed at each trial at 7 degs eccentricity (100 different faces and background)
%% Either inverted or upright. On an annulus of background.

%% Want to get the minSRT (of the first saccade of each trial) and the accuracy of this saccade
% For inverted versus upright faces

function [Matrix_Correct, Matrix_Accuracy,saccadeReactionTimes,stim,essais_incorr,Angular_dist,Amplitude_Sacc,Coords_Sacc,Coords_Face]=Analyse_LocAccuracy_v3(iSjt,ascpath,matlabpath)% pathfile to matlab
addpath ../MainScriptsInterf/Experiment3_FaceLocalization/
sRT=[];
essais_incorr=[];
Matrix_Correct=nan(1,320);% one element per trial
Matrix_Accuracy=[];
% 1) Load the matlab file one by one
% 2) Load the corresponding ASC file, one per session

% NomEDFFiles ordered list of the folders into the ascpath
[nomDir,NomEDFFiles] = LookForFiles(ascpath);% la liste des dossiers avec des ASC files
NomEDFFiles=sort_nat(NomEDFFiles);
% nomEDFSubj folder of a given subject
nomEDFSubj=NomEDFFiles;
% nomEDFSubj path to the folder of the subject
% nomEDFSubj=strcat(ascpath,nomEDFSubj);% le nom du dossier ASC du sujet dont le fichier matlab a ete charge (on prend un seul fichier matlab alors quil y en a autant que de sessions car tous contiennent stimulus, la seule matrice utilisee, avec 1080 essais)
% [nomDirEDF, NomFichierEDF] = LookForFiles(nomEDFSubj);% l'ensemble des fichiers asc du sujet, qui est dans le dossier ASC correspondant
% % NomFichierEDF ordered list of the files in the folder of the subject
% NomFichierEDF=sort_nat(NomFichierEDF);

%% load also one mat file per subject
%% Pour chaque condition
% Dans le dossier, un fichier matlab par participant
%[nomDir, NomFichierMat] = LookForFiles('Resultats/ResultatsMat_Loc_Levan');% liste tous les fichiers matlab, un par participant
[nomDir, NomFichierMat] = LookForFiles(matlabpath);% liste tous les fichiers matlab, un par participant
NomFichierMat=sort_nat(NomFichierMat);% ces fichiers sont ordonnes par ordre alphabetique/numerique (1 2 3 4 etc.)
saccadeReactionTimes = nan(1,320);

%% Determine for each trial whether the face was on the left or on the right
%% Based on lines containing coords
nb_DIN = 0;
for isession=1:length(nomEDFSubj)%length(NomFichierEDF);%% 15 sessions
    % Load matlab file session per session
    nomMatSubj=NomFichierMat{isession};% nomMatSubj le fichier matlab du sujet
    nomMatSubj=strcat(matlabpath,nomMatSubj);
    eval(['load ' nomMatSubj])
    
    % Reads into edf file session per session
    edfname=NomEDFFiles{isession};
    edfname=strcat(ascpath,edfname);
    triggeronsets = getLinesWith(edfname,'Image',1);%% Le contenu des lignes qui correspondent a l'affichage de l'image ? notamment le temps d'apparition de l'image
    starttrial = getLinesWith(edfname,'new trial',1);%% Le contenu des lignes qui correspondent au debut de chaque essai
    thelines = getLinesStartingWith(edfname,'ESACC',1);% Le contenu des lignes qui resument l'evenement saccade (avec notamment le moment du debut et de la fin de la saccade)
    linescoord = getLinesWith(edfname,'cond=',1);% lignes avec les coordonnees du visage (condition 1 2), des 2 visages (condition 3)
    linesBUTTON= getLinesStartingWith(edfname,'BUTTON',1);
    
    
    % nb_DIN =
    %% On cherche les lignes dans lesquelles le temps est identique a celui des deux precedentes et on garde ces timings la comme etant les timings d'apparition des images
    %% On verifie qu'il y a en length(triggeronsets) dans un fichier
    % % % % % %     for index_trial = 2 : size(linesBUTTON,2)
    % % % % % %         timing(index_trial)=str2double(linesBUTTON{index_trial}{1}{2});
    % % % % % %     end
    % % % % % %
    % % % % % %     for index_buttontme = 2: length(timing)-1
    % % % % % %         if timing(index_buttontme)==timing(index_buttontme-1) % %% LE PLUS SOUVENT 3 BOUTONS DAFFILEE AVEC LE MEME TEMPS AU DEBUT DE L'ESSAI, AU MOMENT OU LAFFICHAGE DE LIMAGE, MAIS PARFOIS SEULEMENT 2, DEUX BOUTONS MEME TIMING CEST SEULEMENT EN DEBUT DESSAI DE CE QUE JE VOIS DONC CRITERE SATISFAISANT. & timing(index_buttontme)==timing(index_buttontme+1)                    % % % % % %             timing_image_display(ind_display)=timing(index_buttontme);
    % % % % % %             ind_display=ind_display+1;
    % % % % % %         end
    % % % % % %
    % % % % % %     end
    % % % % % %     timing_image_display=unique(timing_image_display);
    % % % % % %
    
    %% Use then the subfunctions of Jacob (adapt them very little)
    %% informations about the saccades
    allsaccadedata = zeros(length(thelines),7);
    % import the saccade time data
    for linenum=1:length(thelines)
        allsaccadedata(linenum,1) = str2double(thelines{linenum}{1}{3}); % start
        allsaccadedata(linenum,2) = str2double(thelines{linenum}{1}{4}); % end
        allsaccadedata(linenum,3) = str2double(thelines{linenum}{1}{5}); % duration
        allsaccadedata(linenum,4) = str2double(thelines{linenum}{1}{6}); % startx
        allsaccadedata(linenum,5) = str2double(thelines{linenum}{1}{7}); % starty
        allsaccadedata(linenum,6) = str2double(thelines{linenum}{1}{8});% endx
        allsaccadedata(linenum,7) = str2double(thelines{linenum}{1}{9});% endy
        allsaccadedata(linenum,8) = str2double(thelines{linenum}{1}{10});% AMPLITUDE

    end
    
    % Now aggregate the saccade data into the trials by correlating with
    % the trial onset times
    saccades = cell(1,length(triggeronsets));
    saccadeSides = zeros(1,length(triggeronsets));
    for i=1:length(triggeronsets)% i, essai par essai
        
        
        % triggertime1 est reutilise comme la reference pour calculer le TR, donc ca doit etre
        % le moment d'apparition de l'image, quand c'est ecrit Image
        % just flipped en effet
        %triggertime1 = triggeronsets{i,2};% the line for the beginning of a trial, en fait je pense que ca doit etre l'apparition de l'image a voir selon la maniere dont c'est utilise pour les TR
        triggertime1=get_coordsstarttrial(triggeronsets{i});%% le moment de l'apparition de l'image pour l'essai i
        Mat_Im_Mess(i)=triggertime1;
        
        % Temps d'apparition de l'image vient desormais de BUTTON de la
        % photodiode
        % triggertime1=timing_image_display(i);
        
        % triggertime2 moment d'apparition de l'image suivante
        if i+1 > length(triggeronsets)
            triggertime2 = inf;
        else
            triggertime2=get_coordsstarttrial(triggeronsets{i+1});
            % triggertime2=timing_image_display(i+1);
        end
        %% 13 octobre 2014,je veux les saccades qui demarrent entre l'apparition de l'image et 300 ms ensuite. Plutot qu'entre l'apparition d'une image et de la suivante. D'autant plus important ici qu'il se peut qu'un sujet n'ait pas le temps de saccader entre temps.
        saccadesfortrial = allsaccadedata(allsaccadedata(:,1) >= triggertime1 & allsaccadedata(:,1) <=triggertime2,:);% & allsaccadedata(:,7) >= 0.5,:);% triggertime2,:);% when there are saccades between the beginning of a trial and the beginning of the next trial
        saccadesfortrial = saccadesfortrial(1,:);% keep only the first saccade of the trial
        numsaccadesfortrial = size(saccadesfortrial,1);
        if numsaccadesfortrial == 0
            disp(['WARNING:  NO SACCADES FOR TRIAL ' num2str(i)]);
            saccadeReactionTimes((isession-1)*length(triggeronsets)+i)=nan;
            corrPremSacc((isession-1)*length(triggeronsets) + i)=nan;
        end
        
        for j=1%:numsaccadesfortrial% j l'ensemble des saccades dans un essai
            % Coordonnees d'arrivees de la saccade, (x,y)
            saccades{i}.endx(j) = saccadesfortrial(j,6);
            saccades{i}.endy(j) = saccadesfortrial(j,7);
            %  le RT de toutes les saccades d'un essai, entre la premiere a
            %  partir de l'apparition d'une image et la derniere de l'essai
            %  [jusqu'a l'apparition de la derniere image]
            
            %% Position of the face at each trial of each session
            % Left or right
            % If the face was on the left, -1, 1 if on the right
            
            
            if numsaccadesfortrial > 0 %% 
                
                
                % le TR de la premiere saccade de chaque essai.
                CEndPt_PremSacc{(isession-1)*length(triggeronsets)+i}=[saccadesfortrial(1,6) saccadesfortrial(1,7)];
                %% Compute the distance between the saccade endpoint of the trial and the face coordinates of the trial
                A=trialOutput.CoordsRelScreen(i).face;% A Coords of the face
                B=CEndPt_PremSacc{(isession-1)*length(triggeronsets)+i};% B Endpoint of the saccades
                C = trialOutput.trials(i).angle;
                face_angle= C;
                
                %% Here, saccades are considered correct if they land within ±45 degrees from the angle of the face
                coords_ep(1) = B(1)- 1920/2; % see notebook for explanations
                coords_ep(2) = 1080/2 - B(2);
                [theta,rho] = cart2pol(coords_ep(1),coords_ep(2));
                ang_deg_sacc = rad2deg(theta);
                ang_sacc = mod(ang_deg_sacc, 360); % for instance -39 will be 323, to match the angles I have for the faces when looking for a window face_ang ± -45

                
                %% Look for trials in which the saccades end at ±45 from the eyes
                ang_sep = 22.5;
                % Delicate case with angles that can be expressed as 350 or
                % -10
                if ((ang_sacc >= (360 -  ang_sep) & face_angle <= ang_sep) |  (face_angle >= (360 -  ang_sep) & ang_sacc <= ang_sep))% might be close enough from each other but would not be detected since abs(350 - 20) > 45
                    if ang_sacc < face_angle
                        ang_sacc = ang_sacc + 360;
                    elseif face_angle < ang_sacc
                        face_angle = face_angle + 360;
                    end
                    
                end
                
                % Determine whether more than ± 45 degrees between saccade
                % endpoint and face
                if (abs(face_angle - ang_sacc) < ang_sep)% Trials considered as correct
                    Matrix_Correct((isession-1)*length(triggeronsets)+i) = 1;
                    saccades{i}.reactiontime(j) = (saccadesfortrial(j,1) - triggertime1) / 1000; % in ms % debut des j saccades de l'essai i- moment d'apparition de l'oimage
                    saccadeReactionTimes((isession-1)*length(triggeronsets)+i)= saccades{i}.reactiontime(1);
                    Matrix_Accuracy((isession-1)*length(triggeronsets)+i)=norm(B-A);
                    Angular_dist((isession-1)*length(triggeronsets)+i) = abs(face_angle - ang_sacc); 
                    Amplitude_Sacc((isession-1)*length(triggeronsets)+i) =  saccadesfortrial(1,8);
                    Coords_Sacc{(isession-1)*length(triggeronsets)+i} = B;
                    Coords_Face{(isession-1)*length(triggeronsets)+i} = A;

                else % Incorrect trials
                    Matrix_Correct((isession-1)*length(triggeronsets)+i) = nan;
                    saccades{i}.reactiontime(j) = (saccadesfortrial(j,1) - triggertime1) / 1000; % in ms % debut des j saccades de l'essai i- moment d'apparition de l'oimage
                    saccadeReactionTimes((isession-1)*length(triggeronsets)+i)= saccades{i}.reactiontime(1);
                    Matrix_Accuracy((isession-1)*length(triggeronsets)+i)=norm(B-A);
                    Angular_dist((isession-1)*length(triggeronsets)+i)= abs(face_angle - ang_sacc); 
                    Amplitude_Sacc((isession-1)*length(triggeronsets)+i) =  saccadesfortrial(1,8);
                    Coords_Sacc{(isession-1)*length(triggeronsets)+i} = B;
                    Coords_Face{(isession-1)*length(triggeronsets)+i} = A;

                end
            end
                %% Matrix_Correct, 1 if the EP of the first saccade lannds within the quadrant of the face and 0 else
                
                
                %% Convention, quand deux visages, je mets toujours un (ie saccade du bon cote), en effet, ou qu'ils saccadent, c'est juste. Cette condition ne sera pas interessante pour cette variable mais elle le sera tout-de-meme pour les SRT (comparaison avec un visage, effet de la presentation simultanee de deux items).
                
                
            
            %sRT=[sRT saccadeReactionTimes];
            
        end
    end
    

    stim = stimulus; % comes from the last run

end

