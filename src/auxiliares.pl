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
% Extensão do meta-predicado nao: Questao -> {V, F}
nao(Questao) :- Questao, !, fail.
nao(Questao).

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