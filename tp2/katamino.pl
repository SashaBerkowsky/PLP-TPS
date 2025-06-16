:- use_module(piezas).

% Completar ...
%1
partir(N, Lista, L1, L2) :-
    append(L1, L2, Lista),
    length(L1, N).

sublista(D,T,L,R) :- partir(D,L,_,L2), partir(T, L2, R, _).

%2 
tablero(K, T) :-
    K > 0,
    length(T, 5),
    maplist(es_fila(K), T).

es_fila(C, F) :-
    length(F, C).
  
%3
tamaño(M, F, C) :-
    length(M, F),
    F > 0,
    nth0(0, M, F1),
    length(F1, C).

%4
coordenadas(T, IJ) :-
    tamaño(T, X, Y),
    between(1, X, I),
    between(1, Y, J),
    IJ = (I, J).

%5
kPiezas(K, PS) :- nombrePiezas(L), length(PS,K), elegirPiezas(K, L, PS).

elegirPiezas(0, _, []). 
elegirPiezas(K, [X|L],[X|PS]):- K > 0,K1 is K - 1, elegirPiezas(K1, L, PS).
elegirPiezas(K, [_|L],PS):- K > 0, elegirPiezas(K, L, PS).

%6 
buscarFila(T,1, T).
buscarFila([_|T],FILA, PS):- FILA > 1, FILA1 is FILA - 1, buscarFila(T,FILA1, PS).

ejercicio([], _, _, _, []).
ejercicio(, 0,, _,[]).
ejercicio([X|T], ALTO, ANCHO, (_, J), ST) :-
    J1 is J - 1,
    sublista(J1, ANCHO, X, R),
    ALTO1 is ALTO - 1,
    ejercicio(T, ALTO1, ANCHO, (_, J), ST1),
    append(R, ST1, ST).
seccionTablero(T,ALTO, ANCHO, IJ, ST):- IJ = (I,_), buscarFila(T,I, T1), ejercicio(T1, ALTO, ANCHO, IJ, ST).

%7
ubicarPieza(T, Id):- pieza(Id,F), ubicar(T,F,T).

ubicar(T,[],T).
ubicar([X|T],[Y|F], [Z|T1]):- poner(X,Y,Z), ubicar(T,F,T1).
ubicar([X|T],F, T):- ubicar(T,F,T1).

poner(X,[],X). 
poner([B|X],[A|Y],[A|Z]):- var(B), poner(X,Y,Z). 
%8
ubicarPiezas(_, _, []).
ubicarPiezas(T0, Poda, [X|IdL]) :- 
    ubicarPieza(T0, X, T1), 
    ubicarPiezas(T1, Poda, IdL).
