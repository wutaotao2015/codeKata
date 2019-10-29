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

(define mis1 (make-mis (make-posn (/ BGW 2) (- BGH 30))))
(define mis2 (make-mis (make-posn (/ BGW 2) (- BGH 40))))

; an aim is a structure
;   (make-aim (make-ufo posn) (make-tank number number))
;   it is a state which tank is aiming at ufo, no missile
(define-struct aim [ufo tank])

(define aim1 (make-aim ufo1 tank1))
(define aim2 (make-aim ufo2 tank2))
; an fire is a structure
;  (make-fire (make-ufo posn) (make-tank number number) (make-missile posn))
(define-struct fire [ufo tank mis])

(define fire1 (make-fire ufo1 tank1 mis1) )
(define fire2 (make-fire ufo2 tank2 mis2) )

; a ws is one of
;   (make-aim (make-ufo posn) (make-tank number number))
;   (make-fire (make-ufo posn) (make-tank number number) (make-missile posn))
;  it is the complete state of the world program

; ufo -> image
;  render ufo to an image
(define (ufo-render u im)
  (place-image UFO (posn-x (ufo-p u)) (posn-y (ufo-p u)) im))

; tank -> image
;   render tank to an image
(define (tank-render t im)
  (place-image TANK (tank-x t) (- BGH (/ TH 2)) im))

; mis -> image
;  render mis to an image
(define (mis-render m im)
  (place-image MIS (posn-x (mis-p m)) (posn-y (mis-p m)) im))

; ws -> image
(define (render ws)
  (cond
   [(aim? ws) (ufo-render (aim-ufo ws) (tank-render (aim-tank ws) BG))]
   [(fire? ws)
    (mis-render (fire-mis ws)
                (ufo-render (fire-ufo ws)
                            (tank-render (fire-tank ws) BG)))]))
; render test
(check-expect (render aim1)
              (place-image UFO (posn-x (ufo-p (aim-ufo aim1))) (posn-y (ufo-p  (aim-ufo aim1)))
                           (place-image TANK (tank-x (aim-tank aim1))
                                        (- BGH (/ TH 2)) BG)))

(check-expect (render fire1)
              (place-image MIS
                           (posn-x (mis-p (fire-mis fire1)))
                           (posn-y (mis-p  (fire-mis fire1)))
                           (place-image UFO
                                        (posn-x (ufo-p (fire-ufo fire1)))
                                        (posn-y (ufo-p (fire-ufo fire1)))
                                        (place-image TANK
                                                     (tank-x (fire-tank fire1))
                                                     (- BGH (/ TH 2)) BG))))





