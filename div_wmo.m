function [wmo]=div_wmo(xctd,yctd,WMOB,estlim,norlim)

% Find which WMO box CTD data is in.
% Box is 10°X10°, in the Mediterranean and  Seas:
% 7300 7400 1300 1400 1301 1401 1302 1402 1303 1403 1304 1404
%

a=0;
for i=1:length(estlim)-1
    for j=1:length(norlim)-1
        a=a+1;
        if xctd >= estlim(i) && xctd < estlim(i+1)
            if yctd >= norlim(j) && yctd < norlim(j+1)
                wmo=WMOB(a);
            end
        end
    end
end
