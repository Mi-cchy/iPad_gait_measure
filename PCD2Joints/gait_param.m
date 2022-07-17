clear
% result_sheet(1, :) = {"id", "num_step", "mean_steptime", "std_steptime", "mean_LtoRtime", "std_LtoRtime", ...
%         "mean_RtoLtime", "std_RtoLtime"};
% p_num = 1:9;

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

%% コード


for id = 1:9
    id
%     clearvars -except matfile_folder id tform1;
%     save_name = "1030_roujin" + id + "_front_plane";
%     mkdir("graph\withoutplane\"+ save_name)
% 
%     matfile_name = matfile_folder(id).folder +"\" + matfile_folder(id).name;
%     load(matfile_name); 
%     % load("C:\Users\mitsuhiro\Documents\measuresys_multiperson\matfile3D\3Dposes_ipad_2021-10-30--14-55-47.mat")
    sheet = readtable("D:\KWAP_true_old\GaitRite_param\sensor-20211030-roujin" + id + ".xls");

    event = table2array(rmmissing(sheet(:,6)));
    num_step(id) = size(event,1).';
        
    if event(1) == 0 % first contact is left foot
        startevent = 0; % start with Left data
    else
        startevent = 1; % start with Right data
    end
    
    steptime = table2array(rmmissing(sheet(:,19)));
    if startevent == 0
        LtoR_time = steptime(2:2:size(steptime,1));
        RtoL_time = steptime(3:2:size(steptime,1));
    else
        LtoR_time = steptime(3:2:size(steptime,1));
        RtoL_time = steptime(2:2:size(steptime,1));
    end
    
    firstcontact = table2array(rmmissing(sheet(:,13)));
    lastcontact = table2array(rmmissing(sheet(:,15)));
    for i = 1:num_step(id)-1
        double_supp(i) = lastcontact(i)-firstcontact(i+1);
    end
    

    for i = 1:num_step(id)-2
        OntoOff(id,i) = (lastcontact(i) - firstcontact(i+1)) / (firstcontact(i+2) - firstcontact(i+1)) * 100;
        OfftoOn(id,i) = (firstcontact(i+2) - lastcontact(i)) / (firstcontact(i+2) - firstcontact(i+1)) * 100;
    end
    
    mean_OntoOff(id) = mean(OntoOff(id,1:num_step(id)-2))
    std_OntoOff(id)  = std(OntoOff(id,1:num_step(id)-2))
    
    stancetime = table2array(rmmissing(sheet(:,22)));
    stridetime = table2array(rmmissing(sheet(:,20)));
    
    for i = 1:num_step(id)-2
        Single_OntoOff(id,i) = stancetime(i) / stridetime(i+2) * 100;
    end
    
    
        
    mean_steptime(id) = mean(steptime(2:end));
    std_steptime(id)  = std(steptime(2:end));
    mean_LtoRtime(id) = mean(LtoR_time);
    std_LtoRtime(id)  = std(LtoR_time);
    mean_RtoLtime(id) = mean(RtoL_time);
    std_RtoLtime(id)  = std(RtoL_time);
    
    mean_dubble_supp(id)  = mean(double_supp);
    std_dubble_supp(id)   = std(double_supp);
    
%     gait_ratio(
    
%     double_support_time = table2array(rmmissing(sheet(:,24))); %たぶんおかしい
%     double_support_time(double_support_time==0) = [];
%     mean_double_support = mean(double_support_time);
%     std_double_support = std(double_support_time);
    
%     result_sheet(id+1, :) = {id, num_step, mean_steptime, std_steptime, mean_LtoRtime, std_LtoRtime, ...
%         mean_RtoLtime, std_RtoLtime};
    
    
%     disp(startevent)
% %     diff_time = zeros(9, size(event,1)-1);
%     for j = 1:size(event)-1
%         diff_time(id,j) = event(j+1) - event(j);
%     end    
%     disp(diff_time)
%     
       
end

figure(1)
B = OntoOff ~= 0;
mean(OntoOff(B))
std(OntoOff(B))
histogram(OntoOff(B),7)
xlabel(' ratio of On-Off [%]') 
ylabel(' number of data ') 

figure(2)
C = Single_OntoOff ~= 0;
mean(Single_OntoOff(C))
std(Single_OntoOff(C))
histogram(Single_OntoOff(C),7)
xlabel(' ratio of stance phase [%]') 
ylabel(' number of data ') 


p_num = 1:9;
p_num = p_num.';
num_step = num_step.';
mean_steptime = mean_steptime.';
std_steptime= std_steptime.';
mean_LtoRtime = mean_LtoRtime.';
std_LtoRtime = std_LtoRtime.';
mean_RtoLtime = mean_RtoLtime.';
std_RtoLtime = std_RtoLtime.';
mean_dubble_supp  = mean_dubble_supp.';
std_dubble_supp = std_dubble_supp.';


T = table(p_num, num_step, mean_steptime, std_steptime, mean_LtoRtime, std_LtoRtime, ...
        mean_RtoLtime, std_RtoLtime, mean_dubble_supp, std_dubble_supp);