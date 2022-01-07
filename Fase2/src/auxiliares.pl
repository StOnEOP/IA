% --------------------
% ---- AUXILIARES ----
% --------------------

% ------------------------------------------
% Ficheiros a consultar
:- consult('base_conhecimento.pl').

% ------------------------------------------
% Escolha do veículo a usar tendo em conta o peso da entrega
% escolheVeiculo: Distância, TempoMáximo, Peso, VelocidadeMédia, Veículo
escolheVeiculo(Distancia, TempoMaximo, Peso, VelocidadeMedia, Veiculo) :-
	velocidadeMedia(Peso, bicicleta, VB),
	velocidadeMedia(Peso, moto, VM),
	velocidadeMedia(Peso, carro, VC),
	(TempoMaximo > Distancia/VB, Peso =< 5 -> Veiculo = bicicleta, VelocidadeMedia is VB, !;
	TempoMaximo > Distancia/VM, Peso =< 20 -> Veiculo = moto, VelocidadeMedia is VM, !;
	TempoMaximo > Distancia/VC, Peso =< 100 -> Veiculo = carro, VelocidadeMedia is VC, !).

% ------------------------------------------
% Cálculo da velocidade média do veículo tendo em conta o peso
% velocidadeMedia: Peso, Veículo, VelocidadeMédia
velocidadeMedia(Peso, Veiculo, V) :-
	Veiculo == bicicleta -> V is (10 - Peso*0.7);
	Veiculo == moto -> V is (35 - Peso*0.5);
	Veiculo == carro -> V is (25 - Peso*0.1).

% ------------------------------------------
% Cálculo do custo do tempo com base na próxima localidade e veículo
% custoT: Peso, Localidade, PróximaLocalidade, Veículo, CustoTempo
custoT(Peso, Localidade, ProxLocalidade, Veiculo, CustoT) :-
	ligacaoC(Localidade, ProxLocalidade, Distancia),
	velocidadeMedia(Peso, Veiculo, VM),
	CustoT is Distancia/VM.

% ------------------------------------------
% Cálculo da estima do tempo com base na localidade e veículo
% estimaT: Peso, Localidade, Veículo, EstimaTempo
estimaT(Peso, Localidade, Veiculo, EstimaT) :-
	estimaD(Localidade, Distancia),
	velocidadeMedia(Peso, Veiculo, VM),
	EstimaT is Distancia/VM.								

% ------------------------------------------
% Gera os circuitos sem volta, i.e, [Freguesia....amares] ou [amares... Freguesia]
% geraCircuitosSemVolta: Freguesia, Lista
geraCircuitosSemVolta(Freguesia, L) :-
    todosCaminhosSemVolta(L1),
    todosCaminhosTerritorio(Freguesia, L1, L).

% ------------------------------------------
% Obtém todos os caminhos possíveis para todas as freguesias de todas as encomendas
% até chegar a Amares (freguesia do centro de distribuições)
% todosCaminhos: Solução
todosCaminhos(L) :-
    findall(Freguesia, encomenda(_, _, _, _, _, Freguesia, _, _, _, _), L1),
    getAllCaminhos(L1, L).

getAllCaminhos([], []).
getAllCaminhos([C|T], L) :-
    findall(Lista, resolve_lp(0, C, amares, _, _, Lista/_), L1),
    getAllCaminhos(T, L2),
    append(L1, L2, L).

% ------------------------------------------
% Obtém todos os caminhos possíveis para todas as freguesias de todas as encomendas
% todosCaminhos: Solução
todosCaminhosSemVolta(L) :-
    findall(Freguesia, encomenda(_, _, _, _, _, Freguesia, _, _, _, _), L1),
    getAllCaminhosSemVolta(L1, L).

getAllCaminhosSemVolta([], []).
getAllCaminhosSemVolta([C|T], L) :-
    findall(Lista, larguraprimeiroD(C, [([amares]/0)], Lista/_), L1),
    getAllCaminhosSemVolta(T, L2),
    append(L1, L2, L).

