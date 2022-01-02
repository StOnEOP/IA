% --------------------
% ---- AUXILIARES ----
% --------------------

% ------------------------------------------
% Ficheiros a consultar
:- consult('base_conhecimento.pl').

% ------------------------------------------
% Escolha do veículo a usar tendo em conta o peso da entrega
% escolheVeiculo: Distância, TempoMáximo, Peso, VelocidadeMédia, Veículo -> {V,F}
escolheVeiculo(Distancia, TempoMaximo, Peso, VelocidadeMedia, Veiculo) :-
	velocidadeMedia(Peso, bicicleta, VB),
	velocidadeMedia(Peso, moto, VM),
	velocidadeMedia(Peso, carro, VC),
	(TempoMaximo > Distancia/VB, Peso =< 5 -> Veiculo is 1, VelocidadeMedia is VB, !;
	TempoMaximo > Distancia/VM, Peso =< 20 -> Veiculo is 2, VelocidadeMedia is VM, !;
	TempoMaximo > Distancia/VC, Peso =< 100 -> Veiculo is 3, VelocidadeMedia is VC, !).

% ------------------------------------------
% Cálculo da velocidade média do veículo tendo em conta o peso
% velocidadeMedia: Peso, Veículo, VelocidadeMédia -> {V,F}
velocidadeMedia(Peso, Veiculo, V) :-
	Veiculo == bicicleta -> V is (10 - Peso*0.7);
	Veiculo == moto -> V is (35 - Peso*0.5);
	Veiculo == carro -> V is (25 - Peso*0.1).

% ------------------------------------------
% Cálculo da estima do tempo com base na localidade e veículo
% estimaT: Peso, Localidade, Veículo, EstimaTempo -> {V,F}
estimaT(Peso, Localidade, Veiculo, EstimaT) :-
	estimaD(Localidade, Distancia),
	velocidadeMedia(Peso, Veiculo, VM),
	EstimaT is Distancia/VM.

% ------------------------------------------
% Cálculo do custo do tempo com base na próxima localidade e veículo
% custoT: Peso, Localidade, PróximaLocalidade, Veículo, CustoTempo -> {V,F}
custoT(Peso, Localidade, ProxLocadidade, Veiculo, CustoT) :-
	ligacaoC(Localidade, ProxLocadidade, Distancia),
	velocidadeMedia(Peso, Veiculo, VM),
	CustoT is Distancia/VM.

% ------------------------------------------
% Obtém o melhor caminho do algoritmo escolhido pelo custo escolhido (distância ou tempo)
% Variável 'Algoritmo': 0 -> bfs ; 1 -> dfs
% Variável 'IdentificadorCusto': 0 -> distância ; 1 -> tempo
% obtemMelhor: Algoritmo, IdentificadorCusto, Nodo, Peso, Veiculo, Solução, Custo -> {V,F}
% -- BFS com distância
obtemMelhor(0, 0, Nodo, NodoF, _, _, S, D) :-
	findall((SS, DD), resolve_lp_d(Nodo, NodoF, SS/DD), L),
	minimo(L, (S, D)).
% -- BFS com tempo
%obtemMelhor(0, 1, Nodo, Peso, Veiculo, S, T) :-
%	findall((SS, TT), resolve_lp_t(Nodo, _, Peso, Veiculo, SS, TT), L),
%	minimo(L, (S, T)).
% -- DFS com distância
obtemMelhor(1, 0, Nodo, NodoF, _, _, S, D) :-
	findall((SS, DD), resolve_pp_d(Nodo, NodoF, SS, DD), L),
	minimo(L, (S, D)).
% -- DFS com tempo
obtemMelhor(1, 1, Nodo, NodoF, Peso, Veiculo, S, T) :-
    findall((SS, TT), resolve_pp_t(Nodo, NodoF, Peso, Veiculo, SS, TT), L),
	minimo(L, (S, T)).

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
% Pesquisa: Profundidade (DFS) (Talvez não seja necessário)
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
% Pesquisa: Largura primeiro com custo
% ------------------------------------------------------------------------------------------------------------------------------
% -- Custo = Distância
resolve_lp_d(EstadoI, EstadoF, Solucao) :-
    larguraprimeiroD(EstadoF, [([EstadoI]/0)], Solucao).
larguraprimeiroD(EstadoF, [[EstadoF|T]/D|_] , Solucao/D) :-
    reverse([EstadoF|T], Solucao).
