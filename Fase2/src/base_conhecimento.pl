% ------------------------------
% ---- BASE DE CONHECIMENTO ----
% ------------------------------

% ------------------------------------------
% Aresta: LocalidadeOrigem, LocalidadeDestino, CustoDistancia -> {V,F}
aresta(saovictor, pinheirovelho, 4).
aresta(saovictor, gualtar, 3).
aresta(saovictor, saovicente, 4).
aresta(pinheirovelho, regadas, 3).
aresta(gualtar, regadas, 4).
aresta(gualtar, pousada, 6).
aresta(gualtar, navarra, 6).
aresta(gualtar, adaufe, 4).
aresta(saovicente, adaufe, 4).
aresta(saovicente, palmeira, 5).
aresta(saovicente, saopedromerelim, 5).
aresta(regadas, pousada, 3).
aresta(pousada, navarra, 5).
aresta(pousada, amares, 6).
aresta(navarra, adaufe, 4).
aresta(palmeira, saopedromerelim, 5).
aresta(palmeira, vilaprado, 6).
aresta(saopedromerelim, vilaprado, 3).
aresta(vilaprado, lago, 7).
aresta(lago, amares, 7).

% ------------------------------------------
% estimaD: Localidade, estimaDistância -> {V,F}
estimaD(saovictor, 10).
estimaD(pinheirovelho, 7).
estimaD(gualtar, 8).
estimaD(saovicente, 9).
estimaD(regadas, 5).
estimaD(pousada, 4).
estimaD(navarra, 4).
estimaD(adaufe, 7).
estimaD(palmeira, 8).
estimaD(saopedromerelim, 11).
estimaD(vilaprado, 10).
estimaD(lago, 6).

% ------------------------------------------
% Objetivo: Localidade -> {V,F}
objetivo(amares).