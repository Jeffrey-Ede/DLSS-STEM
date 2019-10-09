import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
plt.rcParams["font.family"] = "Times New Roman"
mpl.rcParams['xtick.direction'] = 'in'
mpl.rcParams['ytick.direction'] = 'in'
fontsize = 9
mpl.rcParams['axes.labelsize'] = fontsize
mpl.rcParams['xtick.labelsize'] = fontsize
mpl.rcParams['ytick.labelsize'] = fontsize
mpl.rcParams['legend.fontsize'] = fontsize
mpl.rcParams['font.size'] = fontsize
mpl.rcParams['axes.titlepad'] = 7
mpl.rcParams['savefig.dpi'] = 300
plt.rcParams["figure.figsize"] = [4,3]


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

loc = r'Z:\Jeffrey-Ede\models\stem-random-walk-nin-20-68\mses-image.npy'
img = np.sqrt(np.load(loc)) / 2

d = 100
m1 = np.mean(img)
m2 = np.mean(img[d:-d,d:-d])
print((m1 - m2)/m1, )

errors = [ 0 for _ in range(256) ]
freqs = [ 0 for _ in range(256) ]

for x in range(512):
    for y in range(512):
        dx = min(x+1, 512-x)
        dy = min(y+1, 512-y)
        d = min(dx, dy)

        errors[d-1] += img[x, y]
        freqs[d-1] += 1

y = [ e/f for e, f in zip(errors, freqs) ]
x = [ i for i in range(1, 256+1) ]


f = plt.figure()
ax = f.add_subplot(111)
ax2 = ax.twinx()

p1 = ax.plot(x, y)

ax.axhline(y=np.mean(y), color=p1[0].get_color(), linestyle='--', linewidth=0.8)

mu = np.mean(img)
z = [-100*(np.mean(img[i:-i, i:-i])-mu)/mu for i in x[:-1]]

ax2._get_lines.get_next_color()
p2 = ax2.plot(x[:-1], z)


ax.set_xlabel('Distance (px)')
ax.set_ylabel('Root Mean Squared Error')
ax2.set_ylabel('Error Decrease (%)')
ax.xaxis.set_ticks_position('both')
#ax.yaxis.set_ticks_position('both')

ax.spines['left'].set_color(p1[0].get_color())
ax2.spines['left'].set_color(p1[0].get_color())
#ax.spines['left'].set_edgecolor(p1[0].get_color())
ax.tick_params(axis='y', which='both', colors=p1[0].get_color())
ax.yaxis.label.set_color(p1[0].get_color())
ax.tick_params(axis='y', colors=p1[0].get_color())

ax2.spines['right'].set_color(p2[0].get_color())
ax2.tick_params(axis='y', which='both', colors=p2[0].get_color())
ax2.yaxis.label.set_color(p2[0].get_color())
ax2.tick_params(axis='y', colors=p2[0].get_color())

ax.minorticks_on()
ax2.minorticks_on()

#plt.tick_params()

save_loc = 'manhatten.png'
plt.savefig( save_loc, bbox_inches='tight', )