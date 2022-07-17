clear

load("D:\KWAP_true_old\ipad_camfront\camparam1030.mat")
% 近いほう（2.5ｍ）の写真を先に入力
trans1 = cameraParams.TranslationVectors(end,:)/1000
% trans2 = cameraParams.TranslationVectors(end,:)/1000

% 原点が2.5mずれているため補正
% trans2(3) = trans2(3) + 2.5;

% 軸の向きを補正 かつ原点が4.5cm浮いているため補正
trans1(1) = -trans1(1) - 0.045 ;
% trans2(1) = -trans2(1) - 0.045 ;

rotv1 = cameraParams.RotationVectors(end,:);

rotv1(1) = 0;
rotv1(2) = -rotv1(2);
rotv1(3) = 0;
rot1 = rotationVectorToMatrix(rotv1);
tform1 = rigid3d(rot1,trans1);


side = 0;
save_name = "1030_roujin1";

% function plot3D_multi(save_name, side)
%     mat_name = "3Dposes_" + save_name +".mat";
%     load(mat_name)
%     poses_list = [];
    load("C:\Users\mitsuhiro\Documents\measuresys_multiperson\matfile3D\3Dposes_ipad_camfront_2021-10-30--12-04-16.mat") % 前のカメラ
%     poses3d_1 = poses3d;
    
  

    for i = 1:size(poses3d,1)
        i
%         color = linspace(1,10,25);
        try
            pt = pointCloud(poses3d{i,1});
            pt = pctransform(pt, tform1);
            Wposes{i,1} = pt.Location;
%             WVposes(i,1) =  pt.Location(12,2)*1000; % RHip
%             WVposes(i,2) = -pt.Location(12,3)*1000;
%             WVposes(i,3) = -pt.Location(12,1)*1000;
%             WVposes(i,4) =  pt.Location(15,2)*1000; % LHip
%             WVposes(i,5) = -pt.Location(15,3)*1000;
%             WVposes(i,6) = -pt.Location(15,1)*1000;
            
            
       
            if isempty(poses3d{i,2}) == 0
                pt = pointCloud(poses3d{i,2})
                pt = pctransform(pt, tform1);
                Wposes{i,2} = pt.Location            
            end

        catch
            % 空白のフレームを挟みたい
            continue
        end

    end
    
    out_name = append(".\Wposes\Wposes_", save_name, ".mat");
    save(out_name,'Wposes')
    
%% 一人に絞る
for i = 1:size(Wposes,1)  
    if isempty(Wposes{i,2})
        Oposes{i,1} = Wposes{i,1}
    else
        if isnan(Wposes{i,2}(10,1))
            Oposes{i,1} = Wposes{i,1}
        elseif isnan(Wposes{i,1}(10,1))
            Oposes{i,1} = Wposes{i,2}
        elseif Wposes{i,1}(10,1) < Wposes{i,2}(10,1) % 被験者が左
            Oposes{i,1} = Wposes{i,1}
        else 
            Oposes{i,1} = Wposes{i,2}
        end
    end
end

%% 左右逆転の防止
joints_No = [10 11 12 13 14 15]; % Rhip, Knee, Ankle, LHip, Knee, Ankle

for i = 1:size(Oposes,1)
    if Oposes{i,1}(10,1) > Oposes{i,1}(13,1) % 右足が右（左右反転）の時
        RL(1,:) = Oposes{i,1}(13,:);
        RL(2,:) = Oposes{i,1}(14,:);
        RL(3,:) = Oposes{i,1}(15,:);
        RL(4,:) = Oposes{i,1}(10,:);
        RL(5,:) = Oposes{i,1}(11,:);
        RL(6,:) = Oposes{i,1}(12,:);
        for j = 1:size(joints_No,2)
            j
            Oposes{i,1}(joints_No(j),:) = RL(j,:);
        end
        
    end               
        
end


%% 各関節ごとに時系列でまとめる
joints_No = [10 11 12 13 14 15]; % Rhip, Knee, Ankle, LHip, Knee, Ankle
for i = 1:size(Oposes,1)
    for j = 1:size(joints_No,2)
        try
