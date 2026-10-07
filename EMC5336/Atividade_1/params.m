% Parametros do sistema 
Kq0 = 2.15;      
A   = 6.597e-3;
l1  = 0.1;        
 
nome_do_modelo = 'modelo_sistema_2';
 
% Casos: [relacao l2/l1, amplitude do degrau (m)] 
casos = [10 0.1;
         10 0.2;
         20 0.1;
         20 0.2];
 
for k = 1:size(casos,1)
    razao = casos(k,1);
    amp   = casos(k,2);        % usada no bloco Step
    l2    = razao*l1;          % usada nos blocos Gain
 
    clear out posicao velocidade tout
    sim(nome_do_modelo);
 
    if exist('out','var')
        tempo = out.tout; xA = out.posicao; vA = out.velocidade;
    else
        tempo = tout;     xA = posicao;     vA = velocidade;
    end
 
    tau = A*l2/(Kq0*l1);
    fprintf('l2/l1=%2d | degrau=%.1f m | tau=%.4f s | xA_final=%.3f m | vA_max=%.2f m/s\n', ...
            razao, amp, tau, xA(end), max(vA));
 
    sufixo  = sprintf('razao%d_degrau%s', razao, strrep(num2str(amp),'.','p'));
    legenda = sprintf('l_2/l_1 = %d, degrau %.1f m', razao, amp);
 
    titulos  = {['Posição do Atuador - ' legenda], ['Velocidade do Atuador - ' legenda]};
    ylabels  = {'Posição x_{A1} (m)', 'Velocidade dx_{A1}/dt (m/s)'};
    arquivos = {['Posicao_' sufixo '.png'], ['Velocidade_' sufixo '.png']};
    dados    = {xA, vA};
 
    for i = 1:2
        fig = figure('Color', [0.15 0.15 0.15], 'Visible', 'on');
 
        plot(tempo, dados{i}, 'm', 'LineWidth', 1.5);
 
        grid on;
        set(gca, 'Color', 'black', 'GridColor', [0.3 0.3 0.3], 'GridAlpha', 0.5);
        set(gca, 'XColor', 'white', 'YColor', 'white');
 
        title(titulos{i}, 'Color', 'white', 'FontSize', 12);
        xlabel('Tempo (s)', 'Color', 'white');
        ylabel(ylabels{i}, 'Color', 'white');
        xlim([0 5]);
 
        print(fig, arquivos{i}, '-dpng', '-r300');
        close(fig);
    end
end
