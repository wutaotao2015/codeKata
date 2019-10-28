;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname spaceWar) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define BGW 400)
(define BGH 400)
(define BG (empty-scene BGW BGH))
(define UFOH 10)
;(define UFO (overlay/align "middle" "bottom" 
                           (ellipse 40 UFOH "solid" "blue")
                           (circle UFOH "solid" "green")))
(define TW 60)
(define TH 20)
;(define TANK (rectangle TW TH "solid" "red"))
;(define OM (place-image UFO (/ BGW 2) 0 (place-image TANK (/ TW 2) (- BGH (/ TH 2)) BG)))

;(define MIS (triangle TH "solid" "red"))
;(define OM2 (place-image MIS 20 30 OM))

; ufo is a structure
;   (make-ufo (make-posn number number))  
;  it is the location of ufo
(define-struct ufo [p])

; tank is a structure
;   (make-tank number number) 
;  it is the x location of tank(y location is BGH), v is the velocity, negative means left
(define-struct tank [x v])

; missile is a structure
;  (make-missile (make-posn number number)
;  it is the missile location
(define-struct missile [p])

; an aim is a structure
;   (make-aim (make-ufo posn) (make-tank number number))
;   it is a state which tank is aiming at ufo, no missile 
(define-struct aim [ufo tank])

; an fire is a structure
;  (make-fire (make-ufo posn) (make-tank number number) (make-missile posn))
(define-struct fire [ufo tank missile])

; a ws is one of 
;   (make-aim (make-ufo posn) (make-tank number number))
;   (make-fire (make-ufo posn) (make-tank number number) (make-missile posn))
;  it is the complete state of the world program 


