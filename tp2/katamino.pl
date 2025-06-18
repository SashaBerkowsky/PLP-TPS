:- use_module(piezas).

% 1
sublista(D,T,L,R) :- 
    length(PD, D),
    length(R, T),
    append(PD, PR, L),
    append(R, _, PR).

% 2 
tablero(K, T) :-
    K > 0,
    length(T, 5),
    maplist(esFila(K), T).

esFila(C, F) :-
    length(F, C).
  
% 3
tamaño(M, F, C) :-
    length(M, F),
    F > 0,
    nth0(0, M, F1),
    length(F1, C).

% 4
coordenadas(T, IJ) :-
    tamaño(T, X, Y),
    between(1, X, I),
    between(1, Y, J),
    IJ = (I, J).

% 5
kPiezas(K, PS) :- nombrePiezas(L), length(PS,K), elegirPiezas(K, L, PS).

elegirPiezas(0, _, []). 
elegirPiezas(K, [X|L],[X|PS]):- K > 0,K1 is K - 1, elegirPiezas(K1, L, PS).
elegirPiezas(K, [_|L],PS):- K > 0, elegirPiezas(K, L, PS).

% 6 
seccionTablero(T, ALTO, ANCHO, (I, J), ST) :-
    PF is I - 1,
    PC is J - 1,

    tamaño(T, FT, CT),

    FF is PF + ALTO,
    FF =< FT,
    FC is PC + ANCHO,
    FC =< CT,

    sublista(PF, ALTO, T, FS),
    maplist(obtenerCols(PC, ANCHO), FS, ST).

obtenerCols(J, ANCHO, FS, FA) :-
    sublista(J, ANCHO, FS, FA).    

% 7
ubicarPieza(T, ID) :-
    pieza(ID, P), 
    tamaño(P, HP, WP),
    tamaño(T, FILAS, COLS),
    between(1, FILAS, I),
    between(1, COLS, J),
    seccionTablero(T, HP, WP, (I, J), S),
    colocarPieza(ID, P, S).

colocarPieza(_, [], []). 
colocarPieza(ID, [FP|RP], [FT|RT]) :-
    colocarPiezaEnFila(ID, FP, FT),
    colocarPieza(ID, RP, RT).

colocarPiezaEnFila(_, [], []). 
colocarPiezaEnFila(ID, [PU|PR], [TU|TR]) :-
    colocarUnidadPieza(ID, PU, TU),
    colocarPiezaEnFila(ID, PR, TR).

colocarUnidadPieza(ID, ID, TU) :-
    var(TU),
    TU = ID.
colocarUnidadPieza(_, PU, _) :- var(PU).

% 8
ubicarPiezas(_, _, []).
ubicarPiezas(T, Poda, [PA|PR]) :-
    ubicarPieza(T, PA),
    poda(Poda, T),
    ubicarPiezas(T, Poda, PR).

% 9
llenarTablero(Poda, C, T) :-
    tablero(C, T),
    kPiezas(C, P),
    ubicarPiezas(T, Poda, P).

% 10
cantSoluciones(Poda, C, N) :-
    findall(T, llenarTablero(Poda, C, T), TS),
    length(TS, N).

% 11
poda(sinPoda, _) :- true.
poda(podaMod5, T) :- todosGruposLibresModulo5(T).

todosGruposLibresModulo5(T) :-
    coordenadasLibres(T, CL),
    agruparCoordenadasLibres(CL).

agruparCoordenadasLibres([]) :- true.
agruparCoordenadasLibres(CL) :-
    agrupar(CL, GL),
    maplist(tamañoEsMod5, GL).

tamañoEsMod5(G) :-
    length(G, TG),
    TG mod 5 =:= 0.

coordenadasLibres(T, LC) :-
    tamaño(T, CF, CC),
    findall((F,C), (
        between(1, CF, F),
        between(1, CC, C),
        esCeldaLibre(T, F, C)
    ), LC).

esCeldaLibre(T, F, C) :-
    PF is F - 1,
    nth0(PF, T, UF),

    PC is C - 1,
    nth0(PC, UF, U),
    var(U).
