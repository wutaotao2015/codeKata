;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname gauge) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

; constants
(define BGW 100)
(define BGH 200)
(define MS 5)
(define RW (- BGW (* 2 MS)))
(define RH (- BGH  MS))
; number -> number
; the height of red bar, hap is happiness, 0 to 100
(define (RHF hap) (* RH hap 0.01))
(define BG (rectangle BGW BGH "solid" "black"))

; world state is a number [0,100]
; number is height of red bar's height ratio to RH

; ws -> image
; place-image would crop image to meet the need, place-image/align's function
; is to anchor the image, here it stick the red bar at the x's center and y's bottom
; x is distance from middle to the left, y is distance from the top to the bottom 
; so the distance is always counted from left and top
(define (render ws)(place-image/align (rectangle RW (RHF ws) "solid" "red")
             (+ MS (* 0.5 RW)) RH "center" "bottom" BG)
)

; ws->ws
; each tick ws decrease by 0.5
(define (tock ws) (- ws 0.5))

; number,number -> number
; over 100 set to 100, or set to num * fac
(define (feed num fac) (if (>= (* num fac) 100) 100 (* num fac)))      

; ws->ws
; key event handler, down arrow key increase ws by 1/5, up arrow key increase ws by 1/3 
; maximum can not be bigger than 100
(define (kh ws key) 
  (cond 
    [(string=? key "down") (feed ws 6/5)]
    [(string=? key "up")  (feed ws 4/3)]
    [else ws]
    ))
(check-expect (kh 30 "down") 36)
(check-expect (kh 30 "up") 40)
(check-expect (kh 30 "left") 30)

; ws->ws
; stop when ws = 0, because of multiplying, it can never equal to 0
(define (end? ws) (<= ws 0) )
; ws -> image
; last image when world ended 
(define (last-pic ws) (text "your\nbattery\nis\nout!" 30 "red"))

; main
(define (main ws) 
  (big-bang ws 
    [to-draw render]
    [on-tick tock]
    [on-key kh]
    [stop-when end? last-pic]))

(main 100)

