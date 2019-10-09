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
#mpl.rcParams['title.fontsize'] = fontsize
mpl.rcParams['font.size'] = fontsize
mpl.rcParams['axes.titlepad'] = 7
mpl.rcParams['savefig.dpi'] = 300
plt.rcParams["figure.figsize"] = [4, 3]

take_ln = True
moving_avg = True
save = True
save_val = True
window_size = 2500
dataset_num = 8
mean_from_last = 20000
remove_repeats = True #Caused by starting from the same counter multiple times

scale = 1.2
ratio = 1.6 # 1.618
width = 2 * scale * 3.3
height = (width / 1.618) / 2
num_data_to_use = 20000
num_hist_bins = 200
mse_x_to = 0.012

f = plt.figure()

labels_sets = [["1/16", "1/25", "1/36", "1/64", "1/100"], ["1/16", "1/25", "1/36", "1/64", "1/100"]]

sets = [[65, 54, 63, 66, 64], [16, 25, 36, 64, 100]]

titles = ["Individual Networks", "Unified Network"]

f, big_axes = plt.subplots( figsize=(15.0, 15.0), nrows=1, ncols=2, sharey=False ) 
losses_sets = []
iters_sets = []
for i, (data_nums, labels, ax, title) in enumerate(zip(sets, labels_sets, big_axes, titles)):

    #ax._frameon = False

    #ax = f.add_subplot(1, 2, i+1)
    ax.xaxis.set_ticks_position('both')
    ax.yaxis.set_ticks_position('both')
    ax.tick_params(labeltop=False, labelright=False)
    ax.minorticks_on()
    for j, dataset_num in enumerate(data_nums):
        if not i:
            hist_loc = ("Z:/Jeffrey-Ede/models/stem-random-walk-nin-20-"+str(dataset_num)+"/")
            hist_file = hist_loc+"mses.npy"
        else:
            hist_file = f"Z:/Jeffrey-Ede/models/stem-random-walk-nin-20-68/mses-{dataset_num}.npy"

        mses = np.load(hist_file)
        #for x in mses: print(x)
        #print(np.mean(mses), np.std(mses))
        print(len([x for x in mses if x >= 10]))
        mses = [x/800 for x in mses if x < 10]
        
        bins, edges = np.histogram(mses, 100)
            
        edges = 0.5*(edges[:-1] + edges[1:])

        ax.plot(edges, bins, label=labels[j], linewidth=1)

    ax.set_ylabel('Frequency')
    ax.set_xlabel('MSE')

    ax.set_ylim(-100, 2175)

    plt.legend(loc='upper right', frameon=False, fontsize=8)

    ax.set_title(title, size=fontsize)

    plt.minorticks_on()
    
f.subplots_adjust(wspace=0.22, hspace=0.26)
f.subplots_adjust(left=.00, bottom=.00, right=1., top=1.)

f.set_size_inches(width, height)

save_loc =  "Z:/Jeffrey-Ede/models/stem-random-walk-nin-figures/dlss_hist.png"
plt.savefig( save_loc, bbox_inches='tight', )

#plt.gcf().clear()
