#lang racket

;; required libraries

(require json)
(require racket/serialize)
(require net/uri-codec)
(require net/url)
(require web-server/servlet
         web-server/servlet-env)

(require "./boilerplate.scm")
(require "./utils.scm")

;; dispatch stuff

(define-values (site-dispatch site-url)
               (dispatch-rules
                 (("") main)

                 (("red-generals") red-gens)
                 (("green-generals") green-gens)
                 (("white-generals") white-gens)
                 (("blue-generals") blue-gens)
                 (("black-generals") black-gens)

                 (("colorless-generals") colorless-gens)
                 (("rainbow-generals") rainbow-gens)

                 (("black-red-green-generals") jund-gens)
                 (("green-white-blue-generals") bant-gens)
                 (("blue-black-red-generals") grixis-gens)
                 (("white-blue-black-generals") esper-gens)
                 (("red-green-white-generals") naya-gens)

                 (("blue-red-white-generals") jeskai-gens)
                 (("red-white-black-generals") mardu-gens)
                 (("black-green-blue-generals") sultai-gens)
                 (("green-blue-red-generals") temur-gens)
                 (("white-black-green-generals") abzan-gens)

                 (("white-blue-generals") azorius-gens)
                 (("blue-black-generals") dimir-gens)
                 (("black-red-generals") rakdos-gens)
                 (("red-green-generals") gruul-gens)
                 (("green-white-generals") selesnya-gens)

                 (("white-black-generals") orzhov-gens)
                 (("blue-red-generals") izzet-gens)
                 (("black-green-generals") golgari-gens)
                 (("red-white-generals") boros-gens)
                 (("green-blue-generals") simic-gens)


                 (("jund") jund-gens)
                 (("bant") bant-gens)
                 (("grixis") grixis-gens)
                 (("esper") esper-gens)
                 (("naya") naya-gens)
                 (("jeskai") jeskai-gens)
                 (("mardu") mardu-gens)
                 (("sultai") sultai-gens)
                 (("temur") temur-gens)
                 (("abzan") abzan-gens)
                 (("azorius") azorius-gens)
                 (("dimir") dimir-gens)
                 (("rakdos") rakdos-gens)
                 (("gruul") gruul-gens)
                 (("selesnya") selesnya-gens)
                 (("orzhov") orzhov-gens)
                 (("izzet") izzet-gens)
                 (("golgari") golgari-gens)
                 (("boros") boros-gens)
                 (("simic") simic-gens)
                 (("red") red-gens)
                 (("green") green-gens)
                 (("white") white-gens)
                 (("blue") blue-gens)
                 (("black") black-gens)
                 (("rainbow") rainbow-gens)
                 (("colorless") colorless-gens)
                 ))


(define (start req)
  (site-dispatch req))

(define (main req) (make-index-page req))

(define (jund-gens req) (make-gen-page "JUND" req))
(define (bant-gens req) (make-gen-page "BANT" req))
(define (grixis-gens req) (make-gen-page "GRIXIS" req))
(define (esper-gens req) (make-gen-page "ESPER" req))
(define (naya-gens req) (make-gen-page "NAYA" req))
(define (jeskai-gens req) (make-gen-page "JESKAI" req))
(define (mardu-gens req) (make-gen-page "MARDU" req))
(define (sultai-gens req) (make-gen-page "SULTAI" req))
(define (temur-gens req) (make-gen-page "TEMUR" req))
(define (abzan-gens req) (make-gen-page "ABZAN" req))
(define (azorius-gens req) (make-gen-page "AZORIUS" req))
(define (dimir-gens req) (make-gen-page "DIMIR" req))
(define (rakdos-gens req) (make-gen-page "RAKDOS" req))
(define (gruul-gens req) (make-gen-page "GRUUL" req))
(define (selesnya-gens req) (make-gen-page "SELESNYA" req))
(define (orzhov-gens req) (make-gen-page "ORZHOV" req))
(define (izzet-gens req) (make-gen-page "IZZET" req))
(define (golgari-gens req) (make-gen-page "GOLGARI" req))
(define (boros-gens req) (make-gen-page "BOROS" req))
(define (simic-gens req) (make-gen-page "SIMIC" req))
(define (red-gens req) (make-gen-page "RED" req))
(define (green-gens req) (make-gen-page "GREEN" req))
(define (white-gens req) (make-gen-page "WHITE" req))
(define (blue-gens req) (make-gen-page "BLUE" req))
(define (black-gens req) (make-gen-page "BLACK" req))
(define (rainbow-gens req) (make-gen-page "RAINBOW" req))
(define (colorless-gens req) (make-gen-page "COLORLESS" req))



