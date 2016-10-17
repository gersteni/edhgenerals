#lang racket

(require racket/serialize)
(require net/uri-codec)
(require net/url)


;; Declarations


(define dbpath "./edhdb")

(define cardimgagespath "./edhcardimg/")

;; persistance related things

(define (save-thing path obj)
    (with-output-to-file path (lambda () (write (serialize obj)))
                                                #:exists 'replace))

(define (load-thing path)
    (deserialize (call-with-input-file path read)))

(define edhdb (load-thing dbpath))

(define (save-edhdb)
  (save-thing dbpath edhdb))






;; this is used in interactive mode to pull a card by name and look at it

(define c "")
(define (cize name)
  (set! c (hash-ref edhdb name)))






;; construct a card hash, after using cize

(define (make-card name color mid)
  (hash-set! edhdb name (make-hash))
  (cize name)
  (hash-set! c 'colorid `(,color))
  (hash-set! c 'frenchban '(""))
  (hash-set! c 'multiban '(""))
  (hash-set! c 'has-img? #t)
  (hash-set! c 'mid mid)
  (hash-set! c 'exclude `(""))
  )


(define categories '("RAINBOW"
                   "COLORLESS"
                   "JUND"
                   "BANT"
                   "GRIXIS"
                   "ESPER"
                   "NAYA"
                   "JESKAI"
                   "MARDU"
                   "SULTAI"
                   "TEMUR"
                   "ABZAN"
                   "AZORIUS"
                   "DIMIR"
                   "RAKDOS"
                   "GRUUL"
                   "SELESNYA"
                   "ORZHOV"
                   "IZZET"
                   "GOLGARI"
                   "BOROS"
                   "SIMIC"
                   "BLUE"
                   "BLACK"
                   "RED"
                   "GREEN"
                   "WHITE"))


;; function to sort cards, descending by card id (cid)

(define (sort-card a b)
  (define amid (hash-ref (hash-ref edhdb a) 'mid))
  (define bmid (hash-ref (hash-ref edhdb b) 'mid))
  (> amid bmid))


;; to-do: change this to use "c" and not the name of the card ...
(define (exclude-card? name)
  (define c (hash-ref edhdb name))
  (equal? "TRUE" (car (hash-ref c 'exclude))))


(define (get-cards-by-cid color)
  (define clist (remove* '(#f)
                         (map
                           (lambda (name)
                             (define c (hash-ref edhdb name))
                             (define cid (car (hash-ref c 'colorid)))
                             (if (equal? cid color) 
                               (if (exclude-card? name) #f name)
                               #f))


                           (hash-keys edhdb))))

  (sort clist sort-card))





(define (frenchban? c)
  (if (equal? "TRUE" (car (hash-ref c 'frenchban))) #t #f))

(define (multiban? c)
  (if (equal? "TRUE" (car (hash-ref c 'multiban))) #t #f))

(define (annoying? c) (hash-ref c 'annoying #f))

(define (overrated? c) (hash-ref c 'overrated #f))

(define (allstar? c) (hash-ref c 'allstar #f))

(define (pillowfort? c) (hash-ref c 'pillowfort #f))

(define (suspend? c) (hash-ref c 'suspend #f))

(define (strange? c) (hash-ref c 'strange #f))



(define (print-card cardname)
  (define c (hash-ref edhdb cardname))
  `(div ((class "card")) 

        (img ((height "311")
              (width "223")
              (alt ,cardname)
              (src ,(string-append cardimgagespath (number->string (hash-ref c 'mid)) ".png"))))
        (div ((class "cardinfo"))
             (b ,cardname) " "

             ,(if (allstar? c) '(label ((class "label label-success")) "Allstar") "")
             ,(if (frenchban? c) '(label ((class "label label-danger")) "Banned in Duel Commander 1v1") "")
             ,(if (multiban? c) '(label ((class "label label-danger")) "Banned in Multiplayer") "")
             ,(if (annoying? c) '(label ((class "label label-warning")) "Annoying") "")
             ,(if (overrated? c) '(label ((class "label label-warning")) "Overrated") "")
             ,(if (pillowfort? c) '(label ((class "label label-warning")) "Pillowfort") "")
             ,(if (suspend? c) '(label ((class "label label-danger")) "Cannot Suspend from Command Zone") "")
             ,(if (strange? c) '(label ((class "label label-danger")) "Needs Setup") "")
             
             
             )))


(define (print-color color)
  `(div ((class "row"))
        (div ((class "col-md-12")) 
             ,@(map print-card (get-cards-by-cid color)))))


(define (print-color-links color)
  `(div ((class "row")) 
        (div ((class "col-md-12"))
             ,@(map 
                 (lambda (x)

                   (define link `(span ((class "colorlink"))(a ((href ,(string-append "/" (string-downcase x)))) ,(string-append x " "))))

                   (if (eqv? color x)
                     `(b ,link)
                     link))
                 categories))))



(provide (all-defined-out))
