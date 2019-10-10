;Hechos estaticos
(deffacts caminos
  (camino p1 f)
  (camino p1 p3)
  (camino p1 p5)
  (camino p2 f)
  (camino p2 p4)
  (camino p3 p4)
  (camino p5 r)
  (camino p5 p7)
  (camino p6 p8)
  (camino p6 r)
  (camino p7 p8)
)

(deffacts vagones ;pesos
  (vagon vagont1 0 15)
  (vagon vagont2 16 23)
)

(deffacts maletas ;peso posicion
  (maleta m1 12 F p3)
  (maleta m2 18 F p5)
  (maleta m3 20 p1 R)
  (maleta m4 14 p6 R)
)

;Hechos dinamicos
(deffacts hechosDinamicos ; maquina localizacion enganchada ;maletas maleta localizacion ;vagones vagon cogido posicion maletasCogidas
  (maquina_transportadora p6 true maletas m1 F m2 F m3 p1 m4 p6 vagones vagont1 true p6 vagont2 false p2 maletasCogidas)
)

;Reglas
(defrule coger_maleta
  (maquina_transportadora ?sitiomaq true maletas $?x ?maleta ?sitiomal $?y vagones $?z ?vagon true ?sitiovag $?r)
  (maleta ?maleta ?peso $?)
  (vagon ?vagon ?pesoMin ?pesoMax)
  (test (eq ?sitiomaq ?sitiomal))
  (test (<= ?peso ?pesoMax))
  (test (>= ?peso ?pesoMin))
  =>
  (printout t " Maleta ha sido cargada " crlf)
  (assert (maquina_transportadora ?sitiomaq true maletas $?x $?y vagones $?z ?vagon true ?sitiovag $?r ?maleta ?sitiomal))
)

(defrule descargar_maleta
  (maquina_transportadora ?sitiomaq $?x maletasCogidas $?y ?maleta ?sitiomal $?h)
  (maleta ?maleta $? ?final)
  (test (eq ?sitiomaq ?final))
  (test (= (length $?h) 0))
  =>
  (printout t " Maleta ha sido descargada " crlf)
  (assert (maquina_transportadora ?sitiomaq $?x maletasCogidas $?y $?h))
)

(defrule mover_maquina
  (maquina_transportadora ?sitiomaq $?g)
  (camino ?sitiomaq ?x)
  =>
  (bind ?sitiomaq ?x)
  (assert (maquina_transportadora ?sitiomaq $?g))
)

(defrule enganchar_vagon
  (maquina_transportadora ?sitiomaq false maletas $?r vagones $?r1 ?vagon false ?sitiovag $?r2)
  (test (eq ?sitiomaq ?sitiovag))
  =>
  (printout t ?vagon" cogido " crlf)
  (assert (maquina_transportadora ?sitiomaq true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2))
)

(defrule desenganchar_vagon
  (maquina_transportadora ?sitiomaq true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2 maletasCogidas)
  =>
  (printout t ?vagon" soltado " crlf)
  (assert (maquina_transportadora ?sitiomaq false maletas $?r vagones $?r1 ?vagon false ?sitiomaq $?r2 maletasCogidas))
)

(defrule objetivo
  (maquina_transportadora ?sitiomaq ?noMatters maletas vagones $?r maletasCogidas $?x)
  (test (= (length $?x) 0))
  =>
  (printout t "SOLUCION ENCONTRADA" crlf)
)
