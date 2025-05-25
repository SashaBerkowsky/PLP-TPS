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
                      TextoPP _ -> False
                      IntPP _ -> False
                      ObjetoPP xs -> foldr (\(_, x) acc -> acc && pponAtomico x) True xs
                        

intercalar :: Doc -> [Doc] -> Doc
intercalar s = foldr (\x acc -> if acc == vacio then x else x <+> s <+> acc) vacio

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
-- En el caso recursivo se genera la solución a partir del resultado de todas las recursiones previas utilizando map sobre xs
pponADoc :: PPON -> Doc
pponADoc pp = case pp of
                    TextoPP t -> texto (show t)
                    IntPP i -> texto (show i)
                    ObjetoPP xs -> if (tieneHijos xs) then (entreLlaves . docs) xs else ((aplanar . entreLlaves) . docs) xs
                    where
                      tieneHijos xs = any (\x -> case (snd x) of ObjetoPP _ -> True; _ -> False) xs
                      docs xs = map (\x -> texto "\"" <+> texto (fst x) <+> texto "\": " <+> pponADoc (snd x)) xs
