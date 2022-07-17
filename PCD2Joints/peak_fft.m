clear
clf('reset')

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


matfile_folder =  dir("D:\KWAP_true_old\matfile_3dposition\*.mat");

%% 変更するところ

for id = 1:9
    clf
    id
    clearvars -except matfile_folder id tform1 freqmax cycle_time;
    save_name = "FFT_1030_roujin" + id + "_front_plane";
    mkdir("graph\withoutplane\"+ save_name)

    matfile_name = matfile_folder(id).folder +"\" + matfile_folder(id).name;
    load(matfile_name); 
    % load("C:\Users\mitsuhiro\Documents\measuresys_multiperson\matfile3D\3Dposes_ipad_2021-10-30--14-55-47.mat")
    sheet = readtable("D:\KWAP_true_old\GaitRite\sensor-20211030-roujin" + id + ".xls");

    %% ここからグラフの描画

        for i = 1:size(poses3d,1)
            i
    %         color = linspace(1,10,25);
            try
                pt = pointCloud(poses3d{i,1});
    %             pt = pctransform(pt, tform1);
                Wposes{i,1} = pt.Location;        

                if isempty(poses3d{i,2}) == 0
                    pt = pointCloud(poses3d{i,2})
    %                 pt = pctransform(pt, tform1);
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
    joints_No = [10 11 12 13 14 15 9]; % Rhip, Knee, Ankle, LHip, Knee, Ankle, MidHip 

    for i = 1:size(Oposes,1)
        if isempty(Oposes{i,1}) == 0 && Oposes{i,1}(10,1) > Oposes{i,1}(13,1) % 右足が右（左右反転）の時
            RL(1,:) = Oposes{i,1}(13,:);
            RL(2,:) = Oposes{i,1}(14,:);
            RL(3,:) = Oposes{i,1}(15,:);
            RL(4,:) = Oposes{i,1}(10,:);
            RL(5,:) = Oposes{i,1}(11,:);
            RL(6,:) = Oposes{i,1}(12,:);
            RL(7,:) = Oposes{i,1}(9,:);
            for j = 1:size(joints_No,2)
                Oposes{i,1}(joints_No(j),:) = RL(j,:);
            end

        end               

    end


    %% 各関節ごとに時系列でまとめる
    joints_No = [10 11 12 13 14 15 9]; % Rhip, Knee, Ankle, LHip, Knee, Ankle, MidHip
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



    %% 接地離地データ読み込み

    L_on  = table2array(rmmissing(sheet(:,2)));
    L_off = table2array(rmmissing(sheet(:,3)));
    R_on  = table2array(rmmissing(sheet(:,4)));
    R_off = table2array(rmmissing(sheet(:,5)));

    PLY_start_list = [8 8 8 12 8 7 8 9 10];
    GaitRite_start_list = [3.647 2.568 3.129 2.482 2.355 3.014 2.582 2.391 3.206];

    PLY_start = PLY_start_list(id);
    GaitRite_start = GaitRite_start_list(id);

    % % roujin1
    % R_on = [5.88 6.91];
    % R_off = [6.57 7.59];
    % L_on = [5.33 6.4 7.47];
    % L_off = [6.07 7.05 8.15];
    % 
    % PLY_start = 8.0;
    % GaitRite_start = 3.647;

    % % roujin2
    % R_on = [6.51 7.77 8.95 10.14];
    % R_off = [7.4 8.59 9.73 11.11];
    % L_on = [7.11 8.38 9.5];
    % L_off = [8.02 9.16 10.42];
    % 
    % PLY_start = 8.0;
    % GaitRite_start = 2.568;

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

    %% filterの設計

    % x = Joint_diff(:,16);
    fc = 5; % カットオフ周波数
    Fs = 60; % サンプリング周波数
    Wn = fc/(Fs/2);
    [b,a] = butter(4,Wn,'low'); % 4次

    %% グラフ書く

    for i = 1:7
        f = figure(i);
        % 背景色
        set(gcf, 'Color', 'none')
    %     f.Position = [100 100 300 300]
    %     M_ipad = [sheet{i,1}{:,7}, -(sheet{i,1}{:,10}-ipad_bias(2)), sheet{i,1}{:,9}-ipad_bias(1), sheet{i,1}{:,11}-ipad_bias(3)];
        t = 0:0.016666:(size(poses3d,1)-1)*0.016666;
    %     y1 = filter(b,a,fillmissing(Joints(:,i*3-2),'linear'));
    %     y2 = filter(b,a,fillmissing(Joints(:,i*3-1),'linear'));
    %     y3 = filter(b,a,fillmissing(Joints(:,i*3  ),'linear'));

        % filtfilt:ゼロ位相フィルタ, fillmissing:欠損値の補完

        f_Joints(:,i*3-2) = filtfilt(b,a,double(fillmissing(Joints(:,i*3-2),'linear')));
        f_Joints(:,i*3-1) = filtfilt(b,a,double(fillmissing(Joints(:,i*3-1),'linear')));
        f_Joints(:,i*3  ) = filtfilt(b,a,double(fillmissing(Joints(:,i*3  ),'linear')));

    %     plot(t,Joints(:,i*3-2),t,Joints(:,i*3-1),t,Joints(:,i*3), t, f_Joints(:,i*3-2), t, f_Joints(:,i*3-1), t, f_Joints(:,i*3-1));
%         plot(t, f_Joints(:,i*3-2), t, f_Joints(:,i*3-1), t, f_Joints(:,i*3 ));
%         findpeaks(f_Joints(:,i*3-2), t);
        fs = 60
        
       
%         plot(t, f_Joints(:,i*3-2), t, f_Joints(:,i*3-1), t, f_Joints(:,i*3 ));
        


        y = fft(f_Joints(:,i*3-2)); 
        n = length(f_Joints(:,i*3-2));          % number of samples
        f = (0:n-1)*(fs/n);     % frequency range
        power = abs(y).^2/n;    % power of the DFT

        plot(f,power)
        xlabel('Frequency')
        ylabel('Power')
        


%         h1 = xline(R_on, '-r', 'R-on');
%         h2 = xline(R_off, '--r', 'R-off');
%         h3 = xline(L_on, '-b', 'L-on');
%         h4 = xline(L_off, '--b', 'L-off');
% 
%         xlabel('time [s]') 
%         ylabel('position [m]') 
% 
%         legend("X","Y","Z",'Location','southeast')

        sheet_name = ["Rhip","Rknee","Rankle","Lhip","Lknee","Lankle","Mid_Hip"];
        filename = "graph\withoutplane\" + save_name + "\" + sheet_name(i);
        saveas(gcf,filename,'svg')
        hold off
    end



    %% 関節の差分
    for i = 1:6
        try            
            Joint_diff(:,i*3-2) = f_Joints(:,i*3-2)-f_Joints(:,19);
            Joint_diff(:,i*3-1) = f_Joints(:,i*3-1)-f_Joints(:,20);
            Joint_diff(:,i*3  ) = f_Joints(:,i*3  )-f_Joints(:,21);       
        catch

        end
    end    

    for i = 1:6
        f = figure(i+7);
        
        % 背景色
        set(gcf, 'Color', 'none')
    %     f.Position = [100 100 300 300]
    %     M_ipad = [sheet{i,1}{:,7}, -(sheet{i,1}{:,10}-ipad_bias(2)), sheet{i,1}{:,9}-ipad_bias(1), sheet{i,1}{:,11}-ipad_bias(3)];
        t = 0:0.016666:(size(poses3d,1)-1)*0.016666;
        
        [pks_p,locs_p] = findpeaks(Joint_diff(:,i*3-2), t,  'MinPeakDistance',0.5);
        [pks_n,locs_n] = findpeaks(-Joint_diff(:,i*3-2), t, 'MinPeakDistance',0.5);

        %         findpeaks(Joint_diff(:,i*3-2), t,'MinPeakDistance',0.5);
         
        y = fft(Joint_diff(:,i*3-2)); 
        n = length(Joint_diff(:,i*3-2));          % number of samples
        
        f = (0:n-1)*(fs/n);     % frequency range
        power = abs(y).^2/n;    % power of the DFT
        plot(f,power)
        xlim([0,10]);
        xlabel('Frequency')
        ylabel('Power')

        [pks,locs] = findpeaks(power,f, 'SortStr','descend');
        for loc = 1:size(locs,2)
            if locs(loc)> 0.2 && locs(loc) < 5
                freqmax{id,i} = locs(loc);
                cycle_time{id,i} = 1/locs(loc);
                break;
            end
        end
        
        
%         plot(t, Joint_diff(:,i*3-2))
%         hold on
%         plot(locs_p,pks_p,'rv','MarkerFaceColor','r');
%         plot(locs_n,-pks_n,'rv','MarkerFaceColor','b');
% 
%         h1 = xline(R_on, '-r', 'R-on');
%         h2 = xline(R_off, '--r', 'R-off');
%         h3 = xline(L_on, '-b', 'L-on');
%         h4 = xline(L_off, '--b', 'L-off');
% 
%     %     xline(R_on, '-r', 'DisplayName', 'R-on')
%     %     xline(R_off, '--r', 'DisplayName', 'R-off')
%     %     xline(L_on, '-b', 'DisplayName', 'L-on')
%     %     xline(L_off, '--b', 'DisplayName', 'L-off')
%         xlabel('time [s]') 
%         ylabel('position [m]') 
% 
%         legend("X","Y","Z",'Location','southeast')
% 
%         sheet_name = ["diff_Rhip","diff_Rknee","diff_Rankle","diff_Lhip","diff_Lknee","diff_Lankle"];
% 
%         filename = "graph\withoutplane\" + save_name + "\" + sheet_name(i);
%         saveas(gcf,filename,'svg')
%         hold off
    end

    %% 両ひざの差分

    try            
        knee_diff(:,1) = f_Joints(:,4)-f_Joints(:,13);
        knee_diff(:,2) = f_Joints(:,5)-f_Joints(:,14);
        knee_diff(:,3) = f_Joints(:,6)-f_Joints(:,15);       
    catch

    end

    figure(14);
    hold on;    
     % 背景色
    set(gcf, 'Color', 'none')
    
    t = 0:0.016666:(size(poses3d,1)-1)*0.016666;
    plot(t,knee_diff(:,1));
    
    [pks_p,locs_p] = findpeaks( knee_diff(:,1), t, 'MinPeakDistance',0.5);
    [pks_n,locs_n] = findpeaks(-knee_diff(:,1), t, 'MinPeakDistance',0.5);
    plot(locs_p, pks_p,'rv','MarkerFaceColor','r');
    plot(locs_n,-pks_n,'rs','MarkerFaceColor','r');
    
    fc = 1.8; % カットオフ周波数
    Fs = 60; % サンプリング周波数
    Wn = fc/(Fs/2);
    [b,a] = butter(4,Wn,'low'); % 4次
    knee_diff(:,1) = filtfilt(b,a,double(fillmissing(knee_diff(:,1),'linear')));

   
%     plot(t,knee_diff(:,1),t,knee_diff(:,2),t,knee_diff(:,3));
    plot(t,knee_diff(:,1));

%     findpeaks(knee_diff(:,1),t, 'MinPeakHeight',0.05, 'MinPeakDistance',0.5);
    [pks_p,locs_p] = findpeaks(knee_diff(:,1), t,  'MinPeakDistance',0.5);
    [pks_n,locs_n] = findpeaks(-knee_diff(:,1), t, 'MinPeakDistance',0.5);
    plot(locs_p, pks_p,'rv','MarkerFaceColor','b');
    plot(locs_n,-pks_n,'rs','MarkerFaceColor','b');

    h1 = xline(R_on, '-r', 'R-on');
    h2 = xline(R_off, '--r', 'R-off');
    h3 = xline(L_on, '-b', 'L-on');
    h4 = xline(L_off, '--b', 'L-off');

    xlabel('time [s]') 
    ylabel('position [m]') 

    legend("X","Y","Z",'Location','southeast')

    filename = "graph\withoutplane\" + save_name + "\" + "knee_diff";
    saveas(gcf,filename,'svg')
    hold off

end