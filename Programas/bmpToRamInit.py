from PIL import Image
import numpy as np
import math

def dtob (num):
    if num >= 8:
        return bin(num).replace("0b", "")
    elif num >= 4:
        return bin(num).replace("0b", "0")
    elif num >= 2:
        return bin(num).replace("0b", "00")
    elif num >= 1:
        return bin(num).replace("0b", "000")
    else:
        return "0000"

def main ():
    endereco = "imagem.bmp"

    img= Image.open(endereco)
    matrix = np.array(img)
    largura, altura = img.size


    for i in range (0, altura):
        for j in range(0, largura):
            string = ''
            for k in range (0,3):
                string = string + dtob(int(matrix[i,j,k]/16))
            print(string)

main()
