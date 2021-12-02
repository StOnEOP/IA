% ------------------------------
% ---- BASE DE CONHECIMENTO ----
% ------------------------------

%-------------------------------
% Estafetas
% estafeta(ID,  Encomendas,    Penalizacao)
estafeta(1, [2,10], 0).
estafeta(2, [5,6,9],0).
estafeta(3, [4,11], 1).
estafeta(4, [7,3,8],0).
estafeta(5, [1],    3).

%-------------------------------
% Clientes
% cliente(IDCliente,    IDEncomenda)
cliente(1,  3).
cliente(2,  5).
cliente(3,  4).
cliente(4,  7).
cliente(5,  1).
cliente(6,  2).
cliente(6,  11).
cliente(7,  10).
cliente(8,  6).
cliente(9,  9).
cliente(10, 8).


%-------------------------------
% Encomendas
% encomenda(IDEncomenda,   IDCliente,  IDEstafeta, Peso,   Volume, Rua,    Freguesia,  ValidaDataPedido,        ValidaDataEntrega, Prazo,  Classificacao,  Transporte)  
encomenda(  1,  5,  5,  5,  40, 'Rua de Passsos',           'Amares',               validaData(2020,2,1,3),     validaData(2020,2,2,3),     1,  0,  1).
encomenda(  2,  6,  1,  6,  5,  'Rua Rochdale',             'Maia',                 validaData(2020,3,3,5),     validaData(2020,3,3,5),     0,  4,  2).
encomenda(  3,  1,  4,  1,  10, 'Rua da Quinta Amarela',    'Porto',                validaData(2020,2,1,22),    validaData(0,0,0,0),        6,  5,  3).
encomenda(  4,  3,  3,  3,  90, 'Rua da Senhora à Branca',  'S.Victor',             validaData(2020,1,22,13),   validaData(2020,1,30,13),   7,  3,  3).
encomenda(  5,  2,  2,  2,  60, 'Rua de Fiais',             'Paços de Ferreira',    validaData(2020,12,29,21),  validaData(2020,12,29,23),  2,  4,  2).
encomenda(  6,  8,  2,  8,  55, 'Rua Industrias',           'Amadora',              validaData(2020,5,10,6),    validaData(2020,5,12,6),    3,  2,  1).
encomenda(  7,  4,  4,  4,  9,  'Rua da Piedade',           'Alges',                validaData(2020,11,22,12),  validaData(2020,11,22,12),  0,  1,  2).
encomenda(  8,  10, 4,  10, 7,  'Rua do Pombal',            'S.Vicente',            validaData(2020,9,15,9),    validaData(2020,9,16,9),    1,  4,  3).
encomenda(  9,  9,  2,  9,  5,  'Rua Da Lage',              'Gualtar',              validaData(2020,8,17,10),   validaData(2020,8,24,10),   7,  2,  1).
encomenda(  10, 7,  1,  7,  69, 'Rua Jacinta Marto',        'Fátima',               validaData(2020,7,27,20),   validaData(2020,7,28,20),   6,  5,  2).
encomenda(  11, 6,  3,  1,  15, 'Rua Jacinta Marto',        'Fátima',               validaData(2020,7,27,18),   validaData(2020,7,28,0),    6,  5,  2).

%-------------------------------