% ------------------------------------------
% Obtém todos os caminhos que passam por uma certa freguesia
% todosCaminhosTerritorio: Freguesia, CaminhosPossíveis, Solução
todosCaminhosTerritorio(_, [], []).
todosCaminhosTerritorio(Freguesia, [Caminho|T], L) :-
	(member(Freguesia, Caminho) ->
		todosCaminhosTerritorio(Freguesia, T, L1),
		append([Caminho], L1, L);
		todosCaminhosTerritorio(Freguesia, T, L)).

% ------------------------------------------
% Obtém o melhor caminho com o uso do algoritmo DFS e calcula o custo pretendido (distância ou tempo)
% Variável 'Custo': 0 -> distância ; 1 -> tempo
% obtemMelhor: IdentificadorCusto, Nodo, Peso, Veiculo, Solução/Custo
% -- Custo = Distância
obtemMelhor(0, Nodo, _, _, S/D) :-
	findall((SS,DD), resolve_pp(0, Nodo, _, _, SS/DD), L),
	minimo(L, (S,D)).
% -- Custo = Tempo
obtemMelhor(1, Nodo, Peso, Veiculo, S/T) :-
	findall((SS,TT), resolve_pp(1, Nodo, Peso, Veiculo, SS/TT), L),
	minimo(L, (S,T)).

% ------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Largura primeiro com custo
% ------------------------------------------------------------------------------------------------------------------------------
% -- Custo: 0 -> Distânca ; 1 -> Tempo
resolve_lp(Custo, EstadoF, EstadoI, Peso, Veiculo, Solucao/R) :-
	(Custo == 0 ->
		larguraprimeiroD(EstadoF, [([EstadoI]/0)], Solucao1/R1);
	Custo == 1 ->
		larguraprimeiroT(EstadoF, Peso, Veiculo, [([EstadoI]/0)], Solucao1/R1)),
	reverse(Solucao1, Solucao2),
	apagaPrimeiro(Solucao1, Solucao3),
	append(Solucao2, Solucao3, Solucao),
	R is R1 + R1.

% -- Custo = Distância
larguraprimeiroD(EstadoF, [[EstadoF|T]/D|_] , [EstadoF|T]/D).
larguraprimeiroD(EstadoF, [EstadosA/D1|Outros], Solucao) :-
	EstadosA=[Act|_],
	findall(([EstadoX|EstadosA]/D), (EstadoF\==Act, ligacaoC(Act,EstadoX,D2), D is D1 + D2, \+member(EstadoX,EstadosA)), Novos),
	append(Outros, Novos, Todos),
    larguraprimeiroD(EstadoF, Todos, Solucao).

% -- Custo = Tempo
larguraprimeiroT(EstadoF, _, _, [[EstadoF|Tail]/T|_] , [EstadoF|Tail]/T).
larguraprimeiroT(EstadoF, Peso, Veiculo, [EstadosA/T1|Outros], Solucao) :-
	EstadosA=[Act|_],
	findall(([EstadoX|EstadosA]/T), (EstadoF\==Act, custoT(Peso,Act,EstadoX,Veiculo,T2), T is T1 + T2, \+member(EstadoX,EstadosA)), Novos),
	append(Outros, Novos, Todos),
    larguraprimeiroT(EstadoF, Peso, Veiculo, Todos, Solucao).

% ------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Profundidade primeiro com custo
% ------------------------------------------------------------------------------------------------------------------------------
% -- Custo: 0-> Distânca ; 1 -> Tempo
resolve_pp(Custo, Nodo, Peso, Veiculo, Caminho/R) :-
	(Custo == 0 ->
		profundidadeprimeiroD(Nodo, [Nodo], Caminho1/R1);
	Custo == 1 ->
		profundidadeprimeiroT(Nodo, Peso, Veiculo, [Nodo], Caminho1/R1)),
	reverse(Caminho1, CaminhoI),
	append(CaminhoI, [Nodo], CaminhoN),
	append(CaminhoN, Caminho1, Caminho),
	R is R1 + R1.

% -- Custo = Distância
profundidadeprimeiroD(Nodo, _, []/0) :-
	objetivo(Nodo).
