% ---------------------
% -- FUNCIONALIDADES --
% ---------------------

% ------------------------------------------
% Ficheiros a consultar
:- consult('base_conhecimento.pl').
:- consult('auxiliares.pl').
:- consult('invariantes.pl').

% ------------------------------------------
% Gerar circuitos recebendo a encomenda, utilizando algoritmos não informados (BFS, DFS, PPC)
% geraCircuitosNI:
geraCircuitosNI(IDEncomenda, BFS, DFS/Custo) :-
    encomenda(IDEncomenda, _, _, _, _, Freguesia, _, _, _, _ , _),
    % -- BFS
    bfs(amares, Freguesia, BFS1),
    bfs(Freguesia, amares, BFS2),
    apagaPrimeiro(BFS2, BFS3), append(BFS1, BFS3, BFS),
    % -- DFS
    resolve_pp_d(amares, Freguesia, DFS1, Custo1),
    resolve_pp_d(Freguesia, amares, DFS2, Custo2),
    apagaPrimeiro(DFS2, DFS3), append(DFS1, DFS3, DFS),
    Custo is Custo1 + Custo2.

% ------------------------------------------
% Gerar circuitos recebendo a encomenda, utilizando algoritmos informados (Gulosa, Estrela)
% geraCircuitosI: 
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
% Comparar circuitos de entrega tendo em conta os indicadores de produtividade
% 

% ------------------------------------------
% Obter o circuito mais rápido usando o critério da distância
% 

% ------------------------------------------
% Obter o cirtuito mais ecológico usando o critério de tempo
% 

