## Author: Duarte Mateus (62019)
#          Francisca Reis (62029)
#          Laura dos Santos (62032)
## Created: 2024-10-19


% Funcao que define a aplicacao com GUI principal
function create_gui()
    % Cria o painel principal
    fig = figure('Position', [100, 100, 400, 350], 'MenuBar', 'none', ...
                 'Name', 'Mandelbrot', 'NumberTitle', 'off', ...
                 'Resize', 'off');

    % Adiciona os campos xmin e xmax inicilizados com valores sugeridos
    uicontrol('Style', 'text', 'Position', [50, 280, 80, 20], 'String', 'xmin:');
    xmin_edit = uicontrol('Style', 'edit', 'Position', [140, 280, 100, 20],'String', '-2');

    uicontrol('Style', 'text', 'Position', [50, 240, 80, 20], 'String', 'xmax:');
    xmax_edit = uicontrol('Style', 'edit', 'Position', [140, 240, 100, 20], 'String', '1');

    % Adiciona os campos ymin e ymax inicilizados com valores sugeridos
    uicontrol('Style', 'text', 'Position', [50, 200, 80, 20], 'String', 'ymin:');
    ymin_edit = uicontrol('Style', 'edit', 'Position', [140, 200, 100, 20], 'String', '-1.1');

    uicontrol('Style', 'text', 'Position', [50, 160, 80, 20], 'String', 'ymax:');
    ymax_edit = uicontrol('Style', 'edit', 'Position', [140, 160, 100, 20], 'String', '1.1');

    % Adiciona os campos maxit e xmax inicilizados com valores sugeridos
    uicontrol('Style', 'text', 'Position', [50, 120, 80, 20], 'String', 'maxit:');
    maxit_edit = uicontrol('Style', 'edit', 'Position', [140, 120, 100, 20], 'String', '300');

    uicontrol('Style', 'text', 'Position', [50, 80, 80, 20], 'String', 'npixh:');
    npixh_edit = uicontrol('Style', 'edit', 'Position', [140, 80, 100, 20], 'String', '300');

    % Adiciona uma checkbox para paralelizar, por omissao está sem valor
    parallelize_checkbox = uicontrol('Style', 'checkbox', 'Position', [50, 40, 150, 20], ...
                                     'String', 'Paralelizar', 'Value', 0);


   % Adiciona um grupo de botoes de radio para escolher a cor de fundo
    color_button_group = uibuttongroup('Position', [0.65, 0.55, 0.3, 0.3], ...
                                       'Title', 'Cor de Fundo', 'SelectionChangedFcn', @selection_changed);
    azul_radio = uicontrol(color_button_group, 'Style', 'radiobutton', ...
                           'String', 'Azul', 'Position', [10, 60, 100, 30]);
    vermelho_radio = uicontrol(color_button_group, 'Style', 'radiobutton', ...
                               'String', 'Vermelho', 'Position', [10, 30, 100, 30]);
    verde_radio = uicontrol(color_button_group, 'Style', 'radiobutton', ...
                            'String', 'Verde', 'Position', [10, 0, 100, 30]);


    % Adiciona um botão que invoca a funcao para criar a imagem
    uicontrol('Style', 'pushbutton', 'Position', [260, 80, 100, 30], ...
              'String', 'Criar Fractal', ...
              'Callback', {@call_function, xmin_edit, xmax_edit, ymin_edit, ymax_edit, maxit_edit, npixh_edit, parallelize_checkbox,azul_radio,verde_radio});

    % Adiciona um botão para fechar a imagem
    uicontrol('Style', 'pushbutton', 'Position', [260, 40, 100, 30], ...
              'String', 'Fechar', ...
              'Callback', @(src, event) close(fig));
end



 % Funcao para criar a imagem
