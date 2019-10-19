;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname rockup) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/batch-io)
(require 2htdp/universe)

; constants
(define BGW 400)
(define BGH 600)
(define BG (empty-scene BGW BGH))
(define UFO (overlay/align "middle" "bottom" 
                           (ellipse 40 10 "solid" "blue")
                           (circle 10 "solid" "red")))
(define V 4)
; 6 seconds
(define C -3)
(define CN (* C 28))
;(place-image/align UFO (/ BGW 2) BGH "middle" "bottom" BG)

; world state is LR(itemization)
; LR is "starting" or the pixels to the bottom(it is getting bigger as ticks go)
; or -N is countDown

; ws -> image
(define (place ws) (place-image/align UFO (/ BGW 2) ws "middle" "bottom" BG))

; ws -> ws
; render ws to image
(define (render ws) 
  (cond
    [(string? ws) (place BGH)]
    [(> ws 0) (place (- BGH ws))]
    [else (place-image 
            (text (number->string ws)
                  20 "red") 100 100 (place BGH))]
    )
)
(check-expect (render "s") (place-image/align UFO (/ BGW 2) BGH  "middle" "bottom" BG))
(check-expect (render 30) (place-image/align UFO (/ BGW 2) (- BGH 30) "middle" "bottom" BG))
(check-expect (render CN) (place-image (text  (number->string CN) 20 "red") 100 100 (place BG)))

; ws -> ws
; tick handler "stop" is static, number means ufo is getting up
(define (tock ws) 
          (cond 
           [(string? ws) ws] 
           [(<= ws 0) (+ ws 1)]
           [else (+ ws V)] 
          )
)
(check-expect (tock "s") "s")
(check-expect (tock CN) (+ CN 1))
(check-expect (tock 10) (+ 10 V))

; ws->ws
; only when ufo is not launching, press space key will launch ufo
(define (kh ws key) 
  (if (and (string=? key " ") (string? ws)) CN ws))

(check-expect (kh "s" " ") CN)
(check-expect (kh "s" "r") "s")
(check-expect (kh 1 "r") 1)
(check-expect (kh 6 " ") 6)

; ws->boolean
; when getting to the top, world ends
; because of cond mechanism, it must judge string first, than it can use <= 0 operation
(define (end? ws) 
          (cond 
           [(string? ws) #f] 
           [(>= ws BGH) #t] 
           [else #f] 
          ))
(check-expect (end? "s") #f)
(check-expect (end? -6) #f)
(check-expect (end? 23) #f)
(check-expect (end? (+ 1 BGH)) #t)

; ws->image
(define (last ws) (text "UFO\nfly\naway!" 20 "red"))

; ws -> ws 
; if main function here has no parameter, it is just a constant, using (define main ...),
; drrackt will evaluate it and execute big-bang,
; using (main ws) will make it a function and do not execute big-bang
(define (main ws)
  (big-bang "starting"
    [on-tick tock]
    [to-draw render]
    [stop-when end? last]
    [on-key kh]
    ))

(main "go")

