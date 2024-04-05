#!/bin/bash

#Caminho para a pasta com imagens
DIRECTORY='./fotos_a_ser_geradas'

#Loop pelas imagens na pasta
for FILE in "$DIRECTORY"/*
do 

echo "$FILE"

#Roda o comando ffmepg
ffmpeg -i "$FILE" -vf scale=320:240 output.bmp

#Converte para o espaco de cor de 12 bits
python3 12bitcolorspace.py

#cria arquivo novo para imagem
EXT="txt"
STRING="${FILE%.*}.$EXT"
touch "$STRING"

#converte a imagem em bmp para texto e escreve no novo arquivo
python3 bmpToRamInit.py > "$STRING"

#apaga arquivos intermediarios criados
rm "output.bmp"
rm "imagem.bmp"


done #FIM
