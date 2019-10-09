import numpy as np
import matplotlib as mpl
#mpl.use('pdf')
import matplotlib.pyplot as plt
plt.rcParams["font.family"] = "Times New Roman"
mpl.rcParams['xtick.direction'] = 'in'
mpl.rcParams['ytick.direction'] = 'in'
mpl.rcParams['savefig.dpi'] = 400
fontsize = 7
mpl.rcParams['axes.titlesize'] = fontsize
mpl.rcParams['axes.labelsize'] = fontsize
mpl.rcParams['xtick.labelsize'] = fontsize
mpl.rcParams['ytick.labelsize'] = fontsize
mpl.rcParams['legend.fontsize'] = fontsize

import matplotlib.mlab as mlab

import glob

import scipy.stats as stats
from scipy.misc import imread

import cv2

from PIL import Image


def scale0to1(img):
    
    min = np.min(img)
    max = np.max(img)

    print(min, max)

    if min == max:
        img.fill(0.5)
    else:
        img = (img-min) / (max-min)

    return img.astype(np.float32)

#Width as measured in inkscape
scale = 1.0
width = scale * 3.487
height = 1*(width / 1.618) / 2.2

locs = [r'Z:\Jeffrey-Ede\models\stem-random-walk-nin-20-68\mses-image.npy']
imgs = [np.sqrt(scale0to1(np.load(loc))) for loc in locs]

print(np.mean(imgs[0]))

#Image.fromarray(imgs[1]).save('general_abs_err.tif')

w = h = 512

subplot_cropsize = 16
subplot_prop_of_size = 0.6
subplot_side = int(subplot_prop_of_size*w)
subplot_prop_outside = 0.2
out_len = int(subplot_prop_outside*subplot_side)
side = w+out_len


num_examples = 1
f=plt.figure(figsize=(num_examples, 1))
columns = 1
rows = num_examples
d = 256//16#int(307/16)+1
for i in range(num_examples):

    j = 1
    img = np.ones(shape=(side,side))
    tmp = imgs[j-1]
    tmp = tmp[:16,:16]
    sub = np.zeros((256, 256))
    for y in range(256):
        for x in range(256):
            sub[y,x] = tmp[y//d, x//d]

    img[:w, :w] = imgs[j-1]
    img[(side-subplot_side):,(side-subplot_side):] = cv2.resize(sub, (307, 307))

    #img = img.clip(0., 1.)
    k = i*columns+j
    ax = f.add_subplot(rows, columns, k)
    plt.imshow(img, cmap='gray')
    plt.xticks([])
    plt.yticks([])

    ax.set_frame_on(False)

f.subplots_adjust(wspace=-0.54, hspace=-.095)
f.subplots_adjust(left=.00, bottom=.00, right=1., top=1.)
#f.tight_layout()

f.set_size_inches(width, height)

plt.show()

f.savefig('mse_image.png', bbox_inches='tight')