profundidadeprimeiroD(Nodo, Historico, [ProxNodo|Caminho]/D) :-
	ligacaoC(Nodo, ProxNodo, D1),
	nao(membro(ProxNodo, Historico)),
	profundidadeprimeiroD(ProxNodo, [ProxNodo|Historico], Caminho/D2),
	D is D1 + D2.

% -- Custo = Tempo
profundidadeprimeiroT(Nodo, _, _, _, []/0) :-
	objetivo(Nodo).
profundidadeprimeiroT(Nodo, Peso, Veiculo, Historico, [ProxNodo|Caminho]/T) :-
	custoT(Peso, Nodo, ProxNodo, Veiculo, T1),
	nao(membro(ProxNodo, Historico)),
	profundidadeprimeiroT(ProxNodo, Peso, Veiculo, [ProxNodo|Historico], Caminho/T2),
	T is T1 + T2.

% ------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Iterativa Limitada em Profundidade com custo
% ------------------------------------------------------------------------------------------------------------------------------
% -- Custo: 0-> Distânca ; 1 -> Tempo
resolve_pil(Custo, Nodo, Peso, Veiculo, Limite, Caminho/R) :-
	(Custo == 0 ->
		caminhopilD(amares, Nodo, Limite, Caminho1/R1);
	Custo == 1 ->
		caminhopilT(amares, Nodo, Peso, Veiculo, Limite, Caminho1/R1)),
	reverse(Caminho1, Caminho2),
	apagaPrimeiro(Caminho1, Caminho3),
	append(Caminho2, Caminho3, Caminho),
	R is R1 + R1.

% -- Custo = Distância
caminhopilD(Nodo, Nodo, Limite, [Nodo]/0) :-
	Limite > 0.
caminhopilD(Nodo, NodoF, Limite, [NodoF|Caminho]/D) :-
	Limite > 0,
	LimiteAUX is Limite - 1,
	caminhopilD(Nodo, NodoX, LimiteAUX, Caminho/D2),
	ligacaoC(NodoX, NodoF, D1), D is D1 + D2,
	\+ member(NodoF, Caminho).

% -- Custo = Tempo
caminhopilT(Nodo, Nodo, _, _, Limite, [Nodo]/0) :-
	Limite > 0.
caminhopilT(Nodo, NodoF, Peso, Veiculo, Limite, [NodoF|Caminho]/T) :-
	Limite > 0,
	LimiteAUX is Limite - 1,
	caminhopilT(Nodo, NodoX, Peso, Veiculo, LimiteAUX, Caminho/T2),
	custoT(Peso, NodoX, NodoF, Veiculo, T1), T is T1 + T2,
	\+ member(NodoF, Caminho).

%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Gulosa
%---------------------------------------------------------------------------------------------------------------------------------------
% -- Custo: 0-> Distânca ; 1 -> Tempo
resolve_gulosa(Custo, Nodo, Veiculo, Peso, Caminho/R) :-
	(Custo == 0 ->
		estimaD(Nodo, EstimaD),
		agulosa_distancia_g([[Nodo]/0/EstimaD], Caminho1/R1/_);
	Custo == 1 ->
		estimaT(Peso, Nodo, Veiculo, EstimaT),
		agulosa_tempo_g(Veiculo, Peso, [[Nodo]/0/EstimaT], Caminho1/R1/_)),
	inverso(Caminho1, Caminho2),
	apagaPrimeiro(Caminho2, Caminho3),
	append(Caminho1, Caminho3, Caminho),
	R is R1 + R1.

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
agulosa_tempo_g(_,_,Caminhos, Caminho) :-
	obtem_melhor_tempo_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	objetivo(Nodo).
