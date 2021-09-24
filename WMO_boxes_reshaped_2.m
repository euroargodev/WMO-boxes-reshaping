function []=WMO_boxes_reshaped_2(path_1,basin,WMOB,estlim,norlim)

% load CTD data
% compute potential temperature
% save data grouped per WMO boxes
%
% TEMPERATURE IS IN ITS-90 *********************
% LONG IS from 0 to 360    *********************
% no data is NAN           *********************
%
% reference: "How to prepare the reference database for OW" Annie Wong
%
% Giulio Notarstefano, Sep 2021


[r,c]=size(basin);

% LOAD CTD DATA, COMPUTE POTENTIAL TEMPERATURE
j=0;
for k=1:r
    
    file_1=getfname([path_1,'WMO_RESHAPED\CTD_A\',basin(k,:),'\*.mat']);
    [r1,c1]=size(file_1);

    for i=1:r1

        j=j+1;
        eval(['load ' ([path_1,'WMO_RESHAPED\CTD_A\',basin(k,:),'\',file_1(i,:)])]);

        [wmo]=div_wmo(lon,lat,WMOB,estlim,norlim); % find wmo box for each ctd data

        TEMP=temp;
        % -----------------------------------
        PTMP = sw_ptmpITS90(saly,TEMP,pres,0);     % compute potential temperature
        lon(lon < 0)=lon+360;
        LONG=lon;
        LAT=lat;
        PRES=pres;
        
        t=datestr(time,30);
        t(9)=[];
        DATES=str2num(t);
        % ----
        SAL=saly;
        SOURCE='';

        eval(['save ' path_1 'WMO_RESHAPED\CTD_B\' basin(k,:) '\' num2str(wmo) '_' num2str(length(PRES)) '_' num2str(j) ' DATES LAT LONG PRES SAL TEMP PTMP SOURCE'])
        
    end
end
