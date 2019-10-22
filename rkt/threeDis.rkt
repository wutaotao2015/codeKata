;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname threeDis) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)

;(define-struct 3dp [x y z])
;; a 3dp is a structure:
;;   (make-3dp number number number)
;; a 3dp is one 3 dimensional position 
;(define (dis p)
;   (sqrt (+ 
;           (sqr (3dp-x p))
;           (sqr (3dp-y p))
;           (sqr (3dp-z p))
;           ))
;  )
;(check-expect (dis (make-3dp 0 0 6)) 6)
;(check-expect (dis (make-3dp 6 -2 3)) 7)

;(define-struct time [h m s])
;; a Time is a structure:
;;  (make-time number number number)
;;  h is a integer [0, 24], m and s is a integer [0, 60]
;
;(define t1 (make-time 12 30 2))
;
;(define MS 60)
;(define HS (* 60 60))
;; time -> number
;; computes the seconds passed from midnight to t
;(define (pass t) 
;  (+ (* (time-h t) HS)
;     (* (time-m t) MS)
;     (time-s t)))
;
;(check-expect (pass t1) 45002)


;(define-struct w3 [l1 l2 l3])
;; A W3 is a structure:
;;  (make-w3 string/boolean string/boolean string/boolean)
;;   l1, l2, l3 are all 1-length string ["a" -> "z"] and #f
;
;(define w3a (make-w3 "a" "b" "c"))
;(define w3b (make-w3 "z" "f" "g"))
;(define w3c (make-w3 #f #f #f))
;(define w3d (make-w3 "z" "f" "g"))
;
;; string-> boolean
;; compare single letters, if agree return #t, else return #f
;(define (comp-letter m n) (if (string=? m n) #t #f))
;
;(check-expect (comp-letter "a" "b") #f)
;(check-expect (comp-letter "s" "s") #t)
;
;
;; w3 -> w3
;; compare two w3 words, if the same then return one of them, otherwise return (make-w3 #f #f #f)
;(define (compare-w3 a b)
;  (if (and 
;        (comp-letter (w3-l1 a) (w3-l1 b)) 
;        (comp-letter (w3-l2 a) (w3-l2 b)) 
;        (comp-letter (w3-l3 a) (w3-l3 b)) 
;  ) a (make-w3 #f #f #f)))
;
;(check-expect (compare-w3 w3b w3d) w3d)
;(check-expect (compare-w3 w3a w3b) (make-w3 #f #f #f))


(define-struct editor [pre post])
; An Editor is a structure: (make-editor string string)
; it means the text is (string-append pre post), and a cursor is between pre and post
(define e1 (make-editor "hello" "world"))
(define e2 (make-editor "hel" "loworld"))
(define e3 (make-editor "hello" ""))
(define e4 (make-editor "" "hello"))
(define e5 (make-editor "123456789abcd" ""))

(define BGH 400)
(define BGW 200)
(define FS 30)
; 400BGW 40FS 22w 20CN 
; 600BGW 60FS 33w 20CN
; 200BGW 30FS 17w 12CN
(define CN (- (/ BGW (/ FS 2)) 1))
(define BG (empty-scene BGW BGH))

; editor -> image
; render an editor to a image
(define (render ed) 
  (overlay/align "left" "center"
    (beside (text (editor-pre ed) FS "black")
            (rectangle 1 FS "solid" "red")
            (text (editor-post ed) FS "black")) BG))

(check-expect (render e1) (overlay/align "left" "center"
    (beside (text (editor-pre e1) FS "black")
            (rectangle 1 FS "solid" "red")
            (text (editor-post e1) FS "black")) BG))

(check-expect (render e2) (overlay/align "left" "center"
    (beside (text (editor-pre e2) FS "black")
            (rectangle 1 FS "solid" "red")
            (text (editor-post e2) FS "black")) BG))


(define (string-remove-last str) (substring str 0 (- (string-length str) 1))) 
(check-expect (string-remove-last "wtd") "wt")
(check-expect (string-remove-last "wsg") "ws")

(define (string-remove-first str) (substring str 1 (string-length str) )) 
(check-expect (string-remove-first "wtd") "td")
(check-expect (string-remove-first "wsg") "sg")

(define (string-first str) (string-ith str 0))
(check-expect (string-first "sdg") "s")
(check-expect (string-first "wdg") "w")

(define (string-last str) (string-ith str (- (string-length str) 1)))
(check-expect (string-last "wsg") "g")
(check-expect (string-last "wsd") "d")

; editor string -> editor
; when pressed key, change editor according to it 
;  when key is "\b", delete the letter before cursor(if any), 
; other key add the key string to the pre
; \t and \r is ignored 
;  when key is "left" or "right", move cursor left or right(if any), other longer than 1 length
; string keys is ignored 
(define (edit ed key) 
   (cond
     [(string=? key "\b") 
       (if (= (string-length (editor-pre ed)) 0) ed 
      (make-editor (string-remove-last (editor-pre ed)) (editor-post ed)))]

     [(or (string=? key "\r") (string=? key "\t")) ed]

     [(= (string-length key) 1) 

      ;; here the whole length can out of the BG, should use the length of pre plus post
      (if (>= (string-length (editor-pre ed)) CN) ed 
      (make-editor (string-append (editor-pre ed) key) (editor-post ed)))]

     [(string=? key "left")
       (if (= (string-length (editor-pre ed)) 0) ed 
          (make-editor (string-remove-last (editor-pre ed)) 
                       (string-append (string-last (editor-pre ed)) (editor-post ed))))]

     [(string=? key "right") 
       (if (= (string-length (editor-post ed)) 0) ed 
          (make-editor (string-append (editor-pre ed) (string-first (editor-post ed)) ) 
                       (string-remove-first (editor-post ed))))]
     [else ed]))

(check-expect (edit e1 "\b") (make-editor "hell" "world"))
(check-expect (edit e2 "\b") (make-editor "he" "loworld"))
(check-expect (edit e3 "\b") (make-editor "hell" ""))
(check-expect (edit e4 "\b") (make-editor "" "hello"))

(check-expect (edit e1 "\r") (make-editor "hello" "world"))
(check-expect (edit e2 "\r") (make-editor "hel" "loworld"))
(check-expect (edit e3 "\r") (make-editor "hello" ""))
(check-expect (edit e4 "\r") (make-editor "" "hello"))

(check-expect (edit e1 "\t") (make-editor "hello" "world"))
(check-expect (edit e2 "\t") (make-editor "hel" "loworld"))
(check-expect (edit e3 "\t") (make-editor "hello" ""))
(check-expect (edit e4 "\t") (make-editor "" "hello"))

(check-expect (edit e1 "s") (make-editor "hellos" "world"))
(check-expect (edit e2 "s") (make-editor "hels" "loworld"))
(check-expect (edit e3 "s") (make-editor "hellos" ""))
(check-expect (edit e4 "s") (make-editor "s" "hello"))
(check-expect (edit e5 "s") e5)

(check-expect (edit e1 "left") (make-editor "hell" "oworld"))
(check-expect (edit e2 "left") (make-editor "he" "lloworld"))
(check-expect (edit e3 "left") (make-editor "hell" "o"))
(check-expect (edit e4 "left") (make-editor "" "hello"))

(check-expect (edit e1 "right") (make-editor "hellow" "orld"))
(check-expect (edit e2 "right") (make-editor "hell" "oworld"))
(check-expect (edit e3 "right") (make-editor "hello" ""))
(check-expect (edit e4 "right") (make-editor "h" "ello"))

; editor->editor
; run the editor
(define (run pre)
   (big-bang (make-editor pre "")
            [to-draw render] 
            [on-key edit]
             )   
  )

(run "type here")


