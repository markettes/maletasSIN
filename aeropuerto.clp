;Hechos estaticos
(deffacts caminos
  (camino F p2 p4 p3 p1)
  (camino R p6 p8 p7 p5)
  (camino p1 p5)
)

(deffacts vagones ;pesos
  (vagont1 0 15)
  (vagont2 16 23)
)

(deffacts maletas ;peso posicion
  (m1 12 F p3)
  (m2 18 F p5)
  (m3 20 p1 R)
  (m4 14 p6 R)
)

;Hechos dinamicos
(deffacts hechosDinamicos ; maquina localizacion cargada ;maletas maleta localizacion ;vagones vagon cogido cargado posicion
  (maquina_transportadora p6 true maletas m1 F m2 F m3 p1 m4 p6 vagones vagont1 true false p6 vagont2 false false p2)
)

;Reglas
