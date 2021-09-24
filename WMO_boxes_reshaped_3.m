function []=WMO_boxes_reshaped_3(path_1,basin,WMOB)

% load CTD data grouped per WMO box and create a single matrix

[r,c]=size(basin);

s=size(WMOB);

for k=1:r
    for i=1:s(2)
        file=getfname([path_1 'WMO_RESHAPED\CTD_B\' basin(k,:) '\' num2str(WMOB(i)) '*.mat']);
        [n,c]=size(file);        % n ==> number of columns

        levels=[];
        for j=1:n
            l=strfind(file(j,:),'_');
            lev=str2num(file(j,l(1)+1:l(2)-1));
            levels=[levels;lev];
        end
        clear j
        m=max(levels(:));        % m ==> number of rows

        % matrices initialization for selected wmo box
        dates=NaN.*ones(1,n);
        lat=NaN.*ones(1,n);
        long=NaN.*ones(1,n);
        pres=NaN.*ones(m,n);
        sal=NaN.*ones(m,n);
        temp=NaN.*ones(m,n);
        ptmp=NaN.*ones(m,n);
        source=cell(1,n);

        for j=1:n
            eval(['load ' ([path_1 'WMO_RESHAPED\CTD_B\' basin(k,:) '\' file(j,:)])]);
            dates(1,j)=DATES;
            lat(1,j)=LAT;
            long(1,j)=LONG;
            pres(1:length(PRES),j)=PRES;
            sal(1:length(SAL),j)=SAL;
            temp(1:length(TEMP),j)=TEMP;
            ptmp(1:length(PTMP),j)=PTMP;
            source{1,j}=SOURCE;
        end
        eval(['save ' path_1 'WMO_RESHAPED\CTD_WMO\' basin(k,:) '\ctd_' num2str(WMOB(i)) ' dates lat long pres sal temp ptmp source'])
    end
end
    