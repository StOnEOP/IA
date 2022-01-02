% --------------------
% ---- AUXILIARES ----
% --------------------

% ------------------------------------------
% Ficheiros a consultar
:- consult('base_conhecimento.pl').

% ------------------------------------------
% Escolha do veículo a usar tendo em conta o peso da entrega
% escolheVeiculo: Distancia, TempoMáximo, Peso, Velocidade média -> {V,F}
escolheVeiculo(Distancia, TempoMaximo, Peso, VelocidadeMedia, Veiculo) :-
	velocidadeBicicleta(Peso, VB),
	velocidadeMoto(Peso, VM),
	velocidadeCarro(Peso, VC),
	
	(TempoMaximo > Distancia/VB, Peso =< 5 -> Veiculo is 1, VelocidadeMedia is VB, !;
	TempoMaximo > Distancia/VM, Peso =< 20 -> Veiculo is 2, VelocidadeMedia is VM, !;
	TempoMaximo > Distancia/VC, Peso =< 100 -> Veiculo is 3, VelocidadeMedia is VC, !).

velocidadeBicicleta(Peso, V) :-
	V is (10 - Peso*0.7).

velocidadeMoto(Peso, V) :-
	V is (35 - Peso*0.5).

velocidadeCarro(Peso, V) :-
	V is (25 - Peso*0.1).

% ------------------------------------------
% Cálculo da estima do tempo (em minutos)
% estimaT: estimaDistância, Velocidade média, EstimaTempo -> {V,F}
estimaT(Localidade, Veiculo, EstimaT) :-
	estimaD(Localidade, X),
	transporte(Veiculo, _, V),
	EstimaT is X/V.

custoT(Localidade, ProxLocadidade, Veiculo, CustoT) :-
	aresta(Localidade,ProxLocadidade,X),
	transporte(Veiculo, _, V),
	CustoT is X/V.


%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Largura (BFS)
%---------------------------------------------------------------------------------------------------------------------------------------
bfs(EstadoI, EstadoF, Solucao) :-
    bfs2(EstadoF, [[EstadoI]], Solucao).

bfs2(EstadoF, [[EstadoF|T]|_], Solucao) :-
    reverse([EstadoF|T], Solucao).
bfs2(EstadoF, [EstadosA|Outros], Solucao) :-
    EstadosA=[Act|_],
    findall([EstadoX|EstadosA],(EstadoF\==Act, ligacao(Act,EstadoX), \+member(EstadoX,EstadosA)),Novos),
    append(Outros,Novos,Todos),
    bfs2(EstadoF, Todos, Solucao).

%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Profundidade (DFS)
%---------------------------------------------------------------------------------------------------------------------------------------
dfs(EstadoI, EstadoF, Solucao) :-
	dfs2(EstadoI, EstadoF, [EstadoI], Solucao).

dfs2(EstadoF,EstadoF,EstadosA,Solucao) :-
	reverse(EstadosA, Solucao).
dfs2(Act, EstadoF, EstadosA, Solucao) :-
	ligacao(Act, EstadoX),
	\+member(EstadoX, EstadosA),
	dfs2(EstadoX, EstadoF, [EstadoX|EstadosA], Solucao).

% ------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Profundidade primeiro com custo
% ------------------------------------------------------------------------------------------------------------------------------
resolve_pp_c(Nodo, [Nodo|Caminho], C) :-
	profundidadeprimeiro(Nodo, [Nodo], Caminho, C).

profundidadeprimeiro(Nodo,_, [], 0) :-
	objetivo(Nodo).
profundidadeprimeiro(Nodo, Historico, [ProxNodo|Caminho], C) :-
	adjacente(Nodo, ProxNodo, C1),
    nao(membro(ProxNodo, Historico)),
    profundidadeprimeiro(ProxNodo, [ProxNodo|Historico], Caminho, C2), C is C1 + C2.

adjacente(Nodo, ProxNodo, C) :-
	aresta(Nodo, ProxNodo, C).
adjacente(Nodo, ProxNodo, C) :-
	aresta(ProxNodo, Nodo, C).

% MAIN CALL
melhor(Nodo, S, Custo) :-
    findall((SS, CC),
    resolve_pp_c(Nodo, SS, CC), L),
	minimo(L, (S, Custo)).

