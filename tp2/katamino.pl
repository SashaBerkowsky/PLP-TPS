:- use_module(piezas).

% 12
% Repasamos si sublista puede ser usado como sublista(-D, +T, +L, +R)
% Para esto analizamos casos en los que la funcion tiene una, multiples o ninguna solucion
% Caso solucion unica: (ej. sublista(D, 2, [1,2,3,4,5], [2,3]))
% La lista [2,3] de longitud 2 figura unica vez como sublista como resultado de descartar un elemento
% En este caso el resultado es unico D = 1, No falla
% ***
% Caso multiples soluciones: (ej. sublista(D, 2, [1,2,3,2,3], [2,3]))
% En este ejemplo la lista [2,3] de longitud 2 figura dos veces como sublista:
% Una al eliminar 1 elemento y otra eliminando 2
% Los resultados son: D = 1; D = 3. No falla
% ***
% Caso sin soluciones: (ej. sublista(D, 2, [1,2,3,2,3], [4,5]))
% La lista [4,5] no aparece en ninguna instancia como sublista
% Devuelve la solucion esperada: false
% ***
% Como en cada escenario el predicado sublista(-D, +T, +L, +R) instancia correctamente las variables D y T
% sin caer en errores de instanciacion podemos afirmar que efectivamente es reversible

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
    coordenadas(T, (I, J)),
    espacioSuficiente(T, (I, J), HP, WP),
    seccionTablero(T, HP, WP, (I, J), S),
    colocarPieza(ID, P, S).

espacioSuficiente(T, (I, J), HP, WP) :-
    tamaño(T, FT, CT),
    I =< FT - HP + 1,
    J =< CT - WP + 1.

colocarPieza(_, [], []). 
colocarPieza(ID, [FP|RP], [FT|RT]) :-
    colocarPiezaEnFila(ID, FP, FT),
    colocarPieza(ID, RP, RT).

colocarPiezaEnFila(_, [], []). 
colocarPiezaEnFila(ID, [PU|PR], [TU|TR]) :-
    colocarUnidadPieza(ID, PU, TU),
    colocarPiezaEnFila(ID, PR, TR).

colocarUnidadPieza(ID, PU, TU) :-
    ID == PU,
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
poda(podaMod5, T) :-
    gruposLibres(T, GL),
    todosSonMultiplosDe5(GL).

gruposLibres(T, GL) :-
    coordenadasLibres(T, CL),
    agrupar(CL, GL).

todosSonMultiplosDe5([]).
todosSonMultiplosDe5([G|R]) :-
    length(G, TG),
    TG mod 5 =:= 0,
    todosSonMultiplosDe5(R).

coordenadasLibres(T, CL) :-
    coordenadas(T, CL),
    findall((F, C),
        (nth1(F, T, FA),
         nth1(C, FA, UA),
         var(UA)),
        CL).
