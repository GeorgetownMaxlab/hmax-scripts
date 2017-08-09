% 16042014, sera utilise a la fois pour prendre les asc et pour prendre les
% fichiers matlab

function [nomDir,NomFichier] = LookForFiles(NomDossier)% stimulus only to get the content of the stimulus variable in the matlab file
Garde=[];
nomDir = [NomDossier];% avec les premiers essais de lentrainement de chaque sujet (correspond parfois a tout leur entrainement, parfois pas)
files = dir(nomDir);%liste les fichiers dans ce dossier
NomFichier={files.name};
NomFichier=sort_nat(NomFichier);
for i=1:size(NomFichier,2)
    if (strcmp('.DS_Store',NomFichier{i}) | strcmp('.',NomFichier{i}) | strcmp('..',NomFichier{i}));
        NomFichier{i}=[];
    else
        Garde=horzcat(Garde,i);
    end
end

NomFichier={files(Garde).name};