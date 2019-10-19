;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname theater) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define (attend price) (- 120 (* (- price 5) (/ 15 0.1))))
(define (income price) (* price (attend price)))
(define (cost price)  (* 1.5 (attend price)))
(define (profit price) (- (income price) (cost price)))
