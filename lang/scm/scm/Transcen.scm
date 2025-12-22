;; Copyright (C) 1992, 1993, 1995, 1997 Free Software Foundation, Inc.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this software; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;;
;; As a special exception, the Free Software Foundation gives permission
;; for additional uses of the text contained in its release of GUILE.
;;
;; The exception is that, if you link the GUILE library with other files
;; to produce an executable, this does not by itself cause the
;; resulting executable to be covered by the GNU General Public License.
;; Your use of that executable is in no way restricted on account of
;; linking the GUILE library code into it.
;;
;; This exception does not however invalidate any other reasons why
;; the executable file might be covered by the GNU General Public License.
;;
;; This exception applies only to the code released by the
;; Free Software Foundation under the name GUILE.  If you copy
;; code from other Free Software Foundation releases into a copy of
;; GUILE, as the General Public License permits, the exception does
;; not apply to the code that you add in this way.  To avoid misleading
;; anyone as to the status of such modified files, you must delete
;; this exception notice from them.
;;
;; If you write modifications of your own for GUILE, it is your choice
;; whether to permit this exception to apply to your modifications.
;; If you do not wish that, delete this exception notice.

;;;; "Transcen.scm", Complex trancendental functions for SCM.
;;; Author: Jerry D. Hedden.

(define compile-allnumbers #t)		;for HOBBIT compiler

(define (exp z)
  (if (real? z) ($exp z)
      (make-polar ($exp (real-part z)) (imag-part z))))

(define (log z)
  (if (and (real? z) (>= z 0))
      ($log z)
      (make-rectangular ($log (magnitude z)) (angle z))))

(define (sqrt z)
  (if (real? z)
      (if (negative? z) (make-rectangular 0 ($sqrt (- z)))
	  ($sqrt z))
      (make-polar ($sqrt (magnitude z)) (/ (angle z) 2))))

(define expt
  (let ((integer-expt integer-expt))
    (lambda (z1 z2)
      (cond ((exact? z2)
	     (integer-expt z1 z2))
	    ((and (real? z2) (real? z1) (>= z1 0))
	     ($expt z1 z2))
	    (else
	     (exp (* z2 (log z1))))))))

(define (sinh z)
  (if (real? z) ($sinh z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($sinh x) ($cos y))
			  (* ($cosh x) ($sin y))))))
(define (cosh z)
  (if (real? z) ($cosh z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($cosh x) ($cos y))
			  (* ($sinh x) ($sin y))))))
(define (tanh z)
  (if (real? z) ($tanh z)
      (let* ((x (* 2 (real-part z)))
	     (y (* 2 (imag-part z)))
	     (w (+ ($cosh x) ($cos y))))
	(make-rectangular (/ ($sinh x) w) (/ ($sin y) w)))))

(define (asinh z)
  (if (real? z) ($asinh z)
      (log (+ z (sqrt (+ (* z z) 1))))))

(define (acosh z)
  (if (and (real? z) (>= z 1))
      ($acosh z)
      (log (+ z (sqrt (- (* z z) 1))))))

(define (atanh z)
  (if (and (real? z) (> z -1) (< z 1))
      ($atanh z)
      (/ (log (/ (+ 1 z) (- 1 z))) 2)))

(define (sin z)
  (if (real? z) ($sin z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($sin x) ($cosh y))
			  (* ($cos x) ($sinh y))))))
(define (cos z)
  (if (real? z) ($cos z)
      (let ((x (real-part z)) (y (imag-part z)))
	(make-rectangular (* ($cos x) ($cosh y))
			  (- (* ($sin x) ($sinh y)))))))
(define (tan z)
  (if (real? z) ($tan z)
      (let* ((x (* 2 (real-part z)))
	     (y (* 2 (imag-part z)))
	     (w (+ ($cos x) ($cosh y))))
	(make-rectangular (/ ($sin x) w) (/ ($sinh y) w)))))

(define (asin z)
  (if (and (real? z) (>= z -1) (<= z 1))
      ($asin z)
      (* -i (asinh (* +i z)))))

(define (acos z)
  (if (and (real? z) (>= z -1) (<= z 1))
      ($acos z)
      (+ (/ (angle -1) 2) (* +i (asinh (* +i z))))))

(define (atan z . y)
  (if (null? y)
      (if (real? z) ($atan z)
	  (/ (log (/ (- +i z) (+ +i z))) +2i))
      ($atan2 z (car y))))
