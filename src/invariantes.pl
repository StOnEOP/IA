% ---------------------
% ---- INVARIANTES ----
% ---------------------

% ------------------------------------------
% Operações adicionais
:- op(900,xfy,'::').

% ------------------------------------------
% Definições iniciais
:- dynamic estafeta/3.
:- dynamic cliente/5.
:- dynamic encomenda/9.

% ------------------------------------------
% Invariantes estruturais para o predicado estafeta.
% Conjunto de encomendas: lista com todos os IDs das encomendas.
% Penalização: inteiro que funciona como contador, sempre que não entregar, adiciona uma penalização.
+estafeta(ID,Encomendas,Penalizacao) :: (integer(ID)
                                        ,validaListaInteger(Encomendas)
                                        ,integer(Penalizacao)).

% ------------------------------------------
% Invariantes estruturais para o predicado cliente.
% Prazo de entrega: imediato , 2h, 6h, 1 dia, 3 dias, 7 dias.
% Classificação da entrega: 0 a 5.
+cliente(IDCliente,IDEncomenda,IDEstafeta,Prazo,Classificacao) ::   (integer(IDCliente)
                                                                    ,integer(IDEncomenda)
                                                                    ,integer(IDEstafeta)
                                                                    ,validaPrazo(Prazo)
                                                                    ,validaClassificacao(Classificacao)).

% ------------------------------------------
% Invariante estrutural para o predicado encomenda.
% Preço: calculado através de peso, volume, transporte utilizado (menos ecológico = mais caro) e o prazo de entrega (mais curto = mais caro).
+encomenda(IDEncomenda,IDCliente,Rua,Freguesia,Peso,Volume,Data,Transporte,Preco) ::    (integer(IDEncomenda)
                                                                                        ,integer(IDCliente)
                                                                                        ,atom(Rua)
                                                                                        ,atom(Freguesia)
                                                                                        ,integer(Peso)
                                                                                        ,integer(Volume)
                                                                                        ,validaData(Data)
                                                                                        ,validaTransporte(Transporte)
                                                                                        ,calculaPreco(Preco)).

% ------------------------------------------