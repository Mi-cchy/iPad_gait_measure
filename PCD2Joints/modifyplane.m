% clear

ptCloud = pcread("D:\KWAP_true_old\ipad\2021-10-30--11-41-53\PLY\0000200.ply")
ptCloud = pcdenoise(ptCloud)



% rotv1(1) = 0;
% rotv1(2) = -rotv1(2);
% rotv1(3) = 0;
% 
% rot1 = rotationVectorToMatrix(rotv1);
% tform1 = rigid3d(rot1,trans1);
% 
% ptCloud = pctransform(ptCloud, tform1);

% rotv1 = [0.20898 4.02171 -0.15374];
% rotv1 = [0.0518552, 0.997926, -0.0381482];

rotv1 = [0.04 0 0.04];
rot1 = rotationVectorToMatrix(rotv1);
trans1 = [0 0 0];
tform1 = rigid3d(rot1,trans1);
ptCloud = pctransform(ptCloud, tform1);


figure
pcshow(ptCloud)


% %% 座標変換
load("D:\KWAP_true_old\ipad\camparam1030.mat")
trans1 = cameraParams.TranslationVectors(end,:)/1000
trans1(1) = -trans1(1) - 0.045 ;
rotv1 = cameraParams.RotationVectors(end,:);
% rotv1(1) = -rotv1(1);
% rotv1(2) = -rotv1(2);
rotv1(1) = 0;
rotv1(2) = -rotv1(2);
rotv1(3) = 0;
rot1 = rotationVectorToMatrix(rotv1);
tform1 = rigid3d(rot1,trans1);

ptCloud = pctransform(ptCloud, tform1);

figure
pcshow(ptCloud)

maxDistance = 0.03;
maxAngularDistance = 10;
referenceVector = [0,1,0];
[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
            maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);
remain_ptCloud = select(ptCloud,outlierIndices);
pcshow(plane1);
figure
pcshow(remain_ptCloud);

% normals = pcnormals(plane1);


% 
% figure
% pcshow(plane1)
% title('Estimated Normals of Point Cloud')
% hold on
% x = plane1.Location(1:10:end,1);
% y = plane1.Location(1:10:end,2);
% z = plane1.Location(1:10:end,3);
% u = normals(1:10:end,1);
% v = normals(1:10:end,2);
% w = normals(1:10:end,3);
% quiver3(x,y,z,u,v,w);
% hold off
% 
% sensorCenter = [3.0,3.6,3.6]; 
% for k = 1 : numel(x)
%    p1 = sensorCenter - [x(k),y(k),z(k)];
%    p2 = [u(k),v(k),w(k)];
%    % Flip the normal vector if it is not pointing towards the sensor.
%    angle = atan2(norm(cross(p1,p2)),p1*p2');
%    if angle > pi/2 || angle < -pi/2
%        u(k) = -u(k);
%        v(k) = -v(k);
%        w(k) = -w(k);
%    end
% end
% 
% figure
% pcshow(plane1)
% title('Adjusted Normals of Point Cloud')
% hold on
% quiver3(x, y, z, u, v, w);
% hold off
