# WMO-boxes-reshaping
WMO boxes used in OWC are reshaped according to the dimensions of selected sub-basins.

DESCRIPTION:

    CTD profiles are grouped per sub-basins. 
    WMO boxes used in OWC are re-shaped according to the dimension of the sub-basins. 
    WMO boxes dimensions could be too large for OWC application in marginal seas.
    The WMO boxes reshaping is useful to avoid selecting historical data for 
    calibration coming from completely different oceanographic regions. 
    Sub-basins are defined by polygons created by the user.

 REQUIREMENTS:
 
    You need a folder called WMO_RESHAPED located in 'YOUR_PATH\WMO_RESHAPED' that contains:
    
    1) your reference CTD profiles in mat format:
       one mat file per CTD profile whose variables are: 
       lat(1,1), lon(1,1), time (1,1), pres(1,n), temp(1,n), saly(1,n)
       ******* lon(1,1) west of Greenwich must be negative *******

    2) sub-basins' polygons (one mat files per polygon with coodinates "xv" for longitude and
       "yv" for latitude) in a folder called "bas_poly". FIRST FIVE LETTERS of
       sub-basins polygons names should be unique since names of sub-basins are
       automatically generated (i.e. for the Med Sea: adriatic.m --> adria, ionian.m --> ionia).
       ******* "xv" (longitude) west of Greenwich must be negative *******

 INPUT:
 
    1) you have to set up your path

    2) You have to set up the WMO boxes geographical limits.
       EL=[min lon, max lon]; 
       NL=[min lat, max lat]; 
       12 WMO boxes are used to cover the Med % Black Sea area whose limits
       are: EL=[-10 50]; NL=[30 50];

    3) You have to set up the WMO boxes numbers. 
       They must be sorted per increasing longitude and latitude
       i.e. for the Mediterranean and Black Sea in this way:
       WMOB=[7300 7400 1300 1400 1301 1401 1302 1402 1303 1403 1304 1404];

 USAGE:
 
    WMO_boxes_reshaped('YOUR_PATH\',EL,NL,WMOB)
    i.e. for the Med Sea:
    WMO_boxes_reshaped('YOUR_PATH\',[-10 50],[30 50],[7300 7400 1300 1400 1301 1401 1302 1402 1303 1403 1304 1404])

 OUTPUT:
 
    wmo boxes files in mat format reshaped according to the sub-basin's dimension.
    Files are in: 'YOUR_PATH\WMO_RESHAPED\CTD_WMO'
    wmo boxes files can be used in OWC software

 Giulio Notarstefano, Sep 2021
