% ------------------------------
% ---- BASE DE CONHECIMENTO ----
% ------------------------------

% ------------------------------------------
% aresta: LocalidadeOrigem, LocalidadeDestino, CustoDistancia
aresta(amares, pousada, 6).
aresta(amares, lago, 7).
aresta(pousada, saomamedeeste, 6).
aresta(pousada, navarra, 5).
aresta(pousada, gualtar, 6).
aresta(covelas, saomamedeeste, 7).
aresta(saomamedeeste, pinheirovelho, 2).
aresta(navarra, adaufe, 4).
aresta(gualtar, pinheirovelho, 2).
aresta(gualtar, saovictor, 3).
aresta(pinheirovelho, espinho, 6).
aresta(adaufe, palmeira, 7).
aresta(adaufe, saovicente, 4).
aresta(saovictor, saovicente, 4).
aresta(saovictor, arcos, 5).
aresta(espinho, arcos, 11).
aresta(palmeira, saopedromerelim, 5).
aresta(saovicente, saopedromerelim, 5).
aresta(arcos, ferreiros, 4).
aresta(lago, vilaprado, 7).
aresta(vilaprado, saopedromerelim, 3).
aresta(saopedromerelim, semelhe, 4).
aresta(ferreiros, semelhe, 4).

% ------------------------------------------
% estimaD: Localidade, EstimaDistância
estimaD(amares, 0).
estimaD(pousada, 4).
estimaD(lago, 6).
estimaD(covelas, 4).
estimaD(saomamedeeste, 7).
estimaD(navarra, 4).
estimaD(gualtar, 7).
estimaD(pinheirovelho, 8).
estimaD(adaufe, 7).
estimaD(saovictor, 10).
estimaD(espinho, 10).
estimaD(palmeira, 9).
estimaD(saovicente, 9).
estimaD(arcos, 14).
estimaD(semelhe, 13).
estimaD(vilaprado, 9).
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
% encomenda: IDEncomenda,	IDCliente,	IDEstafeta,	Peso,	Volume,	Freguesia,	ValidaDataPedido,	ValidaDataEntrega,	Prazo,	Classificacao
encomenda(  1,  5,  5,  5,	40, lago,        	  	validaData(2020,2,1,3),     validaData(2020,2,2,3),     24,   0).
encomenda(  2,  6,  1,  6,  5,  navarra,        	validaData(2020,3,3,5),     validaData(2020,3,3,5),     72,   4).
encomenda(  3,  1,  4,  1,  10, ferreiros,      	validaData(2020,2,1,22),    validaData(0,0,0,0),        6,    5).
encomenda(  4,  3,  3,  3,  90, saovictor,      	validaData(2020,1,22,13),   validaData(2020,1,30,13),   168,  3).
encomenda(  5,  2,  2,  2,  60, espinho,        	validaData(2020,12,29,21),  validaData(2020,12,29,23),  2,    4).
encomenda(  6,  8,  2,  8,  55, adaufe,         	validaData(2020,5,10,6),    validaData(2020,5,12,6),    72,   2).
encomenda(  7,  4,  4,  4,  9,  pinheirovelho,  	validaData(2020,11,22,12),  validaData(2020,11,22,12),  24,	  1).
encomenda(  8,  10, 4,  10, 7,  gualtar,        	validaData(2020,9,15,9),    validaData(2020,9,16,9),    24,   4).
encomenda(  9,  9,  2,  9,  5,  saomamedeeste,  	validaData(2020,8,17,10),   validaData(2020,8,24,10),   168,  2).
encomenda(  10, 7,  1,  7,  69, palmeira,       	validaData(2020,7,27,20),   validaData(2020,7,28,20),   6,    5).
encomenda(  11, 6,  3,  1,  15, vilaprado,      	validaData(2020,7,27,18),   validaData(2020,7,28,0),    6,    5).
encomenda(  12, 6,  3,  1,  15,	arcos,          	validaData(2020,7,27,18),   validaData(2020,7,28,0),    6,    4).
encomenda(	13, 4,	2,	25,	5,	pousada,			validaData(2020,7,27,18),   validaData(2020,7,28,0),	24,	  4).
encomenda(  14, 5,	4,	50,	5,	covelas,			validaData(2020,7,27,18),   validaData(2020,7,27,18),	24,	  4).
encomenda(  15, 1,	3,	3,	2,	saovicente,			validaData(2020,7,27,18),	validaData(2020,7,27,18),	168,  3).
encomenda(  16, 8,	1,	15,	10,	semelhe,			validaData(2020,7,27,18),   validaData(2020,7,27,18),	6,	  4).
encomenda(  17, 7,  2,	12,	2,	saopedromerelim,	validaData(2020,7,27,18),	validaData(2020,7,27,18),	72,	  1).
