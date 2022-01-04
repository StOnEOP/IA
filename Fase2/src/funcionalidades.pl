% ---------------------
% -- FUNCIONALIDADES --
% ---------------------

% ------------------------------------------
% Ficheiros a consultar
:- consult('base_conhecimento.pl').
:- consult('auxiliares.pl').
:- consult('invariantes.pl').

% ------------------------------------------
% Gera circuitos recebendo a encomenda, utiliza algoritmos não informados (BFS, DFS, PPC)
% geraCircuitosNI: IDEncomenda, SoluçãoBFS, SoluçãoDFS -> {V,F}
geraCircuitosNI(IDEncomenda, BFS/CustoB/TempoB, DFS/CustoD/TempoD, DLS/CustoL/TempoL) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Veiculo == 1 ->
        % -- BFS, DFS e DLS com o uso da bicicleta
        resolve_lp(amares, Freguesia, Peso, bicicleta, BFS/CustoB/TempoB),
        resolve_pp(Freguesia, Peso, bicicleta, DFS/CustoD/TempoD),
        resolve_pil(Freguesia, Peso, bicicleta, 10, DLS/CustoL/TempoL);
    Veiculo == 2 ->    
        % -- BFS, DFS e DLS com o uso da moto
        resolve_lp(amares, Freguesia, Peso, moto, BFS/CustoB/TempoB),
        resolve_pp(Freguesia, Peso, moto, DFS/CustoD/TempoD),
        resolve_pil(Freguesia, Peso, moto, 10, DLS/CustoL/TempoL);
    Veiculo == 3 ->
        % -- BFS, DFS e DLS com o uso do carro
        resolve_lp(amares, Freguesia, Peso, carro, BFS/CustoB/TempoB),
        resolve_pp(Freguesia, Peso, carro, DFS/CustoD/TempoD),
        resolve_pil(Freguesia, Peso, carro, 10, DLS/CustoL/TempoL)
    ).

% ------------------------------------------
% Gera circuitos recebendo a encomenda, utiliza algoritmos informados (Gulosa, Estrela)
% geraCircuitosI: IDEncomenda, SoluçãoGulosaDistância, SoluçãoGulosaTEmpo, SoluçãoEstrelaDistância, SoluçãoEstrelaTempo -> {V,F}
geraCircuitosI(IDEncomenda, GulosaD/CGD, GulosaT/CGT ,AEstrelaD/CAD, AEstrelaT/CAT) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
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
% Gera as soluções com o uso de algoritmos informados e não informados
% geraCircuitosAlgoritmos: IDEncomenda, SoluçãoBFS, SoluçãoDFS, SoluçãoDLS, SoluçãoGulosaDistância, SoluçãoGulosaTempo, SoluçãoEstrelaDistância, SoluçãoTempoEstrela -> {V,F}
geraCircuitosAlgoritmos(IDEncomenda, BFS, DFS, DLS, GulosaD, GulosaT, AEstrelaD, AEstrelaT) :-
    geraCircuitosNI(IDEncomenda, BFS, DFS, DLS),
    geraCircuitosI(IDEncomenda, GulosaD, GulosaT, AEstrelaD, AEstrelaT).

% ------------------------------------------
% Gera todos os trajetos possíveis que passam por uma dada freguesia
% geraCircuitos: Freguesia, Solução -> {V,F}
geraCircuitos(Freguesia, L) :-
    todosCaminhos(L1),
    todosCaminhosTerritorio(Freguesia, L1, L).

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