(define (make-gen-page color req)

  (define titletext
    (if (eqv? "RAINBOW" color)
      "EDH Generals"
      (string-append color " EDH Generals")))


  (response/xexpr 
    `(html
       (head
        (title ,titletext)      
        (meta ((charset "utf-8")))

         ;; using the viewport recommendation from https://developers.google.com/speed/docs/insights/ConfigureViewport
         (meta ((name "viewport")
                (content "width=device-width, initial-scale=1")))

         (meta ((http-equiv "X-UA-Compatible")
                (content "IE=edge")))

         
    

         ;; removing sharethis stuff for now, it will better to have it on the bottom
         ,insertbootstrap ;;,insertsharethis1 ,insertsharethis2

         (link ((rel "stylesheet") (href "style.css")))

         ,insertGA)

       (body
         (div ((class "container"))

              (div ((class "row"))
                   (div ((class "col-md-12"))
                        (h1 ((id "header")) 
                            (a ((href "/")) "EDH Generals")
                            " > "
                            ,(string-append color " Generals"))))


              (h2 ,(string-append "There are  " 

                                 (number->string (length (get-cards-by-cid color)))
                                 " "
                                 color " commander generals."))

              ,(print-color color)

              ,insertlegalfooter

              )))))



(define (make-color-link1 a)
  `(div ((class "col-md-2"))
        (div ((class "colorlink"))
             (a ((href ,(string-append "/" a "-generals")))
                (img ((src ,(string-append "/img/" a ".png"))))
                (br)
                ,(string-append a)))))

(define (make-color-link2 a b)
  `(div ((class "col-md-2"))
        (div ((class "colorlink"))
             (a ((href ,(string-append "/" a "-" b "-generals")))
                (img ((src ,(string-append "/img/" a ".png"))))
                (img ((src ,(string-append "/img/" b ".png"))))
                (br)
                ,(string-append a "-" b)))))

(define (make-color-link3 a b c)
  `(div ((class "col-md-2"))
        (div ((class "colorlink"))
             (a ((href ,(string-append "/" a "-" b "-" c "-generals")))
                (img ((src ,(string-append "/img/" a ".png"))))
                (img ((src ,(string-append "/img/" b ".png"))))
                (img ((src ,(string-append "/img/" c ".png"))))
                (br)
                ,(string-append a "-" b "-" c)))))

(define (make-color-link5)
  `(div ((class "col-md-2"))
        (div ((class "colorlink"))
             (a ((href "/rainbow-generals"))
                (img ((src "/img/white.png")))
                (img ((src "/img/blue.png")))
                (img ((src "/img/black.png")))
                (img ((src "/img/red.png")))
                (img ((src "/img/green.png")))
                (br)
                "rainbow"))))




(define (make-index-page req)
  (response/xexpr
    `(html
       (head

         (meta ((charset "utf-8")))

         ;; using the viewport recommendation from https://developers.google.com/speed/docs/insights/ConfigureViewport
         (meta ((name "viewport")
                (content "width=device-width, initial-scale=1")))

         (meta ((http-equiv "X-UA-Compatible")
                (content "IE=edge")))


         ;; removing sharethis stuff for now, it will better to have it on the bottom
         ,insertbootstrap  ,insertGA 
         (link ((rel "stylesheet") (href "style.css")))
         
         (title "EDH Generals"))
       (body (div ((class "container main"))
                  (div ((class "row"))
                       (div ((class "col-md-12"))
                            (h1 "EDH Generals")
                            (p "Every EDH General printed from Alpha to Kaladesh.")
                            (hr)))

                  (div ((class "row")) (div ((class "col-md-12")) (h2 "Special Generals")))
                  (div ((class "row")) (div ((class "col-md-12")) (p "Four color generals are coming in November. Stay tuned!")))
                  (div ((class "row")) 

                       (div ((class "col-md-4")) "")
                       ,(make-color-link1 "colorless")
                       ,(make-color-link5))

                  (div ((class "row")) (div ((class "col-md-12")) (h2 "Monocolored")))
                  (div ((class "row"))
                       (div ((class "col-md-1")) "")
                       ,(make-color-link1 "white")
                       ,(make-color-link1 "blue")
                       ,(make-color-link1 "black")
                       ,(make-color-link1 "red")
                       ,(make-color-link1 "green"))


                  (div ((class "row")) (div ((class "col-md-12")) (h2 "Allied")))

                  (div ((class "row"))
                       (div ((class "col-md-1")) "")
                       ,(make-color-link2 "white" "blue")
                       ,(make-color-link2 "blue" "black")
                       ,(make-color-link2 "black" "red")
                       ,(make-color-link2 "red" "green")
                       ,(make-color-link2 "green" "white"))

                  (div ((class "row")) (div ((class "col-md-12")) (h2 "Enemy")))

                  (div ((class "row"))
                       (div ((class "col-md-1")) "")
                       ,(make-color-link2 "white" "black")
                       ,(make-color-link2 "blue" "red")
                       ,(make-color-link2 "black" "green")
                       ,(make-color-link2 "red" "white")
                       ,(make-color-link2 "green" "blue"))


                  (div ((class "row")) (div ((class "col-md-12")) (h2 "Shard")))

                  (div ((class "row"))
                       (div ((class "col-md-1")) "")
                       ,(make-color-link3 "green" "white" "blue")
                       ,(make-color-link3 "white" "blue" "black")
                       ,(make-color-link3 "blue" "black" "red")
                       ,(make-color-link3 "black" "red" "green")
                       ,(make-color-link3 "red" "green" "white"))

                  (div ((class "row")) (div ((class "col-md-12")) (h2 "Wedge")))

                  (div ((class "row"))

                       (div ((class "col-md-1")) "")
                       ,(make-color-link3 "white" "black" "green")
                       ,(make-color-link3 "blue" "red" "white")
                       ,(make-color-link3 "black" "green" "blue")
                       ,(make-color-link3 "red" "white" "black")
                       ,(make-color-link3 "green" "blue" "red"))


                  (div ((class "row"))

                       (div ((class "col-md-12"))
                            (hr)
                            "Say hi at  " 
                            (a ((href "https://twitter.com/idoh")) "@idoh")
                            " and "
                            (a ((href "https://plus.google.com/+IdohGerstenx")) "Google+")
                            " | " (a ((href "https://github.com/gersteni")) "Site's source code")
                            " | " (a ((href "http://www.idoh.com")) "blog"))))))))


(define (gogo) 
  (serve/servlet start
                 #:servlet-regexp #rx""
                 #:servlet-path "/"
                 #:listen-ip #f
                 #:command-line? #t
                 ;; if you run on port 80 then you need to "sudo racket" first
                 #:port 80
                 ;; #:log-file "./log.txt"

                 ;; to-do: fix this, should not be reading from the root directory

                 #:extra-files-paths (list  (build-path "./"))
                 ))

(provide (all-defined-out))
