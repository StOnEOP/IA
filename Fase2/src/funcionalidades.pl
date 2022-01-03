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
geraCircuitosNI(IDEncomenda, BFS/CustoB/TempoB, DFS/CustoD/TempoD) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _ , _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Veiculo == 1 ->
        % -- BFS
        resolve_lp_d(amares, Freguesia, BFS/CustoB),
        resolve_lp_t(amares, Freguesia, Peso, bicicleta, _/TempoB),
        % -- DFS
        resolve_pp_d(Freguesia, DFS, CustoD),
        resolve_pp_t(Freguesia, Peso,bicicleta, _, TempoD);
    Veiculo == 2 ->    
        % -- BFS
        resolve_lp_d(amares, Freguesia, BFS/CustoB),
        resolve_lp_t(amares, Freguesia, Peso, moto, _/TempoB),
        % -- DFS
        resolve_pp_d(Freguesia, DFS, CustoD),
        resolve_pp_t(Freguesia, Peso, moto, _, TempoD);
    Veiculo == 3 ->
        % -- BFS
        resolve_lp_d(amares, Freguesia, BFS/CustoB),
        resolve_lp_t(amares, Freguesia, Peso, carro, _/TempoB),
        % -- DFS
        resolve_pp_d(Freguesia, DFS, CustoD),
        resolve_pp_t(Freguesia, Peso, carro, _, TempoD)
    ).

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

geraCircuitos(IDEncomenda, BFS, DFS, GulosaD, GulosaT, AEstrelaD, AEstrelaT) :-
    geraCircuitosNI(IDEncomenda, BFS, DFS),
    geraCircuitosI(IDEncomenda, GulosaD, GulosaT, AEstrelaD, AEstrelaT).

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

