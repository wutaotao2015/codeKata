#lang racket

(define MAX-BYTES (* 100 1024 1024))
(custodian-limit-memory (current-custodian) MAX-BYTES)

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; a layer is a structure
;  (make-layer string RD)
;  it is one layer of a russian doll with its color and inside doll
(define-struct layer [color doll])

; a RD(Russian Doll) is one of
; string
;  (make-layer string RD)
(define rd1 "brown")
(define rd2 (make-layer "yellow" (make-layer "red" (make-layer "white" "black"))))

; RD -> string
;  print out the colors sequencely from outermost to the innermost doll
(define (colors rd) (cond
                      [(string? rd) rd]
                      [(layer? rd) (string-append (layer-color rd) ", " (colors (layer-doll rd)))]
                      ))

(check-expect (colors rd1) "brown")
(check-expect (colors rd2) "yellow, red, white, black")

; RD -> string
;  find the innermost color of given rd
(define (inner rd) (cond
                     [(string? rd) rd]
                     [(layer? rd) (inner (layer-doll rd))]
                     ))

(check-expect (inner rd1) "brown")
(check-expect (inner rd2) "black")




; this need to put at last line to ensure testing all test cases
(test)
