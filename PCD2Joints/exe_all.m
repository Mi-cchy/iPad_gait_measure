
% ディレクトリを指定
% PLY_file_dir = "D:\ipad_data\[01]KAWP\2021_1002\5m_f\white\2021-10-02--11-11-22\PLY"

function exe_all(PLY_file_dir, isFRONT)
%     clear;
    tic

    dir_names = strsplit(PLY_file_dir, '\')
%     save_name = append(dir_names(end-2),'_',dir_names(end-1))
    if isFRONT == 1
        save_name = append(dir_names(end-1),'_front')
    else
        save_name = append(dir_names(end-1))
    end

   %% pngファイルの作成
    make_XYpic(PLY_file_dir, isFRONT)

    %% pngのトリミング
    cmd = append('python .\cv2_trim.py ', '"', PLY_file_dir,'" "', save_name, '"')
    status = system(cmd)

    %% OpenPoseの実行
    oldFolder = cd("c:\tools\openpose")
    % bin\OpenPoseDemo.exe --image_dir "C:\Users\mitsuhiro\Documents\measure_sys\trimmed_images" --net_resolution "320x240" --write_json "C:\Users\mitsuhiro\Documents\measure_sys\json0911" --write_images "C:\Users\mitsuhiro\Documents\measure_sys\result_render"

    % % 要修正
    % img_dir = "C:\Users\mitsuhiro\Documents\measure_sys\trimmed_images\" + save_name;
    % output_img_dir = "C:\Users\mitsuhiro\Documents\measure_sys\result_render\" + save_name;
    % output_json_dir = "C:\Users\mitsuhiro\Documents\measure_sys\json\" + save_name;
    % cmd = append('bin\OpenPoseDemo.exe --image_dir "', img_dir, '" --net_resolution "320x240" --write_json "', output_json_dir, '" --write_images "', output_img_dir, '"')
    % status = system(cmd)

    img_dir = PLY_file_dir + "\trimmed_images"; 
    output_img_dir = PLY_file_dir + "\result_render";
    mkdir(output_img_dir)
    output_json_dir = PLY_file_dir + "\json";
    mkdir(output_json_dir)
    cmd = append('bin\OpenPoseDemo.exe --number_people_max 2 --image_dir "', img_dir, '" --net_resolution "320x240" --write_json "', output_json_dir, '" --write_images "', output_img_dir, '"')
    status = system(cmd)

    cd(oldFolder)
    %% jsonのパース
    cmd = append('python .\json2mat.py ',  '"', output_json_dir, '" "', save_name, '"')
    status = system(cmd)

    %% 深度の取得
    depth_calc(PLY_file_dir, save_name, isFRONT)

    %% アニメーションの作成
    result_video = PLY_file_dir + "\result_video";
    mkdir(result_video)
    plot3D(result_video, save_name)
    toc
end