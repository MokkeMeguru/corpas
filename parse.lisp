(in-package :parse)

(defun shape-movie-line (text s)
  (let* ((base (cl-ppcre:split "\\s+" text))
         (tag (first base))
         (words-list (let ((words (cddddr (cddddr base))))
                       (if (equal "+++$+++" (first words))
                           (rest words)
                           words))))
    (format s "~a|~b~%" tag
            (string-downcase
             (cl-ppcre:regex-replace-all
              "  "
              (cl-ppcre:regex-replace-all
                "\\. . ."
                (cl-ppcre:regex-replace-all
                 "\\!"
                 (cl-ppcre:regex-replace-all
                  "--"
                  (cl-ppcre:regex-replace-all
                   "\\,"
                   (cl-ppcre:regex-replace-all
                    "\\?"
                    (cl-ppcre:regex-replace-all
                     "\\.{1}"
                       (format nil "~{~a~^ ~}" words-list)
                     " .") " ?") " ,") " -- ") " !") "... ") " ")))))

(defun shape-movie-lines (path)
  (with-open-file (write-stream (format nil "~a~b"
                                        (first (cl-ppcre:split "\\." path))
                                        "_shaped.txt")
                                :direction :output
                                :if-exists :supersede
                                :if-does-not-exist :create)
    (with-open-file (read-stream path)
      (do  ((l (read-line read-stream) (read-line read-stream nil 'eof)))
           ((eq l 'eof) "EOF")
       (shape-movie-line l write-stream)))))

(defun shape-movie-conversation (text s)
  (let ((key-list
          (remove-if (lambda (i) (or (equal i " ") (equal i "")))
                     (cl-ppcre:split "[\\,\\']"
                                     (cadr (cl-ppcre:split "[\\[\\]]"
                                                           text))))))
    (format s "~a~%" (format nil "~{~a~}"
                             (cdr (mapcan (lambda (i) (list "|" i )) key-list))))))

(defun shape-movie-conversations (path)
  (with-open-file (write-stream (format nil "~a~b"
                                        (first (cl-ppcre:split "\\." path))
                                        "_shaped.txt")
                                :direction :output
                                :if-exists :supersede
                                :if-does-not-exist :create)
    (with-open-file (read-stream path)
      (do  ((l (read-line read-stream) (read-line read-stream nil 'eof)))
           ((eq l 'eof) "EOF")
        (shape-movie-conversation l write-stream)))))

;; --- trash ---------
;; (defparameter shape-movie-line
;;   (let ((tag (first (cl-ppcre:split "\\s+" test-movie-line)))
;;         (words-list (cddddr (cddddr (cl-ppcre:split "\\s+" test-movie-line)))))
;;     (format nil "~A|~B" tag (format nil "~{~a~^ ~}" words-list))))

;; (with-open-file (stream "movie_lines_shaped.txt"
;;                         :direction :output
;;                         :if-exists :supersede)
;;   (format stream "hello"))

;; (defparameter test-movie-line
;;   (with-open-file (stream "movie_lines.txt" :direction :input)
;;     (read-line stream)))

;; (remove-if (lambda (i) (or (equal i " ") (equal i "")))
;;            (cl-ppcre:split "[\\,\\']"
;;                            (cadr (cl-ppcre:split "[\\[\\]]" "u0 +++$+++ u2 +++$+++ m0 +++$+++ ['L194', 'L195', 'L196', 'L197']"))))

;; (cl-ppcre:regex-replace "\\.{1}^\\.{3}" (cl-ppcre:regex-replace "\\.{3}" "hello... somethings? happen." " ...") " .")

;; (cl-ppcre:regex-replace-all "\\. . ." (cl-ppcre:regex-replace-all "\\," (cl-ppcre:regex-replace-all "\\?" (cl-ppcre:regex-replace-all "\\.{1}" "h, h. hello... somethings? happen." " .") " ?") " ,") "...")
