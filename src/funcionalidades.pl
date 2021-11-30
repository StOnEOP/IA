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
estafetasEncomendaCliente(L,LE,Cliente) :-  solucoes(Encomenda,pedido(_,Cliente,Encomenda,_,_,_,_,_,_,_,_),S),
                                            verificarLE(LE,S,L).

verificarLE([H|T],S,L) :- nao(membro(H,S)), verificarLE(T,S,L).
verificarLE([H|T],S,[H|L]).

% ------------------------------------------
% 3: Clientes servidos por um determinado estafeta.
clientesEstafeta(L,Estafeta) :- solucoes(Cliente,pedido(_,Cliente,_,Estafeta,_,_,_,_,_,_,_),L).

% ------------------------------------------
% 4: Valor faturado pela Green Distribution num determinado dia.


% ------------------------------------------
% 5: Zonas com maior volume de entregas por parte da Green Distribution.


% ------------------------------------------
% 6: Classificação média de satisfação dos clientes de um determinado estafeta.


% ------------------------------------------
% 7: Número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo.


% ------------------------------------------
% 8: Número total de entregas pelos estafetas, num determinado intervalo de tempo.


% ------------------------------------------
% 9: Número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo.


% ------------------------------------------
% 10: Peso total transportado por cada estafeta, num determinado dia.


% ------------------------------------------