%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: A Estrela 
%---------------------------------------------------------------------------------------------------------------------------------------
% -- Algoritmo
resolve_aestrela(Nodo,Veiculo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-
%	estima(Nodo, EstimaD, EstimaT),
	estimaD(Nodo,EstimaD),
	estimaT(Nodo,Veiculo, EstimaT),
	aestrela_distancia([[Nodo]/0/EstimaD], InvCaminho/CustoDist/_),
	aestrela_tempo(Veiculo, [[Nodo]/0/EstimaT], InvCaminhoTempo/CustoTempo/_),
	inverso(InvCaminho, CaminhoDistancia),
	inverso(InvCaminhoTempo, CaminhoTempo).

% -- Distância
aestrela_distancia(Caminhos, Caminho) :-
	obtem_melhor_distancia(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,objetivo(Nodo).
aestrela_distancia(Caminhos, SolucaoCaminho) :-
	obtem_melhor_distancia(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela_distancia(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        aestrela_distancia(NovoCaminhos, SolucaoCaminho).

obtem_melhor_distancia([Caminho], Caminho) :- !.
obtem_melhor_distancia([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor_distancia([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
obtem_melhor_distancia([_|Caminhos], MelhorCaminho) :-
	obtem_melhor_distancia(Caminhos, MelhorCaminho).

expande_aestrela_distancia(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_distancia(Caminho,NovoCaminho), ExpCaminhos).

% -- Tempo
aestrela_tempo(_,Caminhos, Caminho) :-
	obtem_melhor_tempo(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	objetivo(Nodo).
aestrela_tempo(Veiculo,Caminhos, SolucaoCaminho) :-
	obtem_melhor_tempo(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela_tempo(Veiculo,MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela_tempo(Veiculo,NovoCaminhos, SolucaoCaminho).

obtem_melhor_tempo([Caminho], Caminho) :- !.
obtem_melhor_tempo([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor_tempo([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
obtem_melhor_tempo([_|Caminhos], MelhorCaminho) :-
	obtem_melhor_tempo(Caminhos, MelhorCaminho).

expande_aestrela_tempo(Veiculo,Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_tempo(Veiculo,Caminho,NovoCaminho), ExpCaminhos).

%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Gulosa
%---------------------------------------------------------------------------------------------------------------------------------------
resolve_gulosa(Nodo,Veiculo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-
	estimaD(Nodo,EstimaD),
	estimaT(Nodo,Veiculo, EstimaT),
	agulosa_distancia_g([[Nodo]/0/EstimaD], InvCaminho/CustoDist/_),
	agulosa_tempo_g(Veiculo,[[Nodo]/0/EstimaT], InvCaminhoTempo/CustoTempo/_),
	inverso(InvCaminho, CaminhoDistancia),
	inverso(InvCaminhoTempo, CaminhoTempo).

% -- Distância
agulosa_distancia_g(Caminhos, Caminho) :-
	obtem_melhor_distancia_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	objetivo(Nodo).
agulosa_distancia_g(Caminhos, SolucaoCaminho) :-
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_distancia_g(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa_distancia_g(NovoCaminhos, SolucaoCaminho).

obtem_melhor_distancia_g([Caminho], Caminho) :- !.
obtem_melhor_distancia_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_distancia_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
obtem_melhor_distancia_g([_|Caminhos], MelhorCaminho) :-
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho).

expande_agulosa_distancia_g(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_distancia(Caminho,NovoCaminho), ExpCaminhos).
	
% -- Tempo
agulosa_tempo_g(_,Caminhos, Caminho) :-
	obtem_melhor_tempo_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	objetivo(Nodo).
agulosa_tempo_g(Veiculo,Caminhos, SolucaoCaminho) :-
	obtem_melhor_tempo_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_tempo_g(Veiculo, MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa_tempo_g(Veiculo, NovoCaminhos, SolucaoCaminho).

obtem_melhor_tempo_g([Caminho], Caminho) :- !.
obtem_melhor_tempo_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_tempo_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
obtem_melhor_tempo_g([_|Caminhos], MelhorCaminho) :-
	obtem_melhor_tempo_g(Caminhos, MelhorCaminho).

expande_agulosa_tempo_g(Veiculo, Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_tempo(Veiculo, Caminho,NovoCaminho), ExpCaminhos).

% ------------------------------------------
% -- Adjacente
adjacente_distancia([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist) :-
	aresta(Nodo, ProxNodo, PassoCustoDist),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCustoDist,
	estimaD(ProxNodo, EstDist).

adjacente_tempo(Veiculo, [Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstimaTempo) :-
	custoT(Nodo, ProxNodo, Veiculo, PassoTempo),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoTempo,
	estimaT(ProxNodo, Veiculo, EstimaTempo).

% ------------------------------------------
% Predicados auxiliares

% -- Mínimo
minimo([(P,X)], (P,X)).
minimo([(_,X)|L], (Py,Y)):-
    minimo(L, (Py,Y)),
    X > Y. 
minimo([(Px,X)|L], (Px,X)):-
    minimo(L, (_,Y)),
    X =< Y.

% -- Inverso
inverso(Xs, Ys):-
	inverso(Xs, [], Ys).
inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

% -- Seleciona
seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :-
    seleciona(E, Xs, Ys).

% -- Negação
nao(Questao) :-
    Questao, !, fail.
nao(_).

% -- Membro
membro(X, [X|_]).
membro(X, [_|Xs]):-
	membro(X, Xs).

% -- Escrever
escrever([]).
escrever([X|L]):-
    write(X), nl,
    escrever(L).
