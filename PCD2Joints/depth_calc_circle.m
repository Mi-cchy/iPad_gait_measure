function depth_calc_circle(PLY_file_dir, save_name)

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
    i=100;
    k=1;
    j=11;
%     for i = 1:length(ply_list)
        i
        if isempty(poses{1, i}) == 0
           % 関節データが含まれるのでplyを読み込む
            ptCloud = pcread(ply_list(i).name)
            ptCloud = pcdenoise(ptCloud);
            
            ptCloudSize = [ptCloud.XLimits ptCloud.YLimits ptCloud.ZLimits];
            Xlength = ptCloudSize(2)-ptCloudSize(1);
            Ylength = ptCloudSize(4)-ptCloudSize(3);
            
%             for k = 1:size(poses{1,i},1)
%                 for j = 1:25
%                     if  poses{1, i}(k,j,1) ~= 0
                        x = poses{1, i}(k,j,1);
                        y = poses{1, i}(k,j,2);

                        X = ptCloudSize(1) + x/double(684)*Xlength;
                        Y = ptCloudSize(4) - y/double(518)*Ylength;

    %                   横向きで撮影時
    %                   X = ptCloudSize(2) - y/double(imgsize(i,1))*Xlength;
    %                   Y = ptCloudSize(4) - x/double(imgsize(i,2))*Ylength;




                        roi = [ X-0.1 X+0.1 Y-0.01 Y+0.01 -4 0 ];
                        indices = findPointsInROI(ptCloud,roi);
                        ptCloudB = select(ptCloud,indices)
%                         pcshow(ptCloudB);
                        
                        % 対象領域のzの中央値をその点のz座標とする

%                         poses3d{i,k}(j,1) = X;
%                         poses3d{i,k}(j,2) = Y;
%                         poses3d{i,k}(j,3) = median(ptCloudB.Location(:,3));
%                     else
%                         poses3d{i,k}(j,1) = NaN;
%                         poses3d{i,k}(j,2) = NaN;
%                         poses3d{i,k}(j,3) = NaN;
%                     end
%                 end
%                 
%             end
        end
%     end
    figure
    pcshow(ptCloud)
    hold on
    pcshow(ptCloudB.Location,'r');
    legend('Point Cloud','Points within the ROI','Location','southoutside','Color',[1 1 1])
    hold off
    
    figure(2)
    pcshow(ptCloudB.Location, 'r')

    cd(oldFolder)
%     out_name = append(".\matfile3D\3Dposes_", save_name, ".mat");
%     save(out_name,'poses3d')
end