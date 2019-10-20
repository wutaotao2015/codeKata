;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname structure) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

;(define (dis p)
;  (sqrt (+ (sqr (posn-x p)) (sqr (posn-y p)))))

; define class 
;(define-struct person [age sex])
; define object
;(define wtt (make-person 23 "m"))
; get method
;(person-age wtt)
;(person-sex wtt)

;(define-struct ball [location velocity])
;(define-struct velo [deltax deltay])
;(define ball2 (make-ball (make-posn 3 4) (make-velo 1 -1)))
;(ball-location ball2)
;(ball-velocity ball2)
;(posn-x (ball-location ball2))
;(velo-deltay (ball-velocity ball2))

;(define-struct entry [name home office cell])
;(define-struct phone [area number])
;(define wtt (make-entry "wtt" 
;            (make-phone "cd" 123)
;            (make-phone "cs" 133)
;            (make-phone "cg" 153)))
;
;(phone-area (entry-home wtt))
; distances in terms of pixels:

;(define HEIGHT 200)
;(define MIDDLE (quotient HEIGHT 2))
;(define WIDTH  400)
;(define CENTER (quotient WIDTH 2))
; 
;(define-struct game [left-player right-player ball])
; 
;(define game0
;  (make-game MIDDLE MIDDLE (make-posn CENTER CENTER)))

;(define p (make-posn 3 4))
;(define (setpx p x) (make-posn x (posn-y p)))
;(setpx p 6)

(define MTS (empty-scene 400 400))
(define DOT (circle 3 "solid" "red"))
 
; A Posn represents the state of the world.

; posn->posn
; posn x + 3 each tick
(define (x+ p) (make-posn (+ (posn-x p) 3) (posn-y p)))
(check-expect (x+ (make-posn 3 4)) (make-posn 6 4))
(check-expect (x+ (make-posn 0 4)) (make-posn 3 4))

; posn->posn
; dot reset to the clicked position
(define (reset-dot p x y me) 
  (cond
    [(string=? me "button-down") (make-posn x y)]
    [else p]))
(check-expect (reset-dot (make-posn 3 4) 6 7 "button-down") (make-posn 6 7))
(check-expect (reset-dot (make-posn 3 4) 6 7 "button-up") (make-posn 3 4))
 
; posn->image
; put dot in MTS at p.
(define (scene+dot p) (place-image DOT (posn-x p) (posn-y p) MTS))
(check-expect (scene+dot (make-posn 3 4)) (place-image DOT 3 4 MTS))
(check-expect (scene+dot (make-posn 2 9)) (place-image DOT 2 9 MTS))


; Posn -> Posn 
(define (main p0)
  (big-bang p0
    [on-tick x+ 1]
    [on-mouse reset-dot]
    [to-draw scene+dot]))
(main (make-posn 3 3))
