;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname moveCar) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; constants
(define R 20)
(define CAR (circle R "solid" "red"))
(define BGW (* R 20))
(define BGH (* R 4))
(define TREE
  (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))
(define EMP (empty-scene BGW BGH))
(define BG (place-image TREE (- BGW R) (- BGH R) EMP))

(define V 5)

;; world state is a num
;; the pixels from the left margin to the car 
;
;; ws -> image
;; render current world state to a image
;(define (render ws) (place-image CAR (+ R ws) (- BGH R) BG))
;
;; ws -> ws
;; tick handler
;(define (tock ws) (+ ws V))
;
;; ws -> boolean
;; when to stop, world state judged to boolean
;(define (end? ws) (>= ws (- BGW (* 3.5 R))))

;; main
;; paramter as initial position
;(define (main ws) 
;                (big-bang ws 
;                          [on-tick tock]
;                          [to-draw render]
;                          [stop-when end?])   
;                   )


;; world state is a num
;; the tick number since start(time passed)
; 
;; ws -> image 
;; render ws to image
;(define (render ws) (place-image CAR (+ R (* V ws)) (- BGH R) BG))
;
;; ws -> ws
;; tick handler
;(define (tock ws) (+ ws 1))
;
;; on-tick function has a property limit-expr
;(define STOPNUM 20)
;
;; main
;; paramter as initial position
;(define (main ws) 
;                (big-bang ws 
;                          [on-tick tock 1/28 STOPNUM]
;                          [to-draw render])
;                   )


; when mouse clicked, put the car the x coordinate of clicked position

; world state is a num
; the pixels from the left margin to the car 

; ws -> image
; render current world state to a image
(define (render ws) (place-image CAR (+ R ws) (- BGH R) BG))

; ws -> ws
; tick handler
(define (tock ws) (+ ws V))

; ws -> ws 
; mouse event handler: when clicked car position(ws) set to x, otherwise remain the same
(define (clicked ws x y me) 
  (cond [(string=? me "button-up") x]
        [else ws]
        ))

; ws -> boolean
; when to stop, world state judged to boolean
(define (end? ws) (>= ws (- BGW (* 3.5 R))))

; main
; paramter as initial position
(define (main ws) 
                (big-bang ws 
                          [on-tick tock]
                          [to-draw render]
                          [on-mouse clicked]
                          [stop-when end?])   
                   )

(main 1)


