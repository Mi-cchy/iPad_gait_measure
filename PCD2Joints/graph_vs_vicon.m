%% VICONデータの読み込み保存
%%
clear all
close all

oldFolder = cd("G:\マイドライブ\[1]研究室\[2]研究_B4\[06]中間発表\[04]MATLAB");

% % 書式
% GUIのフォント
% set(0, 'defaultUicontrolFontName','Times New Roman' );%'MS UI Gothic'
% 軸のフォント
% set(0, 'defaultAxesFontName','Times New Roman');
% タイトル、注釈などのフォント
% set(0, 'defaultTextFontName','Times New Roman');
% GUIのフォントサイズ
% set(0, 'defaultUicontrolFontSize', 9);
% 軸のフォントサイズ
% set(0, 'defaultAxesFontSize', 9);%10
% タイトル、注釈などのフォントサイズ
% set(0, 'defaultTextFontSize', 9);
% ラインの太さ
% set(0, 'defaultlineLineWidth', 1);
% 
% box on;

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

%% vicon exel

% OpenPose = readtable("精度検証_1台_下半身.xlsx","sheet","OpenPose");
% Rhip = readtable("精度検証_1台_下半身.xlsx","sheet","Rhip");
% Rknee = readtable("精度検証_1台_下半身.xlsx","sheet","Rknee");
% Rankle = readtable("精度検証_1台_下半身.xlsx","sheet","Rankle");
% Lhip = readtable("精度検証_1台_下半身.xlsx","sheet","Lhip");
% Lknee = readtable("精度検証_1台_下半身.xlsx","sheet","Lknee");
% Lankle = readtable("精度検証_1台_下半身.xlsx","sheet","Lankle");

% sheet_name = [OpenPose,Rhip,Rknee,Rankle,Lhip,Lknee,Lankle];

sheet{1,1} = readtable("精度検証_1台_下半身.xlsx","sheet","OpenPose");
sheet{2,1} = readtable("精度検証_1台_下半身.xlsx","sheet","Rhip");
sheet{3,1} = readtable("精度検証_1台_下半身.xlsx","sheet","Rknee");
sheet{4,1} = readtable("精度検証_1台_下半身.xlsx","sheet","Rankle");
sheet{5,1} = readtable("精度検証_1台_下半身.xlsx","sheet","Lhip");
sheet{6,1} = readtable("精度検証_1台_下半身.xlsx","sheet","Lknee");
sheet{7,1} = readtable("精度検証_1台_下半身.xlsx","sheet","Lankle");

%% 座標変換（時間，前額面X, 左手方向Y，上向きZ）

ipad_bias = [454.14, 870.32, 54.77];

for i =  2:7
    
    M_vicon{i,:} = [sheet{i,1}{:,1}, -sheet{i,1}{:,4}, sheet{i,1}{:,3}, sheet{i,1}{:,5}];
%     M_ipad = [sheet{i,1}{:,7}, -(sheet{i,1}{:,10}-ipad_bias(2)), sheet{i,1}{:,9}-ipad_bias(1), sheet{i,1}{:,11}-ipad_bias(3)];

    % viconの計測位置グラフ

    % ax1 = axes('Position',[0.1 0.1 0.8 0.8]);
    % ax1.PositionConstraint = 'outerposition';
% 
%     t = tiledlayout(1,1,'Padding','tight');
% 
%     t.Units = 'inches';
%     t.OuterPosition = [0.25 0.25 3 3];

%     nexttile;

