function []=WMO_boxes_reshaped(path_1,EL,NL,WMOB)

% DESCRIPTION:
%    CTD profiles are grouped per sub-basins of the Mediterranean and Black Seas. 
%    WMO boxes used in OWC are re-shaped according to the dimension of the sub-basins. 
%    WMO boxes dimensions could be too large for OWC application in marginal seas.
%    The WMO boxes reshaping is useful to avoid selecting historical data for 
%    calibration coming from completely different oceanographic regions. 
%
%    Sub-basins are defined by polygons created by the user.
%
% REQUIREMENTS:
%    You need a folder called WMO_RESHAPED located in 'YOUR_PATH\WMO_RESHAPED' that contains:
%    1) your reference CTD profiles in mat format:
%       one mat file per CTD profile whose variables are: 
%       lat(1,1), lon(1,1), time (1,1), pres(1,n), temp(1,n), saly(1,n)
%       ******* lon(1,1) west of Greenwich must be negative *******
%
%    2) sub-basins' polygons (one mat files per polygon with coodinates "xv" for longitude and
%       "yv" for latitude) in a folder called "bas_poly". FIRST FIVE LETTERS of
%       sub-basins polygons names should be unique since names of sub-basins are
%       automatically generated (i.e. for the Med Sea: adriatic.m --> adria, ionian.m --> ionia).
%       ******* "xv" (longitude) west of Greenwich must be negative *******
%
% INPUT:
%    1) you have to set up your path
%
%    2) You have to set up the WMO boxes geographical limits.
%       EL=[min lon, max lon]; 
%       NL=[min lat, max lat]; 
%       12 WMO boxes are used to cover the Med % Black Sea area whose limits
%       are: EL=[-10 50]; NL=[30 50];
%
%    3) You have to set up the WMO boxes numbers. 
%       They must be sorted per increasing longitude and latitude
%       i.e. for the Mediterranean and Black Sea in this way:
%       WMOB=[7300 7400 1300 1400 1301 1401 1302 1402 1303 1403 1304 1404];
%
% USAGE:
%    WMO_boxes_reshaped('YOUR_PATH\',EL,NL,WMOB)
%    i.e. for the Med Sea:
%    WMO_boxes_reshaped('YOUR_PATH\',[-10 50],[30 50],[7300 7400 1300 1400 1301 1401 1302 1402 1303 1403 1304 1404])
%
% OUTPUT:
%    wmo boxes files in mat format reshaped according to the sub-basin's dimension.
%    Files are in: 'YOUR_PATH\WMO_RESHAPED\CTD_WMO'
%    wmo boxes files can be used in OWC software
%
% Giulio Notarstefano, Sep 2021
%

clc
% LIMITS OF WMO BOXES
estlim=[EL(1):10:EL(2)]; norlim=[NL(1):10:NL(2)];


% LIST SUB-BASINS' POLYGONS
file_poly=getfname([path_1,'WMO_RESHAPED\bas_poly\','*.mat']);
[rp,cp]=size(file_poly);   


% GENERATE SUB-BASINS' NAMES and FOLDERS
if exist([path_1,'WMO_RESHAPED\CTD_WMO'],'dir')
    disp(' **********************************************')
    disp('Do you want to delete the exsisting')
    disp('CTD_WMO folder created in the last run?')
    action=input('TYPE 1 for YES ot 0 for NO   ');
    if action == 1
        rmdir([path_1,'WMO_RESHAPED\CTD_WMO'],'s');
    else
        disp(' **********************************************')
        disp('   +++ Your folder CTD_WMO will be renamed +++')
        disp(' +++ and a new folder CTD_WMO will be created +++')
        disp(' **********************************************')
        pause(5)
        movefile([path_1,'WMO_RESHAPED\CTD_WMO'],[path_1,'WMO_RESHAPED\CTD_WMO_old'])
    end
end

mkdir([path_1,'WMO_RESHAPED\CTD_A']);
mkdir([path_1,'WMO_RESHAPED\CTD_B']);
mkdir([path_1,'WMO_RESHAPED\CTD_WMO']);

basin=[];
for j=1:rp
    basin=[basin;file_poly(j,1:5)];
    mkdir([path_1,'WMO_RESHAPED\CTD_A\' file_poly(j,1:5)]);
    mkdir([path_1,'WMO_RESHAPED\CTD_B\' file_poly(j,1:5)]);
    mkdir([path_1,'WMO_RESHAPED\CTD_WMO\' file_poly(j,1:5)]);
end
[r,c]=size(basin);
      

% LOAD SUB-BASINS' POLYGONS
for i=1:rp
    eval(['load ' ([path_1 'WMO_RESHAPED\bas_poly\' file_poly(i,:)])]);
    eval(['x',basin(i,:),'=xv;']);
    eval(['y',basin(i,:),'=yv;']);
end

clear xv yv i rp rc j


% LOAD CTD DATA
file_1=getfname([path_1,'WMO_RESHAPED\','*.mat']);
[r1,c1]=size(file_1);

for i=1:r1
    eval(['load ' ([path_1,'WMO_RESHAPED\',file_1(i,:)])]);
    clc
    disp(['Processing CTD ' num2str(i) ' of ' num2str(r1)])

    % CHECK BASIN
    for j=1:r
        eval(['xv=x',basin(j,:),';']);
        eval(['yv=y',basin(j,:),';']);

        in=inpolygon(lon,lat,xv,yv);
        if in == 1
            eval(['save ',path_1,'WMO_RESHAPED\CTD_A\',basin(j,:),'\',file_1(i,:),' time lon lat pres temp saly']);
        end
    end
end


WMO_boxes_reshaped_2(path_1,basin,WMOB,estlim,norlim)

WMO_boxes_reshaped_3(path_1,basin,WMOB)


rmdir([path_1,'WMO_RESHAPED\CTD_A'],'s');
rmdir([path_1,'WMO_RESHAPED\CTD_B'],'s');

disp(' **********************************************')
disp('   +++ Your wmo boxes files are in  +++')
disp(['  +++ ' path_1 'WMO_RESHAPED\CTD_WMO +++'])
disp(' **********************************************')


