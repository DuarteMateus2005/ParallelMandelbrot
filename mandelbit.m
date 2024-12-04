
## Author: Duarte Mateus (62019)
#          Francisca Reis (62029)
#          Laura dos Santos (62032)
## Created: 2024-10-19

# Funcao que calcula o conjunto de Mandelbrot entre xmin a xman e ymin a ymax,
# parando no numero maximo de iteradas maxit, numa imagem cuja resolucao
#horizontal é npixh
function M=mandelbit(xmin, xmax, ymin, ymax, maxit, npixh, npixv, startxh, endxh)
  # Calculo da dimensao vertical da imagem a gerar
  #npixv = round(((ymax-ymin)*(npixh-1))/(xmax-xmin))+1;

  # inicializacao da variavel resultado
  # O numero de linhas e a dimensao vertical
  # O numero de colunas e a dimensao horizontal
  # A matriz e inicializada toda a zeros
  M = zeros(npixv,endxh-startxh+1);

  #Ciclo que itera sobre todas as posições verticais
  for n=startxh:endxh

   #Ciclo que itera sobre todas as posições horizontais
    for m=1:npixv
      #Calculo do x correspondente a posicao m,n da matriz
      #Divide-se a imagem em npixh-1 intervalos no horizontal
      # cada um com amplitude ah=(xmax-xmin)/(npixh-1).
      # Com npixh-1 intervalos obtem-se npixh pontos
      #o primeiro ponto corresponde a xmin,
      #o segundo a xmin + ah,
      #o ké-simo a xmin +(k-1)*ah,
      #o último ponto e xmin+(npixh-1)*ah=xmax.
      x = xmin+(n-1)*(xmax-xmin)/(npixh-1);

      # Calculo do y corresponde 'a posicao vertical
      # De forma sememlhante divide-se a imagem npixv-1 intervalos na vertical
      # para obter npixv pontos
      y = ymin + (npixv-m)*(ymax-ymin)/(npixv-1);

      #c é complexo para o qual se verifica a convergencia
      #da sucessao de Mandelbrot no ponto c=x+i*y
      c = x + i*y;

      #inicia-se a sucessao de Mandelbrot z0=0+i0
      z = 0;

      #inicia-se o contador de iteracoes da sucessao
      contador = 0;

      #Para-se de iterar caso |z|>2, pois neste caso a sucessao diverge ou
      #se for atingido o maxit
      while (abs(z)<=2 && contador < maxit)

        #atualiza-se z_k+1=z_k^2+c o passo da sucessao
        z = z^2+c;

        #incrementa-se o contador
        contador+=1;
      endwhile

      #guarda-se o valor do contador na variavel resultado
      M(m,n-startxh+1)=contador;
    endfor
  endfor
endfunction