%% --------
%     hold on;
%     plot(M_ipad(:,1),M_ipad(:,2),"r",M_ipad(:,1),M_ipad(:,3),"g",M_ipad(:,1),M_ipad(:,4),"b")
%     plot(M_vicon(:,1),M_vicon(:,2),":r",M_vicon(:,1),M_vicon(:,3),":g", M_vicon(:,1),M_vicon(:,4),":b")
%     xlim([7000, 9400])
% 
%     legend("X (iPad)","Y (iPad)","Z (iPad)","X (VICON)","Y (VICON)","Z (VICON)",'Location','southeast')
%     xlabel('time [ms]') 
%     ylabel('position [mm]') 
% %     set(gcf, 'Position', [] 
%     sheet_name = ["OpenPose","Rhip","Rknee","Rankle","Lhip","Lknee","Lankle"];
%     saveas(gcf,sheet_name(i),'jpeg')
%     hold off;

end

%% グラフの描画
f = figure(1);
f.Position = [100 100 300 300];
set(gcf, 'Color', 'none')

t = M_vicon{3,1}(:,1);
Joint_diff(:,1) = M_vicon{3,1}(:,2) - M_vicon{2,1}(:,2); % knee - hip
Joint_diff(:,2) = M_vicon{4,1}(:,2) - M_vicon{2,1}(:,2); % ankle - hip
Joint_diff(:,3) = M_vicon{3,1}(:,2) - M_vicon{6,1}(:,2); % Rknee - Lknee
Joint_diff(:,4) = M_vicon{4,1}(:,2) - M_vicon{7,1}(:,2); % Rankle - Lankle

[pks_1,locs_1] = findpeaks(Joint_diff(:,1), t,  'MinPeakDistance',0.5);
[pks_2,locs_2] = findpeaks(Joint_diff(:,2), t,  'MinPeakDistance',0.5);
[pks_2n,locs_2n] = findpeaks(-Joint_diff(:,2), t,  'MinPeakDistance',0.5);

[pks_3,locs_3] = findpeaks(Joint_diff(:,3), t,  'MinPeakDistance',0.5);
[pks_4,locs_4] = findpeaks(Joint_diff(:,4), t,  'MinPeakDistance',0.5);

hold on;
plot(t,Joint_diff(:,1),"r",t,Joint_diff(:,2),"g",t,M_vicon{4,1}(:,4),"b", ...
    t,Joint_diff(:,3),":r",t,Joint_diff(:,4),":g")
h1 = xline(locs_1, '-r');
h2 = xline(locs_2, '-g');
h3 = xline(locs_3, ':r');
h4 = xline(locs_4, ':g');



legend("KneeHip(VICON)","AnkleHip(VICON)","AnkleHeight","KneeDiff","AnkleDiff",'Location','southeast')
xlabel('time [ms]') 
ylabel('position [mm]') 
xlim([7000, 9400])
hold off

%% 関節位置の真値描画
f = figure(2);
t = t/1000;
f.Position = [100 100 300 300];
set(gcf, 'Color', 'none')
hold on;
% plot(M_ipad(:,1),M_ipad(:,2),"r",M_ipad(:,1),M_ipad(:,3),"g",M_ipad(:,1),M_ipad(:,4),"b")
% plot(t, M_vicon{2,1}(:,2)/1000, t, M_vicon{3,1}(:,2)/1000, t, M_vicon{4,1}(:,2)/1000)
plot(t, M_vicon{3,1}(:,2)/1000, t, M_vicon{4,1}(:,2)/1000)

xlim([7, 9.4])
h2 = xline(locs_2/1000, 'r', 'on','FontSize',14,'LineWidth',1);
h2 = xline(locs_2n/1000, '--r','off','FontSize',14,'LineWidth',1);

% h3 = xline(locs_3/1000, ':r');
legend("Knee","Ankle",'Location','southeast')
xlabel('time [s]') 
ylabel('position [m]') 
hold off;

%% グラフの描画
f = figure(3);

f.Position = [100 100 300 300];
set(gcf, 'Color', 'none')

t = M_vicon{3,1}(:,1)/1000;
Joint_diff(:,1) = ( M_vicon{3,1}(:,2) - M_vicon{6,1}(:,2) ) /1000; % Rknee - Lknee
Joint_diff(:,2) = ( M_vicon{4,1}(:,2) - M_vicon{2,1}(:,2) ) /1000; % Rankle - Rhip
Joint_diff(:,3) = ( M_vicon{7,1}(:,2) - M_vicon{5,1}(:,2) ) /1000; % Lankle - Lhip

[pks_1,locs_1] = findpeaks(Joint_diff(:,1), t,  'MinPeakDistance',0.5); % ron
[pks_1n,locs_1n] = findpeaks(-Joint_diff(:,1), t,  'MinPeakDistance',0.5); % lon

[pks_2,locs_2] = findpeaks(Joint_diff(:,2), t,  'MinPeakDistance',0.5); % ron
[pks_2n,locs_2n] = findpeaks(-Joint_diff(:,2), t,  'MinPeakDistance',0.5); % roff

[pks_3,locs_3] = findpeaks(Joint_diff(:,3), t,  'MinPeakDistance',0.5);
[pks_3n,locs_3n] = findpeaks(-Joint_diff(:,3), t,  'MinPeakDistance',0.5);

% plot(t,Joint_diff(:,1),t,Joint_diff(:,2),t,Joint_diff(:,3))


subplot(3,1,1)
hold on;
plot(t,Joint_diff(:,1))
plot(locs_1,pks_1,'rv','MarkerFaceColor','r');
plot(locs_1n,-pks_1n,'bv','MarkerFaceColor','b');
h1 = xline(locs_1, '-r','LineWidth',1);
h2 = xline(locs_1n, '-b','LineWidth',1);
h3 = xline(locs_2n, ':r','LineWidth',1);
h4 = xline(locs_3n, ':b','LineWidth',1);
xlim([7, 9.4])
ax = gca;
ax.XTickLabel = cell(size(ax.XTickLabel)); % Y 軸の目盛り上の数値を削除
ax.YTickLabel = cell(size(ax.YTickLabel)); % Y 軸の目盛り上の数値を削除


subplot(3,1,2)
hold on;
plot(t,Joint_diff(:,2))
plot(locs_2,pks_2,'rv','MarkerFaceColor','r');
plot(locs_2n,-pks_2n,'bv','MarkerFaceColor','b');
h1 = xline(locs_1, '-r','LineWidth',1);
h2 = xline(locs_1n, '-b','LineWidth',1);
h3 = xline(locs_2n, ':r','LineWidth',1);
h4 = xline(locs_3n, ':b','LineWidth',1);
xlim([7, 9.4])
ax = gca;
ax.XTickLabel = cell(size(ax.XTickLabel)); % Y 軸の目盛り上の数値を削除
ax.YTickLabel = cell(size(ax.YTickLabel)); % Y 軸の目盛り上の数値を削除

subplot(3,1,3)
hold on;
plot(t,Joint_diff(:,3))
plot(locs_3,pks_3,'rv','MarkerFaceColor','r');
plot(locs_3n,-pks_3n,'bv','MarkerFaceColor','b');
h1 = xline(locs_1, '-r','LineWidth',1);
h2 = xline(locs_1n, '-b','LineWidth',1);
h3 = xline(locs_2n, ':r','LineWidth',1);
h4 = xline(locs_3n, ':b','LineWidth',1);
xlim([7, 9.4])
ax = gca;
ax.XTickLabel = cell(size(ax.XTickLabel)); % Y 軸の目盛り上の数値を削除
ax.YTickLabel = cell(size(ax.YTickLabel)); % Y 軸の目盛り上の数値を削除




% legend("KneeDiff","RAnkleHip","LAnkleHip",'Location','southeast')
hold off
saveas(gcf,"vicon_event_detection",'svg')

%% グラフの描画
f = figure(4);

f.Position = [100 100 300 300];
set(gcf, 'Color', 'white')

t = M_vicon{3,1}(:,1)/1000;
Joint_diff(:,1) = ( M_vicon{3,1}(:,2) - M_vicon{6,1}(:,2) ) /1000; % Rknee - Lknee
Joint_diff(:,2) = ( M_vicon{4,1}(:,2) - M_vicon{2,1}(:,2) ) /1000; % Rankle - Rhip
Joint_diff(:,3) = ( M_vicon{7,1}(:,2) - M_vicon{5,1}(:,2) ) /1000; % Lankle - Lhip

[pks_1,locs_1] = findpeaks(Joint_diff(:,1), t,  'MinPeakDistance',0.5); % ron
[pks_1n,locs_1n] = findpeaks(-Joint_diff(:,1), t,  'MinPeakDistance',0.5); % lon

[pks_2,locs_2] = findpeaks(Joint_diff(:,2), t,  'MinPeakDistance',0.5); % ron
[pks_2n,locs_2n] = findpeaks(-Joint_diff(:,2), t,  'MinPeakDistance',0.5); % roff

[pks_3,locs_3] = findpeaks(Joint_diff(:,3), t,  'MinPeakDistance',0.5);
[pks_3n,locs_3n] = findpeaks(-Joint_diff(:,3), t,  'MinPeakDistance',0.5);

% plot(t,Joint_diff(:,1),t,Joint_diff(:,2),t,Joint_diff(:,3))
ankle_knee = ( M_vicon{4,1}(:,2) - M_vicon{3,1}(:,2) ) /1000;


% subplot(3,1,1)
hold on;
% plot(t,Joint_diff(:,1))
plot(t,ankle_knee)
plot(locs_1,pks_1,'rv','MarkerFaceColor','r');
plot(locs_1n,-pks_1n,'bv','MarkerFaceColor','b');
h1 = xline(locs_1, '-r','LineWidth',1);
h2 = xline(locs_1n, '-b','LineWidth',1);
h3 = xline(locs_2n, ':r','LineWidth',1);
h4 = xline(locs_3n, ':b','LineWidth',1);
xlim([7, 9.4])
ax = gca;
ax.XTickLabel = cell(size(ax.XTickLabel)); % Y 軸の目盛り上の数値を削除
ax.YTickLabel = cell(size(ax.YTickLabel)); % Y 軸の目盛り上の数値を削除


% subplot(3,1,2)
% hold on;
% plot(t,Joint_diff(:,2))
% plot(locs_2,pks_2,'rv','MarkerFaceColor','r');
% plot(locs_2n,-pks_2n,'bv','MarkerFaceColor','b');
% h1 = xline(locs_1, '-r','LineWidth',1);
% h2 = xline(locs_1n, '-b','LineWidth',1);
% h3 = xline(locs_2n, ':r','LineWidth',1);
% h4 = xline(locs_3n, ':b','LineWidth',1);
% xlim([7, 9.4])
% ax = gca;
% ax.XTickLabel = cell(size(ax.XTickLabel)); % Y 軸の目盛り上の数値を削除
% ax.YTickLabel = cell(size(ax.YTickLabel)); % Y 軸の目盛り上の数値を削除
% 
% subplot(3,1,3)
% hold on;
% plot(t,Joint_diff(:,3))
% plot(locs_3,pks_3,'rv','MarkerFaceColor','r');
% plot(locs_3n,-pks_3n,'bv','MarkerFaceColor','b');
% h1 = xline(locs_1, '-r','LineWidth',1);
% h2 = xline(locs_1n, '-b','LineWidth',1);
% h3 = xline(locs_2n, ':r','LineWidth',1);
% h4 = xline(locs_3n, ':b','LineWidth',1);
% xlim([7, 9.4])
% ax = gca;
% ax.XTickLabel = cell(size(ax.XTickLabel)); % Y 軸の目盛り上の数値を削除
% ax.YTickLabel = cell(size(ax.YTickLabel)); % Y 軸の目盛り上の数値を削除




% legend("KneeDiff","RAnkleHip","LAnkleHip",'Location','southeast')
hold off
% saveas(gcf,"vicon_event_detection",'svg')

cd(oldFolder)

% plot(M_vicon_Rhip(:,1), M_vicon_Rhip(:,2))

