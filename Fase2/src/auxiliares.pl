% --------------------
% ---- AUXILIARES ----
% --------------------

% ------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa em profundidade primeiro com custo
%---------------------------------------------------------------------------------------------------------------------------------------
%    resolve_pp_c(s,C,Custo).


resolve_pp_c(Nodo, [Nodo|Caminho], C) :-
	profundidadeprimeiro(Nodo, [Nodo], Caminho, C).


profundidadeprimeiro(Nodo,_, [], 0) :-
	goal(Nodo).

profundidadeprimeiro(Nodo, Historico, [ProxNodo|Caminho], C) :-
	adjacente(Nodo, ProxNodo, C1),
    nao(membro(ProxNodo, Historico)),
profundidadeprimeiro(ProxNodo, [ProxNodo|Historico], Caminho, C2), C is C1 + C2.	

adjacente(Nodo, ProxNodo, C) :- 
	move(Nodo, ProxNodo, C).
adjacente(Nodo, ProxNodo, C) :- 
	move(ProxNodo, Nodo, C).

melhor(Nodo, S, Custo) :- findall((SS, CC), resolve_pp_c(Nodo, SS, CC), L), 
							minimo(L, (S, Custo)).

minimo([(P,X)],(P,X)).
minimo([(Px,X)|L],(Py,Y)):- minimo(L,(Py,Y)), X>Y. 
minimo([(Px,X)|L],(Px,X)):- minimo(L,(Py,Y)), X=<Y.


%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa A Estrela 
%---------------------------------------------------------------------------------------------------------------------------------------
resolve_aestrela(Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-
	estima(Nodo, EstimaD, EstimaT),
	aestrela_distancia([[Nodo]/0/EstimaD], InvCaminho/CustoDist/_),
	aestrela_tempo([[Nodo]/0/EstimaT], InvCaminhoTempo/CustoTempo/_),
	inverso(InvCaminho, CaminhoDistancia),
	inverso(InvCaminhoTempo, CaminhoTempo).

aestrela_distancia(Caminhos, Caminho) :-
	obtem_melhor_distancia(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,goal(Nodo).

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
	
% --- tempo 

aestrela_tempo(Caminhos, Caminho) :-
	obtem_melhor_tempo(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	goal(Nodo).

aestrela_tempo(Caminhos, SolucaoCaminho) :-
	obtem_melhor_tempo(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela_tempo(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        aestrela_tempo(NovoCaminhos, SolucaoCaminho).
	
obtem_melhor_tempo([Caminho], Caminho) :- !.
obtem_melhor_tempo([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor_tempo([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_tempo([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_tempo(Caminhos, MelhorCaminho).
	

expande_aestrela_tempo(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_tempo(Caminho,NovoCaminho), ExpCaminhos).
	
%---------------------------------------------------------------------------------------------------------------------------------------
% Pesquisa Gulosa
%---------------------------------------------------------------------------------------------------------------------------------------

resolve_gulosa(Nodo,CaminhoDistancia/CustoDist, CaminhoTempo/CustoTempo) :-
	estima(Nodo, EstimaD, EstimaT),
	agulosa_distancia_g([[Nodo]/0/EstimaD], InvCaminho/CustoDist/_),
	agulosa_tempo_g([[Nodo]/0/EstimaT], InvCaminhoTempo/CustoTempo/_),
	inverso(InvCaminho, CaminhoDistancia),
	inverso(InvCaminhoTempo, CaminhoTempo).

agulosa_distancia_g(Caminhos, Caminho) :-
	obtem_melhor_distancia_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	goal(Nodo).

agulosa_distancia_g(Caminhos, SolucaoCaminho) :-
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_distancia_g(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        agulosa_distancia_g(NovoCaminhos, SolucaoCaminho).	

obtem_melhor_distancia_g([Caminho], Caminho) :- !.
obtem_melhor_distancia_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_distancia_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_distancia_g([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho).
	

expande_agulosa_distancia_g(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_distancia(Caminho,NovoCaminho), ExpCaminhos).
	
% --- tempo 

agulosa_tempo_g(Caminhos, Caminho) :-
	obtem_melhor_tempo_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	goal(Nodo).

agulosa_tempo_g(Caminhos, SolucaoCaminho) :-
	obtem_melhor_tempo_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_tempo_g(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        agulosa_tempo_g(NovoCaminhos, SolucaoCaminho).
	
obtem_melhor_tempo_g([Caminho], Caminho) :- !.
obtem_melhor_tempo_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_tempo_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_tempo_g([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_tempo_g(Caminhos, MelhorCaminho).
	

expande_agulosa_tempo_g(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente_tempo(Caminho,NovoCaminho), ExpCaminhos).


adjacente_distancia([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist) :-
	move(Nodo, ProxNodo, PassoCustoDist, _),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCustoDist,
	estima(ProxNodo, EstDist, _).


adjacente_tempo([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstimaTempo) :-
	move(Nodo, ProxNodo, _, PassoTempo),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoTempo,
	estima(ProxNodo, _ , EstimaTempo).
%---------------------------------------------------------------------------------------------------------------------------------------
% Depth-first
%---------------------------------------------------------------------------------------------------------------------------------------

resolvedf(Solucao) :- inicial(InicialEstado), resolvedf(IncialEstado, [InicialEstado], Solucao).

resolvedf(Estado, Historico, []) :- final(Estado),!, reverse(Historico,L), write(Historico).

resolvedf(Estado, Historico, [Move|Solucao]) :- transicao(Estado, Move, Estado1), nao(membro(Estado1, Historico)), resolvedf(Estado1, [Estado1|Historico], Solucao).

todos(L) :- findall((S,C), (resolvedf(S), length(S,C)), L).
melhor(S, Custo) :- findall((S,C), (resolvedf(S), length(S,C)), L), minimo(L,(S, Custo)).

minimo([(P,X)], (P,X)).
minimo([(Px,X)|L], (Py,Y)) :- minimo(L,(Py,Y)), X > Y.
minimo([(Px,X)|L], (Px,X)) :- minimo(L,(Py,Y)), X=< Y.

%---------------------------------------------------------------------------------------------------------------------------------------
% Breath-first
%---------------------------------------------------------------------------------------------------------------------------------------

resolvebf(Solucao) :- bfs_M(jarros(0,0), jarros(_,4), Solucao).

bfs_M(Estado1, EstadoF,Solucao) :- bfs_M2(EstadoF, [[EstadoI]], Solucao).

bfs_M2(EstadoF, [[EstadoF|T]|_], Solucao) :- reverse([EstadoF|T], Solucao).

bfs_M2(EstadoF, [EstadosA|Outros], Solucao) :-
    EstadosA=[Act|_],
    findall([EstadoX|EstadosA],
        (EstadoF\==Act, transicao(Act,Move,EstadoX), \+member(EstadoX,EstadosA)),
        Novos),
    append(Outros,Novos,Todos),
    bfs_M2(EstadoF, Todos, Solucao).    

%---------------------------------predicados auxiliares

inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

membro(X, [X|_]).
membro(X, [_|Xs]):-
	membro(X, Xs).		

escrever([]).
escrever([X|L]):- write(X), nl, escrever(L).