larguraprimeiroD(EstadoF, [EstadosA/D1|Outros], Solucao) :-
    EstadosA=[Act|_],
    findall(([EstadoX|EstadosA]/D),(EstadoF\==Act, ligacaoC(Act,EstadoX, D2), D is D1 + D2, \+member(EstadoX,EstadosA)),Novos),
    append(Outros,Novos,Todos),
    larguraprimeiroD(EstadoF, Todos, Solucao).

% -- Custo = Tempo

% ------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Profundidade primeiro com custo
% ------------------------------------------------------------------------------------------------------------------------------
% -- Custo = Distância
resolve_pp_d(Nodo, NodoF, [Nodo|Caminho], D) :-
	profundidadeprimeiroD(Nodo, NodoF, [Nodo], Caminho, D).
profundidadeprimeiroD(NodoF, NodoF,_, [], 0).
profundidadeprimeiroD(Nodo, NodoF, Historico, [ProxNodo|Caminho], D) :-
	ligacaoC(Nodo, ProxNodo, D1),
    nao(membro(ProxNodo, Historico)),
    profundidadeprimeiroD(ProxNodo, NodoF, [ProxNodo|Historico], Caminho, D2), D is D1 + D2.

% -- Custo = Tempo
resolve_pp_t(Nodo, NodoF, Peso, Veiculo, [Nodo|Caminho], T) :-
	profundidadeprimeiroT(Nodo, NodoF, Peso, Veiculo, [Nodo], Caminho, T).
profundidadeprimeiroT(NodoF, NodoF, _, _, _, [], 0).
profundidadeprimeiroT(Nodo, NodoF, Peso, Veiculo, Historico, [ProxNodo|Caminho], T) :-
	custoT(Peso, Nodo, ProxNodo, Veiculo, T1),
    nao(membro(ProxNodo, Historico)),
    profundidadeprimeiroT(ProxNodo, NodoF, Peso, Veiculo, [ProxNodo|Historico], Caminho, T2), T is T1 + T2.

