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

-- Tipo de recursion: primitiva
-- En los casos base se devuelve un valor fijo
-- En el caso recursivo solo utiliza la funcion original (pponADoc) tomando como argumento una versión reducida del argumento original acercándose al caso base
-- Sin embargo en el caso recursivo la funcion si requiere de revisar la estructura original con lo cual esta instancia de recursión no puede ser determinada como estructural
pponADoc :: PPON -> Doc
pponADoc pp = case pp of
                    TextoPP t -> texto (show t)
                    IntPP i -> texto (show i)
                    ObjetoPP xs -> if (all (\(_, v) -> pponAtomico v) xs) then ((aplanar . entreLlaves) . (map (\(k, v) -> clave k <+> pponADoc v))) xs 
                                                                          else (entreLlaves . (map (\(k, v) -> clave k <+> if pponObjetoSimple v then (aplanar. pponADoc) v else pponADoc v))) xs
                    where
                      clave = \x -> texto ("\"" ++ x ++ "\": ")
