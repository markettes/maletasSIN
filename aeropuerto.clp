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



;Reglas
(defrule coger_maleta
  (maquina_transportadora ?nivel ?sitiomaq ?posAnterior true maletas $?x ?maleta ?sitiomal $?y vagones $?z ?vagon true ?sitiovag $?r)
  (profundidad-maxima ?prof)
  (maleta ?maleta ?peso $?)
  (vagon ?vagon ?pesoMin ?pesoMax)
  (test (eq ?sitiomaq ?sitiomal))
  (test (<= ?peso ?pesoMax))
  (test (>= ?peso ?pesoMin))
  (test (< ?nivel ?prof))
  =>
  (printout t " Maleta " ?maleta " ha sido cargada " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora (+ ?nivel 1) ?sitiomaq ?posAnterior true maletas $?x $?y vagones $?z ?vagon true ?sitiovag $?r ?maleta ?sitiomal))
)

(defrule descargar_maleta
  (maquina_transportadora ?nivel ?sitiomaq $?x maletasCogidas $?y ?maleta ?sitiomal $?h)
  (maleta ?maleta $? ?final)
  (test (eq ?sitiomaq ?final))
  (profundidad-maxima ?prof)
  (test (< ?nivel ?prof))
  =>
  (printout t " Maleta " ?maleta " ha sido descargada " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora (+ ?nivel 1) ?sitiomaq $?x maletasCogidas $?y $?h))
)

(defrule mover_maquina
  (maquina_transportadora ?nivel ?sitiomaq ?posAnterior $?g)
  (camino ?sitiomaq ?x)
  (test (neq ?posAnterior ?x))
  (profundidad-maxima ?prof)
  (test (< ?nivel ?prof))
  =>
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora (+ ?nivel 1) ?x ?sitiomaq $?g))
)

(defrule enganchar_vagon
  (maquina_transportadora ?nivel ?sitiomaq ?posAnterior false maletas $?r vagones $?r1 ?vagon false ?sitiovag $?r2)
  (profundidad-maxima ?prof)
  (test (eq ?sitiomaq ?sitiovag))
  (test (< ?nivel ?prof))
  =>
  (printout t ?vagon" cogido " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora (+ ?nivel 1) ?sitiomaq ?posAnterior true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2))
)

(defrule desenganchar_vagon
  (maquina_transportadora ?nivel ?sitiomaq ?posAnterior true maletas $?r vagones $?r1 ?vagon true ?sitiovag $?r2 maletasCogidas)
  (profundidad-maxima ?prof)
  (test (< ?nivel ?prof))
  =>
  (printout t ?vagon" soltado " crlf)
  (bind ?*nod-gen* (+ ?*nod-gen* 1))
  (assert (maquina_transportadora (+ ?nivel 1) ?sitiomaq ?posAnterior false maletas $?r vagones $?r1 ?vagon false ?sitiomaq $?r2 maletasCogidas))
)

(defrule objetivo
  (declare (salience 100))
  ?f<-(maquina_transportadora ?nivel ?sitiomaq ?posAnterior ?noMatters maletas vagones $?r maletasCogidas)
  =>
  (printout t "SOLUCION ENCONTRADA EN EL NIVEL " ?nivel crlf)
  (printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)
  (printout t "HECHO OBJETIVO " ?f crlf)
  (halt)
)

(defrule no_solucion
    (declare (salience -99))
    (maquina_transportadora ?nivel $?)

=>
    (printout t "SOLUCION NO ENCONTRADA" crlf)
    (printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)

    (halt)
)




(deffunction inicio ()
        (reset)
	(printout t "Profundidad Maxima:= " )
	(bind ?prof (read))
	(printout t "Tipo de Busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then    (set-strategy breadth)
	       else   (set-strategy depth))
        (printout t " Ejecuta run para poner en marcha el programa " crlf)

	(assert (profundidad-maxima ?prof))
  (assert (maquina_transportadora 0 p6 p1 true maletas m1 f m2 f m3 p1 m4 p6 vagones vagont1 true p6 vagont2 false p2 maletasCogidas))
  )
