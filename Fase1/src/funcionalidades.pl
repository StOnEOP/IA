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
estafetaEcologico(Elem) :-  solucoes(Estafeta,encomenda(_,_,Estafeta,_,_,_,_,_,_,_,_,1),L),
                            maxOcorr(_,L,Elem).


maxOcorr(0,[],[]).
maxOcorr(Max,[H|T],L) :-    contaElem(H,[H|T],Count),
                            apagaT(H,[H|T],NewList), 
                            maxOcorr(NewMax,NewList,Ls),
                            (Count > NewMax -> Max = Count, L = H;
                            Max = NewMax, L = Ls), !.
                        
                        
% ------------------------------------------
% 2: Estafetas que entregaram determinadas encomendas a um determinado cliente.
estafetasEncomendaCliente(LE,Cliente,L) :-  solucoes((Encomenda,Estafeta),encomenda(Encomenda,Cliente,Estafeta,_,_,_,_,_,_,_,_,_),S),
                                            verificarLE(LE,S,L).

verificarLE(_,[],[]).
verificarLE(S,[(A,_)|T],L) :- nao(membro(A,S)), verificarLE(S,T,L).
verificarLE(S,[(A,B)|T],[B|L]) :- membro(A,S), verificarLE(S,T,L).

% ------------------------------------------
% 3: Clientes servidos por um determinado estafeta.
clientesEstafeta(L,Estafeta) :- solucoes(Cliente,encomenda(_,Cliente,Estafeta,_,_,_,_,_,_,_,_,_),L).

% ------------------------------------------
% 4: Valor faturado pela Green Distribution num determinado dia.
faturaDia(validaData(A,M,D,_),Sum) :-   solucoes((Peso,Volume,Transporte,Prazo),encomenda(_,_,_,Peso,Volume,_,_,_,validaData(A,M,D,_),Prazo,_,Transporte),L),
                                        calculaPrecoLista(L,L1),
                                        sum_Lista(L1,Sum).

calculaPrecoLista([],[]).
calculaPrecoLista([(Peso,Volume,Transporte,Prazo)],[P]) :- calculaPreco(Peso,Volume,Transporte,Prazo,P).
calculaPrecoLista([(Peso,Volume,Transporte,Prazo)|T], [P|L2]) :-    calculaPreco(Peso,Volume,Transporte,Prazo,P),
                                                                    calculaPrecoLista(T, L2).

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
estafetaMedia(Estafeta,Media) :-    solucoes(Classificacao,encomenda(_,_,Estafeta,_,_,_,_,_,_,_,Classificacao,_),L),
                                    media_Lista(L,Media).

media_Lista(L,Media) :- sum_Lista(L,Sum),
                        comprimento(L,Comp),
                        Comp > 0,
                        Media is Sum/Comp.

% ------------------------------------------
% 7: Número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo.
totalEntregasTransporte(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),Sorted) :-  solucoes((validaData(A3,M3,D3,H3),Transporte),encomenda(_,_,_,_,_,_,_,_,validaData(A3,M3,D3,H3),_,_,Transporte),L1),
                                                                                    filtraDataElemento(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),L1,L2),
                                                                                    parElementoOcorrencia(L2,L3),
                                                                                    sort(L3,Sorted).                                             

% ------------------------------------------
% 8: Número total de entregas pelos estafetas, num determinado intervalo de tempo.
totalEntregasEstafeta(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),Sorted) :-    solucoes((validaData(A3,M3,D3,H3),Estafeta),encomenda(_,_,Estafeta,_,_,_,_,_,validaData(A3,M3,D3,H3),_,_,_),L1),
                                                                                    filtraDataElemento(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),L1,L2),
                                                                                    parElementoOcorrencia(L2,L3),
                                                                                    sort(L3,Sorted).                                             

% ------------------------------------------
% 9: Número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo.
entregueENaoEntregue(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2), A,B) :- solucoes((validaData(A3,M3,D3,H3),validaData(A4,M4,D4,H4),P),encomenda(_,_,_,_,_,_,_,validaData(A3,M3,D3,H3),validaData(A4,M4,D4,H4),P,_,_),L1),
                                                                            filtraData(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2), L1, L2),
                                                                            verificaZeros(validaData(A2,M2,D2,H2),L2,B),
                                                                            contaDatasEntregues(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2), L2, A).
                                                                            
                                                                                
                                                                                
                                                            
verificaZeros(_,[],0).
verificaZeros(validaData(A1,M1,D1,H1),[(D2,validaData(0,0,0,0),P)|T],B) :- nao(encomendaEntregue(D2, validaData(A1,M1,D1,H1), P)) ->
                                                                           verificaZeros(validaData(A1,M1,D1,H1),T,B1), B is B1 + 1;
                                                                           verificaZeros(validaData(A1,M1,D1,H1),T,B).

verificaZeros(validaData(A1,M1,D1,H1),[(_,_,_)|T],B) :- verificaZeros(validaData(A1,M1,D1,H1),T,B).                                                                                                                                                                                                  

contaDatasEntregues(_,_,[],0).
contaDatasEntregues(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),[(_,validaData(0,0,0,0),_)|T],A) :- contaDatasEntregues(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),T,A).     
contaDatasEntregues(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),[(_,DE,_)|T],B) :- (comparaData(validaData(A1,M1,D1,H1),DE),
                                                                                        nao(comparaData(validaData(A2,M2,D2,H2),DE))) ->                                                                                                                            
                                                                                        contaDatasEntregues(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),T,B1), B is B1+1;
                                                                                        contaDatasEntregues(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),T,B).

filtraData(_,_,[],[]).
filtraData(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),[(D3,D4,P)|R],L2) :- (comparaData(validaData(A1,M1,D1,H1),D3),
                                                                                nao(comparaData(validaData(A2,M2,D2,H2),D3))) ->
                                                                                filtraData(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),R,L1),
                                                                                adicionar((D3,D4,P),L1,L2);
                                                                                filtraData(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),R,L2).                                                                 
% ------------------------------------------
% 10: Peso total transportado por cada estafeta, num determinado dia.
estafetaPeso(validaData(A,M,D,_),Sol) :-    solucoes(Estafeta,encomenda(_,_,Estafeta,_,_,_,_,_,validaData(A,M,D,_),_,_,_),L),
                                            sort(0,@<,L,Ls),
                                            estafetaPesoAux(validaData(A,M,D,_),Sol,Ls).

estafetaPesoAux(_,_,[]).
estafetaPesoAux(validaData(A,M,D,_),L,[Estafeta|T]) :-  contaTodosOsPesos(validaData(A,M,D,_),Estafeta,Sum),
                                                        estafetaPesoAux(validaData(A,M,D,_),L1,T),
                                                        adicionar((Estafeta,Sum),L1,L), !.


contaTodosOsPesos(validaData(A,M,D,_),Estafeta,Sum) :-  solucoes(Peso,encomenda(_,_,Estafeta,Peso,_,_,_,_,validaData(A,M,D,_),_,_,_),L),
                                                        sum_Lista(L,Sum).

% ------------------------------------------