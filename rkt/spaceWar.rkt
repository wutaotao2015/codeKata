;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname spaceWar) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define BGW 400)
(define BGH 400)
(define BG (empty-scene BGW BGH))
(define UFOV 5)
(define UFOH 10)
(define UFODX 3)
(define UFO (overlay/align "middle" "bottom"
                           (ellipse 40 UFOH "solid" "blue")
                           (circle UFOH "solid" "green")))
(define TW 60)
(define TH 20)
(define TANK (rectangle TW TH "solid" "red"))
(define TANKY (- BGH (/ TH 2)))
;(define OM (place-image UFO (/ BGW 2) 0 (place-image TANK (/ TW 2) (- BGH (/ TH 2)) BG)))

(define MIS (triangle TH "solid" "red"))
;(define OM2 (place-image MIS 20 30 OM))

; ufo is a structure
;   (make-ufo (make-posn number number))
;  it is the location of ufo
(define-struct ufo [p])

(define ufo1 (make-ufo (make-posn (/ BGW 2) 0)))
(define ufo2 (make-ufo (make-posn (/ BGW 2) (- BGH (/ UFOH 2)))))
(define ufo3 (make-ufo (make-posn (/ BGW 2) (/ BGH 2))))

; tank is a structure
;   (make-tank number number)
;  it is the x location of tank(y location is BGH), v is the velocity, negative means left
(define-struct tank [x v])

(define tank1 (make-tank (/ TW 2) 3))
(define tank2 (make-tank (/ BGW 2) -4))

; missile is a structure
;  (make-missile (make-posn number number)
;  it is the missile location
(define-struct mis [p])

(define mis1 (make-mis (make-posn (/ BGW 2) (- BGH 30))))
(define mis2 (make-mis (make-posn (/ BGW 2) (- BGH 40))))
(define mis3 (make-mis (make-posn (+ 1 (/ BGW 2)) (- (/ BGH 2) 1))))

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
(define fire2 (make-fire ufo3 tank2 mis3) )

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
  (place-image TANK (tank-x t) TANKY im))

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
                                         TANKY BG)))

(check-expect (render fire1)
              (place-image MIS
                           (posn-x (mis-p (fire-mis fire1)))
                           (posn-y (mis-p  (fire-mis fire1)))
                           (place-image UFO
                                        (posn-x (ufo-p (fire-ufo fire1)))
                                        (posn-y (ufo-p (fire-ufo fire1)))
                                        (place-image TANK
                                                     (tank-x (fire-tank fire1))
                                                     TANKY BG))))

; posn, posn -> number
;  return the distance of UFO and missile according to their position
(define (dis up mp) (sqrt (+ (sqr (- (posn-x up) (posn-x mp))) (sqr (- (posn-y up) (posn-y mp))))))

; ws -> boolean
;  stop when the ufo lands or missile hit the ufo
(define (gameOver ws)
  (cond
   [(aim? ws) (cond
               [(>=  (posn-y (ufo-p (aim-ufo ws))) (- BGH (/ UFOH 2))) #t]
               [else #f]
               )]
   [(fire? ws) (cond
                [(>=  (posn-y (ufo-p (fire-ufo ws))) (- BGH (/ UFOH 2))) #t]
                [(<=  (dis (ufo-p (fire-ufo ws)) (mis-p (fire-mis ws))) 3) #t]
                [else #f]
                )]
   ))
(check-expect (gameOver aim1) #f)
(check-expect (gameOver fire1) #f)
(check-expect (gameOver aim2) #t)
(check-expect (gameOver fire2) #t)

; ws -> image
;  render ws to image at last
(define (final ws) (text "Game Over!" 30 "red"))

; ws -> ws
;  on-tick handler
;   UFO is vertical down and delta move at horizontal level
;   MIS is vertical up(2x speed of UFO) and not changed in horizontal level
;   TANK is moving accoring to its v
(define (move ws) (cond
                   [(aim? ws) (make-aim (make-ufo (make-posn (+ UFODX (posn-x (ufo-p (aim-ufo ws))))
                                                          (+ UFOV (posn-y (ufo-p (aim-ufo ws))))
                                                          ))
                                     (make-tank (+ (tank-v (aim-tank ws)) (tank-x (aim-tank ws)))
                                                (tank-v (aim-tank ws)))
                                     )]
                   [(fire? ws) (make-fire (make-ufo (make-posn (+ UFODX (posn-x (ufo-p (fire-ufo ws))))
                                                            (+ UFOV (posn-y (ufo-p (fire-ufo ws))))
                                                            ))
                                       (make-tank (+ (tank-v (fire-tank ws)) (tank-x (fire-tank ws)))
                                                  (tank-v (fire-tank ws)))
                                       (make-mis (make-posn  (posn-x (mis-p (fire-mis ws)))
                                                            (- (* 2 UFOV) (posn-y (mis-p (fire-mis ws)))))
                                                 )
                                       )]
                   ))
(check-expect (move aim1) (make-aim (make-ufo (make-posn (+ UFODX (posn-x (ufo-p (aim-ufo aim1))))
                                                         (+ UFOV (posn-y (ufo-p (aim-ufo aim1))))
                                                         ))
                                    (make-tank (+ (tank-v (aim-tank aim1)) (tank-x (aim-tank aim1)))
                                               (tank-v (aim-tank aim1)))
                                    ))
(check-expect (move fire1) (make-fire (make-ufo (make-posn (+ UFODX (posn-x (ufo-p (fire-ufo fire1))))
                                                           (+ UFOV (posn-y (ufo-p (fire-ufo fire1))))
                                                           ))
                                      (make-tank (+ (tank-v (fire-tank fire1)) (tank-x (fire-tank fire1)))
                                                 (tank-v (fire-tank fire1)))
                                      (make-mis (make-posn  (posn-x (mis-p (fire-mis fire1)))
                                                           (- (* 2 UFOV) (posn-y (mis-p (fire-mis fire1)))))
                                                )
                                      ))

; ws -> ws
;  key event handler, left and right key turn the tank left and right
;  space key launch the mis if it has not bee launched yet
(define (kh ws key) (if (aim? ws) 
                  (cond 
                    [(or (and (string=? key "left") (> (tank-x (aim-tank ws)) 0))
                      (and (string=? key "right") (< (tank-x (aim-tank ws)) 0))) 
                     (make-aim (make-ufo (aim-ufo ws))
                               (make-tank (tank-x (aim-tank ws))
                                          (- 0 (tank-v (aim-tank ws)))
                                          ))]
                    [(string=? key "space") (make-fire (make-ufo (aim-ufo ws))
                                                       (make-tank (aim-tank ws))
                                                       (make-mis (make-posn (tank-x (aim-tank ws))
                                                                           TANKY )))]
                    )
                  ws))
(check-expect (kh fire1 "left") fire1)
(check-expect (kh aim1 "left") (make-aim (make-ufo (aim-ufo aim1))
                               (make-tank (tank-x (aim-tank aim1))
                                          (- 0 (tank-v (aim-tank aim1)))
                                          )))
(check-expect (kh aim1 "right") aim1)
(check-expect (kh aim2 "left") aim2)
(check-expect (kh aim2 "right") (make-aim (make-ufo (aim-ufo aim1))
                               (make-tank (tank-x (aim-tank aim1))
                                          (- 0 (tank-v (aim-tank aim1)))
                                          )))
