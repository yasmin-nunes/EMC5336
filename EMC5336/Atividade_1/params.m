% Parâmetros do Sistema Dinâmico
m = 100;   
B = 100; 
F = 10;

% 1. Nome do seu arquivo do Simulink (sem o .slx)
nome_do_modelo = 'modelo_sistema'; 


sim(nome_do_modelo);

tempo = tout;

titulos = {'Aceleração Rampa', 'Velocidade Rampa', 'Posição Rampa', 'Força Aplicada {Rampa}'};
arquivos = {'Aceleracao_Rampa.png', 'Velocidade_Rampa.png', 'Posicao_Rampa.png', 'Forca_Aplicada_Rampa.png'};

for i = 1:length(titulos)
    if i == 1, dados = aceleracao;
    elseif i == 2, dados = velocidade;
    elseif i == 3, dados = posicao;
    else, dados = forca;
    end

    fig = figure('Color', [0.15 0.15 0.15], 'Visible', 'on'); 
    
    plot(tempo, dados, 'm', 'LineWidth', 1.5); 
    
    grid on;
    set(gca, 'Color', 'black', 'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.5);
    set(gca, 'XColor', 'white', 'YColor', 'white');
    
    title(titulos{i}, 'Color', 'white', 'FontSize', 12);
    xlabel('Tempo (s)', 'Color', 'white');
    ylabel(titulos{i}, 'Color', 'white');
    xlim([0 10]); % Limita o eixo X em 10 segundos
    
    print(fig, arquivos{i}, '-dpng', '-r300');
    close(fig);
end

