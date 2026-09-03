% Parâmetros do Sistema Dinâmico
m = 100;   
B = 100; 
F = 10;

%% 2. EXECUTAR A SIMULAÇÃO
% Certifique-se de que a chave manual no Simulink está apontada para 
% a entrada que você quer analisar neste momento (ex: Degrau)
sim('modelo_sistema');

%% 3.EXTRAÇÃO DOS DADOS DO WORKSPACE
% Coleta o tempo e as respostas geradas pelos blocos "To Workspace"
tempo = simOut.tout;
aceleracao = simOut.acel.Data;
velocidade = simOut.vel.Data;
posicao = simOut.pos.Data;

%% 4. GERAÇÃO DO GRÁFICO AUTOMÁTICO PARA O RELATÓRIO
figure('Name', 'Analise de Resposta Dinamica', 'NumberTitle', 'off');

% Gráfico 1: Aceleração
subplot(3, 1, 1);
plot(tempo, aceleracao, 'r', 'LineWidth', 1.5);
title('Resposta do Sistema Dinâmico');
ylabel('Aceleração (m/s²)');
grid on;

% Gráfico 2: Velocidade
subplot(3, 1, 2);
plot(tempo, velocidade, 'g', 'LineWidth', 1.5);
ylabel('Velocidade (m/s)');
grid on;

% Gráfico 3: Posição
subplot(3, 1, 3);
plot(tempo, posicao, 'b', 'LineWidth', 1.5);
ylabel('Posição (m)');
xlabel('Tempo (s)');
grid on;

%% 5. SALVAR A IMAGEM AUTOMATICAMENTE
% Salva o gráfico gerado como imagem PNG na mesma pasta para você colar no Word/Relatório
saveas(gcf, 'resultado_simulacao.png');
disp('Gráfico gerado com sucesso e salvo como "resultado_simulacao.png"!');