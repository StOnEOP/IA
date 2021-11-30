% ------------------------------
% ---- BASE DE CONHECIMENTO ----
% ------------------------------

%-------------------------------
% Estafetas
% estafeta(ID,Pedidos,Penalizacao)

estafeta(1, [2,10], 0).
estafeta(2, [5,6,9], 0).
estafeta(3, [4], 1).
estafeta(4, [7,3,8], 0).
estafeta(5, [1], 3).

%-------------------------------
% Clientes
% cliente(IDCliente,IDPedido)

cliente(1, 3).
cliente(2, 5).
cliente(3, 4).
cliente(4, 7).
cliente(5, 1).
cliente(6, 2).
cliente(6, 11).
cliente(7, 10).
cliente(8, 6).
cliente(9, 9).
cliente(10, 8).

%-------------------------------
% Pedidos
% pedido(IDPedido,  IDCliente,  IDEncomenda, IDEstafeta,       Rua,                      Freguesia,              Data,                Prazo,      Classificacao,        Transporte,     Preco)

pedido(      1,        1,         3,          5,           'Rua Javarda',                'Amares',               data(2020,2,1),          1,           0,                     1,          5  ).
pedido(      2,        2,         5,          1,           'Rua do Andre',               'Maia',                 data(2020,3,3),          0,           4,                     2,          10 ).
pedido(      3,        3,         4,          4,           'Rua do Puorto',              'Puerto',               data(2020,5,12),         6,           5,                     3,          5  ).
pedido(      4,        4,         7,          3,           'Rua da Senhora à Branca',    'S.Victor',             data(2020,1,22),         7,           3,                     3,          25 ).
pedido(      5,        5,         1,          2,           'Rua do St0nE',               'Paços de Ferreira',    data(2020,12,29),        2,           4,                     2,          65 ).
pedido(      6,        6,         2,          2,           'Rua Nossa Senhora',          'Amadora',              data(2020,5,10),         3,           2,                     1,          12 ).
pedido(      7,        7,         10,         4,           'Rua de Pedra',               'Pedregulho',           data(2020,11,22),        0,           1,                     2,          1  ).
pedido(      8,        8,         6,          4,           'Rua do Armando',             'S.Vicente',            data(2020,9,15),         1,           4,                     3,          7  ).
pedido(      9,        9,         9,          2,           'Rua Gostosa',                'Augusto',              data(2020,8,17),         7,           2,                     1,          8  ).
pedido(      10,       10,        8,          1,           'Rua da Misecordia',          'Fátima',               data(2020,7,27),         6,           5,                     2,          23 ).
pedido(      11,       6,        8,          1,           'Rua da Misecordia',          'Fátima',               data(2020,7,27),         6,           5,                     2,          23 ).

%-------------------------------
% Encomendas
% encomenda(IDEncomenda,Peso,Volume)

encomenda(1, 5, 40).
encomenda(2, 6, 5).
encomenda(3, 1, 10).
encomenda(4, 3, 22).
encomenda(5, 2, 60).
encomenda(6, 8, 55).
encomenda(7, 4, 9).
encomenda(8, 10, 7).
encomenda(9, 9, 5).
encomenda(10, 7, 69).