agulosa_tempo_g(Veiculo, Peso, Caminhos, SolucaoCaminho) :-
	obtem_melhor_tempo_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_tempo_g(Veiculo, Peso, MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa_tempo_g(Veiculo, Peso,NovoCaminhos, SolucaoCaminho).

obtem_melhor_tempo_g([Caminho], Caminho) :- !.
obtem_melhor_tempo_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_tempo_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
obtem_melhor_tempo_g([_|Caminhos], MelhorCaminho) :-
	obtem_melhor_tempo_g(Caminhos, MelhorCaminho).

expande_agulosa_tempo_g(Veiculo, Peso, Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_tempo(Veiculo, Peso,Caminho,NovoCaminho), ExpCaminhos).

%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: A Estrela 
%---------------------------------------------------------------------------------------------------------------------------------------
% -- Custo: 0-> Distânca ; 1 -> Tempo
resolve_aestrela(Custo, Nodo, Veiculo, Peso, Caminho/R) :-
	(Custo == 0 ->
		estimaD(Nodo, EstimaD),
		aestrela_distancia([[Nodo]/0/EstimaD], Caminho1/R1/_);
	Custo == 1 ->
		estimaT(Peso, Nodo, Veiculo, EstimaT),
		aestrela_tempo(Veiculo, Peso, [[Nodo]/0/EstimaT], Caminho1/R1/_)),
	inverso(Caminho1, Caminho2),
	apagaPrimeiro(Caminho2, Caminho3),
	append(Caminho1, Caminho3, Caminho),
	R is R1 + R1.

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
aestrela_tempo(_,_,Caminhos, Caminho) :-
	obtem_melhor_tempo(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	objetivo(Nodo).
aestrela_tempo(Veiculo,Peso,Caminhos, SolucaoCaminho) :-
	obtem_melhor_tempo(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela_tempo(Veiculo,Peso,MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela_tempo(Veiculo,Peso,NovoCaminhos, SolucaoCaminho).

obtem_melhor_tempo([Caminho], Caminho) :- !.
obtem_melhor_tempo([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor_tempo([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
obtem_melhor_tempo([_|Caminhos], MelhorCaminho) :-
	obtem_melhor_tempo(Caminhos, MelhorCaminho).

expande_aestrela_tempo(Veiculo,Peso,Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_tempo(Veiculo,Peso,Caminho,NovoCaminho), ExpCaminhos).

% ------------------------------------------
% Adjacente para os diferntes custos
% ------------------------------------------
% -- Distância
adjacente_distancia([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist) :-
	ligacaoC(Nodo, ProxNodo, PassoCustoDist),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCustoDist,
	estimaD(ProxNodo, EstDist).

% -- Tempo
adjacente_tempo(Veiculo, Peso, [Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstimaTempo) :-
	custoT(Peso, Nodo, ProxNodo, Veiculo, PassoTempo),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoTempo,
	estimaT(Peso, ProxNodo, Veiculo, EstimaTempo).

% ------------------------------------------
% Auxiliares (FASE I)

% -- validaData: Ano, Mes, Dia, Hora
validaData(Ano, Mes, Dia, Hora) :-
	integer(Ano), integer(Mes), integer(Dia), integer(Hora),
    membro(Mes, [1,3,5,7,8,10,12]),
    Dia >= 1, Dia =< 31,
    Hora >= 0, Hora =< 23.
validaData(Ano, Mes, Dia, Hora) :-
	integer(Ano), integer(Mes), integer(Dia), integer(Hora),
    membro(Mes, [4,6,9,11]),
    Dia >= 1, Dia =< 30,
    Hora >= 0, Hora =< 23.
validaData(Ano, 2, Dia, Hora) :-
	integer(Ano), integer(Dia), integer(Hora),
    Dia >= 1, Dia =< 29, Hora >= 0, Hora =< 23.

% ----------------------------------------
% Auxiliares (FASE II)

% -- ligacao: LocalidadeEsquerda, LocalidadeDireita
ligacao(X, Y) :- aresta(X, Y, _).
ligacao(X, Y) :- aresta(Y, X, _).

% ligacaoC: LocalidadeEsquerda, LocalidadeDireita, Custo
ligacaoC(X, Y, C) :- aresta(X, Y, C).
ligacaoC(X, Y, C) :- aresta(Y, X, C).

% -- Mínimo
minimo([X], X) :- !.
minimo([(A,B)|T], (RA,RB)) :-
	minimo(T, (A1,B1)), !,
	(B1 > B ->
		(RA = A,  RB = B);
		(RA = A1, RB = B1)).

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

% -- Apaga primeiro elemento
apagaPrimeiro([_|T], T).
