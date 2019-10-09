import numpy as np
from scipy.misc import imread
from scipy.stats import entropy

import matplotlib as mpl
#mpl.use('pdf')
import matplotlib.pyplot as plt
plt.rcParams["font.family"] = "Times New Roman"
mpl.rcParams['xtick.direction'] = 'in'
mpl.rcParams['ytick.direction'] = 'in'
mpl.rcParams['savefig.dpi'] = 100
fontsize = 11
mpl.rcParams['axes.titlesize'] = fontsize
mpl.rcParams['axes.labelsize'] = fontsize
mpl.rcParams['xtick.labelsize'] = fontsize
mpl.rcParams['ytick.labelsize'] = fontsize
mpl.rcParams['legend.fontsize'] = fontsize

import matplotlib.mlab as mlab

import cv2

from PIL import Image
from PIL import ImageDraw

coverage = 25

parent = "Z:/Jeffrey-Ede/models/stem-random-walk-nin-20-68/"
prependings = [f"final_{coverage}_input-", f"final_25_truth-", f"final_{coverage}_output-", f"final_{coverage}_adversarial-"]

image_nums = [3, 4, 15, 18, 20]


imgs = []
for i in image_nums:
    for prepending in prependings:
        filename = parent + prepending + f"{i}.tif"
        img = imread(filename, mode="F")

        #if i == 54:
        #    img = np.flip(img, axis=0)

        imgs.append(img)

x_titles = [
    "Input",
    "Truth",  
    "Non-Adversarial", 
    "Adversarial"]

def scale0to1(img):
    
    min = np.min(img)
    max = np.max(img)

    print(min, max)

    if min == max:
        img.fill(0.5)
    else:
        img = (img-min) / (max-min)

    return img.astype(np.float32)

def block_resize(img, new_size):

    x = np.zeros(new_size)
    
    dx = int(new_size[0]/img.shape[0])
    dy = int(new_size[1]/img.shape[1])

    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            px = img[i,j]

            for u in range(dx):
                for v in range(dy):
                    x[i*dx+u, j*dy+v] = px

    return x
    
#Width as measured in inkscape
scale = 4
width = scale * 2.2
height = 1.1*scale* (width / 1.618) / 2.2

print(np.mean(imgs[0]), np.mean(imgs[1]))


w = h = 512

subplot_cropsize = 64
subplot_prop_of_size = 0.625
subplot_side = int(subplot_prop_of_size*w)
subplot_prop_outside = 0.25
out_len = int(subplot_prop_outside*subplot_side)
side = w+out_len

print(imgs[1])

f=plt.figure(figsize=(1, 4))
columns = 4
rows = 5

#spiral = inspiral(1/20, int(512*0.6*512/64))
#spiral_crop = spiral[:subplot_side, :subplot_side]

for i in range(rows):
    for j in range(1, columns+1):
        img = np.ones(shape=(side,side))
        img[:w, :w] = imgs[columns*i+j-1]
        crop = block_resize(img[:subplot_cropsize, :subplot_cropsize], 
                          (subplot_side, subplot_side))
        img[(side-subplot_side):,(side-subplot_side):] = crop
        img = img.clip(0., 1.)
        k = i*columns+j
        ax = f.add_subplot(rows, columns, k)
        plt.imshow(img, cmap='gray')
        plt.xticks([])
        plt.yticks([])

        ax.set_frame_on(False)
        if not i:
            ax.set_title(x_titles[j-1])#, fontsize=fontsize)

f.subplots_adjust(wspace=-0.00, hspace=0.03)
f.subplots_adjust(left=.00, bottom=.00, right=1., top=1.)
#f.tight_layout()

f.set_size_inches(width, height)

#plt.show()

f.savefig(f'adv_vs_non-adv_extra-{coverage}.png', bbox_inches='tight')
