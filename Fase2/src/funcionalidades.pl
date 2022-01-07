% ---------------------
% -- FUNCIONALIDADES --
% ---------------------

% ------------------------------------------
% Ficheiros a consultar
:- consult('base_conhecimento.pl').
:- consult('auxiliares.pl').
%:- consult('invariantes.pl').

% ------------------------------------------------------------------------------------------------------------------------------
% FUNCIONALIDADE 1: Gerar os circuitos de entrega que cubram um determinado território
% Teste: geraCircuitos(saovictor, Lista, Tamanho).
% ------------------------------------------------------------------------------------------------------------------------------
% Gera todos os trajetos possíveis que passam por uma dada freguesia
% geraCircuitos: Freguesia, Lista, TamanhoLista
geraCircuitos(Freguesia, L, Length) :-
    todosCaminhos(L1),
    todosCaminhosTerritorio(Freguesia, L1, L),
    length(L, Length).

% ------------------------------------------------------------------------------------------------------------------------------
% FUNCIONALIDADE 2: Identificar quais os circuitos com maior número de entregas (por volume e peso)
% Teste: circuitosComMaisEntrega(saopedromerelim, P1, P2, P3).
% ------------------------------------------------------------------------------------------------------------------------------
% Identificar quais os circuitos com maior número de entregas por volume e peso
% circuitosComMaisEntrega: Freguesia, Caminho1, Caminho2, Caminho3
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

% ------------------------------------------
% Calcula o Volume + Peso de um caminho
% contaPesoVolumeCaminho: Caminho, CálculoFinal
contaPesoVolumeCaminho([], 0).
contaPesoVolumeCaminho([Freguesia], Max) :- contaPesoVolume(Freguesia, Max).
contaPesoVolumeCaminho([Freguesia|T], Max) :-
    contaPesoVolume(Freguesia, Max1),
    contaPesoVolumeCaminho(T, Max2),
    Max is Max1 + Max2.

% ------------------------------------------
% Soma o peso e volume de todas as encomendas de uma Freguesia
% contaPesoVolume: Freguesia, Soma
contaPesoVolume(Freguesia, Sum) :-
    findall(Total, (encomenda(_,_,_, Peso, Volume, Freguesia, _,_,_,_), Total is Peso + Volume), L),
    sum_list(L, Sum).

% ------------------------------------------------------------------------------------------------------------------------------
% FUNCIONALIDADE 3: Comparar circuitos de entrega tendo em conta os indicadores de produtividade
% Teste-distância: comparaCircuitos(0, 3, Freguesia, BFS, DFS, IDS, G, AE).
% Teste-tempo: comparaCircuitos(1, 16, Freguesia, BFS, DFS, IDS, G, AE).
% ------------------------------------------------------------------------------------------------------------------------------
% Comparar circuitos de entrega obtidos através de cada algoritmo, tendo em conta os indicadores de produtividade
% Variável 'Custo': 0 -> Distância ; 1 -> Tempo
% comparaCircuitos: IdentificadorCusto, IDEncomenda, Freguesia, TravessiaBFS, TravessiaDFS, TravessiaIDS, TravessiaG, TravessiaAE
comparaCircuitos(Custo, IDEncomenda, Freguesia, TravessiaBFS, TravessiaDFS, TravessiaIDS, TravessiaG, TravessiaAE) :-
    encomenda(IDEncomenda,_,_,_,_,Freguesia,_,_,_,_),
    (Custo == 0 ->
        geraCircuitosAlgoritmos(bfs, 0, IDEncomenda, TravessiaBFS),
        geraCircuitosAlgoritmos(dfs, 0, IDEncomenda, TravessiaDFS),
        geraCircuitosAlgoritmos(ids, 0, IDEncomenda, TravessiaIDS),
        geraCircuitosAlgoritmos(gulosa, 0, IDEncomenda, TravessiaG),
        geraCircuitosAlgoritmos(aestrela, 0, IDEncomenda, TravessiaAE);
    Custo == 1 ->
        geraCircuitosAlgoritmos(bfs, 1, IDEncomenda, TravessiaBFS),
        geraCircuitosAlgoritmos(dfs, 1, IDEncomenda, TravessiaDFS),
        geraCircuitosAlgoritmos(ids, 1, IDEncomenda, TravessiaIDS),
        geraCircuitosAlgoritmos(gulosa, 1, IDEncomenda, TravessiaG),
        geraCircuitosAlgoritmos(aestrela, 1, IDEncomenda, TravessiaAE)
    ).

% ------------------------------------------
% Gera as soluções com o uso de algoritmos informados e não informados
% Variável 'Algoritmo', identifica o algoritmo a utilizar
% Variável 'Custo': 0 -> Distância ; 1 -> Tempo
% geraCircuitosAlgoritmos: Algoritmo, IdentificarCusto, IDEncomenda, Travessia
geraCircuitosAlgoritmos(Algoritmo, Custo, IDEncomenda, Travessia) :-
    Custo >= 0, Custo =< 1,
    (Algoritmo \== 'gulosa', Algoritmo \== 'aestrela' ->
        geraCircuitosNI(Algoritmo, Custo, IDEncomenda, Travessia);
        geraCircuitosI(Algoritmo, Custo, IDEncomenda, Travessia)).

