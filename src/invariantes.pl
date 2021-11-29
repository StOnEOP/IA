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
:- dynamic pedido/11.
:- dynamic encomenda/3.

% ------------------------------------------
% Invariantes estruturais para o predicado estafeta.
% Conjunto de encomendas: lista com todos os IDs das encomendas.
% Penalização: inteiro que funciona como contador, sempre que não entregar, adiciona uma penalização.
+estafeta(ID,Pedidos,Penalizacao) ::    (integer(ID)
                                        ,validaListaInteger(Pedidos)
                                        ,integer(Penalizacao)).

% ------------------------------------------
% Invariantes estruturais para o predicado cliente.
+cliente(IDCliente,IDPedido) :: (integer(IDCliente)
                                ,integer(IDPedido)).

% ------------------------------------------
% Invariantes estruturais para o predicado cliente.
% Prazo de entrega: imediato , 2h, 6h, 1 dia, 3 dias, 7 dias.
% Classificação da entrega: 0 a 5.
% Transporte: bicicleta - 1 , moto - 2 , carro - 3.
% Preço: calculado através de peso, volume, transporte utilizado (menos ecológico = mais caro) e o prazo de entrega (mais curto = mais caro).
+pedido(IDPedido,IDCliente,IDEncomenda,IDEstafeta,Rua,Freguesia,Data,Prazo,Classificacao,Transporte,Preco) ::   (integer(IDPedido)
                                                                                                                ,integer(IDCliente)
                                                                                                                ,integer(IDEncomenda)
                                                                                                                ,integer(IDEstafeta)
                                                                                                                ,atom(Rua)
                                                                                                                ,atom(Freguesia)
                                                                                                                ,validaData(Data)
                                                                                                                ,validaPrazo(Prazo)
                                                                                                                ,validaClassificacao(Classificacao)
                                                                                                                ,validaTransporte(Transporte)
                                                                                                                ,calculaPreco(Preco)).

% ------------------------------------------
% Invariante estrutural para o predicado encomenda.
+encomenda(IDEncomenda,Peso,Volume) ::  (integer(IDEncomenda)
                                        ,integer(Peso)
                                        ,integer(Volume)).

% ------------------------------------------