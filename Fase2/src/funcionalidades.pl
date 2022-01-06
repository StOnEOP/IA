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
geraCircuitosNI(Algoritmo, Custo, IDEncomenda, Travessia/CustoT) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Algoritmo == 'bfs' ->
        resolve_lp(Custo, Freguesia, amares, Peso, Veiculo, Travessia/CustoT);
    Algoritmo == 'dfs' ->    
        resolve_pp(Custo, Freguesia, Peso, Veiculo, Travessia/CustoT);
    Algoritmo == 'ids' ->   
        resolve_pil(Custo, Freguesia, Peso, Veiculo, 10, Travessia/CustoT)).    

% ------------------------------------------
% Gera circuitos recebendo a encomenda, utiliza algoritmos informados (Gulosa, Estrela)
% Variável 'Custo': 0 -> Distância ; 1 -> Custo
% geraCircuitosI: Custo, IDEncomenda, SoluçãoGulosa, SoluçãoEstrela -> {V,F}
geraCircuitosI(Algoritmo, Custo, IDEncomenda, Travessia/CustoT) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Algoritmo == 'gulosa' ->
        resolve_gulosa(Custo, Freguesia, Veiculo, Peso, Travessia/CustoT);
    Algoritmo == 'aestrela' ->   
        resolve_aestrela(Custo, Freguesia, Veiculo, Peso, Travessia/CustoT)).

% ------------------------------------------
% Gera as soluções com o uso de algoritmos informados e não informados
% geraCircuitosAlgoritmos: IDEncomenda, SoluçãoBFS, SoluçãoDFS, SoluçãoDLS, SoluçãoGulosaDistância, SoluçãoGulosaTempo, SoluçãoEstrelaDistância, SoluçãoTempoEstrela -> {V,F}
geraCircuitosAlgoritmos(Algoritmo, Custo, IDEncomenda, Travessia) :-
    Custo >= 0, Custo =< 1,
    (Algoritmo \== 'gulosa', Algoritmo \== 'aestrela' ->
        geraCircuitosNI(Algoritmo, Custo, IDEncomenda, Travessia);
    geraCircuitosI(Algoritmo, Custo, IDEncomenda, Travessia)).

% ------------------------------------------
% Gera todos os trajetos possíveis que passam por uma dada freguesia
% geraCircuitos: Freguesia, Solução -> {V,F}
geraCircuitos(Freguesia, L, Length) :-
    todosCaminhos(L1),
    todosCaminhosTerritorio(Freguesia, L1, L),
    length(L, Length).

% ------------------------------------------
% Identificar quais os circuitos com maior número de entregas por volume e peso
% 
circuitosComMaisEntrega(Freguesia, C1, C2, C3) :-
    geraCircuitosSemVolta(Freguesia, L1),
    circuitosComMaisEntregaAUX(L1, C),
    sort(0, @>, C, [C1, C2, C3|_]).

% retorna lista com caminhos [(Peso + Volume, Caminho)]
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

% Conta o Volume + Peso de um Caminho
contaPesoVolumeCaminho([], 0).
contaPesoVolumeCaminho([Freguesia], Max) :- contaPesoVolume(Freguesia, Max).
contaPesoVolumeCaminho([Freguesia|T], Max) :-
    contaPesoVolume(Freguesia, Max1),
    contaPesoVolumeCaminho(T, Max2),
    Max is Max1 + Max2.

% Soma o peso e volume de todas as encomendas de uma Freguesia
contaPesoVolume(Freguesia, Sum) :-
    findall(Total, (encomenda(_,_,_, Peso, Volume, Freguesia, _,_,_,_), Total is Peso + Volume), L),
        sum_list(L, Sum).

% Gera os circuitos sem volta, i.e, [Freguesia....amares] ou [amares... Freguesia]
geraCircuitosSemVolta(Freguesia, L) :-
    todosCaminhosSemVolta(L1),
    todosCaminhosTerritorio(Freguesia, L1, L).
    
% ------------------------------------------
% Comparar circuitos de entrega tendo em conta os indicadores de produtividade
% Variável 'Custo': 0 -> Distância ; 1 -> Tempo
% 
comparaCircuitos(Custo, Freguesia, TravessiaDFS, TravessiaBFS, TravessiaIDS, TravessiaG, TravessiaAE) :-
    encomenda(IDEncomenda,_,_,_,_,Freguesia,_,_,_,_),
    (Custo == 0 ->
        geraCircuitosAlgoritmos(dfs, 0, IDEncomenda, TravessiaDFS),
        geraCircuitosAlgoritmos(bfs, 0, IDEncomenda, TravessiaBFS),
        geraCircuitosAlgoritmos(ids, 0, IDEncomenda, TravessiaIDS),
        geraCircuitosAlgoritmos(gulosa, 0, IDEncomenda, TravessiaG),
        geraCircuitosAlgoritmos(aestrela, 0, IDEncomenda, TravessiaAE);
    Custo == 1 ->
        geraCircuitosAlgoritmos(dfs, 1, IDEncomenda, TravessiaDFS),
        geraCircuitosAlgoritmos(bfs, 1, IDEncomenda, TravessiaBFS),
        geraCircuitosAlgoritmos(ids, 1, IDEncomenda, TravessiaIDS),
        geraCircuitosAlgoritmos(gulosa, 1, IDEncomenda, TravessiaG),
        geraCircuitosAlgoritmos(aestrela, 1, IDEncomenda, TravessiaAE)
    ).

% ------------------------------------------
% Obter o circuito mais rápido usando o critério da distância
% 
circuitoMaisRapido(IDEncomenda, Freguesia, Travessia) :-
    encomenda(IDEncomenda, _, _, _, _, Freguesia, _, _, _, _),
    obtemMelhor(0, Freguesia, _, _, Travessia).

% ------------------------------------------
% Obter o cirtuito mais ecológico usando o critério de tempo
% 
circuitoMaisEcologico(IDEncomenda, Freguesia, Veiculo, Peso, Travessia) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    obtemMelhor(1, Freguesia,Peso , Veiculo, Travessia).
