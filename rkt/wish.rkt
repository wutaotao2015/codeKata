;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname wish) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define-struct ufo [loc vel])
(define-struct vel [dx dy])

(define ufo1 (make-ufo (make-posn 3 4) (make-vel 1 -2)))
(define ufo2 (make-ufo (make-posn 4 2) (make-vel 1 -2)))

; posn vel -> posn
; change posn adding with vel
(define (posn+ p v) 
  (make-posn 
  (+ (posn-x p) (vel-dx v))
  (+ (posn-y p) (vel-dy v))))

; ufo -> ufo
; ufo changes loc according to vel, vel not changed
(define (move u) 
  (make-ufo 
    (posn+ (ufo-loc u) (ufo-vel u)) 
    (ufo-vel u)))

(check-expect (move ufo1) ufo2)
(check-expect (posn+ (ufo-loc ufo1) (ufo-vel ufo1)) (ufo-loc ufo2))

