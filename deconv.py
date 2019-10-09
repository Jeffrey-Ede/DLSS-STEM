import tensorflow as tf

import os

import numpy as np
import cv2

from scipy.misc import imread

from PIL import Image

def scale0to1(img):
    
    min = np.min(img)
    max = np.max(img)

    if min == max:
        img.fill(0.5)
    else:
        img = (img-min) / (max-min)

    return img.astype(np.float32)

def disp(img):
    cv2.namedWindow('CV_Window', cv2.WINDOW_NORMAL)
    cv2.imshow('CV_Window', scale0to1(img))
    cv2.waitKey(0)
    return


def pad(tensor, size):
    d1_pad = size[0]
    d2_pad = size[1]

    paddings = tf.constant([[0, 0], [d1_pad, d1_pad], [d2_pad, d2_pad], [0, 0]], dtype=tf.int32)
    padded = tf.pad(tensor, paddings, mode="REFLECT")
    return padded

def blur(image, gauss_kernel):

    #Expand dimensions of `gauss_kernel` for `tf.nn.conv2d` signature
    gauss_kernel = gauss_kernel[:, :, tf.newaxis, tf.newaxis]

    #Convolve
    image = pad(image, (2,2))
    return tf.nn.conv2d(image, gauss_kernel, strides=[1, 1, 1, 1], padding="VALID")


shape=(1, 512,512, 1)

k = cv2.getGaussianKernel(ksize=5, sigma=2.5)
k = k * k.T
k /= np.sum(k)

img_ph = tf.placeholder(tf.float32, shape=shape)
kernel = tf.convert_to_tensor(k, dtype=tf.float32)
lr_ph = tf.placeholder(tf.float32, name="learning_rate")

img_input = tf.Variable(np.ones(shape), trainable=False, dtype=np.float32)
img_var = tf.Variable(np.ones(shape), trainable=True, dtype=np.float32)

output = blur(img_var, kernel)

loss = tf.reduce_mean( (output - img_input)**2 )
train_op = tf.train.AdamOptimizer(learning_rate=lr_ph, beta1=0.9).minimize(loss)

sess = tf.Session()

sess.run(tf.global_variables_initializer())

def deconv(input, n=100, a=.99, learning_rate=.3, beta=0.9):

    base_dict = {img_ph: input}
    sess.run([img_var.assign(img_ph), img_input.assign(img_ph)], feed_dict=base_dict)

    for i in range(n):
        lr = learning_rate*a**i
        feed_dict = {lr_ph: lr}
        sess.run(train_op, feed_dict)

    x, l = sess.run([img_var, loss])

    return x, l


data_dir = f"//flexo.ads.warwick.ac.uk/Shared41/Microscopy/Jeffrey-Ede/models/stem-random-walk-nin-20-68/"
filepaths = [data_dir+f for f in os.listdir(data_dir) if "_output" in f and ".tif" in f and not "_deconv" in f]

for i, filepath in enumerate(filepaths[:1000]):
    
    img = imread(filepath, mode='F')
    
    img = img[np.newaxis,...,np.newaxis]
    img = img.astype(np.float32)

    img, l = deconv(img)

    save_loc = filepath.split(".tif")[0]+"_deconv.tif"
    Image.fromarray(img.reshape(512, 512).astype(np.float32)).save( save_loc )

    print(f"Iter: {i}, Loss: {l}")

#data_dir = "//Desktop-sa1evjv/f/ARM_scans-crops/train/"
#filepaths = [data_dir+f for f in os.listdir(data_dir)]

#raw_ls = []
#ls = []
#for i, filepath in enumerate(filepaths[:1000]):
#    print(f"Iter: {i}")
#    img = imread(filepath, mode='F')

#    img = scale0to1(img)

#    img0 = img
#    img = cv2.GaussianBlur(img,(5,5), 2.5)
#    raw_l = np.mean((img-img0)**2)
#    #img = np.load(r"Z:\Jeffrey-Ede\models\stem-random-walk-nin-20-68\mses-image.npy")
    

#    img = img[np.newaxis,...,np.newaxis]
#    img = img.astype(np.float32)

#    img, l = deconv(img)

#    raw_ls.append(raw_l)
#    ls.append(l)

#raw_ls = np.array(raw_ls)
#ls = np.array(ls)

##np.save(save_dir+"raw_ls.npy", raw_ls)
##np.save("ls.npy", ls)

#print(np.mean(raw_ls), np.mean(ls))