%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: A Estrela 
%---------------------------------------------------------------------------------------------------------------------------------------
% -- Algoritmo
resolve_aestrela(Nodo,Veiculo,Peso,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-
%	estima(Nodo, EstimaD, EstimaT),
	estimaD(Nodo,EstimaD),
	estimaT(Peso, Nodo, Veiculo, EstimaT),
	aestrela_distancia([[Nodo]/0/EstimaD], InvCaminho/CustoDist/_),
	aestrela_tempo(Veiculo, Peso, [[Nodo]/0/EstimaT], InvCaminhoTempo/CustoTempo/_),
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

%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa: Gulosa
%---------------------------------------------------------------------------------------------------------------------------------------
resolve_gulosa(Nodo,Veiculo,Peso,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-
	estimaD(Nodo,EstimaD),
	estimaT(Peso, Nodo,Veiculo, EstimaT),
	agulosa_distancia_g([[Nodo]/0/EstimaD], InvCaminho/CustoDist/_),
	agulosa_tempo_g(Veiculo, Peso, [[Nodo]/0/EstimaT], InvCaminhoTempo/CustoTempo/_),
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

% ------------------------------------------
% Adjacente
adjacente_distancia([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist) :-
	ligacaoC(Nodo, ProxNodo, PassoCustoDist),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCustoDist,
	estimaD(ProxNodo, EstDist).

adjacente_tempo(Veiculo, Peso, [Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstimaTempo) :-
	custoT(Peso, Nodo, ProxNodo, Veiculo, PassoTempo),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoTempo,
	estimaT(Peso, ProxNodo, Veiculo, EstimaTempo).

% ------------------------------------------
% Auxiliares (FASE I)
% Calcula o preço total da entrega: Peso, Volume, Transporte, Prazo, Preço -> {V, F}
% Preço calculado da seguinte forma: 15% Peso + 15% Volume + 35% Transporte Utilizado + 35% Prazo de Entrega
calculaPreco(Peso,Volume,Transporte,Prazo,Preco) :- multiplicacao(Peso,15,Peso1),
                                                    multiplicacao(Volume,15,Volume1),
                                                    multiplicacao(Transporte,35,Transporte1),
                                                    calculaPrecoPrazo(Prazo,Prazo1), multiplicacao(Prazo1,35,Prazo2),
                                                    adicao(Peso1,Volume1,Transporte1,Prazo2,Preco1),
                                                    Preco is div(Preco1,100).

% ----------------------------------------
% Multiplicação de 2 números: X, Y, Resultado -> {V, F}
multiplicacao(X,Y,R) :- R = X*Y.

% ----------------------------------------
% Adição de 4 números: X, Y, Z, W, Resultado -> {V, F}
adicao(X,Y,Z,W,R) :- R = X+Y+Z+W.

% ----------------------------------------
% Calcula o preço apropriado para um determinado prazo de entrega: Prazo, Preco -> {V, F}
% Imediato
calculaPrecoPrazo(0, Preco) :- Preco = 15.
% 1 Dia
calculaPrecoPrazo(24,Preco) :- Preco = 5.
% 2 Horas
calculaPrecoPrazo(2,Preco) :- Preco = 10.
% 3 Dias
calculaPrecoPrazo(72,Preco) :- Preco = 3.
% 6 Horas
calculaPrecoPrazo(6,Preco) :- Preco = 7.
% 7 Dias
calculaPrecoPrazo(168,Preco) :- Preco = 1.

% ----------------------------------------
% Verifica se a lista só tem inteiros: Lista -> {V, F}
validaListaInteger([]).
validaListaInteger([H|T]) :- integer(H), validaListaInteger(T).

% ----------------------------------------
% Verifica se o transporte é válido: Transporte -> {V, F}
validaTransporte(T) :- integer(T), T >= 1, T =< 3.

% ----------------------------------------
% Verifica se um prazo de entrega é válido: Prazo -> {V, F}
validaPrazo(PE) :- integer(PE), (PE == 0; PE == 24; PE == 2; PE == 72; PE == 6; PE == 168).

% ----------------------------------------
% Verifica se uma classificação é válida: Classificação -> {V, F}
validaClassificacao(C) :- integer(C), C >= 0, C =< 5.

% ----------------------------------------
% Verifica se uma data é válida: Data -> {V, F}
validaData(Ano,Mes,Dia,Hora) :- integer(Ano), integer(Mes), integer(Dia), integer(Hora),
                                membro(Mes, [1,3,5,7,8,10,12]),
                                Dia >= 1, Dia =< 31,
                                Hora >= 0, Hora =< 23.
validaData(Ano,Mes,Dia,Hora) :- integer(Ano), integer(Mes), integer(Dia), integer(Hora),
                                membro(Mes, [4,6,9,11]),
                                Dia >= 1, Dia =< 30,
                                Hora >= 0, Hora =< 23.
validaData(Ano,2,Dia,Hora) :-   integer(Ano), integer(Dia), integer(Hora),
                                Dia >= 1, Dia =< 29, Hora >= 0, Hora =< 23.

% Compara datas: Data, Data -> {V, F}

comparaData(validaData(Ano,Mes,Dia,Hora), validaData(Ano2,Mes2,Dia2,Hora2)) :- (Ano-Ano2 < 0;
                                                                                Ano-Ano2 =:= 0, Mes-Mes2 < 0;
                                                                                Ano-Ano2 =:= 0, Mes-Mes2 =:= 0, Dia-Dia2 < 0;
                                                                                Ano-Ano2 =:= 0, Mes-Mes2 =:= 0, Dia-Dia2 =:= 0, Hora-Hora2 =< 0).
                                                                                

% ----------------------------------------
% Verifica se a Encomenda foi entregue no prazo establecido : Data, Data, Prazo -> {V, F}
encomendaEntregue(validaData(A1,M1,D1,H1), validaData(A2,M2,D2,H2), P) :- (P == 0 -> A1 == A2, M1 == M2, D1 == D2, H1 == H2);
                                                                          (P == 2 -> A1 == A2, M1 == M2, D1 == D2, H2-H1 =< 2);
                                                                          (P == 6 -> A1 == A2, M1 == M2, D1 == D2, H2-H1 =< 6);
                                                                          (P == 1 -> A1 == A2, M1 == M2, D2-D1 =< 1);
                                                                          (P == 3 -> A1 == A2, M1 == M2, D2-D1 =< 3);
                                                                          (P == 7 -> A1 == A2, M1 == M2, D2-D1 =< 7).

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

% -- Apaga primeiro elemento
apagaPrimeiro([_|T], T).
