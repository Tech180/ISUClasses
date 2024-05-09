import sys
import numpy as np
from PIL import Image

#Open images
im1 = Image.open(str(sys.argv[1]))
im2 = Image.open(str(sys.argv[2]))

#Make into Numpy arrays
im1np = np.array(im1)*255
im2np = np.array(im2)*255

#XOR with Numpy
result = np.bitwise_xor(im1np, im2np).astype(np.uint8)

#Convert back to PIL image and save
Image.fromarray(result).save(str(sys.argv[3]))
