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
estafetaEcologico(Elem) :-  solucoes(Estafeta,encomenda(_,_,Estafeta,_,_,_,_,_,_,_,1,_),L),
                            maxOcurr(_,L,Elem).

contaElem(_,[],0).
contaElem(X,[X|T],Count) :- contaElem(X,T,Count1), Count is Count1+1.
contaElem(X,[_|T],Count) :- contaElem(X,T,Count).

apagaT(_,[],[]).
apagaT(X,[X|R],L) :- apagaT(X,R,L).
apagaT(X,[Y|R],[Y|L]) :- X \= Y, apagaT(X,R,L).

maxOcurr(0,[],[]).
maxOcurr(Max,[H|T],L) :-    contaElem(H,[H|T],Count),
                            apagaT(H,[H|T],NewList), 
                            maxOcurr(NewMax,NewList,Ls),
                            (Count > NewMax -> Max = Count, L = H;
                            Max = NewMax, L = Ls), !.
                        
                        
% ------------------------------------------
% 2: Estafetas que entregaram determinadas encomendas a um determinado cliente.
estafetasEncomendaCliente(LE,Cliente,L) :-  solucoes(Encomenda,encomenda(Encomenda,Cliente,_,_,_,_,_,_,_,_,_,_),S),
                                            verificarLE(LE,S,L).

verificarLE([],_,_).
verificarLE([H|T],S,L) :- membro(H,S), verificarLE2(H,L,L), verificarLE(T,S,L).
verificarLE2(X,L,L) :- membro(X,L), !.
verificarLE2(X,L,[X|L]).

% ------------------------------------------
% 3: Clientes servidos por um determinado estafeta.
clientesEstafeta(L,Estafeta) :- solucoes(Cliente,encomenda(_,Cliente,Estafeta,_,_,_,_,_,_,_,_,_),L).

% ------------------------------------------
% 4: Valor faturado pela Green Distribution num determinado dia.
faturaDia(validaData,Sum) :-    solucoes(Preco,encomenda(_,_,_,_,_,_,_,validaData,_,_,_,Preco),L),
                                sum_Lista(L,Sum).

sum_Lista([],0).
sum_Lista([X|L],Sum) :-    sum_Lista(L,Sum1), 
                            Sum is X + Sum1.

% ------------------------------------------
% 5: Zonas com maior volume de entregas por parte da Green Distribution.
zonaMaisVolume(Max,Zona) :- solucoes(Freguesia,encomenda(_,_,_,_,_,_,Freguesia,_,_,_,_,_),L),
                            sort(0,@<,L,Ls),
                            encomendaComMaisVolume(Max,Ls,Zona).

contaTodosOsVolumes(Freguesia,Sum) :-   solucoes(Volume,encomenda(_,_,_,_,Volume,_,Freguesia,_,_,_,_,_),L),
                                        sum_Lista(L,Sum).

encomendaComMaisVolume(0,[],[]).
encomendaComMaisVolume(Max,[Freguesia],[Freguesia]) :- contaTodosOsVolumes(Freguesia,C), Max = C.
encomendaComMaisVolume(Max,[Freguesia|T],L) :-  contaTodosOsVolumes(Freguesia,Count),
                                                encomendaComMaisVolume(CountMax,T,Ls),
                                                (Count > CountMax -> Max = Count, L = [Freguesia];
                                                Count == CountMax -> Max = CountMax, L = [Freguesia|Ls]; 
                                                Max = CountMax, L = Ls).
                                                                                    
% ------------------------------------------
% 6: Classificação média de satisfação dos clientes de um determinado estafeta.

estafetaMedia(Estafeta,Media) :-    solucoes(Classificacao,encomenda(_,_,Estafeta,_,_,_,_,_,_,Classificacao,_,_),L),
                                    media_Lista(L,Media).

media_Lista(L,Media) :- sum_Lista(L,Sum),
                        comprimento(L,Comp),
                        Comp > 0,
                        Media is Sum/Comp.

% ------------------------------------------
% 7: Número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo.
totalEntregasTransporte(Data1, Data2, X,Y,Z) :-  solucoes((Data,Transporte), encomenda(_,_,_,_,_,_,_,Data,_,_,Transporte,_), L1),
                                            filtraData(Data1,Data2,L1,L2),
                                            somaTransportes(X,Y,Z,L2).

filtraData(_,_,[],[]).
filtraData(Data1,Data2,[(D,T)|R],L2) :-  comparaData(Data1,D),
                                            nao(comparaData(Data2,D)),
                                            filtraData(Data1,Data2,R,L1),
                                            adicionar((D,T),L1,L2).

somaTransportes(0,0,0,[]).
somaTransportes(X,Y,Z,[(_,T)|R]) :-   somaTransportes(X1,Y1,Z1,R),
                                        (T == 1 -> X is X1+1; (T == 2 -> Y is Y1+1; (T == 3 -> Z is Z1+1))).
                                        
                                            


% ------------------------------------------
% 8: Número total de entregas pelos estafetas, num determinado intervalo de tempo.


% ------------------------------------------
% 9: Número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo.


% ------------------------------------------
% 10: Peso total transportado por cada estafeta, num determinado dia.
estafetaPeso(Data,Sol) :-   solucoes(Estafeta,encomenda(_,_,Estafeta,_,_,_,_,Data,_,_,_,_),L),
                            sort(0,@<,L,Ls),
                            estafetaPesoAux(Data,Sol,Ls).

estafetaPesoAux(_,_,[]).
estafetaPesoAux(Data,L,[Estafeta|T]) :- contaTodosOsPesos(Data,Estafeta,Sum),
                                        estafetaPesoAux(Data,L1,T),
                                        adicionar((Estafeta,Sum),L1,L), !.

adicionar(X,[],[X]).                                              
adicionar(X,L,[X|L]).

contaTodosOsPesos(Data,Estafeta,Sum) :- solucoes(Peso,encomenda(_,_,Estafeta,Peso,_,_,_,Data,_,_,_,_),L),
                                        sum_Lista(L,Sum).

% ------------------------------------------