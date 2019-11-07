#lang racket

(define MAX-BYTES (* 100 1024 1024))
(custodian-limit-memory (current-custodian) MAX-BYTES)

(require test-engine/racket-tests)
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)








; this need to put at last line to ensure testing all test cases
(test)
