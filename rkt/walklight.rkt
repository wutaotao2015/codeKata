;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname walklight) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; wkl is a structure
;  (make-wkl string integer/#f string)
;    it is the image type: one of "circle" and "text"
;    countdown number: integer or #f(represents no number)
;   color:  "red", "orange", "green"
;  countdown number(integer or #f), 
(define-struct wkl [type num color])

(define wkla (make-wkl "circle" #f "red"))
(define wklb (make-wkl "circle" 7 "green"))
(define wklc (make-wkl "text" 10 "green"))
(define wkld (make-wkl "text" 7 "orange"))

(define BGW 100)
(define BGH 100)
(define BG (empty-scene BGW BGH))

; ws -> image
;   render ws to an image
(define (render ws) (place-image 
                      (cond
                        [(string=? (wkl-type ws) "circle") (circle 20 "solid" (wkl-color ws))]
                        [else (text (number->string (wkl-num ws)) 20 (wkl-color ws))])
                      (/ BGW 2) (/ BGH 2) BG))

(check-expect (render wkla) (place-image (circle 20 "solid" "red") (/ BGW 2) (/ BGH 2) BG))
(check-expect (render wklb) (place-image (circle 20 "solid" "green") (/ BGW 2) (/ BGH 2) BG))
(check-expect (render wklc) (place-image (text (number->string 10) 20 "green") (/ BGW 2) (/ BGH 2) BG))
(check-expect (render wkld) (place-image (text (number->string 7) 20 "orange") (/ BGW 2) (/ BGH 2) BG))

; ws -> string
;  helper function for tock, change color according to the number's odd or not
(define (change ws) (cond
                      [(odd? (wkl-num ws)) "green"]
                      [else "orange"]))

; ws->ws
;   tick handler
;  when counting down, number sub1 and change color according to its oddness
;  when count num = 0, change back to circle red
(define (tock ws) (cond 
                    [(string=? (wkl-type ws) "text")
                     (cond 
                       [(= 0 (wkl-num ws)) (make-wkl "circle" #f "red")]
                       [else (make-wkl "text" (- (wkl-num ws) 1) (change ws))])]
                    [(number? (wkl-num ws)) 
                          (if (= 0 (wkl-num ws)) 
                            (make-wkl "text" 10 "green")
                            (make-wkl "circle" (- (wkl-num ws) 1) "green"))]
                    [else ws]))

(check-expect (tock wkla) (make-wkl "circle" #f "red"))
(check-expect (tock wklb) (make-wkl "circle" 6 "green"))
(check-expect (tock wklc) (make-wkl "text" 9 "orange"))
(check-expect (tock wkld) (make-wkl "text" 6 "green"))

; ws->ws
;  key event handler, space key turn circle green
(define (kh ws key) (cond
                     [(and (string=? (wkl-type ws) "circle") 
                           (string=? (wkl-color ws) "red")
                           (key=? key " ")) 
                      (make-wkl "circle" 10 "green")]
                     [else ws]
                      ))

; ws->ws
; main
(define (main ws) (big-bang ws
                            [to-draw render]
                            [on-tick tock 1]
                            [on-key kh]))
(main wkla)




