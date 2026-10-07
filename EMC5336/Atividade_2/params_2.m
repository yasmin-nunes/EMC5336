%% Atividade 3 - EMC 5336 - Servo-atuador hidraulico
% Declara variaveis, roda o modelo Simulink e gera os graficos.
clear; clc; close all;
 
% ---- Parametros ----
Kq0 = 2.15;  A = 6.597e-3;  l1 = 0.1;
nome_do_modelo = 'modelo_sistema';
nome_pos = 'posicao';  nome_vel = 'velocidade';
t_deg = 1;                         % instante do degrau (s)
 
razoes = [10 20];                  % l2/l1
amps   = [0.1 0.2];                % amplitudes do degrau (m)
zoom   = [0.95 1.40;               % janela de zoom para l2/l1 = 10
          0.95 1.60];              % janela de zoom para l2/l1 = 20
cor_amp = {'m','c'};               % cores: degrau 0,1 e 0,2 m
cor_raz = {'g','m'};               % cores: l2/l1 = 10 e 20
 
pasta = fullfile(pwd,'graficos');
if ~exist(pasta,'dir'), mkdir(pasta); end
 
% ---- Simulacoes ----
for r = 1:numel(razoes)
    l2 = razoes(r)*l1;
    for a = 1:numel(amps)
        amp = amps(a);
        clear('tout', nome_pos, nome_vel);
        sim(nome_do_modelo);
 
        xA = eval(nome_pos);  vA = eval(nome_vel);
        if isa(xA,'timeseries'), t = xA.Time; xA = xA.Data; else, t = tout; end
        if isa(vA,'timeseries'), vA = vA.Data; end
 
        D(r,a).t  = t;
        D(r,a).xZ = amp*(t >= t_deg);          % entrada degrau
        D(r,a).xA = squeeze(xA);
        D(r,a).vA = squeeze(vA);
    end
end
 
%% ---- FIGURA 1: uma por relacao l2/l1 (entrada, posicao, velocidade) ----
% Coluna esquerda: 0 a 5 s | Coluna direita: zoom na transicao
campos = {'xZ','xA','vA'};
ylabs  = {'x_{Z1} (m)','x_{A1} (m)','dx_{A1}/dt (m/s)'};
for r = 1:numel(razoes)
    fig = figure('Color',[0.15 0.15 0.15],'Position',[100 100 1200 800]);
    for i = 1:3
        for c = 1:2
            subplot(3,2,2*(i-1)+c); hold on;
            for a = 1:numel(amps)
                plot(D(r,a).t, D(r,a).(campos{i}), cor_amp{a}, 'LineWidth',1.5);
            end
            grid on;
            if c == 1
                xlim([0 5]); ylabel(ylabs{i},'Color','white');
                legend(arrayfun(@(x) sprintf('degrau %.1f m',x),amps,'UniformOutput',false), ...
                       'TextColor','white','Color','black','Location','best');
            else
                xlim(zoom(r,:));
            end
            if i == 3, xlabel('Tempo (s)','Color','white'); end
            if i == 1 && c == 1, title(sprintf('l_2/l_1 = %d - simulação completa',razoes(r)),'Color','white'); end
            if i == 1 && c == 2, title(sprintf('Detalhe da transição (%.2f a %.2f s)',zoom(r,1),zoom(r,2)),'Color','white'); end
        end
    end
    set(findall(fig,'type','axes'),'Color','black','GridColor',[0.3 0.3 0.3],'GridAlpha',0.5,'XColor','white','YColor','white');
    print(fig, fullfile(pasta, sprintf('Resposta_razao%d.png',razoes(r))), '-dpng','-r300');
    close(fig);
end
 
%% ---- FIGURA 2: comparacao l2/l1 = 10 x 20 (degrau de 0,1 m) ----
% Linha 1: posicao | Linha 2: posicao normalizada (xA/xA_final) | Linha 3: velocidade
% A curva normalizada deixa a diferenca de velocidade de resposta bem visivel.
fig = figure('Color',[0.15 0.15 0.15],'Position',[100 100 1200 800]);
rotulos = {'x_{A1} (m)','x_{A1} / x_{A1,final}','dx_{A1}/dt (m/s)'};
for i = 1:3
    for c = 1:2
        subplot(3,2,2*(i-1)+c); hold on;
        for r = 1:numel(razoes)
            y = D(r,1).xA;  v = D(r,1).vA;
            if i == 1, dado = y; elseif i == 2, dado = y/y(end); else, dado = v; end
            plot(D(r,1).t, dado, cor_raz{r}, 'LineWidth',1.5);
        end
        grid on;
        if c == 1
            xlim([0 5]); ylabel(rotulos{i},'Color','white');
            legend('l_2/l_1 = 10','l_2/l_1 = 20','TextColor','white','Color','black','Location','best');
        else
            xlim([0.95 1.6]);
        end
        if i == 2 && c == 2, yline(0.632,':w'); end    % 63,2% (t = tau)
        if i == 3, xlabel('Tempo (s)','Color','white'); end
        if i == 1 && c == 1, title('Degrau de 0,1 m - simulação completa','Color','white'); end
        if i == 1 && c == 2, title('Detalhe da transição (0,95 a 1,6 s)','Color','white'); end
    end
end
set(findall(fig,'type','axes'),'Color','black','GridColor',[0.3 0.3 0.3],'GridAlpha',0.5,'XColor','white','YColor','white');
print(fig, fullfile(pasta,'Comparacao_razao10_x_razao20.png'), '-dpng','-r300');
close(fig);
 
disp(['Graficos salvos em: ' pasta]);
