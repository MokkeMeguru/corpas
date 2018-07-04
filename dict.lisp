(in-package :dict)

;; 10,000 words ... ?
(defparameter *dict* (make-hash-table :size 100000))

(defun create-dictionary (path)
  (setf *dict* (make-hash-table :size 100000))
  (with-open-file (write-stream (cl-ppcre:regex-replace
                                 (caddr (reverse (cl-ppcre:split "\\b" path)))
                                 path
                                 "movie_dictionary")
                                :direction :output
                                :if-exists :supersede
                                :if-does-not-exist :create)
    (with-open-file (read-stream path)
      (do ((l (read-line read-stream) (read-line read-stream nil 'eof)))
          ((eq l 'eof) "EOF")
        (loop for i
                in (cl-ppcre:split " " (cadr (cl-ppcre:split "\\|" l)))
              do (unless (gethash (intern i) *dict*)
                   (progn
                     (setf (gethash (intern i) *dict*) 1)
                     (format write-stream "~a~%" i))))))))
