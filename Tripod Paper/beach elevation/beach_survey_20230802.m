% plot beach survey data 02/08/2023
% LAT LON is converted from EASTING NORTHING in ARCGIS PRO
% EASTING NORTHING need to first be rotated in MATLAB?

% Jan survey as a simple example
Lat (1,:) = surveyrotatedLATLON20230727 (:,2);
Lon (1,:) = surveyrotatedLATLON20230727 (:,1);
Dep (1,:) = surveyrotatedLATLON20230727 (:,3);

figure

geoscatter(Lat(1,:), Lon(1,:),[],Dep (1,:),'filled');
geolimits([-27.3934 -27.3926],[153.4395 153.4408])
% title(['Amity beach elevation ',num2str(time(i)), '2023 May']) 
geotickformat('-dd');
geobasemap satellite
 
colorbar;
c = colorbar;
c.Label.String = 'Elevation AHD (m)';
caxis([-2 5]);

% process May 2023 beach survey
for i = 1:12 
M  = dlmread(['beachsurveyMay2023_',num2str(i), '.csv']);
[row,col] = size(M);
% Total station data
% read the Easting, Northing and elevation from total station data

% Here Easting Northing is the measured value by total station
% 12/04/2023
Easting = M(1:row,2);
Northing = M (1:row,3);
elev = M (1:row,4);

% find the PSM
PSM = [92,1,1,1,1,1,1,1,1,1,1,1];
% find the tree
TR = [93,2,2,2,2,2,2,2,2,2,2,2];

% rotate the measured Easting and Northing
% using the PSM as the pivot
% PSM is Easting 0 Northing 0 in total station

% Easting and Northing for PSM
% PSM true and measured same value
% 12/04/2023
PSM_Easting = 543502.075;
PSM_Northing = 6969926.912;
TR_Easting = 543537.158;
TR_Northing = 6969912.711;

% calculate the distance from the pivot
 Easting_diff (1:row,1) = Easting (:,1);
 Northing_diff (1:row,1) = Northing (:,1);
 Distance (1:row,1) = (Easting_diff.^2 + Northing_diff.^2).^0.5;
 
 % calculate the rotate degree (clockwise) 02/08/2023
 % first calculate the angle of the tree to the pivot in polar coordinate
 % Pivot to Tree is used as the South direction by total station
 
% rotate 74.884 degree clockwise 


% calculate the new angle in polar coordinate
 
Degree_true = atan (Northing_diff./Easting_diff) + 74.884/180*3.14159;

 Northing_diff_true (1:row,1) = Distance (1:row,1) .* sin (Degree_true) ;
 Easting_diff_true (1:row,1) = Distance (1:row,1) .* cos (Degree_true);

% Convert to true Easting and Northing  
 Easting_true (1:row,1) = PSM_Easting + Easting_diff_true;
 Northing_true (1:row,1) = PSM_Northing + Northing_diff_true;
 True (1:row,1) = Easting_true;
 True (1:row,2) = Northing_true;
% Output true Easting and Northing
% Effective digit 
 dlmwrite (['grid_true_May',num2str(i),'.csv'],True,'delimiter', ',', 'precision', 12);

% plot the elevation contour after rotation
  clear;

end

