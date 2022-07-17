function exe_multi(wholeday_dir)

%     folderpath = wholeday_dir + "\5m_f\white"
    folderpath = wholeday_dir
    
    folderInfo = dir(folderpath)
    folderInfo = folderInfo(~ismember({folderInfo.name}, {'.', '..'}));
    file_list = folderInfo([folderInfo.isdir])
    
    
    for i = 1:length(file_list)
        file_path = file_list(i).folder + "\" + file_list(i).name + "\PLY";
        exe_all(file_path,0); % cam view
%         exe_all(file_path,1); % front view 
    end
        
%     folderpath = wholeday_dir + "\5m_f\black"
%     folderInfo = dir(folderpath)
%     folderInfo = folderInfo(~ismember({folderInfo.name}, {'.', '..'}));
%     file_list = folderInfo([folderInfo.isdir])
%     
%     for i = 1:length(file_list)
%         file_path = file_list(i).folder + "\" + file_list(i).name + "\PLY"
%         exe_all(file_path)
%     end
%         
end