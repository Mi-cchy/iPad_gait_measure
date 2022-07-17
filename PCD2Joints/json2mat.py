import scipy.io
from tqdm import tqdm
from typing import List, Dict, Any
import json
import glob
import sys
from pathlib import Path
import numpy as np

args = sys.argv
jsondir_path = Path(args[1])
save_name = args[2]

OpenPoseMap = [
    "Nose",
    "Neck",
    "RShoulder",
    "RElbow",
    "RWrist",
    "LShoulder",
    "LElbow",
    "LWrist",
    "MidHip",
    "RHip",
    "RKnee",
    "RAnkle",
    "LHip",
    "LKnee",
    "LAnkle",
    "REye",
    "LEye",
    "REar",
    "LEar",
    "LBigToe",
    "LSmallToe",
    "LHeel",
    "RBigToe",
    "RSmallToe",
    "RHeel",
    "Background",
]


def batch(iterable, n=1):
    length = len(iterable)
    for index in range(0, length, n):
        yield iterable[index : min(index + n, length)]


def read_openpose_json(filename: str) -> List[Dict[str, Any]]:
    with open(filename, "rb") as f:
        kpt = []
        data = json.load(f)
        num_col = len(data['people'])
        for i, d in enumerate(data['people']):
            if i == 2:
                kpt.append(np.array(d['pose_keypoints_2d']).reshape((25, 3, 2)))
            else:
                kpt.append(np.array(d['pose_keypoints_2d']).reshape((25, 3)))
        # assert (
        #     len(keypoints["people"]) == 1
        # ), "In all pictures, we should have only one person!"

        # points_2d = keypoints["people"][0]["pose_keypoints_2d"]
        # assert (
        #     len(points_2d) == 25 * 3
        # ), "We have 25 points with (x, y, c); where c is confidence."

        # for point_index, (x, y, confidence) in enumerate(batch(points_2d, 3)):
        #     assert x is not None, "x should be defined"
        #     assert y is not None, "y should be defined"
        #     assert confidence is not None, "confidence should be defined"
        #     keypoints_list.append(
        #         {
        #             "x": x,
        #             "y": y,
        #             "c": confidence,
        #             "point_label": OpenPoseMap[point_index],
        #             "point_index": point_index,
        #         }
        #     )

        return kpt


def get_all_openpose_json_files() -> List[str]:
    # ... implement your files loader here ...
    # p = Path("C:\\Users\\mitsuhiro\\Documents\\measure_sys\\json0911\\")
    json_list = list(jsondir_path.glob("*.json"))
    return json_list


poses = []
for filename in tqdm(get_all_openpose_json_files()):
    keypoints = read_openpose_json(filename)#kptの出力
    print("row",len(keypoints))
    # print("col",len(keypoints[0]))
    # keypoints = np.array(keypoints)
    poses.append(keypoints)
    # print(poses.shape[0]-initial)

# Save all at once
scipy.io.savemat("openpose_map.mat", {"OpenPoseMap": OpenPoseMap})
scipy.io.savemat(".\matfile2D\poses_" + save_name + ".mat", {"poses": poses})