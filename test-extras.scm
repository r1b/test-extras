(module test-extras (test-error*)
  (import (chicken base)
          (chicken condition)
          (chicken syntax)
          scheme
          test)

  (define-for-syntax (get-condition-properties exn kind properties #!optional (acc '()))
    (import (chicken condition))  ; XXX: Not sure why we need this?
    (if (null? properties)
        acc
        (let* ((property (car properties))
               (actual-value (get-condition-property exn
                                                     kind
                                                     property
                                                     "<missing>")))
          (get-condition-properties exn
                                    kind
                                    (cddr properties)
                                    (append acc (list property actual-value))))))

  (define-for-syntax (get-actual-conditions exn expected-conditions)
    (let* ((kinds (##sys#slot exn 1))
           (find-condition (lambda (found kind #!optional (properties '()))
                             (if (member kind kinds)
                                 (found kind properties)
                                 (sprintf "<~A: missing>" kind))))
           (make-simple-condition (lambda (kind _) kind))
           (make-condition-with-properties (lambda (kind properties)
                                             (cons kind
                                                   (get-condition-properties exn kind properties)))))
      (map (lambda (spec)
             (if (atom? spec)
                 (find-condition make-simple-condition spec)
                 (find-condition make-condition-with-properties (car spec) (cdr spec))))
           expected-conditions)))

  ; Based on the commented-out `test-error*` in the `test` egg
  ; TODO: Default messages
  (define-syntax test-error*
    (syntax-rules ()
      ((_ ?msg ?expected-condition ... ?expr)
       (let-syntax ((transform-expression
                      (syntax-rules ()
                        ((_ ?expr)
                         (condition-case (begin ?expr "<no error thrown>")
                           (exn () (get-actual-conditions exn
                                                          '(?expected-condition ...))))))))
         (test ?msg '(?expected-condition ...) (transform-expression ?expr)))))))
