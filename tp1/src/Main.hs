module Main (main) where

import Documento
import PPON
import Test.HUnit

main :: IO ()
main = runTestTTAndExit allTests

allTests :: Test
allTests =
  test
    [ "Ejercicio 2" ~: testsEj2,
      "Ejercicio 3" ~: testsEj3,
      "Ejercicio 4" ~: testsEj4,
      "Ejercicio 6" ~: testsEj6,
      "Ejercicio 7" ~: testsEj7,
      "Ejercicio 8" ~: testsEj8,
      "Ejercicio 9" ~: testsEj9
    ]

i1, i2, i3, i4, indDoble :: Doc
i1 = texto "Sasha Berkowsky"
i2 = texto "Manuel Poutays"
i3 = texto "Bruno Gvirtz"
i4 = texto "Thiago Ghianni"
indDoble = indentar 2 linea

nombres :: [Doc]
nombres = [i1, i2, i3, i4]


testsEj2 :: Test
testsEj2 =
  test
    [ vacio <+> vacio ~?= vacio,
      texto "a" <+> texto "b" ~?= texto "ab",
      (texto "a" <+> linea) <+> texto "b" ~?= texto "a" <+> (linea <+> texto "b"),
      texto "Integrantes:" <+> linea <+> i1 <+> linea <+> linea <+> i2 <+> linea <+> i3 <+> linea <+> i4 ~=? texto "Integrantes:" <+> (linea <+> (i1 <+> linea <+> linea <+> i2 <+> linea <+> i3 <+> linea <+> i4)),
      (texto "Hola!" <+> linea) <+> texto "Somos el equipo lambda." ~?= texto "Hola!" <+> linea <+> texto "Somos el equipo lambda.",
      vacio <+> linea <+> vacio ~=? linea
    ]

testsEj3 :: Test
testsEj3 =
  test
    [ indentar 2 vacio ~?= vacio,
      indentar 2 (texto "a") ~?= texto "a",
      indentar 2 (texto "a" <+> linea <+> texto "b") ~?= texto "a" <+> indentar 2 (linea <+> texto "b"),
      indentar 2 (linea <+> texto "a") ~?= indentar 1 (indentar 1 (linea <+> texto "a")),
      indentar 2 (indDoble) ~?= indentar 4 (linea),
      indentar 2 (i1 <+> i2) ~?= i1 <+> i2,
      indentar 0 (i2 <+> indDoble <+> i3) ~?= indentar 2 (i2 <+> linea <+> i3)
    ]

testsEj4 :: Test
testsEj4 =
  test
    [ mostrar vacio ~?= "",
      mostrar linea ~?= "\n",
      mostrar (indentar 2 (texto "a" <+> linea <+> texto "b")) ~?= "a\n  b",
      mostrar (texto "Hola!" <+> linea <+> texto "Somos el grupo lambda.") ~?= "Hola!\nSomos el grupo lambda.",
      mostrar (texto "Hola!" <+> indDoble <+> texto "Somos el grupo lambda.") ~?= "Hola!\n  Somos el grupo lambda."
    ]

pericles, merlina, addams, familias :: PPON
pericles = ObjetoPP [("nombre", TextoPP "Pericles"), ("edad", IntPP 30)]
merlina = ObjetoPP [("nombre", TextoPP "Merlina"), ("edad", IntPP 24)]
addams = ObjetoPP [("0", pericles), ("1", merlina)]
familias = ObjetoPP [("Addams", addams)]

