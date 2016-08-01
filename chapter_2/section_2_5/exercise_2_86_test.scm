(add-load-path "./")
(load "generic_arithmetic_system.scm")

(define int-1 (make-integer 1.5))
(define int-2 (make-integer 4))
(define real-1 (make-real 2))
(define real-2 (make-real 3.1415926))

(sine 2)
(sine int-1)
(sine real-2)

(cosine 4)
(cosine int-2)
(cosine real-1)

(define complex-scheme (make-complex-from-real-imag 2 3.3))
(define complex-int (make-complex-from-mag-ang int-1 int-2))
(define complex-real (make-complex-from-real-imag real-1 real-2))

(real-part complex-scheme)
(imag-part complex-scheme)
(magnitude complex-scheme)
(angle complex-scheme)

(real-part complex-int)
(imag-part complex-int)
(magnitude complex-int)
(angle complex-int)

(real-part complex-real)
(imag-part complex-real)
(magnitude complex-real)
(angle complex-real)
