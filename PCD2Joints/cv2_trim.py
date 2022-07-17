import cv2
import os
from pathlib import Path
import scipy.io
import sys 

args = sys.argv
print(args)
PLYdir_path = Path(args[1])
save_name = args[2]

# INPUTDIR = "D:\\ipad_data\\ply_0911\\png_datas"
INPUTDIR = Path(PLYdir_path, "png_datas")
OUTPUTDIR = Path(PLYdir_path, "trimmed_images")
try:
    os.makedirs(OUTPUTDIR)
except:
    pass

EXT = 'png'

# 余白を削除する関数
def crop(image): #引数は画像の相対パス
    # 画像の読み込み
    img = cv2.imread(image.as_posix())

    # # 周りの部分は強制的にトリミング
    # h, w = img.shape[:2]
    # h1, h2 = int(h * 0.05), int(h * 0.95)
    # w1, w2 = int(w * 0.05), int(w * 0.95)
    # img = img[h1: h2, w1: w2]
    # # cv2.imshow('img', img)

    # Grayscale に変換
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # cv2.imshow('gray', gray)

    # 色空間を二値化
    img2 = cv2.threshold(gray, 254, 255, cv2.THRESH_BINARY)[1]
    # cv2.imshow('img2', img2)

    # 輪郭を抽出
    contours = cv2.findContours(img2, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)[0]

    # 輪郭の座標をリストに代入していく
    x1 = [] #x座標の最小値
    y1 = [] #y座標の最小値
    x2 = [] #x座標の最大値
    y2 = [] #y座標の最大値
    for i in range(1, len(contours)):# i = 1 は画像全体の外枠になるのでカウントに入れない
        ret = cv2.boundingRect(contours[i])
        x1.append(ret[0])
        y1.append(ret[1])
        x2.append(ret[0] + ret[2])
        y2.append(ret[1] + ret[3])

    # 輪郭の一番外枠を切り抜き
    x1_min = min(x1)
    y1_min = min(y1)
    x2_max = max(x2)
    y2_max = max(y2)
    # cv2.rectangle(img, (x1_min, y1_min), (x2_max, y2_max), (0, 255, 0), 3)

    crop_img = img[y1_min:y2_max, x1_min:x2_max]
    # cv2.imshow('crop_img', crop_img)

    return img, crop_img

# 編集後の画像の保存ディレクトリの作成
if not os.path.isdir(OUTPUTDIR):
    os.mkdir(OUTPUTDIR)

# INPUTDIR内の全ての画像に対してループ
imgsize_list = []
for image in INPUTDIR.glob('*.' + EXT):
    img, crop_img = crop(image)

    # 相対パスの部分を削除
    image = image.stem
    # # 切り取る長方形とともに元の画像を表示
    # cv2.imshow(image, img)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()

    # 切り取った画像を保存
    mkfile = Path(OUTPUTDIR, image).with_suffix(".png")
    print(mkfile)
    cv2.imwrite(str(mkfile), crop_img) 
    imgsize_list.append(crop_img.shape[:2])

scipy.io.savemat("imgsize.mat", {"imgsize": imgsize_list})