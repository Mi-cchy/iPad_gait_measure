% 参考　https://jp.mathworks.com/help/vision/lidar-and-point-cloud-processing.html?s_tid=CRUX_lftnav

% PLYファイルの読み込み（点群取得）

function make_XYpic(PLY_file_dir, isFRONT) 

    oldFolder = cd(PLY_file_dir)
    mkdir png_datas
    list = dir('*.ply')
    % disp(list(1))
    
    load("D:\KWAP_true_old\ipad\camparam1030.mat")
    rotv1 = cameraParams.RotationVectors(end,:);
    if isFRONT == 1
        rotv1(2) = -rotv1(2);
    else
        rotv1(2) = 0;
    end
    rotv1 = [0.04 rotv1(2) 0.04];
    rot1 = rotationVectorToMatrix(rotv1);
    trans1 = [0 0 0];
    tform1 = rigid3d(rot1,trans1);
        
    for i = 1:length(list)
        i
        [filepath,name,ext] = fileparts(list(i).name);
        ptCloud = pcread(list(i).name);
        ptCloud = pcdenoise(ptCloud);
        
        % 以下10/30白ipad用のパラメータ
        % %% 座標変換
%         load("D:\KWAP_true_old\ipad\camparam1030.mat")
% %         trans1 = cameraParams.TranslationVectors(end,:)/1000
% %         trans1(1) = -trans1(1) - 0.045 ;
%         rotv1 = cameraParams.RotationVectors(end,:);
% %         % rotv1(1) = -rotv1(1);
%         rotv1(2) = -rotv1(2);
% 
% 
%         rotv1(1) = 0;
%         rotv1(2) = -rotv1(2);
%         rotv1(3) = 0;
% 
%         rot1 = rotationVectorToMatrix(rotv1);
%         tform1 = rigid3d(rot1,trans1);
% 
%         ptCloud = pctransform(ptCloud, tform1);

        % rotv1 = [0.20898 4.02171 -0.15374];
        % rotv1 = [0.0518552, 0.997926, -0.0381482];

        ptCloud = pctransform(ptCloud, tform1);
        
        % 床平面の除去
        maxDistance = 0.03;
        maxAngularDistance = 10;
        referenceVector = [0,1,0];
        [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
                    maxDistance,referenceVector,maxAngularDistance);
%         plane1 = select(ptCloud,inlierIndices);
        ptCloud = select(ptCloud,outlierIndices);


        % ここまで
        
        
        pcshow(ptCloud);
        % 表示方向の設定
        axis off
        % ipad縦向き測定時
        view(0,90)
%         % ipad横向き測定時
%         view(-90,90)
        
        % 画像データとして保存
        % saveas(gcf,"img1000.png")
        exportgraphics(gcf,"png_datas\" + name + ".png")
    end

    cd(oldFolder)
    
end