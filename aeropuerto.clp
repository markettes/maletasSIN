(defglobal ?*nod-gen* = 0)
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
  (vagon vagont1 0 15)
  (vagon vagont2 16 23)
)

(deffacts maletas ;peso posicion
  (maleta m1 12 f p3)
  (maleta m2 18 f p5)
  (maleta m3 20 p1 r)
  (maleta m4 14 p6 r)
)

;Hechos dinamicos
(deffacts hechosDinamicos ; maquina pos posAnterior enganchada ;maletas maleta localizacion ;vagones vagon cogido posicion maletasCogidas
  (maquina_transportadora p6 p1 true maletas m1 f m2 f m3 p1 m4 p6 vagones vagont1 true p6 vagont2 false p2 maletasCogidas)
)

;Reglas
(defrule coger_maleta
  (maquina_transportadora ?sitiomaq ?posAnterior true maletas $?x ?maleta ?sitiomal $?y vagones $?z ?vagon true ?sitiovag $?r)
  (maleta ?maleta ?peso $?)
  (vagon ?vagon ?pesoMin ?pesoMax)
  (test (eq ?sitiomaq ?sitiomal))
  (test (<= ?peso ?pesoMax))
  (test (>= ?peso ?pesoMin))
  =>
  (printout t " Maleta " ?maleta " ha sido cargada " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora ?sitiomaq ?posAnterior true maletas $?x $?y vagones $?z ?vagon true ?sitiovag $?r ?maleta ?sitiomal))
)

(defrule descargar_maleta
  (maquina_transportadora ?sitiomaq $?x maletasCogidas $?y ?maleta ?sitiomal $?h)
  (maleta ?maleta $? ?final)
  (test (eq ?sitiomaq ?final))
  =>
  (printout t " Maleta " ?maleta " ha sido descargada " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora ?sitiomaq $?x maletasCogidas $?y $?h))
)

(defrule mover_maquina
  (maquina_transportadora ?sitiomaq ?posAnterior $?g)
  (camino ?sitiomaq ?x)
  (test (neq ?posAnterior ?x))
  =>
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora ?x ?sitiomaq $?g))
)

(defrule enganchar_vagon
  (maquina_transportadora ?sitiomaq ?posAnterior false maletas $?r vagones $?r1 ?vagon false ?sitiovag $?r2)
  (test (eq ?sitiomaq ?sitiovag))
  =>
  (printout t ?vagon" cogido " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora ?sitiomaq ?posAnterior true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2))
)

(defrule desenganchar_vagon
  (maquina_transportadora ?sitiomaq ?posAnterior true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2 maletasCogidas)
  =>
  (printout t ?vagon" soltado " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora ?sitiomaq ?posAnterior false maletas $?r vagones $?r1 ?vagon false ?sitiomaq $?r2 maletasCogidas))
)

(defrule objetivo
  (declare (salience 100))
  (maquina_transportadora ?sitiomaq ?posAnterior ?noMatters maletas vagones $?r maletasCogidas)
  =>
  (printout t "SOLUCION ENCONTRADA" crlf)
  (assert(maquina_transportadora))
  (halt)
)
