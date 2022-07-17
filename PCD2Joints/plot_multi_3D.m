clear
% close all

% load data
% load stereoparams_ipad.mat
% load stereoParams_75deg_AC_all.mat
% load stereoParams_90deg_AD_all.mat
% rot=stereoParams.RotationOfCamera2;
% trans=stereoParams.TranslationOfCamera2/1000;
% trans=[0 0 0];

load"C:\Users\mitsuhiro\Documents\measure_sys\mat\camparam0928.mat"
% 近いほう（2.5ｍ）の写真を先に入力
trans1 = cameraParams.TranslationVectors(end-1,:)/1000
trans2 = cameraParams.TranslationVectors(end,:)/1000

% 原点が2.5mずれているため補正
trans2(3) = trans2(3) + 2.5;

% 軸の向きを補正 かつ原点が4.5cm浮いているため補正
trans1(1) = -trans1(1) - 0.045 ;
trans2(1) = -trans2(1) - 0.045 ;



rotv1 = cameraParams.RotationVectors(end-1,:);
rotv2 = cameraParams.RotationVectors(end,:);
rotv1(1) = -rotv1(1);
rotv2(1) = -rotv2(1);
rotv1(2) = -rotv1(2);
rotv2(2) = -rotv2(2);


rot1 = rotationVectorToMatrix(rotv1);
rot2 = rotationVectorToMatrix(rotv2);

% rot1 = cameraParams.RotationMatrices(:,:,end-1)
% rot2 = cameraParams.RotationMatrices(:,:,end)
% rot1=[1,0,0;0,1,0;0,0,1]
% rot2=[1,0,0;0,1,0;0,0,1]


%変換行列の作成
tform1 = rigid3d(rot1,trans1); % 近いほう
tform2 = rigid3d(rot2,trans2); % 遠いほう

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
save_name = "test0928";

% function plot3D_multi(save_name, side)
%     mat_name = "3Dposes_" + save_name +".mat";
%     load(mat_name)
%     poses_list = [];
    load("3Dposes_0928_1st.mat") % 前のカメラ
    poses3d_1 = poses3d;
    load("3Dposes_0928_2nd.mat") % 後ろのカメラ
    poses3d_2 = poses3d;
    
    % 同期したフレームの番号
    flash1 = 224;
    flash2 = 43;
    
    % 切り替わりフレームの指定（後ろのカメラの全身映った最初のフレーム）
    cam2_startframe = 30;
    
    
    frame_diff = flash1 - flash2;
    cam1_endframe = cam2_startframe + frame_diff; 
     
 
    v = VideoWriter('result_video\'+ save_name + '.avi');
    v.FrameRate = 60;
    open(v)
    
    % 前のカメラ

    for i = 1:cam1_endframe
        i

        color = linspace(1,10,25);
        try
            pt = pointCloud(poses3d_1(i).joint_position)
            pt = pctransform(pt, tform1);
            pcshow(pt,'MarkerSize',10)
%             scatter3(poses3d(i).joint_position(:,1), poses3d(i).joint_position(:,2), poses3d(i).joint_position(:,3), 30, color)
%         plot3(poses3d(i).joint_position(:,1), poses3d(i).joint_position(:,2), poses3d(i).joint_position(:,3), 30, color)
        catch
            % 空白のフレームを挟みたい
            disp("no data")
            continue
        end
        if side == 0
            xlim([-2.0 0.2])
            ylim([-0.5 1.5])
            zlim([-4.0 4.0])
            xlabel('x')
            ylabel('y')
            zlabel('z')
            campos([-2.0, 2, 4])
            camup([0 -1 0])
%             view([0 0 1]) % front
%             view([0 1 0]) % top
%             view([1 0 0]) % side

        elseif side == 1
            xlim([-1.0 1.5])
            ylim([-3.0 3.0])
            zlim([-4.5 0.5])
            xlabel('x')
            ylabel('y')
            zlabel('z')
            campos([2.0, 4.0, 0.0])
            camup([1 0 0])
        else 
            xlim([-1.0 1.5])
            ylim([-3.0 3.0])
            zlim([-4.5 0.5])
            xlabel('x')
            ylabel('y')
            zlabel('z')
%             campos([0.0, 3.0, -2.5])
%             camup([1 0 0])   
            view([0 1 0])
        end
            
%         view([0 0]) % [0 0]:xz平面（上から） [0 90]:xy平面（正面から）
        grid on
        drawnow limitrate

        frame = getframe(gcf);
        writeVideo(v, frame)

    end
    
    % 後ろのカメラ
    for i = cam2_startframe:size(poses3d,2)
        i

        color = linspace(1,10,25);
        try
            pt = pointCloud(poses3d_2(i).joint_position)
            pt = pctransform(pt, tform2);
            pcshow(pt,'MarkerSize',10)
        catch
            % 空白のフレームを挟みたい
            
            continue
        end
        if side == 0
            xlim([-2.0 0.2])
            ylim([-0.5 1.5])
            zlim([-4.0 4.0])
            xlabel('x')
            ylabel('y')
            zlabel('z')
            campos([-2.0, 2, 4])
            camup([0 -1 0])
%             view([0 0 1]) % front
%             view([0 1 0]) % top
%             view([1 0 0]) % side
        elseif side == 1
            xlim([-1.0 1.5])
            ylim([-3.0 3.0])
            zlim([-4.5 0.5])
            xlabel('x')
            ylabel('y')
            zlabel('z')
            campos([2.0, 4.0, 0.0])
            camup([1 0 0])
        else 
            xlim([-1.0 1.5])
            ylim([-3.0 3.0])
            zlim([-4.5 0.5])
            xlabel('x')
            ylabel('y')
            zlabel('z')
%             campos([0.0, 3.0, -2.5])
%             camup([1 0 0])   
            view([0 1 0])
        end
            
%         view([0 0]) % [0 0]:xz平面（上から） [0 90]:xy平面（正面から）
        grid on
        drawnow limitrate

        frame = getframe(gcf);
        writeVideo(v, frame)

    end

    close(v)
% end