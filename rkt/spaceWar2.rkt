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

; an sgt is a structure
;  (make-sgt posn (make-tank number number) posn/boolean)
(define-struct sgt [ufo tank mis])

(define sgt1 (make-sgt ufo1 tank1 #f))
(define sgt2 (make-sgt ufo2 tank2 #f))
(define sgt3 (make-sgt ufo1 tank1 mis1) )
(define sgt4 (make-sgt ufo3 tank2 mis3) )

; a ws is a sgt, missile can be #f and posn
;  it is the complete sgt of the world program

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
  (cond
    [(boolean? m) im]
    [else (place-image MIS (posn-x m) (posn-y m) im)]))

; ws -> image
(define (render ws)
  (mis-render (sgt-mis ws)
              (ufo-render (sgt-ufo ws)
                          (tank-render (sgt-tank ws) BG))))
; render test
(check-expect (render sgt1)
              (place-image UFO (posn-x (sgt-ufo sgt1)) (posn-y (sgt-ufo sgt1))
                           (place-image TANK (tank-x (sgt-tank sgt1))
                                        TANKY BG)))

(check-expect (render sgt3)
              (place-image MIS
                           (posn-x (sgt-mis sgt3))
                           (posn-y (sgt-mis sgt3))
                           (place-image UFO
                                        (posn-x (sgt-ufo sgt3))
                                        (posn-y (sgt-ufo sgt3))
                                        (place-image TANK
                                                     (tank-x (sgt-tank sgt3))
                                                     TANKY BG))))

; posn, posn -> number
;  return the distance of UFO and missile according to their position
(define (dis up mp) (sqrt (+ (sqr (- (posn-x up) (posn-x mp))) (sqr (- (posn-y up) (posn-y mp))))))

(check-expect (dis (make-posn 1 2) (make-posn 4 6)) 5)
; ws -> boolean
;  stop when the ufo lands or missile hit the ufo(distance is less than UFOW)
(define (gameOver ws)
  (cond
    [(boolean? (sgt-mis ws)) (cond
                               [(>=  (posn-y (sgt-ufo ws)) (- BGH (/ UFOH 2))) #t]
                               [else #f]
                               )]
    [else (cond
            [(>=  (posn-y (sgt-ufo ws)) (- BGH (/ UFOH 2))) #t]
            [(<=  (dis (sgt-ufo ws) (sgt-mis ws)) (/ UFOW 2)) #t]
            [(< (posn-y (sgt-mis ws)) (posn-y (sgt-ufo ws))) #t]
            [else #f]
            )]
    ))
(check-expect (gameOver sgt1) #f)
(check-expect (gameOver sgt3) #f)
(check-expect (gameOver sgt2) #t)
(check-expect (gameOver sgt4) #t)

; ws -> image
;  render ws to image at last
(define (final ws)
  (cond
    [(boolean? (sgt-mis ws)) (text "Game Over!" 30 "red")]
    [else
      (cond
        [(<=  (dis (sgt-ufo ws) (sgt-mis ws)) (/ UFOW 2))
         (text "Congratulations!\nUFO got hit!" 30 "red")]
        [(< (posn-y (sgt-mis ws)) (posn-y (sgt-ufo ws)))
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
                    [(boolean? (sgt-mis ws)) (make-sgt (make-posn (+ UFODX (posn-x (sgt-ufo ws)))
                                                                  (+ UFOV (posn-y (sgt-ufo ws)))
                                                                  ) 
                                                       (make-tank (+ (tank-v (sgt-tank ws)) (tank-x (sgt-tank ws)))
                                                                  (tank-v (sgt-tank ws)))
                                                        #f)]
                    [else (make-sgt (make-posn (+ UFODX (posn-x (sgt-ufo ws)))
                                               (+ UFOV (posn-y (sgt-ufo ws)))
                                               ) 
                                    (sgt-tank ws)
                                    (make-posn (posn-x (sgt-mis ws))
                                               (- (posn-y (sgt-mis ws)) (* 2 UFOV))) 
                                    )]
                    ))
(check-expect (move sgt1) (make-sgt (make-posn (+ UFODX (posn-x (sgt-ufo sgt1)))
                                               (+ UFOV (posn-y (sgt-ufo sgt1)))
                                               ) 
                                    (make-tank (+ (tank-v (sgt-tank sgt1)) (tank-x (sgt-tank sgt1)))
                                               (tank-v (sgt-tank sgt1)))
                                    #f))
(check-expect (move sgt3) (make-sgt (make-posn (+ UFODX (posn-x (sgt-ufo sgt3)))
                                               (+ UFOV (posn-y (sgt-ufo sgt3)))
                                               ) 
                                    (sgt-tank sgt3)
                                    (make-posn  (posn-x (sgt-mis sgt3))
                                                (-  (posn-y (sgt-mis sgt3)) (* 2 UFOV))) 
                                    ))

; ws -> ws
;  key event handler, left and right key turn the tank left and right
;  space key launch the mis if it has not bee launched yet
(define (kh ws key) (if (boolean? (sgt-mis ws))
                      (cond
                        [(or (and (string=? key "left") (> (tank-v (sgt-tank ws)) 0))
                             (and (string=? key "right") (< (tank-v (sgt-tank ws)) 0)))
                         (make-sgt (sgt-ufo ws)
                                   (make-tank (tank-x (sgt-tank ws))
                                              (- 0 (tank-v (sgt-tank ws)))
                                              ) #f)]
                        [(string=? key " ") (make-sgt (sgt-ufo ws)
                                                      (sgt-tank ws)
                                                      (make-posn (tank-x (sgt-tank ws))
                                                                 TANKY ))]
                        [else ws]) ws))
(check-expect (kh sgt3 "left") sgt3)
(check-expect (kh sgt1 "left") (make-sgt (sgt-ufo sgt1)
                                         (make-tank (tank-x (sgt-tank sgt1))
                                                    (- 0 (tank-v (sgt-tank sgt1)))
                                                    ) #f))
(check-expect (kh sgt1 "right") sgt1)
(check-expect (kh sgt2 "left") sgt2)
(check-expect (kh sgt2 "right") (make-sgt (sgt-ufo sgt2)
                                          (make-tank (tank-x (sgt-tank sgt2))
                                                     (- 0 (tank-v (sgt-tank sgt2)))
                                                     ) #f))
(check-expect (kh sgt2 " ") (make-sgt (sgt-ufo sgt2)
                                      (sgt-tank sgt2)
                                      (make-posn (tank-x (sgt-tank sgt2))
                                                 TANKY )))

(define init (make-sgt ufo1 tank1 #f))
; ws->image
;   play the game
(define (main ws) (big-bang ws
                            [on-tick move]
                            [to-draw render]
                            [stop-when gameOver final]
                            [on-key kh]))

(main init)
