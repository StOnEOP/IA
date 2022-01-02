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
:- dynamic pedido/12.

% ------------------------------------------
% Invariantes estruturais para o predicado estafeta.
% Conjunto de encomendas: lista com todos os IDs das encomendas.
% Penalização: inteiro que funciona como contador, sempre que não entregar, adiciona uma penalização.
+estafeta(ID,Encomendas,Penalizacao) :: (integer(ID)
                                        ,validaListaInteger(Encomendas)
                                        ,integer(Penalizacao)).

% ------------------------------------------
% Invariantes estruturais para o predicado cliente.
+cliente(IDCliente,IDEncomenda) ::  (integer(IDCliente)
                                    ,integer(IDEncomenda)).

% ------------------------------------------
% Invariantes estruturais para o predicado encomenda.
% Prazo de entrega: imediato = 0 , 2h = 2, 6h = 6, 1 dia = 1, 3 dias = 3, 7 dias = 7.
% Classificação da entrega: 0 a 5.
% Transporte: bicicleta - 1 , moto - 2 , carro - 3.
% Preço: calculado através de peso, volume, transporte utilizado (menos ecológico = mais caro) e o prazo de entrega (mais curto = mais caro).
+encomenda(IDEncomenda,IDCliente,IDEstafeta,Peso,Volume,Rua,Freguesia,DataPedido,DataEntrega,Prazo,Classificacao,Transporte) :: (integer(IDEncomenda)
                                                                                                                                ,integer(IDCliente)
                                                                                                                                ,integer(IDEstafeta)
                                                                                                                                ,integer(Peso)
                                                                                                                                ,integer(Volume)
                                                                                                                                ,atom(Rua)
                                                                                                                                ,atom(Freguesia)
                                                                                                                                ,validaData(DataPedido)
                                                                                                                                ,validaData(DataEntrega)
                                                                                                                                ,validaPrazo(Prazo)
                                                                                                                                ,validaClassificacao(Classificacao)
                                                                                                                                ,validaTransporte(Transporte)).
                                                                                                                    

% ------------------------------------------