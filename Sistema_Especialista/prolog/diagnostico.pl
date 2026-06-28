% ==============================================================================
% Laboratório de Programação - 2026/1
% Sistema Especialista para Diagnóstico de Falhas Automotivas (Paradigma Lógico)
% Docente: Prof. Sofiane Ben El Hedi Labidi
% Alunos: Deborah Sophia, Samira Farias, Samuel Carvalho, Thalita Amorim
% ==============================================================================

% --- REGRAS DE DIAGNÓSTICO (Estilo Declarativo por Listas) ---

% O diagnóstico X é verdadeiro para uma Lista de Sintomas se os sintomas exigidos estão nela.
% member(Sintoma, Lista) verifica de forma nativa e lógica se o sintoma faz parte da escolha.

diagnostico(bateria_descarregada, Sintomas) :- 
    member(motor_nao_liga, Sintomas), 
    member(luz_bateria_acesa, Sintomas).

diagnostico(motor_partida_travado, Sintomas) :- 
    member(motor_nao_liga, Sintomas), 
    member(ruido_metalico, Sintomas).

diagnostico(vazamento_combustivel, Sintomas) :- 
    member(cheiro_combustivel, Sintomas).

diagnostico(queima_junta_cabecote, Sintomas) :- 
    member(superaquecimento, Sintomas), 
    member(fumaca_branca, Sintomas).

% Se tiver fumaça branca mas NÃO TIVER (\+) superaquecimento, é desgaste de anéis
diagnostico(desgaste_aneis_segmento, Sintomas) :- 
    member(fumaca_branca, Sintomas), 
    \+ member(superaquecimento, Sintomas).

diagnostico(problema_bicos_injetores, Sintomas) :- 
    member(consumo_alto, Sintomas), 
    member(motor_falhando, Sintomas), 
    member(luz_injecao_acesa, Sintomas).

diagnostico(alternador_defeito, Sintomas) :- 
    member(luz_bateria_acesa, Sintomas), 
    member(motor_gira_lento, Sintomas).


% --- INTERFACE DE INFERÊNCIA ---

% Regra para rodar o diagnóstico e imprimir o resultado formatado na tela
gerar_diagnostico(Sintomas) :-
    diagnostico(Falha, Sintomas),
    format('~n==================================================~n'),
    format('RESULTADO DO DIAGNÓSTICO (Prolog Lógico)~n'),
    format('==================================================~n'),
    format('Falha provavel identificada: ~w~n', [Falha]),
    format('==================================================~n'),
    !. % O corte impede respostas duplicadas ou genéricas

% Caso nenhuma regra acima seja unificada com os sintomas passados
gerar_diagnostico(_) :-
    format('~n==================================================~n'),
    format('[AVISO] Nenhum diagnostico correspondente encontrado.~n'),
    format('==================================================~n').
