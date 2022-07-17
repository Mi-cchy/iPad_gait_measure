clear
% close all

% load data
% load stereoparams_ipad.mat
% load stereoParams_75deg_AC_all.mat
% load stereoParams_90deg_AD_all.mat
% rot=stereoParams.RotationOfCamera2;
% trans=stereoParams.TranslationOfCamera2/1000;
% trans=[0 0 0];

% load 0927_camparam.mat
load camparam\camparamTUG1008.mat
% コーン（前額面）の写真を先に入力
trans1 = cameraParams.TranslationVectors(end-1,:)/1000
trans2 = cameraParams.TranslationVectors(end,:)/1000

% 原点が2.5mずれているため補正
trans1(3) = trans1(3) + 2.5;
 
% trans1(2) = -trans1(2)
% trans2(2) = -trans2(2)

% 軸の向きを補正 かつ原点が4.5cm浮いているため補正
% trans1(1) = -trans1(1);
% trans2(1) = -trans2(1);

trans1(2) = -trans1(2)-0.045;
trans2(2) = -trans2(2)-0.045;
% trans1(1) = -trans1(1);
% trans2(1) = -trans2(1);




rotv1 = cameraParams.RotationVectors(end-1,:)
rotv2 = cameraParams.RotationVectors(end,:)
% rotv1(1) = -rotv1(1)
% rotv2(1) = -rotv2(1)
% rotv1(2) = -rotv1(2)
% rotv2(2) = -rotv2(2)

rotv1(1) = -rotv1(1)
rotv2(1) = -rotv2(1)
% rotv1(2) = -rotv1(2)
% rotv2(2) = -rotv2(2)



rotv2(1) = rotv2(1)

rot1 = rotationVectorToMatrix(rotv1)
rot2 = rotationVectorToMatrix(rotv2)

axang = [1 0 0 pi/2];
% axang = [1 0 0 0];


tform_a = rigid3d(axang2tform(axang))




% rot1 = cameraParams.RotationMatrices(:,:,end-1)
% rot2 = cameraParams.RotationMatrices(:,:,end)
% rot1=[1,0,0;0,1,0;0,0,1]
% rot2=[1,0,0;0,1,0;0,0,1]


%変換行列の作成
tform1 = rigid3d(rot1,trans1); % 近いほう
tform2 = rigid3d(rot2,trans2); % 遠いほう

tform_a
%フレーム数
s_num = 1;
e_num = 1;

% rot&trans
oldFolder = cd("C:\Users\mitsuhiro\Documents\cal\TUG_calib")
% pcdFolderInfo = dir('*.pcd');
% data_num = size(pcdFolderInfo,1);
pt{1} = pcread("0000000.ply");
pt{1} = pctransform(pt{1},tform1);

% for num=s_num:e_num
%     i=num2str(sprintf('%07.0f', num-1));
%     filename=strcat(i,'.ply');
% %     ptA{1,num} = pcread(filename);
%     pt{1,num} = pcread(filename);
%     pt{1,num} = pctransform(pt{1,num},tform1);
% end
% 
% cd ../../2021-03-02.13-34-28.B\pcd
% pcdFolderInfo = dir('*.pcd');
% data_num = size(pcdFolderInfo,1);
% 
% for num=s_num:e_num
%     i=num2str(sprintf('%05.0f', num-1));
%     filename=strcat(i,'.pcd');
% %     ptB{1,num} = pcread(filename);
%     pt{2,num} = pcread(filename);
%     pt{2,num} = pctransform(pt{2,num},Btform);
%     pt{2,num} = pctransform(pt{2,num},Btform2);
% end

% cd("D:\ipad_data\[01]KAWP\2021_1002\calib\black_2021-10-02--10-44-05\PLY")
% cd ../../2021-09-07.17-31-20.C\pcd
% cd ../../2021-09-07.17-31-10.D\pcd
% pcdFolderInfo = dir('*.pcd');
% data_num = size(pcdFolderInfo,1);
pt{2} = pcread("chair.ply");
pt{2} = pctransform(pt{2},tform2);
pt{2} = pctransform(pt{2},tform_a);


% for num=s_num:e_num
%     i=num2str(sprintf('%07.0f', num-1));
%     filename=strcat(i,'.ply');
%     pt{3,num} = pcread(filename);
%     pt{3,num} = pctransform(pt{3,num},tform2);
% end

cd(oldFolder)

fig=1;
% for num=1:data_num


figure
grid;
for k=1:2
    pcshow(pt{k});
    set(gcf,'color','w');
    set(gca,'color','w');
%         view([-90 0]);
%        xlim([-1.0 1.0]);
%         xticks([-1.2 -1.0 -0.5 0 0.5 1.0 1.2]);
    xlabel('x');
%         ylim([-1.0 1.0]); 
%         yticks([-1.0 -0.5 0 0.5 1.0]); 
    ylabel('y');
%         zlim([-1.0 1.0]); 
%         zticks([0 0.5 1.0 1.5 2.0]); 
    zlabel('z');
    %     pause
    hold on
end
% for num=s_num:e_num
% 
%     
% end

hold off


% figure
% grid;
% for num=s_num:e_num
% 
%     for k=1:2:3
%         pcshow(pt{k,num});
%         set(gcf,'color','w');
%         set(gca,'color','w');
% %         view([-90 0]);
% %        xlim([-1.0 1.0]);
% %         xticks([-1.2 -1.0 -0.5 0 0.5 1.0 1.2]);
%         xlabel('x');
% %         ylim([-1.0 1.0]); 
% %         yticks([-1.0 -0.5 0 0.5 1.0]); 
%         ylabel('y');
%         zlim([1.0 2.6]); 
% %         zticks([0 0.5 1.0 1.5 2.0]); 
%         zlabel('z');
%         %     pause
%         hold on
%     end
% end
% 
% hold off

% Rot
function [rot] = ...
    Rotation(A, B, C)

rot=[cos(B)*cos(C), sin(A)*sin(B)*cos(C)-cos(A)*sin(C), cos(A)*sin(B)*cos(C)+sin(A)*sin(C);...
    cos(B)*sin(C), sin(A)*sin(B)*sin(C)+cos(A)*cos(C), cos(A)*sin(B)*sin(C)-sin(A)*cos(C);...
    -sin(B), sin(A)*cos(B), cos(A)*cos(B)];
end