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
aresta(navarra, gualtar, 6).
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
aresta(palmeira, vilaprado, 6).
aresta(palmeira, saovicente, 5).
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