function call_function(~, ~, xmin_edit, xmax_edit, ymin_edit, ymax_edit, maxit_edit, npixh_edit, parallelize_checkbox,azul_radio,verde_radio)
    % Retira os valores das parâmetros dos campos
    xmin = str2double(get(xmin_edit, 'String'));
    xmax = str2double(get(xmax_edit, 'String'));
    ymin = str2double(get(ymin_edit, 'String'));
    ymax = str2double(get(ymax_edit, 'String'));
    maxit = str2double(get(maxit_edit, 'String'));
    npixh = str2double(get(npixh_edit, 'String'));
    parallelize = get(parallelize_checkbox, 'Value');
    azul_selected = get(azul_radio,'Value');
    verde_selected = get(verde_radio,'Value');

    %verifica se os valores são válidos
    if isnan(xmin)||isnan(xmax)||isnan(ymin)||isnan(ymax)||isnan(maxit)||isnan(npixh)
      errordlg('Por favor coloque valores válidos para os campos', 'Entradas Inválidas');
      return;
    endif

    %calcula o mapa de cores de acordo com o enunciado
    maxitn = int32(maxit);
    cmap=hsv(maxitn-1);
    cmap=[cmap;[0,0,0]];
    if azul_selected
       cor=[0,0,1;1,0,0;0,1,0];
       cmap=cmap*cor;
     elseif verde_selected
       cor=[0,1,0;1,0,0;0,0,1];
       cmap=cmap*cor;
     endif

    %testa se a checkbox paralizar está verificada
    if parallelize==1
      %Testa se o pacote para paralizar está instalado e carregado
      pacotes=pkg('list','parallel');
      if isempty(pacotes)||pacotes{1,1}.loaded==0
         errordlg('O Pacote parallel não está instalado ou carregado!', 'Pacote não carregado!');
        return;
      endif

      %Mensagem informando que os cálculos estão a decorrer
      h = msgbox('Cálculos em progresso, por favor aguarde...');
      %Caso tudo funcione chama a funcao madelbpar que calcula M usado os varios cores do PC/MAC
      tic; %instrucao usada para calcular inciar um contador de tempo
      M=mandelbpar(xmin,xmax,ymin,ymax,maxit,npixh); %chamada da função paralela
      elapsed_time=toc; %termina a contagem do tempo e esta fica guardado na variavel elapsed_time

      %Remoção da mensagem de informacao
      delete(h)

     else % Caso não se chame a execução em paralelo

      h = msgbox('Cálculos em progresso, por favor aguarde...');
      tic; %instrucao usada para calcular inciar um contador de tempo
      M=mandelb(xmin,xmax,ymin,ymax,maxit,npixh); %chamada da função sequencial
      elapsed_time=toc;%termina a contagem do tempo e esta fica guardado na variavel elapsed_time
      delete(h)
     endif

    %Criação de um novo painel apresentado a imagem e botao para gravar a mesma
    create_gui_with_colormap_image(M,cmap);

    %Criaçao de uma caixa de mensagem a indicar o tempo demorado
    msgbox(sprintf('Demorou %.2f segundos a criar a imagem.\n', elapsed_time), 'Tempo de execução');
end

% Funcao que apresenta a imagem num painel
function create_gui_with_colormap_image(M,cmap)
    % Criacao de painel principal
    fig = figure('Position', [100, 100, 600, 600], 'MenuBar', 'none', ...
                 'Name', 'Mandelbrot', 'NumberTitle', 'off', ...
                 'Resize', 'off');

    % Criacao do painel on vai ficar a imagem
    panel = uipanel('Title', 'Imagem', 'FontSize', 12, ...
                    'Position', [0.05, 0.1, 0.9, 0.85]);

    % Criacao dos eixos do painel
    ax = axes('Parent', panel, 'Position', [0.1, 0.1, 0.8, 0.8]);

    % Apresentacao da imagem no painel
    imshow(M, cmap, 'Parent', ax);


    % Adicao de um botao com a funcao para gravar a imagem
    uicontrol('Style', 'pushbutton', 'Position', [400, 20, 80, 30], ...
              'String', 'Gravar', ...
              'Callback', {@gravar, M,cmap});

    % Adicao de um botao com a funcao para fechar a aplicacao
    uicontrol('Style', 'pushbutton', 'Position', [500, 20, 80, 30], ...
              'String', 'Fechar', ...
              'Callback', @(src, event) close(fig));
end

% Funcao que grava a imagem num ficheiro
function gravar(~, ~, M,cmap)
   % Abertura do diálogo de gravacao de imagem
   [filename, pathname] = uiputfile({'*.png';'*.jpg';'*.bmp';'*.tif'}, 'Save Image As');

   % Verificacao da validade do ficheiro e caminho
  if isequal(filename, 0) || isequal(pathname, 0)
      msgbox('Utilizador cancelou a operaçao de gravacao.','Cancelamento');
   else
    % Construcao do ficheiro para gravacao
    filepath = fullfile(pathname, filename);

    % Gravacao da imagem
    imwrite(M, cmap, filepath);

    % Informacao de gravacao de ficheiro
    msgbox(['Imagem gravada para: ', filepath], 'Gravacao');
  endif
end

create_gui();
