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
-- intercalar s xs = if null xs then vacio else foldl (\acc x -> if x == vacio then acc else acc <+> s <+> x) (if (head xs) == vacio then s else head xs) (tail xs)
intercalar s xs = if null xs then vacio else foldl1 (\acc x -> if x == vacio then s else acc <+> s <+> x) xs

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
                    ObjetoPP xs -> if pponObjetoSimple pp 
                                    then (aplanar . entreLlaves) (map parClaveValor xs)
                                    else entreLlaves (map parClaveValor xs)
                where
                  parClaveValor = \(clave, valor) -> texto ("\"" ++ clave ++ "\": ") <+> pponADoc valor
