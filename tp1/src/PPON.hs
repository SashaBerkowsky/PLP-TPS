module PPON where

import Documento

data PPON
  = TextoPP String
  | IntPP Int
  | ObjetoPP [(String, PPON)]
  deriving (Eq, Show)

pponAtomico :: PPON -> Bool
pponAtomico pp = case pp of
                      TextoPP _ -> True
                      IntPP _ -> True
                      _ -> False

pponObjetoSimple :: PPON -> Bool
pponObjetoSimple pp = case pp of
                      TextoPP _ -> True
                      IntPP _ -> True
                      ObjetoPP xs -> foldr (\(_, x) acc -> acc || pponAtomico x) False xs
                        

intercalar :: Doc -> [Doc] -> Doc
intercalar s = foldr1 (\x acc -> x <+> s <+> acc) 

entreLlaves :: [Doc] -> Doc
entreLlaves [] = texto "{ }"
entreLlaves ds =
  texto "{"
    <+> indentar
      2
      ( linea
          <+> intercalar (texto "," <+> linea) ds
      )
    <+> linea
    <+> texto "}"

aplanar :: Doc -> Doc
aplanar = foldDoc vacio (\s d -> texto s <+> d) (\i d -> texto " " <+> d)

-- Tipo de recursion: global
-- En los casos base se devuelve un valor fijo
-- En el caso recursivo se utilizan todos los resultados de las recursiones previas para generar el resultado utilizando map sobre xs
-- (consultar)
pponADoc :: PPON -> Doc
pponADoc pp = case pp of
                    TextoPP t -> texto (show t)
                    IntPP i -> texto (show i)
                    ObjetoPP xs -> entreLlaves (map (\x -> intercalar (texto ": ") [texto "\"" <+> texto (fst x) <+> texto "\"", pponADoc (snd x)]) xs)
