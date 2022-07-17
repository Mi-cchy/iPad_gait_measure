% 点群表示するだけのコード
% 
%% 座標変換
% load("D:\KWAP_true_old\ipad\camparam1030.mat")
% trans1 = cameraParams.TranslationVectors(end,:)/1000
% trans1(1) = -trans1(1) - 0.045 ;
% rotv1 = cameraParams.RotationVectors(end,:);
% rotv1(1) = -rotv1(1);
% rotv1(2) = -rotv1(2);
% 
% rot1 = rotationVectorToMatrix(rotv1);
% tform1 = rigid3d(rot1,trans1);

load("D:\KWAP_true_old\ipad\camparam1030.mat")
rotv1 = cameraParams.RotationVectors(end,:);
rotv1(2) = -rotv1(2)
rotv1 = [0.04 rotv1(2) 0.04];
rot1 = rotationVectorToMatrix(rotv1);
trans1 = [0 0 0];
tform1 = rigid3d(rot1,trans1);
         
% 

%% 点群の表示
% ptCloud = pcread("D:\KWAP_true_old\ipad_exceptplane\2021-10-30--14-00-21\PLY\0000173.ply")
% ptCloud = pcread("D:\ipad_data\0927\black\PLY\0000001.ply")
ptCloud = pcread("D:\KWAP_true_old\ipad\2021-10-30--14-55-47\PLY\0000153.ply")
ptCloud = pcdenoise(ptCloud)

% view(0,90)
% pcshow(ptCloud)
% ptCloud = pctransform(ptCloud, tform1);
pcshow(ptCloud)

figure;
maxDistance = 0.03;
maxAngularDistance = 5;
referenceVector = [0,1,0];
[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
            maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);
ptCloud = select(ptCloud,outlierIndices);
% pcshow(plane1);
% figure
pcshow(ptCloud);
view(0,90)
% campos([-1.0, 2, 3])
% camup([0.20898 4.02171 -0.15374])