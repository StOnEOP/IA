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
estafetaEcologico(L) :- solucoes(Estafeta,pedido(_,_,_,Estafeta,_,_,_,_,_,1,_),L).

% ------------------------------------------
% 2: Estafetas que entregaram determinadas encomendas a um determinado cliente.
estafetasEncomendaCliente([H|T],Cliente,L) :-   solucoes(Encomenda,pedido(_,Cliente,Encomenda,_,_,_,_,_,_,_,_),S),
                                                verificarLE([H|T],S,L).

verificarLE([],_,_).
verificarLE([H|T],S,L) :- membro(H,S), verificarLE2(H,L,L), verificarLE(T,S,L).
verificarLE2(X,L,L) :- membro(X,L), !.
verificarLE2(X,L,[X|L]).

% ------------------------------------------
% 3: Clientes servidos por um determinado estafeta.
clientesEstafeta(L,Estafeta) :- solucoes(Cliente,pedido(_,Cliente,_,Estafeta,_,_,_,_,_,_,_),L).

% ------------------------------------------
% 4: Valor faturado pela Green Distribution num determinado dia.
faturaDia(Data,Sum) :-  solucoes(Preco,pedido(_,_,_,_,_,_,Data,_,_,_,Preco), L),
                        sum_Lista(L,Sum).

sum_Lista([], 0).
sum_Lista([X|L], Sum) :-    sum_Lista(L, Sum1), 
                            Sum is X + Sum1.

% ------------------------------------------
% 5: Zonas com maior volume de entregas por parte da Green Distribution.


% ------------------------------------------
% 6: Classificação média de satisfação dos clientes de um determinado estafeta.

estafetaMedia(Estafeta,Media) :-    solucoes(Classificacao,pedido(_,_,_,Estafeta,_,_,_,_,Classificacao,_,_),L),
                                    media_Lista(L,Media).

media_Lista(L,Media) :- sum_Lista(L,Sum),
                        comprimento(L,Comp),
                        Comp > 0,
                        Media is Sum/Comp.

% ------------------------------------------
% 7: Número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo.


% ------------------------------------------
% 8: Número total de entregas pelos estafetas, num determinado intervalo de tempo.
entregasTempo(L) :- .

% ------------------------------------------
% 9: Número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo.


% ------------------------------------------
% 10: Peso total transportado por cada estafeta, num determinado dia.


% ------------------------------------------