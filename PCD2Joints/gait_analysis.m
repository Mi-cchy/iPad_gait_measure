for id = 1:9
    id
%     clearvars -except matfile_folder id tform1;
%     save_name = "1030_roujin" + id + "_front_plane";
%     mkdir("graph\withoutplane\"+ save_name)
% 
%     matfile_name = matfile_folder(id).folder +"\" + matfile_folder(id).name;
%     load(matfile_name); 
%     % load("C:\Users\mitsuhiro\Documents\measuresys_multiperson\matfile3D\3Dposes_ipad_2021-10-30--14-55-47.mat")
    sheet = readtable("D:\KWAP_true_old\GaitRite\sensor-20211030-roujin" + id + ".xls");
    L_on  = table2array(rmmissing(sheet(:,2)));
    L_off = table2array(rmmissing(sheet(:,3)));
    R_on  = table2array(rmmissing(sheet(:,4)));
    R_off = table2array(rmmissing(sheet(:,5)));
    event = table2array(rmmissing(sheet(:,10)));
    
    if event(1) == L_on(1)
        startevent = 1;
    else
        startevent = 0; % start with Right data
    end
    
    num_step(id) = size(L_on,1) + size(R_on,1);
    
    
    
    disp(startevent)
%     diff_time = zeros(9, size(event,1)-1);
    for j = 1:size(event)-1
        diff_time(id,j) = event(j+1) - event(j);
    end    
    disp(diff_time)
    
    
    
   
    
end