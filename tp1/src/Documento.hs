module Documento
  ( Doc,
    vacio,
    linea,
    texto,
    foldDoc,
    (<+>),
    indentar,
    mostrar,
    imprimir,
  )
where

data Doc
  = Vacio
  | Texto String Doc
  | Linea Int Doc
  deriving (Eq, Show)

vacio :: Doc
vacio = Vacio

linea :: Doc
linea = Linea 0 Vacio

texto :: String -> Doc
texto t | '\n' `elem` t = error "El texto no debe contener saltos de línea"
texto [] = Vacio
texto t = Texto t Vacio

-- foldDoc :: ... PENDIENTE: Ejercicio 1 ...
foldDoc :: b -> (String -> b -> b)  -> (Int -> b -> b) -> Doc -> b
foldDoc cVacio cTexto cLinea d = case d of
                                    Vacio -> cVacio
                                    Texto s doc -> cTexto s (rec doc)
                                    Linea ind doc -> cLinea ind (rec doc)
                                where
                                  rec = foldDoc cVacio cTexto cLinea


-- NOTA: Se declara `infixr 6 <+>` para que `d1 <+> d2 <+> d3` sea equivalente a `d1 <+> (d2 <+> d3)`
-- También permite que expresiones como `texto "a" <+> linea <+> texto "c"` sean válidas sin la necesidad de usar paréntesis.
infixr 6 <+>

-- Satisface el invariante:
-- En caso de concatenar textos, como ambos documentos previos cumplen con el invariante, al concatenar su contenido el resultado no puede ser vacio, esto tambien es valido para los saltos de línea, ningún documento previo contiene texto con salto de linea incluido con lo cual, al concatenarlos el resultado no puede poseerlo
-- Al concatenar 2 textos, estos documentos se combinan, no generan ningun Doc::Texto extra (revisar)
-- Al combinar cualquier documento con una linea, la indentación solo puede incrementarse o conservar su valor y, como ambos documentos d1 y d2 cumplen con el invariante la indentacion de todas sus lineas es >= 0 con lo cual la suma de ambos solo puede ser >= a 0
(<+>) :: Doc -> Doc -> Doc
(<+>) d1 d2 = foldDoc d2 (\s d -> case d of
                                        Vacio -> Texto s Vacio
                                        Texto s' doc -> Texto (s ++ s') doc
                                        Linea ind doc -> Texto s (Linea ind doc))
                        (\ind d -> case d of
                                        Vacio -> Linea ind Vacio
                                        Texto s doc -> Linea ind (Texto s doc)
                                        Linea ind' doc -> Linea (ind + ind') doc) d1
-- Satisface el invariante:
-- i es mayor a 0 y el documento de entrada para la funcion indentar cumple con el invariante de Doc
-- Con lo cual toda linea del documento de entrada tiene una indentación >= 0
-- La funcion aumenta la indentacion >= 0 de cada linea en i el cual también es mayor o igual a 0
-- Todo numero mayor o igual a 0 + otro numero mayor o igual a 0 da como resultado un numero >= 0
indentar :: Int -> Doc -> Doc
indentar i = foldDoc Vacio (\s d -> Texto s d) (\ind d -> Linea (ind + i) d)

mostrar :: Doc -> String
mostrar = foldDoc "" (\t s -> t ++ s) (\i s -> "\n" ++ espacios i ++ s)
      where
          espacios 0 = ""
          espacios n = " " ++ espacios (n - 1)

-- | Función dada que imprime un documento en pantalla

-- ghci> imprimir (Texto "abc" (Linea 2 (Texto "def" Vacio)))
-- abc
--   def

imprimir :: Doc -> IO ()
imprimir d = putStrLn (mostrar d)
