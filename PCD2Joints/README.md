# measure_sys

## 使い方
MATLABでexeall.mを開いて1つ目のセクションで以下のパラメータを設定し実行  
（10秒のファイルで所要時間1時間程度）
- PLY_file_dir
- save_name　（name_direction_height 例："inoue_s_70")
- SIDE （矢状面計測の場合はtrue 前後からの場合はfalse）

## 処理の流れ
1. iPadにより計測したplyファイルのディレクトリを指定
2. make_XYpic.m により点群のXY平面への投影図をpng形式で保存
3. cv2_trim.py で画像の端と点群の最も外側の点が一致するようにトリミング
4. OpenPoseにより関節位置を含むjsonファイルを作成
    - --net_resolution "320x240" （パソコンのスペックの関係でここまでを落とさないと回らない）
    - --image_dir
    - --write_json
    - --write_images

5. json2mat.py により.mat形式にデータを変換
6. depth_calc.m でOpenPoseで出力した点のZ座標を求める
7. plot3D.m で推定関節のビデオを作成