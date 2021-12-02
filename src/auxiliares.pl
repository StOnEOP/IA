% --------------------
% ---- AUXILIARES ----
% --------------------

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

encomendaEntregue2(validaData(A1,M1,D1,H1), P,R) :-    (P == 0 -> R = validaData(A1,M1,D1,H1));
                                                                                (P == 2 -> R = validaData(A1,M1,D1,H1+2);
                                                                                (P == 6 -> R = validaData(A1,M1,D1,H1+6);
                                                                                (P == 1 -> R = validaData(A1,M1,D1+1,H1);
                                                                                (P == 3 -> R = validaData(A1,M1,D1+3,H1);
                                                                                (P == 7 -> R = validaData(A1,M1,D1+7,H1)). %e se mudar de mes?
    


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