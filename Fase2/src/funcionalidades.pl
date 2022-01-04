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
circuitosComMaisEntrega(Freguesia, L, Max) :-
    geraCircuitosSemVolta(Freguesia, L1),
    circuitosComMaisEntregaAUX(Max, L1, L).

circuitosComMaisEntregaAUX(0, [], []).
circuitosComMaisEntregaAUX(Max, [Caminho], [Caminho]) :- contaPesoVolumeCaminho(Caminho, Max).
circuitosComMaisEntregaAUX(Max, [Caminho|T], L) :- contaPesoVolumeCaminho(Caminho, Count),
                                                   circuitosComMaisEntregaAUX(CountMax, T, Ls),
                                                   (Count > CountMax -> Max = Count, L = [Caminho];
                                                    Count == CountMax -> Max = CountMax, L = [Caminho|Ls]; 
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
% geraCircuitosAlgoritmos(IDEncomenda, BFS, DFS, DLS, GulosaD, GulosaT, AEstrelaD, AEstrelaT)

%obtemMelhor(1, Nodo, Peso, Veiculo, _, S, D, T)

circuitoMaisRapido(Freguesia, BFS, DFS, DLS, GulosaD, AEstrelaD, Best) :-
    encomenda(IDEncomenda,_,_,_,_,Freguesia,_,_,_,_,_),
    geraCircuitosAlgoritmos(IDEncomenda, BFS, DFS, DLS, GulosaD, _, AEstrelaD, _).



% -- BFS com distância
obtemMelhor(Nodo, NodoF,S/D) :-
	findall((SS, DD), resolve_lp_d(Nodo, NodoF, SS/DD), L),
	minimo(L, (S, D)).
% -- BFS com tempo
obtemMelhor(0, 1, Nodo, NodoF, Peso, Veiculo, S, T) :-
	findall((SS, TT), resolve_lp_t(Nodo, NodoF, Peso, Veiculo, SS/TT), L),
	minimo(L, (S, T)).

% -- Custo = Distância
resolve_lp_d(EstadoI, EstadoF, Solucao) :-
    larguraprimeiroD(EstadoF, [([EstadoI]/0)], Solucao).
larguraprimeiroD(EstadoF, [[EstadoF|T]/D|_] , Solucao/D) :-
    reverse([EstadoF|T], Solucao).
larguraprimeiroD(EstadoF, [EstadosA/D1|Outros], Solucao) :-
    EstadosA=[Act|_],
    findall(([EstadoX|EstadosA]/D), (EstadoF\==Act, ligacaoC(Act,EstadoX,D2), D is D1 + D2, \+member(EstadoX,EstadosA)), Novos),
    append(Outros, Novos, Todos),
    larguraprimeiroD(EstadoF, Todos, Solucao).

% -- Custo = Tempo
resolve_lp_t(EstadoI, EstadoF, Peso, Veiculo, Solucao) :-
	larguraprimeiroT(EstadoF, Peso, Veiculo, [([EstadoI]/0)], Solucao).
larguraprimeiroT(EstadoF, _, _, [[EstadoF|Tail]/T|_], Solucao/T) :-
	reverse([EstadoF|Tail], Solucao).
larguraprimeiroT(EstadoF, Peso, Veiculo, [EstadosA/T1|Outros], Solucao) :-
	EstadosA=[Act|_],
	findall(([EstadoX|EstadosA]/T), (EstadoF\==Act, custoT(Peso,Act,EstadoX,Veiculo,T2), T is T1 + T2, \+member(EstadoX,EstadosA)), Novos),
	append(Outros, Novos,Todos),
	larguraprimeiroT(EstadoF, Peso, Veiculo, Todos, Solucao).


% ------------------------------------------
% Obter o cirtuito mais ecológico usando o critério de tempo
% 
