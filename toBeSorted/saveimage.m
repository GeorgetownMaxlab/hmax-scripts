
function saveimage( images, varargin)

%SAVEIMAGE save one or several images to disk
%
%   save_image( images [, names ,format] )
%      images - either an image (numeric matrix) or an array of cell
%               where each cell contain an image
%      names  - a string or an array of cells containing the output
%               filenames (with or without the file extension), if only one
%               name given, images will be saved as 'name_1','name_2',...
%      format - file format (bmp,gif,jpeg,pgm,png,pnm,ppm,tiff)
%
%   Examples:
%      saveimage( image1 , 'foo' , 'bmp')
%      saveimage( image1 , 'foo.jpg' )
%      saveimage( {image1 image2} , 'foo' )
%      saveimage( {image1 image2} , { 'foo' 'test'} , 'jpg' )
%
%   Author:      Adrien Brilhault
%   Date:        2010-01-31
%   E-mail:      adrien.brilhault@gmail.com

OVERWRITING_DIALOG=false;

% ----- How many images to display?

if isa(images,'numeric')
    nbImages=1;
    images={images};
else
    nbImages=size(images,1)*size(images,2);
end

% ----- Optionnal parameters

% no argument given
if (size(varargin,2)<1)
    names={'unnamedImage.bmp'};
    format='bmp';
end
% names
if (size(varargin,2)>=1)
    if isa(varargin{1},'cell')
        names=varargin{1};
    else
        names={varargin{1}};
    end
end
% Format
if (size(varargin,2)>=2)
    format= varargin{2};
else
    format='bmp';
end

% ----- Check if the file extension is included in the names given, if not add it

tempStr=strsplit('.',names{1});
extension=tempStr{length(tempStr)};
if (strfind(['bmp' 'gif' 'jpg' 'jpeg' 'pgm' 'png' 'pnm' 'ppm' 'tif' 'tiff'],extension)>0)
    format=extension;
else
    for i=1:length(names)
        names{i}=[names{i},'.',format];
    end
end

% ----- Complete names list if needed

if (length(names)<nbImages)
    namesTemp=cell(nbImages,1);
    tempStr=strsplit('.',names{1});
    if (size(tempStr{1},2)==0)
        nameImg=['.',tempStr{2}]; % if the name starts with ./
    else
        nameImg=tempStr{1};
    end
    for i=1:nbImages
        namesTemp{i}=[nameImg,'_',num2str(i),'.',format];
    end
    names=namesTemp;
end

% ----- Check folders in the path exist and create them if they don't

for n=1:length(names)
    tempStr=strrep(names{n},'\','/');
    tempStr=strsplit('/',tempStr);
    pathTemp='.';
    for i=2:size(tempStr,2)
        if (strcmp(tempStr{i-1},'.')==1) continue; end
        if (exist([pathTemp,'/',tempStr{i-1}],'dir')==0)
            mkdir([pathTemp,'/',tempStr{i-1}]);
        end
        pathTemp=[pathTemp,'/',tempStr{i-1}];
    end
end

% ----- Save the images
for i=1:nbImages
    imageTemp=images{i};
    
    if max(max(imageTemp))>10
        imageTemp=double(imageTemp)/255;
    end
    
    %% Normalize the image
    % imageTemp=mat2gray(imageTemp);
    % imageTemp= allImagesOut{1};
    % minN=min(min(imageTemp));
    % if (minN<0)
    %     imageTemp=imageTemp-minN;
    % end
    % imageTemp=imageTemp*255/max(max(imageTemp));
    
    
    % Save the image to disk
    overwrite=true;
    if exist(names{i},'file')
        disp(['WARING! File ',names{i},' already exist'])
        
        if (OVERWRITING_DIALOG==true)
            button = questdlg(['Overwrite file ',names{i},' ?'],'Overwrite Dialog','All','Yes','No','All');
            if strcmp(button,'No') overwrite=false; end
            if strcmp(button,'All') OVERWRITING_DIALOG=false; end
        end
    end
    if (overwrite==true)
        imwrite(imageTemp,names{i},format);
        disp(['Writing ',names{i},' to disk! ']);
    end
end

%% That function is need to split the path into folders
    function parts = strsplit(splitstr, str, option)
        %STRSPLIT Split string into pieces.
        %
        %   STRSPLIT(SPLITSTR, STR, OPTION) splits the string STR at every occurrence
        %   of SPLITSTR and returns the result as a cell array of strings.  By default,
        %   SPLITSTR is not included in the output.
        %
        %   STRSPLIT(SPLITSTR, STR, OPTION) can be used to control how SPLITSTR is
        %   included in the output.  If OPTION is 'include', SPLITSTR will be included
        %   as a separate string.  If OPTION is 'append', SPLITSTR will be appended to
        %   each output string, as if the input string was split at the position right
        %   after the occurrence SPLITSTR.  If OPTION is 'omit', SPLITSTR will not be
        %   included in the output.
        
        %   Author:      Peter J. Acklam
        %   Time-stamp:  2004-09-22 08:48:01 +0200
        %   E-mail:      pjacklam@online.no
        %   URL:         http://home.online.no/~pjacklam
        
        nargsin = nargin;
        error(nargchk(2, 3, nargsin));
        if nargsin < 3
            option = 'omit';
        else
            option = lower(option);
        end
        
        splitlen = length(splitstr);
        parts = {};
        
        while 1
            k = strfind(str, splitstr);
            if isempty(k)
                parts{end+1} = str;
                break
            end
            
            switch option
                case 'include'
                    parts(end+1:end+2) = {str(1:k(1)-1), splitstr};
                case 'append'
                    parts{end+1} = str(1 : k(1)+splitlen-1);
                case 'omit'
                    parts{end+1} = str(1 : k(1)-1);
                otherwise
                    error(['Invalid option string -- ', option]);
            end
            str = str(k(1)+splitlen : end);
        end
    end

end