grupo, nombreGrupo, numeroIntegrantes, integrante1, integrante2, integrante3, integrante4, integrantes :: PPON
nombreGrupo = TextoPP "Lambda"
numeroIntegrantes = IntPP 4
integrante1  = ObjetoPP [("nombre", TextoPP "Sasha Berkowsky"), ("email", TextoPP "snberkowsky@gmail.com")]
integrante2  = ObjetoPP [("nombre", TextoPP "Manuel Poutays"), ("email", TextoPP "manuelpoutays@gmail.com")]
integrante3  = ObjetoPP [("nombre", TextoPP "Bruno Gvirtz"), ("email", TextoPP "bgvirtz18@gmail.com")]
integrante4  = ObjetoPP [("nombre", TextoPP "Thiago Ghianni"), ("email", TextoPP "ghiannithiago@gmail.com")]
integrantes = ObjetoPP [("1158/23", integrante1), ("1256/23", integrante2), ("1173/23", integrante3), ("1182/22", integrante4)]
grupo = ObjetoPP [("integrantes", integrantes), ("nombre", nombreGrupo), ("cantidad de integrantes", numeroIntegrantes)]

testsEj6 :: Test
testsEj6 =
  test
    [ pponObjetoSimple pericles ~?= True,
      pponObjetoSimple addams ~?= False,
      pponObjetoSimple nombreGrupo ~?= True,
      pponObjetoSimple integrantes ~?= False
    ]

a, b, c :: Doc
a = texto "a"
b = texto "b"
c = texto "c"

testsEj7 :: Test
testsEj7 =
  test
    [ mostrar (intercalar (texto ", ") []) ~?= "",
      mostrar (intercalar (texto ", ") [a, b, c]) ~?= "a, b, c",
      mostrar (intercalar (texto ", ") nombres) ~?= "Sasha Berkowsky, Manuel Poutays, Bruno Gvirtz, Thiago Ghianni",
      mostrar (entreLlaves []) ~?= "{ }",
      mostrar (entreLlaves [a, b, c]) ~?= "{\n  a,\n  b,\n  c\n}",
      mostrar (entreLlaves nombres) ~?= "{\n  Sasha Berkowsky,\n  Manuel Poutays,\n  Bruno Gvirtz,\n  Thiago Ghianni\n}"
    ]

testsEj8 :: Test
testsEj8 =
  test
    [ mostrar (aplanar (a <+> linea <+> b <+> linea <+> c)) ~?= "a b c",
      mostrar (aplanar (i1 <+> linea <+> i2 <+> linea <+> linea <+> i3 <+> linea <+> i4)) ~?= "Sasha Berkowsky Manuel Poutays Bruno Gvirtz Thiago Ghianni",
      mostrar (aplanar (i1 <+> indDoble <+> i2 <+> indDoble <+> indDoble <+> i3 <+> indDoble <+> i4)) ~?= "Sasha Berkowsky Manuel Poutays Bruno Gvirtz Thiago Ghianni"
    ]

testsEj9 :: Test
testsEj9 =
  test
    [ mostrar (pponADoc pericles) ~?= "{ \"nombre\": \"Pericles\", \"edad\": 30 }",
      mostrar (pponADoc addams) ~?= "{\n  \"0\": { \"nombre\": \"Pericles\", \"edad\": 30 },\n  \"1\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n}",
      mostrar (pponADoc familias) ~?= "{\n  \"Addams\": {\n    \"0\": { \"nombre\": \"Pericles\", \"edad\": 30 },\n    \"1\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n  }\n}",
      mostrar (pponADoc grupo) ~?= "{\n  \"integrantes\": {\n    \"1158/23\": { \"nombre\": \"Sasha Berkowsky\", \"email\": \"snberkowsky@gmail.com\" },\n    \"1256/23\": { \"nombre\": \"Manuel Poutays\", \"email\": \"manuelpoutays@gmail.com\" },\n    \"1173/23\": { \"nombre\": \"Bruno Gvirtz\", \"email\": \"bgvirtz18@gmail.com\" },\n    \"1182/22\": { \"nombre\": \"Thiago Ghianni\", \"email\": \"ghiannithiago@gmail.com\" }\n  },\n  \"nombre\": \"Lambda\",\n  \"cantidad de integrantes\": 4\n}"
    ]
