(load "quicklisp.lisp")
(require :asdf)

;; Install quicklisp
(quicklisp-quickstart:install :path "/home/jupyter/.quicklisp/")

;; Manually call quickload because these dependencies aren't being
;; loaded correctly when loading cl-jupyter.
(ql:quickload "alexandria")
(ql:quickload "trivial-features")
(ql:quickload "babel")

;; Run the kernel script once to get all of the required packages installed
;; so that that pacakges aren't installed when running starting the notebook.
(load "cl-jupyter/cl-jupyter.lisp")
(quit)
