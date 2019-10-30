;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname spaceWar) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define BGW 400)
(define BGH 400)
(define BG (empty-scene BGW BGH))
(define UFOV 0.6)
(define UFOH 10)
(define UFODX 0.3)
(define UFOW 40)
(define UFO (overlay/align "middle" "bottom"
                           (ellipse UFOW UFOH "solid" "blue")
                           (circle UFOH "solid" "green")))
(define TW 60)
(define TH 20)
(define TANK (rectangle TW TH "solid" "red"))
(define TANKY (- BGH (/ TH 2)))
;(define OM (place-image UFO (/ BGW 2) 0 (place-image TANK (/ TW 2) (- BGH (/ TH 2)) BG)))

(define MIS (triangle TH "solid" "red"))
;(define OM2 (place-image MIS 20 30 OM))

; ufo is a posn
;   (make-posn number number)
;  it is the location of ufo

(define ufo1 (make-posn 0 0))
(define ufo2 (make-posn (/ BGW 2) (- BGH (/ UFOH 2))))
(define ufo3 (make-posn (/ BGW 2) (/ BGH 2)))

; tank is a structure
;   (make-tank number number)
;  it is the x location of tank(y location is BGH), v is the velocity, negative means left
(define-struct tank [x v])

(define tank1 (make-tank (/ TW 2) 2))
(define tank2 (make-tank (/ BGW 2) -4))

; missile is a posn
;  (make-posn number number)
;  it is the missile location

(define mis1 (make-posn (/ BGW 2) (- BGH 30)))
(define mis2 (make-posn (/ BGW 2) (- BGH 40)))
(define mis3 (make-posn (+ 1 (/ BGW 2)) (- (/ BGH 2) 1)))

; an aim is a structure
;   (make-aim posn (make-tank number number))
;   it is a state which tank is aiming at ufo, no missile
(define-struct aim [ufo tank])

(define aim1 (make-aim ufo1 tank1))
(define aim2 (make-aim ufo2 tank2))
; an fire is a structure
;  (make-fire posn (make-tank number number) posn)
(define-struct fire [ufo tank mis])

(define fire1 (make-fire ufo1 tank1 mis1) )
(define fire2 (make-fire ufo3 tank2 mis3) )

; a ws is one of
;   (make-aim posn (make-tank number number))
;   (make-fire posn (make-tank number number) posn)
;  it is the complete state of the world program

; ufo -> image
;  render ufo to an image
(define (ufo-render u im)
  (place-image UFO (posn-x u) (posn-y u) im))

; tank -> image
;   render tank to an image
(define (tank-render t im)
  (place-image TANK (tank-x t) TANKY im))

; mis -> image
;  render mis to an image
(define (mis-render m im)
  (place-image MIS (posn-x m) (posn-y m) im))

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
              (place-image UFO (posn-x (aim-ufo aim1)) (posn-y (aim-ufo aim1))
                           (place-image TANK (tank-x (aim-tank aim1))
                                        TANKY BG)))

(check-expect (render fire1)
              (place-image MIS
                           (posn-x (fire-mis fire1))
                           (posn-y (fire-mis fire1))
                           (place-image UFO
                                        (posn-x (fire-ufo fire1))
                                        (posn-y (fire-ufo fire1))
                                        (place-image TANK
                                                     (tank-x (fire-tank fire1))
                                                     TANKY BG))))

; posn, posn -> number
;  return the distance of UFO and missile according to their position
(define (dis up mp) (sqrt (+ (sqr (- (posn-x up) (posn-x mp))) (sqr (- (posn-y up) (posn-y mp))))))

