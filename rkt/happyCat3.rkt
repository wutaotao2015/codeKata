;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname happyCat) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; a ball/cat moves non-stop, if hit the border, bounce like real world, the speed
;; never changes in movement

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

(define-struct vcat [p v h])
; A Vcat is a structure:
;  (make-vcat posn vel number)
;   it means a cat at position pos with vel velocity, and h happiness,
; p-x is [0, BGW], p-y is [0, BGH], h is [0,100]

(define-struct vel [dx dy])
; A Vel is a structure:
;  (make-vel number number)
;  meaning the velocity of the cat
(define vela (make-vel 10 8))
(define velb (make-vel -3 3))
(define velc (make-vel 6 -4))
(define veld (make-vel -5 -1))

;cat x constants
(define R 20)
(define CAR (circle R "solid" "red"))
(define BGW (* R 20))
(define BGH (* R 20))
(define BG (empty-scene BGW BGH))
(define WEND (- BGW R))
(define HEND (- BGH R))
(define V 5)
(define H 0.1)

; cat h constants
(define MS 5)
(define HBW (/ BGW 15))
(define HBH (/ BGH 8))
(define RW (- HBW (* 2 MS)))
(define RH (- HBH  MS))
; number -> number
; the height of red bar, hap is happiness, 0 to 100
(define (RHF hap) (* RH hap 0.01))
(define HB (rectangle HBW HBH "solid" "black"))

(define vc1 (make-vcat (make-posn 20 30) vela 100))
(define vc2 (make-vcat (make-posn 60 20) velb 0))
(define vc3 (make-vcat (make-posn 60 50) velc 30))
(define vc4 (make-vcat (make-posn 30 40) veld 0))
(define vc5 (make-vcat (make-posn WEND 30) vela 30))

; vcat->number
; the x location of vcat
(define (vc-x vc) (posn-x (vcat-p vc)))
; vcat->number
; the y location of vcat
(define (vc-y vc) (posn-y (vcat-p vc)))
; vcat->number
; the dx value of vc
(define (vc-dx vc) (vel-dx (vcat-v vc)))
; vcat->number
; the dy value of vc
(define (vc-dy vc) (vel-dy (vcat-v vc)))

; vcat -> image
; render vcat to a image
(define (render vc) (place-image
                     (place-image/align (rectangle RW (RHF (vcat-h vc)) "solid" "red")
                                        (+ MS (* 0.5 RW)) RH "center" "bottom" HB)
                     (/ BGW 2) (/ BGH 2)
                     (place-image CAR (vc-x vc) (vc-y vc) BG)))

(check-expect (render vc1) (place-image
                            (place-image/align (rectangle RW (RHF (vcat-h vc1)) "solid" "red")
                                               (+ MS (* 0.5 RW)) RH "center" "bottom" HB)
                            (/ BGW 2) (/ BGH 2)
                            (place-image CAR (vc-x vc1) (vc-y vc1) BG)))

(check-expect (render vc2) (place-image
                            (place-image/align (rectangle RW (RHF (vcat-h vc2)) "solid" "red")
                                               (+ MS (* 0.5 RW)) RH "center" "bottom" HB)
                            (/ BGW 2) (/ BGH 2)
                            (place-image CAR (vc-x vc2) (vc-y vc2) BG)))

; vcat -> vcat
; get new position's vcat after one tick
(define (nextvc vc)
  (make-vcat
   (make-posn
    (+ (vc-x vc) (vc-dx vc))
    (+ (vc-y vc) (vc-dy vc)))
   (vcat-v vc) (vcat-h vc)
   ))
; vcat -> vcat
; make vcat's vel's dx turn to opposite number
(define (turndx vc) (make-vcat
                     (vcat-p vc)
                     (make-vel (- 0 (vc-dx vc)) (vc-dy vc))
                     (vcat-h vc)))

; vcat -> vcat
; make vcat's vel's dx turn to opposite number
(define (turndy vc) (make-vcat
                     (vcat-p vc)
                     (make-vel (vc-dx vc) (- 0 (vc-dy vc)))
                     (vcat-h vc)))

; vcat -> vcat
; cat position x -> x + V, happiness h -> h - H
(define (tock vc)
  (cond
   [(>= (vc-x (nextvc vc)) WEND) (turndx vc)]
   [(<= (vc-x (nextvc vc)) 0) (turndx vc)]
   [(>= (vc-y (nextvc vc)) HEND) (turndy vc)]
   [(<= (vc-y (nextvc vc)) 0) (turndy vc)]
   [else (nextvc vc)]))

;(check-expect (tock vc1) (make-vcat (+ V (vcat-x vc1)) (- (vcat-h vc1) H)))
;(check-expect (tock vc2) (make-vcat (+ V (vcat-x vc2)) (- (vcat-h vc2) H)))
;(check-expect (tock vc5) (make-vcat 0 (- (vcat-h vc5) H)))

;; when mouse clicked, put the car the x coordinate of clicked position
;; ws -> ws
;; mouse event handler: when clicked car position(ws) set to x, otherwise remain the same
;(define (clicked vc x y me)
;  (cond [(string=? me "button-up") (make-vcat x (vcat-h vc))]
;        [else vc]))
;
;(check-expect (clicked vc1 (- BGW 10) HBH "button-up") (make-vcat (- BGW 10) (vcat-h vc1)))
;(check-expect (clicked vc2 (- BGW 10) HBH "button-down") vc2)
;
;; vcat -> boolean
;; when the happiness gets to 0, it stops
;(define (end? vc) (if (<= (vcat-h vc) 0) #t #f))
;
;(check-expect (end? vc1) #f)
;(check-expect (end? vc4) #t)
;(check-expect (end? vc5) #f)
;
;; number,number -> number
;; over 100 set to 100, or set to num * fac
;(define (feed num fac) (if (>= (* num fac) 100) 100 (* num fac)))
;
;; ws->ws
;; key event handler, down arrow key increase ws by 1/5, up arrow key increase ws by 1/3
;; maximum can not be bigger than 100
;(define (kh vc key)
;  (cond
;    [(string=? key "down") (make-vcat (vcat-x vc)(feed (vcat-h vc) 6/5))]
;    [(string=? key "up")  (make-vcat (vcat-x vc)(feed (vcat-h vc) 4/3))]
;    [else vc]
;    ))
;(check-expect (kh vc3 "down") (make-vcat (vcat-x vc3) (feed (vcat-h vc3) 6/5)))
;(check-expect (kh vc2 "up") (make-vcat (vcat-x vc2) (feed (vcat-h vc2) 4/3)))
;(check-expect (kh vc1 "left") vc1)
;
;; ws -> image
;; last image when world ended
;(define (last-pic vc) (text "your\nbattery\nis\nout!" 30 "red"))
;
;; main
;(define (main vc)
;  (big-bang vc
;    [to-draw render]
;    [on-tick tock]
;    [on-key kh]
;    [on-mouse clicked]
;    [stop-when end? last-pic]))
;
;(main (make-vcat 0 100))



