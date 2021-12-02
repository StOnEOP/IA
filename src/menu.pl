% ----------------------
% -------- MENU --------
% ----------------------

% ------------------------------------------
% Definições iniciais
:- consult('funcionalidades.pl').

% ------------------------------------------
% Menu
menu :-
    repeat,
    write('----------------------'), nl,
    write('-------- MENU --------'), nl,
    write('----------------------'), nl,
    write('1.  Query 1'), nl,
    write('2.  Query 2'), nl,
    write('3.  Query 3'), nl,
    write('4.  Query 4'), nl,
    write('5.  Query 5'), nl,
    write('6.  Query 6'), nl,
    write('7.  Query 7'), nl,
    write('8.  Query 8'), nl,
    write('9.  Query 9'), nl,
    write('10. Query 10'), nl,nl,
    write('0.  Sair'), nl,
    read(Choice), nl, nl,
    rule(Choice),
    fail. 

% ------------------------------------------
% Funcionalidades
% - Query 1 - Teste: Nenhum input
rule(1) :-  write('1: Estafeta que utilizou mais vezes um meio de transporte mais ecológico.'), !, nl,
            estafetaEcologico(Elem),
            write('Resposta: '), write(Elem), !, nl, nl.

% - Query 2 - Teste: [2,11] 6
rule(2) :-  write('2: Estafetas que entregaram determinadas encomendas a um determinado cliente.'), !, nl,
            write('Introduza uma lista de ids de encomendas.'), !, nl, read(LE),
            write('Introduza o id do cliente.'), !, nl, read(Cliente),
            estafetasEncomendaCliente(LE,Cliente,L),
            write('Resposta: '), write(L), !, nl, nl.

% - Query 3 - Teste: 2
rule(3) :-  write('3: Clientes servidos por um determinado estafeta.'), !, nl,
            write('Introduza o id do estafeta.'), !, nl, read(Estafeta),
            clientesEstafeta(L,Estafeta),
            write('Resposta: '), write(L), !, nl, nl.

% - Query 4 - Teste: (2020,7,27,6)
rule(4) :-  write('4: Valor faturado pela Green Distribution num determinado dia.'), !, nl,
            write('Introduza uma data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A,M,D,H)),
            faturaDia(validaData(A,M,D,H),Sum),
            write('Resposta: '), write(Sum), !, nl, nl.

% - Query 5 - Teste: Nenhum input
rule(5) :-  write('5: Zonas com maior volume de entregas por parte da Green Distribution.'), !, nl,
            zonaMaisVolume(Max,Zona),
            write('Resposta: '), write(Zona), write(' '), write(Max), !, nl, nl.

% - Query 6 - Teste: 4
rule(6) :-  write('6: Classificação média de satisfação dos clientes de um determinado estafeta.'), !, nl,
            write('Introduza o id do estafeta.'), !, nl, read(Estafeta),
            estafetaMedia(Estafeta,Media),
            write('Resposta: '), write(Media), !, nl, nl.

% - Query 7 - Teste: (2010,1,1,1) (2030,1,1,1)
rule(7) :-  write('7: Número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo.'), nl,
            write('Introduza a primeira data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A1,M1,D1,H1)),
            write('Introduza a segunda data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A2,M2,D2,H2)),
            totalEntregasTransporte(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),L),
            write('Resposta: '), write(L), !, nl, nl.

% - Query 8 - Teste: (2020,1,1,1) (2020,9,9,9)
rule(8) :-  write('8: Número total de entregas pelos estafetas, num determinado intervalo de tempo.'), nl,
            write('Introduza a primeira data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A1,M1,D1,H1)),
            write('Introduza a segunda data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A2,M2,D2,H2)),
            totalEntregasEstafeta(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2),Sorted),
            write('Resposta: '), write(Sorted), !, nl, nl.

% - Query 9 - Teste: (2020,1,1,1) (2020,9,9,9)
rule(9) :-  write('9: Número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo.'), nl,
            write('Introduza a primeira data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A1,M1,D1,H1)),
            write('Introduza a segunda data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A2,M2,D2,H2)),
            entregueENaoEntregue(validaData(A1,M1,D1,H1),validaData(A2,M2,D2,H2), A,B),
            write('Resposta: '), write('Encomendas entregues = '), write(A), write('   Encomendas não entregues = '), write(B), !, nl, nl.

% - Query 10 - Teste: (2020,7,28,20)
rule(10) :- write('10: Peso total transportado por cada estafeta, num determinado dia.'), !, nl,
            write('Introduza uma data no seguinte formato (Ano,Mes,Dia,Hora).'), !, nl, read((A,M,D,H)),
            estafetaPeso(validaData(A,M,D,H),L),
            write('Resposta: '), write(L), !, nl, nl.

% - Option 0
rule(0) :- write('A sair do programa...'), nl, halt.

% ------------------------------------------