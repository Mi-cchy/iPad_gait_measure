function depth_calc(PLY_file_dir, save_name, isFRONT)

    posefile_name = '.\matfile2D\poses_' +save_name + '.mat'
    load(posefile_name)
    load('imgsize.mat')
    load('openpose_map.mat')

    %{
    そのフレームに関節位置があるか調べる

    以下認識した関節がある時
    ・画像取り込んでサイズを調べる
    ・位置を比率で出す(0-1?)
    ・点群のminmaxから比率を求める
    ・点群の範囲を指定
    ・中央値からデプスをとる
    （回転させ平面をz=0にあわせる）
    ・3次元関節位置データとしてmatファイルに保存
    %}

    oldFolder = cd(PLY_file_dir)
    ply_list = dir('*.ply');
    
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

    for i = 1:length(ply_list)
        i
        if isempty(poses{1, i}) == 0
           % 関節データが含まれるのでplyを読み込む
            ptCloud = pcread(ply_list(i).name)
            ptCloud = pcdenoise(ptCloud);
            
            % ここから追加ーーーーーーーーーーーーーーーーーーーーー
%             rotv1 = [0.04 0 0.04];
%             rot1 = rotationVectorToMatrix(rotv1);
%             trans1 = [0 0 0];
%             tform1 = rigid3d(rot1,trans1);
            ptCloud = pctransform(ptCloud, tform1);
            % ここまでーーーーーーーーーーーーーーーーーーーーーーー
            
             % 床平面の除去
            maxDistance = 0.03;
            maxAngularDistance = 10;
            referenceVector = [0,1,0];
            [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
                        maxDistance,referenceVector,maxAngularDistance);
    %         plane1 = select(ptCloud,inlierIndices);
            ptCloud = select(ptCloud,outlierIndices);


            % ここまで
            
            ptCloudSize = [ptCloud.XLimits ptCloud.YLimits ptCloud.ZLimits];
            Xlength = ptCloudSize(2)-ptCloudSize(1);
            Ylength = ptCloudSize(4)-ptCloudSize(3);
            
            for k = 1:size(poses{1,i},1)
                for j = 1:25
                    if  poses{1, i}(k,j,1) ~= 0
                        x = poses{1, i}(k,j,1);
                        y = poses{1, i}(k,j,2);

                        X = ptCloudSize(1) + x/double(imgsize(i,2))*Xlength;
                        Y = ptCloudSize(4) - y/double(imgsize(i,1))*Ylength;

    %                   横向きで撮影時
    %                   X = ptCloudSize(2) - y/double(imgsize(i,1))*Xlength;
    %                   Y = ptCloudSize(4) - x/double(imgsize(i,2))*Ylength;

                        roi = [ X-0.01 X+0.01 Y-0.01 Y+0.01 -4 0 ];
                        indices = findPointsInROI(ptCloud,roi);
                        ptCloudB = select(ptCloud,indices);
                        % 対象領域のzの中央値をその点のz座標とする

                        poses3d{i,k}(j,1) = X;
                        poses3d{i,k}(j,2) = Y;
                        poses3d{i,k}(j,3) = median(ptCloudB.Location(:,3));
                    else
                        poses3d{i,k}(j,1) = NaN;
                        poses3d{i,k}(j,2) = NaN;
                        poses3d{i,k}(j,3) = NaN;
                    end
                end
                
                % ここで膝と足首の中間の位置を算出
                j = 26;
                if  poses{1, i}(k,11,1) ~= 0 && poses{1, i}(k,12,1) ~= 0
                    x_Rknee_ankle =  (poses{1, i}(k,11,1) + poses{1, i}(k,12,1)) / 2;
                    y_Rknee_ankle =  (poses{1, i}(k,11,2) + poses{1, i}(k,12,2)) / 2;
                    X = ptCloudSize(1) + x_Rknee_ankle/double(imgsize(i,2))*Xlength;
                    Y = ptCloudSize(4) - y_Rknee_ankle/double(imgsize(i,1))*Ylength;
                    
                    roi = [ X-0.01 X+0.01 Y-0.01 Y+0.01 -4 0 ];
                    indices = findPointsInROI(ptCloud,roi);
                    ptCloudB = select(ptCloud,indices);
                    % 対象領域のzの中央値をその点のz座標とする

                    poses3d{i,k}(j,1) = X;
                    poses3d{i,k}(j,2) = Y;
                    poses3d{i,k}(j,3) = median(ptCloudB.Location(:,3));
                else
                    poses3d{i,k}(j,1) = NaN;
                    poses3d{i,k}(j,2) = NaN;
                    poses3d{i,k}(j,3) = NaN;
                end
                j = 27;
                if  poses{1, i}(k,14,1) ~= 0 && poses{1, i}(k,15,1) ~= 0
                    x_Lknee_ankle =  (poses{1, i}(k,14,1) + poses{1, i}(k,15,1)) / 2;
                    y_Lknee_ankle =  (poses{1, i}(k,14,2) + poses{1, i}(k,15,2)) / 2;
                    X = ptCloudSize(1) + x_Lknee_ankle/double(imgsize(i,2))*Xlength;
                    Y = ptCloudSize(4) - y_Lknee_ankle/double(imgsize(i,1))*Ylength;
                    
                    roi = [ X-0.01 X+0.01 Y-0.01 Y+0.01 -4 0 ];
                    indices = findPointsInROI(ptCloud,roi);
                    ptCloudB = select(ptCloud,indices);
                    % 対象領域のzの中央値をその点のz座標とする

                    poses3d{i,k}(j,1) = X;
                    poses3d{i,k}(j,2) = Y;
                    poses3d{i,k}(j,3) = median(ptCloudB.Location(:,3));
                else
                    poses3d{i,k}(j,1) = NaN;
                    poses3d{i,k}(j,2) = NaN;
                    poses3d{i,k}(j,3) = NaN;
                end
                
            end
        end
    end

    cd(oldFolder)
    out_name = append(".\matfile3D\3Dposes_", save_name, ".mat");
    save(out_name,'poses3d')
end