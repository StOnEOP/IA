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
% Encomendas
% encomendas(IDEncomenda,  IDCliente, IDEstafeta, Peso, Volume, Rua,                     Freguesia,              ValidaData,                       Prazo,       Classificacao,         Transporte, Preco)

pedido(      1,        1,         3,          5,  5,   40, 'Rua Javarda',                'Amares',               validaData(2020,2,1,3),           1,           0,                     1,          5  ).
pedido(      2,        2,         5,          1,  6,   5,  'Rua do Andre',               'Maia',                 validaData(2020,3,3,5),           0,           4,                     2,          10 ).
pedido(      3,        3,         4,          4,  1,   10, 'Rua do Puorto',              'Puerto',               validaData(2020,2,1,22),          6,           5,                     3,          5  ).
pedido(      4,        4,         7,          3,  3,   22, 'Rua da Senhora à Branca',    'S.Victor',             validaData(2020,1,22,13),         7,           3,                     3,          25 ).
pedido(      5,        5,         1,          2,  2,   60, 'Rua do St0nE',               'Paços de Ferreira',    validaData(2020,12,29,21),        2,           4,                     2,          65 ).
pedido(      6,        6,         2,          2,  8,   55, 'Rua Nossa Senhora',          'Amadora',              validaData(2020,5,10,6),          3,           2,                     1,          12 ).
pedido(      7,        7,         10,         4,  4,   9,  'Rua de Pedra',               'Pedregulho',           validaData(2020,11,22,12),        0,           1,                     2,          1  ).
pedido(      8,        8,         6,          4,  10,  7,  'Rua do Armando',             'S.Vicente',            validaData(2020,9,15,9),          1,           4,                     3,          7  ).
pedido(      9,        9,         9,          2,  9,   5,  'Rua Gostosa',                'Augusto',              validaData(2020,8,17,10),         7,           2,                     1,          8  ).
pedido(      10,       10,        8,          1,  7,   69, 'Rua da Misecordia',          'Fátima',               validaData(2020,7,27,20),         6,           5,                     2,          23 ).
pedido(      11,       6,         8,          1,  1,   15, 'Rua da Misecordia',          'Fátima',               validaData(2020,7,27,18),         6,           5,                     2,          23 ).
