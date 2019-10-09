import numpy as np
import re

import matplotlib.pyplot as plt
import matplotlib as mpl
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

import scipy.stats as stats

from functools import reduce
from math import gcd
a = [16, 25, 36, 64, 100]   #will work for an int array of any length

def getLCM(a, b):
    return a * b // gcd(a, b)

from functools import reduce

def nlcm(nums):
    return reduce(getLCM, nums, 1)
print(nlcm(a))

data_num = 50

scale = 1.0
ratio = 1.618 # 1.618
width = scale * 3.3
height = (width / 1.618)
num_data_to_use = 20000
num_hist_bins = 200
mse_x_to = 0.012

f = plt.figure()
ax = f.add_subplot(111)

ax.set_facecolor("whitesmoke")
ax.axvspan(1/10**2, 1/4**2, color='white')

labels0 = [1/9, 1/16, 1/25, 1/36, 1/49, 1/64, 1/81, 1/100, 1/121, 1/144]
labels = ["1/9", "1/16", "1/25", "1/36", "1/49", "1/64", "1/81", "1/100", "1/121", "1/144"]

n = lambda x: f"Z:/Jeffrey-Ede/models/stem-random-walk-nin-20-68/mses-{x}.npy"
values0 = [np.sqrt(np.mean(np.load(n(x[2:]))/200))/2 for x in labels]
values = values0#[x**2 for x in values0]

poly = np.polyfit(np.array(labels0[1:-2]), np.array(values[1:-2]), 2)
print(poly)
#np.save("Z:\Jeffrey-Ede\models\stem-random-walk-nin-20-68\poly.npy", poly)
p = np.poly1d(poly)

#x = np.array([i for i in range(101)])/25
y = (1/12**2 + (1/4**2-1/12**2)*np.array([i for i in range(101)])/100)[::-1]

#plt.plot(range(len(labels)), values, 'o')
#plt.plot(x, p(y))
#plt.xticks(range(len(labels)), labels)
print(labels0)
plt.plot(labels0, values, 'o')
#plt.plot(y, p(y))

#plt.xticks(range(len(labels)), labels)

#for l, ls, v in zip(labels0, labels, values):
#    ax.text(l, v+0.001, f"{ls}, "+"{:.4f}".format(v), ha="center")

plt.xlabel('Coverage')
plt.ylabel('Root Mean Squared Error')
plt.minorticks_on()
ax.xaxis.set_ticks_position('both')
ax.yaxis.set_ticks_position('both')

plt.axvline(x=1/4**2, color='black', linestyle='--', linewidth=0.8)
plt.axvline(x=1/10**2, color='black', linestyle='--', linewidth=0.8)

#plt.xlim(0, 0.072)
#plt.ylim(0.0304, 0.045)

plt.tick_params()

#plt.show()

#for code, data in zip(codes, datasets):
#    subplot_creator(code, data)

#f.subplots_adjust(wspace=0.18, hspace=0.26)
#f.subplots_adjust(left=.00, bottom=.00, right=1., top=1.)

#ax.set_ylabel('Some Metric (in unit)')
#ax.set_xlabel('Something (in unit)')
#ax.set_xlim(0, 3*np.pi)

#f.set_size_inches(width, height)

#plt.show()
#quit()
save_loc = 'test_err.png'
plt.savefig( save_loc, bbox_inches='tight', )

