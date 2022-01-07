% ---------------------
% ---- INVARIANTES ----
% ---------------------

% ------------------------------------------
% Operações adicionais
:- op(900,xfy,'::').

% ------------------------------------------
% Definições iniciais
:- dynamic estafeta/3.
:- dynamic cliente/2.
:- dynamic encomenda/10.
:- dynamic aresta/3.
:- dynamic estimaD/2.

% ------------------------------------------
% Invariantes estruturais para o predicado estafeta.
+estafeta(ID,Encomendas,Penalizacao) :: (integer(ID)
                                        ,validaListaInteger(Encomendas)
                                        ,integer(Penalizacao)).

% ------------------------------------------
% Invariantes estruturais para o predicado cliente.
+cliente(IDCliente,IDEncomenda) ::  (integer(IDCliente)
                                    ,integer(IDEncomenda)).

% ------------------------------------------
% Invariantes estruturais para o predicado encomenda.
+encomenda(IDEncomenda,IDCliente,IDEstafeta,Peso,Volume,Freguesia,DataPedido,DataEntrega,Prazo,Classificacao) ::    (integer(IDEncomenda)
                                                                                                                    ,integer(IDCliente)
                                                                                                                    ,integer(IDEstafeta)
                                                                                                                    ,integer(Peso)
                                                                                                                    ,integer(Volume)
                                                                                                                    ,atom(Freguesia)
                                                                                                                    ,validaData(DataPedido)
                                                                                                                    ,validaData(DataEntrega)
                                                                                                                    ,validaPrazo(Prazo)
                                                                                                                    ,validaClassificacao(Classificacao)).

% ------------------------------------------
% Invariantes estruturais para o predicado aresta.
+aresta(LocalidadeOrigem,LocalidadeDestino,CustoDistancia) ::   (atom(LocalidadeOrigem)
                                                                ,atom(LocalidadeDestino)
                                                                ,integer(CustoDistancia)).

% ------------------------------------------
% Invariantes estruturais para o predicado estimaD.
+estimaD(Localidade,EstimativaDistancia) :: (atom(Localidade)
                                            ,integer(EstimativaDistancia)).
