% ------------------------------
% ---- BASE DE CONHECIMENTO ----
% ------------------------------

% ------------------------------------------
% aresta: LocalidadeOrigem, LocalidadeDestino, CustoDistancia
aresta(amares, pousada, 6).
aresta(amares, lago, 7).
aresta(pousada, covelas, 5).
aresta(pousada, saomamedeeste, 6).
aresta(pousada, navarra, 5).
aresta(pousada, gualtar, 6).
aresta(covelas, saomamedeeste, 7).
aresta(saomamedeeste, pinheirovelho, 2).
aresta(navarra, adaufe, 4).
aresta(gualtar, pinheirovelho, 2).
aresta(gualtar, adaufe, 4).
aresta(gualtar, saovictor, 3).
aresta(pinheirovelho, espinho, 6).
aresta(adaufe, palmeira, 7).
aresta(adaufe, saovicente, 4).
aresta(saovictor, saovicente, 4).
aresta(saovictor, arcos, 5).
aresta(saovictor, semelhe, 7).
aresta(espinho, arcos, 11).
aresta(palmeira, lago, 4).
aresta(palmeira, saopedromerelim, 5).
aresta(saovicente, saopedromerelim, 5).
aresta(arcos, ferreiros, 4).
aresta(lago, vilaprado, 7).
aresta(vilaprado, saopedromerelim, 3).
aresta(saopedromerelim, semelhe, 4).
aresta(ferreiros, semelhe, 4).

% ------------------------------------------
% ligacao: LocalidadeEsquerda, LocalidadeDireita
ligacao(X,Y) :- aresta(X,Y,_).
ligacao(X,Y) :- aresta(Y,X,_).

ligacaoC(X,Y,C) :- aresta(X,Y,C).
ligacaoC(X,Y,C) :- aresta(Y,X,C).

% ------------------------------------------
% estimaD: Localidade, EstimaDistância
estimaD(amares, 0).
estimaD(pousada, 4).
estimaD(lago, 6).
estimaD(covelas, 5).
estimaD(saomamedeeste, 6).
estimaD(navarra, 4).
estimaD(gualtar, 8).
estimaD(pinheirovelho, 7).
estimaD(adaufe, 7).
estimaD(saovictor, 10).
estimaD(espinho, 10).
estimaD(palmeira, 8).
estimaD(saovicente, 9).
estimaD(arcos, 14).
estimaD(semelhe, 13).
estimaD(vilaprado, 10).
estimaD(saopedromerelim, 11).
estimaD(ferreiros, 13).

% ------------------------------------------
% objetivo: Localidade
objetivo(amares).

% ------------------------------------------
% transporte: Veículo, Peso, VelocidadeMédia
transporte(bicicleta, 5, 10).
transporte(moto, 20, 35).
transporte(carro, 100, 25).

%-------------------------------------------
% Encomendas
% encomenda(IDEncomenda,   IDCliente,  IDEstafeta, Peso,   Volume,  Freguesia,  ValidaDataPedido,        ValidaDataEntrega, Prazo,  Classificacao,  Transporte)  
encomenda(  1,  5,  5,  5,  40,  lago,              validaData(2020,2,1,3),     validaData(2020,2,2,3),     24,  0,  1).
encomenda(  2,  6,  1,  6,  5,   navarra,           validaData(2020,3,3,5),     validaData(2020,3,3,5),     0,  4,  2).
encomenda(  3,  1,  4,  1,  10,  ferreiros,         validaData(2020,2,1,22),    validaData(0,0,0,0),        6,  5,  3).
encomenda(  4,  3,  3,  3,  90,  saovictor,         validaData(2020,1,22,13),   validaData(2020,1,30,13),   168,  3,  3).
encomenda(  5,  2,  2,  2,  60,  espinho,           validaData(2020,12,29,21),  validaData(2020,12,29,23),  2,  4,  2).
encomenda(  6,  8,  2,  8,  55,  adaufe,            validaData(2020,5,10,6),    validaData(2020,5,12,6),    72,  2,  1).
encomenda(  7,  4,  4,  4,  9,   pinheirovelho,     validaData(2020,11,22,12),  validaData(2020,11,22,12),  0,  1,  2).
encomenda(  8,  10, 4,  10, 7,   gualtar,           validaData(2020,9,15,9),    validaData(2020,9,16,9),    24,  4,  3).
encomenda(  9,  9,  2,  9,  5,   saomamedeeste,     validaData(2020,8,17,10),   validaData(2020,8,24,10),   168,  2,  1).
encomenda(  10, 7,  1,  7,  69,  palmeira,          validaData(2020,7,27,20),   validaData(2020,7,28,20),   6,  5,  2).
encomenda(  11, 6,  3,  1,  15,  vilaprado,         validaData(2020,7,27,18),   validaData(2020,7,28,0),    6,  5,  2).

%-------------------------------------------
