# Ejercicio 10
Mediante el uso de razonamiento ecuacional e inducción estructural vamos a demostrar que:

indentar n (indentar m x) = indentar (n+m) x	para todo n, m :: Int >= 0. x :: Doc

Antes de continuar definimos la notación "\equiv" que hace referencia al símbolo de equivalencia
Esta notación va a ser usada en múltiples ocaciones durante el razonamiento con el fin de no confundir la equivalencia con la igualdad (=)

## Lemas
Previo a la resolución definimos y demostramos los siguientes 3 lemas:
	1. indentar k Vacio = Vacio para todo k :: Int >= 0							{L1}
	2. indentar k (Texto s d) = Texto s (indentar k d) para todo k :: Int >= 0. s :: String. d :: Doc	{L2}
	3. indentar m (Linea k d) = Linea (m+k) (indentar m d) para todo m, k :: Int >= 0. d :: Doc		{L3}

### Demostraciones de lemas
Para facilitar la notación vamos a definir las siguientes funciones auxiliares:
f :: String -> Doc -> Doc
f = \s d -> Texto s d			{F}
	
g :: Int ->  Int -> Doc -> Doc
g = (\k i d -> Linea (k + i) d)		{G}

#### Lema 1 (L1)
	indentar k Vacio
\equiv	foldDoc Vacio f (g k) Vacio	{I}
\equiv	Vacio					{FV}

Demostramos que la igualdad indentar k Vacio = Vacio vale para todo k :: Int >= 0 por definición

#### Lema 2 (L2)
indentar k (Texto s d) = Texto s (indentar k d) para todo k :: Int >= 0. s :: String. d :: Doc

	indentar k (Texto s d)
\equiv	foldDoc Vacio f (g k) (Texto s d)		{I}
\equiv	f s (rec d)					{FT}
\equiv	f s (foldDoc Vacio f (g k) d)		{REC}
\equiv	f s (indentar k d)				{I}
\equiv	Texto s (indentar k d)				{F}

Demostramos que vale la igualdad por definición

#### Lema 3 (L3)

	indentar m (Linea k d)
\equiv	foldDoc Vacio f (g m) (Linea k d)		{I}
\equiv	g (m+k) (rec d)					{FL}
\equiv	g (m+k) (foldDoc Vacio f (g m) d)		{REC}
\equiv	g (m+k) (indentar m d)				{I}

Demostramos que vale la igualdad por definición

## Resolución
