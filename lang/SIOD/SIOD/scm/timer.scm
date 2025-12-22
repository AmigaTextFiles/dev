(define time-of-day runtime)

(define (timer proc . args)
        (let* ((start (runtime))
               (ans (apply proc args))
               (end (runtime)))
              (writeln "Time = " (- end start) ", Answer = " ans)))
