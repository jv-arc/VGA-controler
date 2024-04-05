from PIL import Image
import numpy as np
import math

#endereco = input()

img = Image.open('output.bmp')

array_velha = np.array(img)

array_nova = np.array(img)

largura, altura = img.size

for i in range(0, altura):
    for j in range(0, largura):
        for k in range (0,3):
            inter = array_velha[i,j]
            array_nova[i,j] = inter - (inter%16)

img_final = Image.fromarray(array_nova)

img_final.save("imagem.bmp")
