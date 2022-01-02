% ---------------------
% -- FUNCIONALIDADES --
% ---------------------

% ------------------------------------------
% Ficheiros a consultar
:- consult('base_conhecimento.pl').
:- consult('auxiliares.pl').
:- consult('invariantes.pl').

% ------------------------------------------
% Gerar circuitos recebendo a encomenda (BFS, DFS, PPC)
% 
geraCircuitosNI(IDEncomenda, BFS, DFS) :-
    encomenda(IDEncomenda, _, _, _, _, Freguesia, _, _, _, _ , _),
    bfs(amares, Freguesia, BFS1),
    bfs(Freguesia, amares, BFS2),
    apagaPrimeiro(BFS2, BFS3), append(BFS1, BFS3, BFS),
    dfs(amares, Freguesia, DFS1),
    dfs(Freguesia, amares, DFS2),
    apagaPrimeiro(DFS2, DFS3), append(DFS1, DFS3, DFS).
    
    %resolve_pp_c(Freguesia, PPC1, C1),
    %reverse(PPC1, PPC2),
    %apagaPrimeiro(PPC2, PPC3), append(PPC3, PPC1, PPC),
    %C is C1 + C1.

% ------------------------------------------
% Gerar circuitos recebendo a encomenda (Gulosa, AEstrela)
% 
geraCircuitosI(IDEncomenda, GulosaD/CGD, GulosaT/CGT ,AEstrelaD/CAD, AEstrelaT/CAT) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _ , _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Veiculo == 1 ->
        resolve_gulosa(Freguesia, bicicleta, Peso, GulosaD/CGD, GulosaT/CGT),
        resolve_aestrela(Freguesia, bicicleta, Peso, AEstrelaD/CAD, AEstrelaT/CAT);
    Veiculo == 2 ->    
        resolve_gulosa(Freguesia, moto, Peso, GulosaD/CGD, GulosaT/CGT),
        resolve_aestrela(Freguesia, moto, Peso, AEstrelaD/CAD, AEstrelaT/CAT);
    Veiculo == 3 ->
        resolve_gulosa(Freguesia, carro, Peso, GulosaD/CGD, GulosaT/CGT),
        resolve_aestrela(Freguesia, carro, Peso, AEstrelaD/CAD, AEstrelaT/CAT)
    ).

% ------------------------------------------
% Identificar quais os circuitos com maior número de entregas por volume e peso
% 

% ------------------------------------------
% Comparar circuitos de entrega entdo em conta os indicadores de produtividade
% 

% ------------------------------------------
% Obter o circuito mais rápido usando o critério da distância
% 

% ------------------------------------------
% Obter o cirtuito mais ecológico usando o critério de tempo
% 

