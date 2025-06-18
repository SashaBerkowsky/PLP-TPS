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
ubicarPieza(Tablero, Identificador) :-
    pieza(Identificador, FormaPieza), 
    tamaño(FormaPieza, AltoPieza, AnchoPieza),
    tamaño(Tablero, FilasTablero, ColsTablero),

    between(1, FilasTablero, I),
    between(1, ColsTablero, J),

    seccionTablero(Tablero, AltoPieza, AnchoPieza, (I, J), SeccionTablero),

    colocar_pieza_en_seccion(Identificador, FormaPieza, SeccionTablero).

colocar_pieza_en_seccion(_, [], []). 
colocar_pieza_en_seccion(Identificador, [FilaPieza | RestoPieza], [FilaTablero | RestoTablero]) :-
    colocar_fila_pieza(Identificador, FilaPieza, FilaTablero),
    colocar_pieza_en_seccion(Identificador, RestoPieza, RestoTablero).

colocar_fila_pieza(_, [], []). 
colocar_fila_pieza(Identificador, [P_Celda | P_Resto], [T_Celda | T_Resto]) :-
    (   P_Celda == Identificador
    ->  
        var(T_Celda),
        T_Celda = Identificador
    ;   var(P_Celda) 
    ->  
        true
    ;   false 
    ),
    colocar_fila_pieza(Identificador, P_Resto, T_Resto).

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
cantSoluciones(Poda, Columnas, N) :-
    findall(T, llenarTablero(Poda, Columnas, T), TS),
    length(TS, N).

% 11
poda(sinPoda, _) :- true.
poda(podaMod5, T) :- todosGruposLibresModulo5(T).

celda_es_libre(Tablero, Fila, Columna) :-
    IndiceFila is Fila - 1,
    nth0(IndiceFila, Tablero, Row),
    IndiceColumna is Columna - 1,
    nth0(IndiceColumna, Row, Celda),
    var(Celda).

obtener_coordenadas_libres(Tablero, ListaCoordenadas) :-
    tamaño(Tablero, NumFilas, NumColumnas),
    findall( (F,C), (
        between(1, NumFilas, F),
        between(1, NumColumnas, C),
        celda_es_libre(Tablero, F, C)
    ), ListaCoordenadas).

grupo_es_modulo_5(Grupo) :-
    length(Grupo, TamanoGrupo),
    TamanoGrupo mod 5 =:= 0.

todosGruposLibresModulo5(Tablero) :-
    obtener_coordenadas_libres(Tablero, CoordenadasLibres),
    (   CoordenadasLibres == []
    ->  true
    ;   
        agrupar(CoordenadasLibres, GruposLibres),
        maplist(grupo_es_modulo_5, GruposLibres)
    ).


