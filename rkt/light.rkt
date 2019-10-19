;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname light) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

; constants
;(define L (circle 60 "solid" "red"))

; ws is string, it is the color
; ws->image
(define (render ws) (circle 60 "solid" ws))

; ws->ws
; change color every tick
(define (tock ws) 
  (cond 
    [(string=? "red" ws) "green"]
    [(string=? "green" ws) "yellow"]
    [(string=? "yellow" ws) "red"]
    ))
; main
; ws is initial state, duration is max tick counts
(define (main ws duration) 
  (big-bang ws
            [on-tick tock 1 duration]
            [on-draw render]
            ))

(main "green" 10)

