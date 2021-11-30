% ---------------------
% -- FUNCIONALIDADES --
% ---------------------

% ------------------------------------------
% Definições iniciais
:- consult('auxiliares.pl').
:- consult('base_conhecimento.pl').
:- consult('invariantes.pl').

% ------------------------------------------
% 1: Estafeta que utilizou mais vezes um meio de transporte mais ecológico.
estafetaEcologico(Elem) :- solucoes(Estafeta,pedido(_,_,_,Estafeta,_,_,_,_,_,1,_),L),
                          maxOcurr(Max, L, Elem).

contaElem(X, [], 0).
contaElem(X, [X|T], Count) :- contaElem(X, T, Count1), Count is Count1 + 1.
contaElem(X, [H|T], Count) :- contaElem(X, T, Count).

apagaT(X, [], []).
apagaT(X, [X|R], L) :- apagaT(X,R,L).
apagaT(X, [Y|R], [Y|L]) :- X \= Y, apagaT(X,R,L).

maxOcurr(0, [], []).
maxOcurr(Max, [H|T], L) :- contaElem(H,[H|T],Count),
                           apagaT(H,[H|T],NewList), 
                           maxOcurr(NewMax,NewList,Ls),
                           (Count > NewMax -> Max = Count, L = H;
                           Max = NewMax, L = Ls), !.
                        
                        
% ------------------------------------------
% 2: Estafetas que entregaram determinadas encomendas a um determinado cliente.
estafetasEncomendaCliente(L,LE,Cliente) :-  solucoes(Encomenda,pedido(_,Cliente,Encomenda,_,_,_,_,_,_,_,_),S),
                                            verificarLE(LE,S,L).

verificarLE([H|T],S,L) :- nao(membro(H,S)), verificarLE(T,S,L).
verificarLE([H|T],S,[H|L]).

% ------------------------------------------
% 3: Clientes servidos por um determinado estafeta.
clientesEstafeta(L,Estafeta) :- solucoes(Cliente,pedido(_,Cliente,_,Estafeta,_,_,_,_,_,_,_),L).

% ------------------------------------------
% 4: Valor faturado pela Green Distribution num determinado dia.
faturaDia(Data,Sum) :- solucoes(Preco,pedido(_,_,_,_,_,_,Data,_,_,_,Preco), L),
                     sum_Lista(L,Sum).

% ------------------------------------------
% 5: Zonas com maior volume de entregas por parte da Green Distribution.
zonaMaisVolume(Max,Zona) :- solucoes(Encomenda, pedido(_,_,Encomenda,_,_,_,_,_,_,_,_), L),
                               sort(0, @<, L, Ls),
                               encomendaComMaisVolume(Max, Ls, MaxL),
                               nomeZona(MaxL,Zona).

contaTodosOsVolumes(Encomenda, Sum) :- solucoes(Volume, encomenda(Encomenda,_,Volume), L),
                                       sum_Lista(L,Sum).

encomendaComMaisVolume(0,[],[]).
encomendaComMaisVolume(Max, [Encomenda], [Encomenda]) :- contaTodosOsVolumes(Encomenda,C), Max = C.
encomendaComMaisVolume(Max, [Encomenda|T], L) :- contaTodosOsVolumes(Encomenda,Count),
                                                encomendaComMaisVolume(CountMax,T,Ls),
                                                (Count > CountMax -> Max = Count, L = [Encomenda];
                                                Count == CountMax -> Max = CountMax, L = [Encomenda|Ls]; 
                                                Max = CountMax, L = Ls).
                                            
nomeZona([],[]).
nomeZona([H|T],L):- solucoes((H,Freguesia), pedido(_,_,H,_,_,Freguesia,_,_,_,_,_),[S|_]),
                    nomeZona(T,Z),
                    L = [S|Z].                                            
% ------------------------------------------
% 6: Classificação média de satisfação dos clientes de um determinado estafeta.

estafetaMedia(Estafeta,Media) :- solucoes(Classificacao,pedido(_,_,_,Estafeta,_,_,_,_,Classificacao,_,_),L),
                                media_Lista(L,Media).

% ------------------------------------------
% 7: Número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo.


% ------------------------------------------
% 8: Número total de entregas pelos estafetas, num determinado intervalo de tempo.


% ------------------------------------------
% 9: Número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo.


% ------------------------------------------
% 10: Peso total transportado por cada estafeta, num determinado dia.


% ------------------------------------------