%             Joints(i,j*3-2) =  Oposes{i,1}(joints_No(j),2);
%             Joints(i,j*3-1) = -Oposes{i,1}(joints_No(j),3);
%             Joints(i,j*3  ) = -Oposes{i,1}(joints_No(j),1);
            Joints(i,j*3-2) = Oposes{i,1}(joints_No(j),3);
            Joints(i,j*3-1) = Oposes{i,1}(joints_No(j),1);
            Joints(i,j*3  ) = Oposes{i,1}(joints_No(j),2);
        catch
            
        end
    end
end

for i = 1:4
    try
        if
        Joints(:,(6+i)*3-2) = Joints(:,i*(3+-2);
        Joints(:,(6+i)*3-1) = Oposes{i,1}(joints_No(j),1);
        Joints(:,(6+i)*3  ) = Oposes{i,1}(joints_No(j),2);        
    catch

    end
end    

%% 接地離地データ読み込み
% roujin1
% R_on = [5.88 6.91];
% R_off = [6.57 7.59];
% L_on = [5.33 6.4 7.47];
% L_off = [6.07 7.05 8.15];
% 
% PLY_start = 8.0;
% GaitRite_start = 3.647;

% roujin2
R_on = [6.51 7.77 8.95 10.14];
R_off = [7.4 8.59 9.73 11.11];
L_on = [7.11 8.38 9.5];
L_off = [8.02 9.16 10.42];

PLY_start = 8.0;
GaitRite_start = 2.568;

time_bias = GaitRite_start - PLY_start;

R_on = R_on + time_bias
R_off = R_off + time_bias
L_on = L_on + time_bias
L_off = L_off + time_bias

%% 書式
% GUIのフォント
set(0, 'defaultUicontrolFontName','Times New Roman' );%'MS UI Gothic'
% 軸のフォント
set(0, 'defaultAxesFontName','Times New Roman');
% タイトル、注釈などのフォント
set(0, 'defaultTextFontName','Times New Roman');
% % GUIのフォントサイズ
% set(0, 'defaultUicontrolFontSize', 9);
% % 軸のフォントサイズ
% set(0, 'defaultAxesFontSize', 9);%10
% % タイトル、注釈などのフォントサイズ
% set(0, 'defaultTextFontSize', 9);
% ラインの太さ
set(0, 'defaultlineLineWidth', 1);
% GUIのフォントサイズ
set(0, 'defaultUicontrolFontSize', 20);
% 軸のフォントサイズ
set(0, 'defaultAxesFontSize', 20);%10
% タイトル、注釈などのフォントサイズ
set(0, 'defaultTextFontSize', 20);


%% グラフ書く

for i = 1:6
    f = figure(i);
    % 背景色
    set(gcf, 'Color', 'none')
%     f.Position = [100 100 300 300]
%     M_ipad = [sheet{i,1}{:,7}, -(sheet{i,1}{:,10}-ipad_bias(2)), sheet{i,1}{:,9}-ipad_bias(1), sheet{i,1}{:,11}-ipad_bias(3)];
    t = 0:0.016666:(size(poses3d,1)-1)*0.016666;
    plot(t,Joints(:,i*3-2),t,Joints(:,i*3-1),t,Joints(:,i*3));
    
    h1 = xline(R_on, '-r', 'R-on');
    h2 = xline(R_off, '--r', 'R-off');
    h3 = xline(L_on, '-b', 'L-on');
    h4 = xline(L_off, '--b', 'L-off');
    
%     xline(R_on, '-r', 'DisplayName', 'R-on')
%     xline(R_off, '--r', 'DisplayName', 'R-off')
%     xline(L_on, '-b', 'DisplayName', 'L-on')
%     xline(L_off, '--b', 'DisplayName', 'L-off')
    xlabel('time [s]') 
    ylabel('position [m]') 
    
    legend("X","Y","Z",'Location','southeast')
    
    sheet_name = ["Rhip","Rknee","Rankle","Lhip","Lknee","Lankle"];
    saveas(gcf,sheet_name(i),'svg')
    hold off
end

%% 関節の差分
