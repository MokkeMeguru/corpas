(asdf:defsystem "corpas"
  :description "make Cornell Movie-Dialogs Corpus's data more convenient for seq2seq"
  :version "0.0.1"
  :author "Meguru Mokke"
  :licence "MIT"
  :depends-on ("cl-ppcre")
  :serial t
  :components ((:file "package")
               (:file "parse")
               (:file "dict")))

;; (ql:quickload :cl-ppcre)
