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
(deffacts hechosDinamicos ; maquina localizacion cargada enganchada ;maletas maleta localizacion ;vagones vagon cogido posicion maletasCogidas
  (maquina_transportadora p6 false true maletas m1 F m2 F m3 p1 m4 p6 vagones vagont1 true p6 vagont2 false p2 maletasCogidas)
)

;Reglas
(defrule coger_maleta
  ;preguntar si el cambio de ?cargada a true es correcto
  (maquina_transportadora ?sitiomaq ?cargada true maletas $?x ?maleta ?sitiomal $?y vagones $?z ?vagon true ?sitiovag $?r)
  (test (= ?sitiomaq ?sitiomal))
  (?maleta ?peso $?c)
  (?vagon ?pesoMin ?pesoMax)
  (test (< ?peso ?pesoMax))
  (test (> ?peso ?pesoMin))
  =>
  (printout t " Maleta ha sido cargada ")
  (bind ?cargada true)
  (assert (maquina_transportadora ?sitiomaq ?cargada true maletas $?x $?y vagones $?z ?vagon true ?sitiovag $?r ?maleta ?sitiomal))
)

(defrule descargar_maleta
  (maquina_transportadora ?sitiomaq true true $?x vagones $?z ?vagon true ?sitiovag $?r maletasCogidas $?y ?maleta ?sitiomal $?h)
  (?maleta ?x ?y ?final)
  (test (= ?sitiomaq ?final))
  =>
  ;preguntar duda sobre como hacer para comprobar si es la última maleta
  (printout t " Maleta ha sido descargada ")
  (assert (maquina_transportadora ?sitiomaq true $?x vagones $?z ?vagon true ?sitiovag $?r maletasCogidas $?y $?h))
)

(defrule mover_maquina

)

(defrule enganchar_vagon
  (maquina_transportadora ?sitiomaq false false maletas $?r vagones $?r1 ?vagon false ?sitiovag $?r2)
  (test (= ?sitiomaq ?sitiovag))
  =>
  (printout t ?vagon" cogido ")
  (maquina_transportadora ?sitiomaq false true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2)
)

(defrule desenganchar_vagon
  (maquina_transportadora ?sitiomaq false true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2)
  (test (= ?sitiomaq ?sitiovag))
  =>
  (printout t ?vagon" soltado ")
  (maquina_transportadora ?sitiomaq false false maletas $?r vagones $?r1 ?vagon false ?sitiovag $?r2)
)

(defrule objetivo
  (maquina_transportadora ?sitiomaq false ?noMatters maletas vagones $?r maletasCogidas)
  =>
  (printout t "SOLUCION ENCONTRADA")
)
