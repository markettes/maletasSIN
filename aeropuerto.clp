;Hechos estaticos
(deffacts caminos
  (camino p1 f)
  (camino p1 p3)
  (camino p1 p5)
  (camino p2 f)
  (camino p2 p4)
  (camino p3 p4)
  (camino p3 p1)
  (camino p4 p2)
  (camino p4 p3)
  (camino p5 p1)
  (camino p5 r)
  (camino p5 p7)
  (camino p6 p8)
  (camino p6 r)
  (camino p7 p5)
  (camino p7 p8)
  (camino p8 p6)
  (camino p8 p7)
  (camino r p6)
  (camino r p5)
  (camino f p1)
  (camino f p2)
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
(deffacts hechosDinamicos ; maquina localizacion enganchada ;maletas maleta localizacion ;vagones vagon cogido posicion maletasCogidas
  (maquina_transportadora p6 true maletas m1 F m2 F m3 p1 m4 p6 vagones vagont1 true p6 vagont2 false p2 maletasCogidas)
)

;Reglas
(defrule coger_maleta
  (maquina_transportadora ?sitiomaq true maletas $?x ?maleta ?sitiomal $?y vagones $?z ?vagon true ?sitiovag $?r)
  (test (eq ?sitiomaq ?sitiomal))
  (?maleta ?peso $?c)
  (?vagon ?pesoMin ?pesoMax)
  (test (<= ?peso ?pesoMax))
  (test (>= ?peso ?pesoMin))
  =>
  (printout t " Maleta ha sido cargada ")
  (assert (maquina_transportadora ?sitiomaq true maletas $?x $?y vagones $?z ?vagon true ?sitiovag $?r ?maleta ?sitiomal))
)

(defrule descargar_maleta
  (maquina_transportadora ?sitiomaq $?x vagones $?z ?vagon true ?sitiovag $?r maletasCogidas $?y ?maleta ?sitiomal $?h)
  (?maleta ?x ?y ?final)
  (test (= ?sitiomaq ?final))
  (test (= (length $?h) 0))
  =>
  ;preguntar duda sobre como hacer para comprobar si es la última maleta
  (printout t " Maleta ha sido descargada ")
  (assert (maquina_transportadora ?sitiomaq $?x vagones $?z ?vagon true ?sitiovag $?r maletasCogidas $?y $?h))
)

(defrule mover_maquina
  (maquina_transportadora ?sitiomaq $?x vagones $?z ?vagon true ?sitiovag $?r maletasCogidas $?y ?maleta ?sitiomal $?h)
  (camino ?sitiomaq ?x)
  =>
  (bind ?sitiomaq ?x)
  (bind ?sitiomal ?x)
  (bind ?sitiovag ?x)
  (assert (maquina_transportadora ?sitiomaq $?x vagones $?z ?vagon true ?sitiovag $?r maletasCogidas $?y ?maleta ?sitiomal $?h))
)

(defrule enganchar_vagon
  (maquina_transportadora ?sitiomaq false maletas $?r vagones $?r1 ?vagon false ?sitiovag $?r2)
  (test (eq ?sitiomaq ?sitiovag))
  =>
  (printout t ?vagon" cogido ")
  (maquina_transportadora ?sitiomaq true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2)
)

(defrule desenganchar_vagon
  (maquina_transportadora ?sitiomaq ?enganchado maletas $?r vagones $?r1 ?vagon ?enganchadov ?sitiovag $?r2)
  (test (eq ?sitiomaq ?sitiovag))
  =>
  (printout t ?vagon" soltado ")
  (bind ?enganchado false)
  (bind ?enganchadov false)
  (maquina_transportadora ?sitiomaq ?enganchado maletas $?r vagones $?r1 ?vagon ?enganchadov ?sitiovag $?r2)
)

(defrule objetivo
  (maquina_transportadora ?sitiomaq ?noMatters maletas vagones $?r maletasCogidas $?x)
  (test (= (length $?x) 0)
  =>
  (printout t "SOLUCION ENCONTRADA")
)
