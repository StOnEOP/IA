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
% Variável 'Custo': 0 -> Distância ; 1 -> Custo
% geraCircuitosNI: Custo, IDEncomenda, SoluçãoBFS, SoluçãoDFS, SoluçãoDLS -> {V,F}
geraCircuitosNI(Custo, IDEncomenda, BFS/CustoB, DFS/CustoD, DLS/CustoL) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    resolve_lp(Custo, Freguesia, amares, Peso, Veiculo, BFS/CustoB),
    resolve_pp(Custo, Freguesia, Peso, Veiculo, DFS/CustoD),
    resolve_pil(Custo, Freguesia, Peso, Veiculo, 10, DLS/CustoL).

% ------------------------------------------
% Gera circuitos recebendo a encomenda, utiliza algoritmos informados (Gulosa, Estrela)
% Variável 'Custo': 0 -> Distância ; 1 -> Custo
% geraCircuitosI: Custo, IDEncomenda, SoluçãoGulosa, SoluçãoEstrela -> {V,F}
geraCircuitosI(Custo, IDEncomenda, Gulosa/CustoG, AEstrela/CustoE) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    resolve_gulosa(Custo, Freguesia, Veiculo, Peso, Gulosa/CustoG),
    resolve_aestrela(Custo, Freguesia, Veiculo, Peso, AEstrela/CustoE).

% ------------------------------------------
% Gera as soluções com o uso de algoritmos informados e não informados
% geraCircuitosAlgoritmos: IDEncomenda, SoluçãoBFS, SoluçãoDFS, SoluçãoDLS, SoluçãoGulosaDistância, SoluçãoGulosaTempo, SoluçãoEstrelaDistância, SoluçãoTempoEstrela -> {V,F}
geraCircuitosAlgoritmos(Custo, IDEncomenda, BFS, DFS, DLS, Gulosa, AEstrela) :-
    Custo >= 0, Custo =< 1,
    geraCircuitosNI(Custo, IDEncomenda, BFS, DFS, DLS),
    geraCircuitosI(Custo, IDEncomenda, Gulosa, AEstrela).

% ------------------------------------------
% Gera todos os trajetos possíveis que passam por uma dada freguesia
% geraCircuitos: Freguesia, Solução -> {V,F}
geraCircuitos(Freguesia, L) :-
    todosCaminhos(L1),
    todosCaminhosTerritorio(Freguesia, L1, L).
    

% ------------------------------------------
% Identificar quais os circuitos com maior número de entregas por volume e peso
% 
circuitosComMaisEntrega(Freguesia, C1, C2, C3) :-
    geraCircuitosSemVolta(Freguesia, L1),
    circuitosComMaisEntregaAUX(L1, C),
    sort(0, @>, C, [C1, C2, C3|_]).

circuitosComMaisEntregaAUX([], []).
circuitosComMaisEntregaAUX([Caminho], [(Max,Caminho3)]) :- 
    contaPesoVolumeCaminho(Caminho, Max),
    reverse(Caminho, Caminho1),
    apagaPrimeiro(Caminho, Caminho2),
    append(Caminho1, Caminho2, Caminho3). 
circuitosComMaisEntregaAUX([Caminho|T], L) :-
        contaPesoVolumeCaminho(Caminho, Count),
        circuitosComMaisEntregaAUX(T, Ls),
        reverse(Caminho, Caminho1),
        apagaPrimeiro(Caminho, Caminho2),
        append(Caminho1, Caminho2, Caminho3), 
        append([(Count, Caminho3)], Ls, L).


contaPesoVolumeCaminho([], 0).
contaPesoVolumeCaminho([Freguesia], Max) :- contaPesoVolume(Freguesia, Max).
contaPesoVolumeCaminho([Freguesia|T], Max) :-
    contaPesoVolume(Freguesia, Max1),
    contaPesoVolumeCaminho(T, Max2),
    Max is Max1 + Max2.

contaPesoVolume(Freguesia, Sum) :-
    findall(Total, (encomenda(_,_,_, Peso, Volume, Freguesia, _,_,_,_), Total is Peso + Volume), L),
        sum_list(L, Sum).

geraCircuitosSemVolta(Freguesia, L) :-
    todosCaminhosSemVolta(L1),
    todosCaminhosTerritorio(Freguesia, L1, L).
    
% ------------------------------------------
% Comparar circuitos de entrega tendo em conta os indicadores de produtividade
% Variável 'Custo': 0 -> Distância ; 1 -> Tempo
% 
comparaCircuitos(Custo, Freguesia, P1, P2, P3) :-
    (Custo == 0 ->
        todosCaminhosDT(0, L1),
        todosCaminhosTerritorioDT(Freguesia, L1, L2),
        sort(0, @<, L2, [P1, P2, P3|_]);
    Custo == 1 ->
        todosCaminhosDT(1, L1),
        todosCaminhosTerritorioDT(Freguesia, L1, L2),
        sort(0, @<, L2, [P1, P2, P3|_])
    ).

% ------------------------------------------
% Obter o circuito mais rápido usando o critério da distância
% 
circuitoMaisRapido(Freguesia, BFS, DFS, DLS, Gulosa, AEstrela, Best) :-
    encomenda(IDEncomenda,_,_,_,_,Freguesia,_,_,_,_),
    geraCircuitosAlgoritmos(0, IDEncomenda, BFS, DFS, DLS, Gulosa, AEstrela),
    obtemMelhor(0, Freguesia, _, _, Best).

% ------------------------------------------
% Obter o cirtuito mais ecológico usando o critério de tempo
% 
circuitoMaisEcologico(Freguesia, Veiculo, BFS, DFS, DLS, Gulosa, AEstrela, Best) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    geraCircuitosAlgoritmos(1, IDEncomenda, BFS, DFS, DLS, Gulosa, AEstrela),
    obtemMelhor(1, Freguesia,Peso , Veiculo, Best).
