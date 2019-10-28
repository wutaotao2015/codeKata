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
(define UFO (overlay/align "middle" "bottom"
                           (ellipse 40 UFOH "solid" "blue")
                           (circle UFOH "solid" "green")))
(define TW 60)
(define TH 20)
(define TANK (rectangle TW TH "solid" "red"))
;(define OM (place-image UFO (/ BGW 2) 0 (place-image TANK (/ TW 2) (- BGH (/ TH 2)) BG)))

(define MIS (triangle TH "solid" "red"))
;(define OM2 (place-image MIS 20 30 OM))

; ufo is a structure
;   (make-ufo (make-posn number number))
;  it is the location of ufo
(define-struct ufo [p])
(define (ufo-x u) (posn-x (ufo-p u)))
(define (ufo-y u) (posn-y (ufo-p u)))

(define ufo1 (make-ufo (make-posn (/ BGW 2) 0)))
(define ufo2 (make-ufo (make-posn (/ BGW 2) 20)))

; tank is a structure
;   (make-tank number number)
;  it is the x location of tank(y location is BGH), v is the velocity, negative means left
(define-struct tank [x v])

(define tank1 (make-tank (/ TW 2) (- BGH (/ TH 2))))
(define tank2 (make-tank (/ BGW 2) (- BGH (/ TH 2))))

; missile is a structure
;  (make-missile (make-posn number number)
;  it is the missile location
(define-struct mis [p])
(define (mis-x m) (posn-x (mis-p m)))
(define (mis-y m) (posn-y (mis-p m)))

(define mis1 (make-mis (make-posn (/ BGW 2) (- BGH 30))))
(define mis2 (make-mis (make-posn (/ BGW 2) (- BGH 40))))

; an aim is a structure
;   (make-aim (make-ufo posn) (make-tank number number))
;   it is a state which tank is aiming at ufo, no missile
(define-struct aim [ufo tank])
(define (aim-ux a) (ufo-x (aim-ufo a)))
(define (aim-uy a) (ufo-y (aim-ufo a)))
(define (aim-tx a) (tank-x (aim-tank a)))
(define (aim-tv a) (tank-v (aim-tank a)))

(define aim1 (make-aim ufo1 tank1))
(define aim2 (make-aim ufo2 tank2))
; an fire is a structure
;  (make-fire (make-ufo posn) (make-tank number number) (make-missile posn))
(define-struct fire [ufo tank mis])
(define (fire-ux f) (ufo-x (fire-ufo f)))
(define (fire-uy f) (ufo-y (fire-ufo f)))
(define (fire-tx f) (tank-x (fire-tank f)))
(define (fire-tv f) (tank-v (fire-tank f)))
(define (fire-mx f) (mis-x (fire-mis f)))
(define (fire-my f) (mis-y (fire-mis f)))

(define fire1 (make-fire ufo1 tank1 mis1) )
(define fire2 (make-fire ufo2 tank2 mis2) )

; a ws is one of
;   (make-aim (make-ufo posn) (make-tank number number))
;   (make-fire (make-ufo posn) (make-tank number number) (make-missile posn))
;  it is the complete state of the world program

; ws -> image
(define (render ws)
  (cond
   [(aim? ws) (place-image UFO (aim-ux ws) (aim-uy ws)
                           (place-image TANK (aim-tx ws) (- BGH (/ TH 2)) BG))]
   [(fire? ws) (place-image MIS (fire-mx ws) (fire-my ws)
                            (place-image UFO (fire-ux ws) (fire-uy ws)
                                         (place-image TANK (fire-tx ws) (- BGH (/ TH 2)) BG)))]))

(check-expect (render aim1)
              (place-image UFO (aim-ux aim1) (aim-uy aim1)
                           (place-image TANK (aim-tx aim1) (- BGH (/ TH 2)) BG)))

(check-expect (render fire1)
              (place-image MIS (fire-mx fire1) (fire-my fire1)
                           (place-image UFO (fire-ux fire1) (fire-uy fire1)
                                        (place-image TANK (fire-tx fire1) (- BGH (/ TH 2)) BG))))

;(define a1 (place-image UFO (aim-ux aim1) (aim-uy aim1)
;                        (place-image TANK (aim-tx aim1) (- BGH (/ TH 2)) BG)))
;(define f1 (place-image MIS (fire-mx fire1) (fire-my fire1)
;                        (place-image UFO (fire-ux fire1) (fire-uy fire1)
;                                     (place-image TANK (fire-tx fire1) (- BGH (/ TH 2)) BG))))






