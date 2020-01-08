import cv2
from scipy.misc import imread

import os
from shutil import copyfile

from PIL import Image

dirs = ["Y:/HCSS6/Shared305/ARM200/Users/Jeffrey-Ede/dlss-stem/seq"+f"{i}" for i in range(1,6)]

for dir in dirs:

    new_dir = dir + "_downsampled"
    os.makedirs(new_dir)

    for file in os.listdir(dir):

        old_file = dir + "/" + file
        new_file = new_dir + "/" + file

        if "input" in file:
            img = imread(old_file, mode="F")
            img = cv2.copyMakeBorder( img, 1, 2, 1, 2, cv2.BORDER_REFLECT)
            img = cv2.resize(img, (103, 103), interpolation=cv2.INTER_NEAREST)
            Image.fromarray(img).save( new_file )
        else:
            copyfile(old_file, new_file)