(check-expect (dis (make-posn 1 2) (make-posn 4 6)) 5)
; ws -> boolean
;  stop when the ufo lands or missile hit the ufo(distance is less than UFOW)
(define (gameOver ws)
  (cond
   [(aim? ws) (cond
               [(>=  (posn-y (aim-ufo ws)) (- BGH (/ UFOH 2))) #t]
               [else #f]
               )]
   [(fire? ws) (cond
                [(>=  (posn-y (fire-ufo ws)) (- BGH (/ UFOH 2))) #t]
                [(<=  (dis (fire-ufo ws) (fire-mis ws)) (/ UFOW 2)) #t]
                [(< (posn-y (fire-mis ws)) (posn-y (fire-ufo ws))) #t]
                [else #f]
                )]
   ))
(check-expect (gameOver aim1) #f)
(check-expect (gameOver fire1) #f)
(check-expect (gameOver aim2) #t)
(check-expect (gameOver fire2) #t)

; ws -> image
;  render ws to image at last
(define (final ws)
  (cond
   [(aim? ws) (text "Game Over!" 30 "red")]
   [else
    (cond
     [(<=  (dis (fire-ufo ws) (fire-mis ws)) (/ UFOW 2))
      (text "Congratulations!\nUFO got hit!" 30 "red")]
     [(< (posn-y (fire-mis ws)) (posn-y (fire-ufo ws)))
      (text "You just missed it!" 30 "red")]
     [else (text "Game Over!" 30 "red")])
    ])
  )

; ws -> ws
;  on-tick handler
;   UFO is vertical down and delta move at horizontal level
;   MIS is vertical up(2x speed of UFO) and not changed in horizontal level
;   TANK is moving accoring to its v
(define (move ws) (cond
                   [(aim? ws) (make-aim (make-posn (+ UFODX (posn-x (aim-ufo ws)))
                                                             (+ UFOV (posn-y (aim-ufo ws)))
                                                             ) 
                                        (make-tank (+ (tank-v (aim-tank ws)) (tank-x (aim-tank ws)))
                                                   (tank-v (aim-tank ws)))
                                        )]
                   [(fire? ws) (make-fire (make-posn (+ UFODX (posn-x (fire-ufo ws)))
                                                               (+ UFOV (posn-y (fire-ufo ws)))
                                                               ) 
                                          (fire-tank ws)
                                         (make-posn (posn-x (fire-mis ws))
                                                               (- (posn-y (fire-mis ws)) (* 2 UFOV))) 
                                          )]
                   ))
(check-expect (move aim1) (make-aim (make-posn (+ UFODX (posn-x (aim-ufo aim1)))
                                                         (+ UFOV (posn-y (aim-ufo aim1)))
                                                         ) 
                                    (make-tank (+ (tank-v (aim-tank aim1)) (tank-x (aim-tank aim1)))
                                               (tank-v (aim-tank aim1)))
                                    ))
(check-expect (move fire1) (make-fire (make-posn (+ UFODX (posn-x (fire-ufo fire1)))
                                                           (+ UFOV (posn-y (fire-ufo fire1)))
                                                           ) 
                                      (fire-tank fire1)
                                     (make-posn  (posn-x (fire-mis fire1))
                                                           (-  (posn-y (fire-mis fire1)) (* 2 UFOV))) 
                                      ))

; ws -> ws
;  key event handler, left and right key turn the tank left and right
;  space key launch the mis if it has not bee launched yet
(define (kh ws key) (if (aim? ws)
                        (cond
                         [(or (and (string=? key "left") (> (tank-v (aim-tank ws)) 0))
                              (and (string=? key "right") (< (tank-v (aim-tank ws)) 0)))
                          (make-aim (aim-ufo ws)
                                    (make-tank (tank-x (aim-tank ws))
                                               (- 0 (tank-v (aim-tank ws)))
                                               ))]
                         [(string=? key " ") (make-fire (aim-ufo ws)
                                                        (aim-tank ws)
                                                        (make-posn (tank-x (aim-tank ws))
                                                                             TANKY ))]
                         [else ws]) ws))
(check-expect (kh fire1 "left") fire1)
(check-expect (kh aim1 "left") (make-aim (aim-ufo aim1)
                                         (make-tank (tank-x (aim-tank aim1))
                                                    (- 0 (tank-v (aim-tank aim1)))
                                                    )))
(check-expect (kh aim1 "right") aim1)
(check-expect (kh aim2 "left") aim2)
(check-expect (kh aim2 "right") (make-aim (aim-ufo aim2)
                                          (make-tank (tank-x (aim-tank aim2))
                                                     (- 0 (tank-v (aim-tank aim2)))
                                                     )))
(check-expect (kh aim2 " ") (make-fire (aim-ufo aim2)
                                       (aim-tank aim2)
                                       (make-posn (tank-x (aim-tank aim2))
                                                            TANKY )))

(define init (make-aim ufo1 tank1))
; ws->image
;   play the game
(define (main ws) (big-bang ws
                            [on-tick move]
                            [to-draw render]
                            [stop-when gameOver final]
                            [on-key kh]))

(main init)