% ------------------------------------------
% Gera circuitos recebendo a encomenda, utiliza algoritmos não informados (BFS, DFS, IDS)
% Variável 'Algoritmo', identifica o algoritmo a utilizar
% Variável 'Custo': 0 -> Distância ; 1 -> Custo
% geraCircuitosNI: Algoritmo, IdentificadorCusto, IDEncomenda, Travessia/CustoF
geraCircuitosNI(Algoritmo, Custo, IDEncomenda, Travessia/CustoF) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Algoritmo == 'bfs' ->
        resolve_lp(Custo, Freguesia, amares, Peso, Veiculo, Travessia/CustoF);
    Algoritmo == 'dfs' ->    
        resolve_pp(Custo, Freguesia, Peso, Veiculo, Travessia/CustoF);
    Algoritmo == 'ids' ->   
        resolve_pil(Custo, Freguesia, Peso, Veiculo, 10, Travessia/CustoF)).    

% ------------------------------------------
% Gera circuitos recebendo a encomenda, utiliza algoritmos informados (Gulosa, Estrela)
% Variável 'Algoritmo', identifica o algoritmo a utilizar
% Variável 'Custo': 0 -> Distância ; 1 -> Custo
% geraCircuitosI: Algoritmo, IdentificadorCusto, IDEncomenda, Travessia/CustoF
geraCircuitosI(Algoritmo, Custo, IDEncomenda, Travessia/CustoF) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    (Algoritmo == 'gulosa' ->
        resolve_gulosa(Custo, Freguesia, Veiculo, Peso, Travessia/CustoF);
    Algoritmo == 'aestrela' ->
        resolve_aestrela(Custo, Freguesia, Veiculo, Peso, Travessia/CustoF)).

% ------------------------------------------------------------------------------------------------------------------------------
% FUNCIONALIDADE 4: Escolher o circuito mais rápido usando o critério da distância
% Teste: circuitoMaisRapido(14, Freguesia, Travessia).
% ------------------------------------------------------------------------------------------------------------------------------
% Obter o circuito mais rápido usando o critério da distância
% circuitoMaisRapido: IDEncomenda, Freguesia, Travessia
circuitoMaisRapido(IDEncomenda, Freguesia, Travessia) :-
    encomenda(IDEncomenda, _, _, _, _, Freguesia, _, _, _, _),
    obtemMelhor(0, Freguesia, _, _, Travessia).

% ------------------------------------------------------------------------------------------------------------------------------
% FUNCIONALIDADE 5: Escolher o circuito mais ecológico usando o critério do tempo
% Teste: circuitoMaisEcologico(5, Freguesia, Peso, Veiculo, Travessia). - bicicleta
% Teste: circuitoMaisEcologico(6, Freguesia, Peso, Veiculo, Travessia). - moto
% Teste: circuitoMaisEcologico(13, Freguesia, Peso, Veiculo, Travessia). - carro
% ------------------------------------------------------------------------------------------------------------------------------
% Obter o circuito mais ecológico usando o critério de tempo
% circuitoMaisEcologico: IDEncomenda, Freguesia, Peso, Veiculo, Travessia
circuitoMaisEcologico(IDEncomenda, Freguesia, Peso, Veiculo, Travessia) :-
    encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
    estimaD(Freguesia, Distancia),
    escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
    obtemMelhor(1, Freguesia, Peso , Veiculo, Travessia).

% ------------------------------------------------------------------------------------------------------------------------------
% ESTATISTICAS - Memória e tempo de execução
% ------------------------------------------------------------------------------------------------------------------------------
% -- BFS, statisticsBFS(1, 3, Travessia, Memoria).
statisticsBFS(Custo, IDEncomenda, Travessia/CustoT, Mem) :-
	encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
	estimaD(Freguesia, Distancia),
	escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
	statistics(global_stack, [Used1, _]),
	time(resolve_lp(Custo, Freguesia, amares, Peso, Veiculo, Travessia/CustoT)),
	statistics(global_stack, [Used2, _]),
	Mem is Used2 - Used1.

% -- DFS, statisticsDFS(1, 3, Travessia, Memoria).
statisticsDFS(Custo, IDEncomenda, Travessia/CustoT, Mem) :-
	encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
	estimaD(Freguesia, Distancia),
	escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
	statistics(global_stack, [Used1, _]),
	time(resolve_pp(Custo, Freguesia, Peso, Veiculo, Travessia/CustoT)),
	statistics(global_stack, [Used2, _]),
	Mem is Used2 - Used1.

% -- IDS, statisticsIDS(1, 3, Travessia, Memoria).
statisticsIDS(Custo, IDEncomenda, Travessia/CustoT, Mem) :-
	encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
	estimaD(Freguesia, Distancia),
	escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
	statistics(global_stack, [Used1, _]),
	time(resolve_pil(Custo, Freguesia, Peso, Veiculo, 10, Travessia/CustoT)),
	statistics(global_stack, [Used2, _]),
	Mem is Used2 - Used1.

% -- GULOSA, statisticsGulosa(1, 3, Travessia, Memoria).
statisticsGulosa(Custo, IDEncomenda, Travessia/CustoT, Mem) :-
	encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
	estimaD(Freguesia, Distancia),
	escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
	statistics(global_stack, [Used1, _]),
	time(resolve_gulosa(Custo, Freguesia, Veiculo, Peso, Travessia/CustoT)),
	statistics(global_stack, [Used2, _]),
	Mem is Used2 - Used1.

% -- AESTRELA, statisticsAEstrela(1, 3, Travessia, Memoria).
statisticsAEstrela(Custo, IDEncomenda, Travessia/CustoT, Mem) :-
	encomenda(IDEncomenda, _, _, Peso, _, Freguesia, _, _, Prazo, _),
	estimaD(Freguesia, Distancia),
	escolheVeiculo(Distancia, Prazo, Peso, _, Veiculo),
	statistics(global_stack, [Used1, _]),
	time(resolve_aestrela(Custo, Freguesia, Veiculo, Peso, Travessia/CustoT)),
	statistics(global_stack, [Used2, _]),
	Mem is Used2 - Used1.
