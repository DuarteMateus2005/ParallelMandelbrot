## Author: Duarte Mateus (62019)
#          Francisca Reis (62029)
#          Laura dos Santos (62032)
## Created: 2024-10-19

#Funcao que calcula o fractal de Mandelbrot distribuindo o esforço
#de computacao pelos cores existente do computador.
#Exige a instalação do pacote parallel e do struct
#pkg install -forge struct
#pkg install -forge parallel

function M = mandelbpar (xmin, xmax, ymin, ymax, maxit, npixh)
 #inicializacao do número de pixeis verticais
 npixv = round(((ymax-ymin)*(npixh-1))/(xmax-xmin))+1;

 #Vamos dividir npixh pelo número de núcleos
 #step vai guardar quantos pixeis horizontais cada núcleo calcula
 step=round(npixh/nproc);

 #stx é um vetor com tantos elementos quanto os núcleos do CPU e para o núcleo i
 #stx(i) indica o primeiro pixel na horizontal que vai calcular
 #O primeiro core ira comecar no pixel 1
 stx=[1];

 #end é um vetor com tantos elementos quanto os núcleos do CPU e para o núcleo i
 #endx(i) indica o último pixel na horizontal que vai calcular
 #O primeiro core ira acabar no step (caso só haja um core step=npixh)
 endx=[step];

 #populamos os intervalos para cada um dos outros núcleos de 2 até ao penúltimo
 for i=2:nproc-1
   stx(i)=endx(i-1)+1;
   endx(i)=endx(i-1)+step;
 endfor

 #O ultimo core terá que terminar em npixh
if nproc>1
  stx(nproc)=endx(nproc-1)+1;
  endx(nproc)=npixh;
endif

 #Definicao da funcao fun que recebe sx e ex e calcula a imagem do do pixel horizontal
 # sx até ao ex, esta funcao é depois distribuida pelos
 #diversos nucleos do PC/MAC utilizando a funcao pararraufun do
 #pacote parallel
 fun=@(sx,ex) mandelbit(xmin, xmax, ymin, ymax, maxit, npixh, npixv,sx,ex);

 #O resuldo é uma lista de matrizes, todas com as mesmas linhas, mas eventualmente
 #a ultima matriz poderá ter um número de colunas ligeiramente diferente
 #devido ao arrendondamento do step
 R=pararrayfun(nproc,fun,stx,endx,"UniformOutput",false);


 # O resultado final é a concatenação de todas as matrizes horizontalmente
  M=R{1};
  for i=2:nproc
    M=horzcat(M,R{i});
  endfor
endfunction

