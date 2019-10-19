;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname func) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; string -> string
; extracts the 1st char from a string
(check-expect (string-first "wtt") "w")
(check-expect (string-first "lt") "l")
;
(define (string-first str) (string-ith str 0))

; string -> string
; extracts the last char from a string
(check-expect (string-last "wst") "t")
(check-expect (string-last "wsg") "g")
;
(define (string-last str) (string-ith str (- (string-length str) 1)))

; string -> string
; return a string with the first character removed
(check-expect (string-rest "wtss") "tss")
(check-expect (string-rest "ldcc") "dcc")
;
(define (string-rest str)(substring str 1))

; string -> string
; return a string with the last character removed
(check-expect (string-remove-last "wtss") "wts")
(check-expect (string-remove-last "ldsc") "ls")
;
(define (string-remove-last str) (substring str 0 (- (string-length str) 1)))

