% --------------------
% ---- AUXILIARES ----
% --------------------

% ----------------------------------------
% Calcula o preço total da entrega: Peso, Volume, Transporte, Prazo, Preço -> {V, F}
% Preço calculado da seguinte forma: 15% Peso + 15% Volume + 35% Transporte Utilizado + 35% Prazo de Entrega
calculaPreco(Peso,Volume,Transporte,Prazo,Preco) :- multiplicacao(Peso,15,Peso1),
                                                    multiplicacao(Volume,15,Volume1),
                                                    multiplicacao(Transporte,35,Transporte1),
                                                    calculaPrecoPrazo(Prazo,Prazo1), multiplicacao(Prazo1,35,Prazo2),
                                                    adicao(Peso1,Volume1,Transporte1,Prazo2,Preco1),
                                                    Preco is div(Preco1,100).

% ----------------------------------------
% Multiplicação de 2 números: X, Y, Resultado -> {V, F}
multiplicacao(X,Y,R) :- R = X*Y.

% ----------------------------------------
% Adição de 4 números: X, Y, Z, W, Resultado -> {V, F}
adicao(X,Y,Z,W,R) :- R = X+Y+Z+W.

% ----------------------------------------
% Calcula o preço apropriado para um determinado prazo de entrega: Prazo, Preco -> {V, F}
% Imediato
calculaPrecoPrazo(0, Preco) :- Preco = 15.
% 1 Dia
calculaPrecoPrazo(1,Preco) :- Preco = 5.
% 2 Horas
calculaPrecoPrazo(2,Preco) :- Preco = 10.
% 3 Dias
calculaPrecoPrazo(3,Preco) :- Preco = 3.
% 6 Horas
calculaPrecoPrazo(6,Preco) :- Preco = 7.
% 7 Dias
calculaPrecoPrazo(7,Preco) :- Preco = 1.

% ----------------------------------------
% Verifica se a lista só tem inteiros: Lista -> {V, F}
validaListaInteger([]).
validaListaInteger([H|T]) :- integer(H), validaListaInteger(T).

% ----------------------------------------
% Verifica se o transporte é válido: Transporte -> {V, F}
validaTransporte(T) :- integer(T), T >= 1, T =< 3.

% ----------------------------------------
% Verifica se um prazo de entrega é válido: Prazo -> {V, F}
validaPrazo(PE) :- integer(PE), PE >= 0, PE =< 3, PE == 6, PE == 7.

% ----------------------------------------
% Verifica se uma classificação é válida: Classificação -> {V, F}
validaClassificacao(C) :- integer(C), C >= 0, C =< 5.

% ----------------------------------------
% Verifica se uma data é válida: Data -> {V, F}
validaData(Ano,Mes,Dia,Hora) :- integer(Ano), integer(Mes), integer(Dia), integer(Hora),
                                membro(Mes, [1,3,5,7,8,10,12]),
                                Dia >= 1, Dia =< 31,
                                Hora >= 0, Hora =< 23.
validaData(Ano,Mes,Dia,Hora) :- integer(Ano), integer(Mes), integer(Dia), integer(Hora),
                                membro(Mes, [4,6,9,11]),
                                Dia >= 1, Dia =< 30,
                                Hora >= 0, Hora =< 23.
validaData(Ano,2,Dia,Hora) :-   integer(Ano), integer(Dia), integer(Hora),
                                Dia >= 1, Dia =< 29, Hora >= 0, Hora =< 23.

% Compara datas: Data, Data -> {V, F}

comparaData(validaData(Ano,Mes,Dia,Hora), validaData(Ano2,Mes2,Dia2,Hora2)) :- (Ano-Ano2 < 0;
                                                                                Ano-Ano2 =:= 0, Mes-Mes2 < 0;
                                                                                Ano-Ano2 =:= 0, Mes-Mes2 =:= 0, Dia-Dia2 < 0;
                                                                                Ano-Ano2 =:= 0, Mes-Mes2 =:= 0, Dia-Dia2 =:= 0, Hora-Hora2 =< 0).
                                                                                

% ----------------------------------------
% Verifica se a Encomenda foi entregue no prazo establecido : Data, Data, Prazo -> {V, F}
encomendaEntregue(validaData(A1,M1,D1,H1), validaData(A2,M2,D2,H2), P) :- (P == 0 -> A1 == A2, M1 == M2, D1 == D2, H1 == H2);
                                                                          (P == 2 -> A1 == A2, M1 == M2, D1 == D2, H2-H1 =< 2);
                                                                          (P == 6 -> A1 == A2, M1 == M2, D1 == D2, H2-H1 =< 6);
                                                                          (P == 1 -> A1 == A2, M1 == M2, D2-D1 =< 1);
                                                                          (P == 3 -> A1 == A2, M1 == M2, D2-D1 =< 3);
                                                                          (P == 7 -> A1 == A2, M1 == M2, D2-D1 =< 7).
% ----------------------------------------
% Conta elementos : Elem, L -> {V, F}
contaElem(_,[],0).
contaElem(X,[X|T],Count) :- contaElem(X,T,Count1), Count is Count1+1.
contaElem(X,[_|T],Count) :- contaElem(X,T,Count).

% ----------------------------------------
% Somatorio de uma lista : L -> {V, F}
sum_Lista([],0).
sum_Lista([X|L],Sum) :- sum_Lista(L,Sum1), 
                        Sum is X + Sum1.

% ----------------------------------------
% Adiciona os elementos com datas entre o intervalo de tempo dado numa nova lista : Data, Data, L -> {V, F}
filtraDataElemento(_,_,[],[]).
filtraDataElemento(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),[(D,E)|R],L2) :- (comparaData(validaData(A1,M1,D1,H1),D),
                                                                                    nao(comparaData(validaData(A2,M2,D2,H2),D))) ->
                                                                                    filtraDataElemento(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),R,L1),
                                                                                    adicionar(E,L1,L2);
                                                                                    filtraDataElemento(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),R,L2). 
% ----------------------------------------
% Adiciona um elemento ao inicio da lista : Elem, L -> {V, F}
adicionar(X,[],[X]).                                              
adicionar(X,L,[X|L]).

% ----------------------------------------
% Cria uma lista de pares (Elem,NºOcurrenciaElemento) : L -> {V, F}
parElementoOcorrencia([],[]).
parElementoOcorrencia([H|T],L) :-   contaElem(H,[H|T],Count),
                                    apagaT(H,[H|T],NewList),
                                    parElementoOcorrencia(NewList,Ls),
                                    adicionar((H,Count),Ls,L), !.

% ----------------------------------------
% Apaga todas as ocorrencias de um elemento numa lista : Elem, L -> {V, F}
apagaT(_,[],[]).
apagaT(X,[X|R],L) :- apagaT(X,R,L).
apagaT(X,[Y|R],[Y|L]) :- X \= Y, apagaT(X,R,L).

% ----------------------------------------
% Extensão do meta-predicado nao: Questao -> {V, F}
nao(Questao) :- Questao, !, fail.
nao(_).

% ----------------------------------------
% Extensão do meta-predicado solucoes: Elemento, Questao, Lista -> {V, F}
solucoes(E,Q,L) :- findall(E,Q,L).

% ----------------------------------------
% Extensão do meta-predicado comprimento: Lista, Comprimento -> {V, F}
comprimento(L,C) :- length(L,C).

% ----------------------------------------
% Extensão do meta-predicado membro: Elemento, Lista -> {V, F}
membro(X,[X|_]).
membro(X,[Y|L]) :- X \= Y, membro(X,L).

% ----------------------------------------