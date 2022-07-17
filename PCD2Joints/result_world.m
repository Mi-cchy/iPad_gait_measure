clear
% close all

% load data
% load stereoparams_ipad.mat
% load stereoParams_75deg_AC_all.mat
% load stereoParams_90deg_AD_all.mat
% rot=stereoParams.RotationOfCamera2;
% trans=stereoParams.TranslationOfCamera2/1000;
% trans=[0 0 0];

load("D:\ipad_data\[00]VICON_sync\camparam_single.mat")
% 近いほう（2.5ｍ）の写真を先に入力
trans1 = cameraParams.TranslationVectors(end,:)/1000
% trans2 = cameraParams.TranslationVectors(end,:)/1000

% 原点が2.5mずれているため補正
% trans2(3) = trans2(3) + 2.5;

% 軸の向きを補正 かつ原点が4.5cm浮いているため補正
trans1(1) = -trans1(1) - 0.045 ;
% trans2(1) = -trans2(1) - 0.045 ;



rotv1 = cameraParams.RotationVectors(end,:);
% rotv2 = cameraParams.RotationVectors(end,:);
rotv1(1) = -rotv1(1);
% rotv2(1) = -rotv2(1);
rotv1(2) = -rotv1(2);
% rotv2(2) = -rotv2(2);


rot1 = rotationVectorToMatrix(rotv1);
% rot2 = rotationVectorToMatrix(rotv2);

% rot1 = cameraParams.RotationMatrices(:,:,end-1)
% rot2 = cameraParams.RotationMatrices(:,:,end)
% rot1=[1,0,0;0,1,0;0,0,1]
% rot2=[1,0,0;0,1,0;0,0,1]


%変換行列の作成
tform1 = rigid3d(rot1,trans1); % 近いほう
% tform2 = rigid3d(rot2,trans2); % 遠いほう

% 3次元データの座標変換

% 
% %フレーム数
% s_num = 1;
% e_num = 1;
% 
% % rot&trans
% oldFolder = cd("D:\ipad_data\0927\black")
% % pcdFolderInfo = dir('*.pcd');
% % data_num = size(pcdFolderInfo,1);
% 
% for num=s_num:e_num
%     i=num2str(sprintf('%07.0f', num-1));
%     filename=strcat(i,'.ply');
% %     ptA{1,num} = pcread(filename);
%     pt{1,num} = pcread(filename);
%     pt{1,num} = pctransform(pt{1,num},tform1);
% end
% 
% cd("D:\ipad_data\0927\silver")
% 
% for num=s_num:e_num
%     i=num2str(sprintf('%07.0f', num-1));
%     filename=strcat(i,'.ply');
%     pt{3,num} = pcread(filename);
%     pt{3,num} = pctransform(pt{3,num},tform2);
% end
% 
% cd(oldFolder)
% 
% fig=1;
% % for num=1:data_num
% 
% 
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
% %         zlim([-1.0 1.0]); 
% %         zticks([0 0.5 1.0 1.5 2.0]); 
%         zlabel('z');
%         %     pause
%         hold on
%     end
% end
% 
% hold off
% 

% % Rot
% function [rot] = ...
%     Rotation(A, B, C)
% 
% rot=[cos(B)*cos(C), sin(A)*sin(B)*cos(C)-cos(A)*sin(C), cos(A)*sin(B)*cos(C)+sin(A)*sin(C);...
%     cos(B)*sin(C), sin(A)*sin(B)*sin(C)+cos(A)*cos(C), cos(A)*sin(B)*sin(C)-sin(A)*cos(C);...
%     -sin(B), sin(A)*cos(B), cos(A)*cos(B)];
% end

side = 0;
save_name = "single_1008_LKNEE";

% function plot3D_multi(save_name, side)
%     mat_name = "3Dposes_" + save_name +".mat";
%     load(mat_name)
%     poses_list = [];
    load("matfile3D\3Dposes_[00]VICON_sync_2021-10-08--18-00-39.mat") % 前のカメラ
%     poses3d_1 = poses3d;
    
  

    for i = 1:size(poses3d,1)
        i
%         color = linspace(1,10,25);
        try
            pt = pointCloud(poses3d{i,1})
            pt = pctransform(pt, tform1);
            Wposes{i,1} = pt.Location
            WVposes(i,1) =  pt.Location(12,2)*1000; % RHip
            WVposes(i,2) = -pt.Location(12,3)*1000;
            WVposes(i,3) = -pt.Location(12,1)*1000;
            WVposes(i,4) =  pt.Location(15,2)*1000; % LHip
            WVposes(i,5) = -pt.Location(15,3)*1000;
            WVposes(i,6) = -pt.Location(15,1)*1000;
            
            
       
            if isempty(poses3d{i,2}) == 0
                pt = pointCloud(poses3d_1{i,1})
                pt = pctransform(pt, tform1);
                Wposes{i,2} = pt.Location            
            end

        catch
            % 空白のフレームを挟みたい
            continue
        end

    end
    
    out_name = append(".\Wposes\WVposes_", save_name, ".mat");
    save(out_name,'WVposes')
    

