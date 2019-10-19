;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname draw) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
;(define (num->square num) (square num "solid" "red"))
;(num->square 5)
;(num->square 10)
;(num->square 20)
;(define (reset s ke) 100)
;(big-bang 100 [to-draw num->square]
;          [on-tick sub1] 
;          [stop-when zero?]
;          [on-key reset]) 

(define BG (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

(define (main y) 
  (big-bang y
            [to-draw place-dot]
            [on-tick sub1]
            [on-key stop]
            [stop-when zero?] 
            ))

(define (place-dot y) (place-image DOT 50 y BG))
(define (stop y ke) 0)
