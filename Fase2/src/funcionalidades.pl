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
circuitosComMaisEntrega(Freguesia, Max, C1, C2, C3, C4, C5) :-
    geraCircuitosSemVolta(Freguesia, L1),
    circuitosComMaisEntregaAUX(Max, L1, [C1, C2, C3, C4, C5|_]).

circuitosComMaisEntregaAUX(0, [], []).
circuitosComMaisEntregaAUX(Max, [Caminho], [Caminho]) :- contaPesoVolumeCaminho(Caminho, Max).
circuitosComMaisEntregaAUX(Max, [Caminho|T], L) :- contaPesoVolumeCaminho(Caminho, Count),
                                                   circuitosComMaisEntregaAUX(CountMax, T, Ls),
                                                   (Count > CountMax -> Max = Count,
                                                    reverse(Caminho, Caminho1),
                                                    apagaPrimeiro(Caminho, Caminho2),
                                                    append(Caminho1, Caminho2, Caminho3), 
                                                    L = [Caminho3];
                                                    Count == CountMax -> Max = CountMax, 
                                                    reverse(Caminho, Caminho1),
                                                    apagaPrimeiro(Caminho, Caminho2),
                                                    append(Caminho1, Caminho2, Caminho3),
                                                    L = [Caminho3|Ls]; 
                                                    Max = CountMax, L = Ls).

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
% 
getAllCaminhosDC(Freguesia, L) :- 
    geraCircuitos(Freguesia, L1),
    getDistanciaTempoCircuito(L1, L).


getDistanciaTempoCircuito([], []/0/0).
getDistanciaTempoCircuito([Caminho], [[amares|Caminho1]/C/T]) :- 
    getDistanciaTempoCaminho(Caminho, Caminho1/C/T).
getDistanciaTempoCircuito([Caminho|Tail], L) :-
    getDistanciaTempoCaminho(Caminho, L1/C/T),
    L2 = [amares|L1]/C/T,
    getDistanciaTempoCircuito(Tail, Ls),
    append([L2], Ls, L).

getDistanciaTempoCaminho([Freguesia, ProxFreguesia], [ProxFreguesia]/C/T) :-
    encomenda(_, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Veiculo == 1 ->
        ligacaoC(Freguesia, ProxFreguesia, C),
        custoT(Peso, Freguesia, ProxFreguesia, bicicleta, T),
    Veiculo == 2 ->    
        ligacaoC(Freguesia, ProxFreguesia, C),
        custoT(Peso, Freguesia, ProxFreguesia, moto, T);
    Veiculo == 3 ->
        ligacaoC(Freguesia, ProxFreguesia, C),
        custoT(Peso, Freguesia, ProxFreguesia, carro, T)
    ).
getDistanciaTempoCaminho([Freguesia,ProxFreguesia|Tail], L/C/T) :-
    encomenda(_, _, _, Peso, _, ProxFreguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Veiculo == 1 ->
        ligacaoC(Freguesia, ProxFreguesia, C1),
        custoT(Peso, Freguesia, ProxFreguesia, bicicleta, T1),
        getDistanciaTempoCaminho([ProxFreguesia|Tail], L1/C2/T2),
        append([ProxFreguesia], L1, L),
        C is C1 + C2, T is T1 + T2;
    Veiculo == 2 ->    
        ligacaoC(Freguesia, ProxFreguesia, C1),
        custoT(Peso, Freguesia, ProxFreguesia, moto, T1),
        getDistanciaTempoCaminho([ProxFreguesia|Tail], L1/C2/T2),
        append([ProxFreguesia], L1, L),
        C is C1 + C2, T is T1 + T2;
    Veiculo == 3 ->
        ligacaoC(Freguesia, ProxFreguesia, C1),
        custoT(Peso, Freguesia, ProxFreguesia, carro, T1),
        getDistanciaTempoCaminho([ProxFreguesia|Tail], L1/C2/T2),
        append([ProxFreguesia], L1, L),
        C is C1 + C2, T is T1 + T2
    ).

getDistancia([Freguesia,ProxFreguesia], [ProxFreguesia]/C) :- ligacaoC(Freguesia, ProxFreguesia, C).
getDistancia([Freguesia,ProxFreguesia|T], L/C) :-
        ligacaoC(Freguesia, ProxFreguesia, C1),
        getDistancia([ProxFreguesia|T], L1/C2),
        append([ProxFreguesia], L1, L),
        C is C1 + C2.
    

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
