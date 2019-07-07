(define-syntax condition:
  (syntax-rules ()
    ((_ ?kind) (?kind))
    ((_ (?kind properties? ...))
     (?kind properties? ...))))

(define-syntax condition-list:
  (syntax-rules ()
    ((_ (?form))
     (condition: ?form))
    ((_ (?form ?rest ...))
     ((condition: ?form) (condition-list: (?rest ...))))))

(define-syntax foo
  (syntax-rules ()
    ((_ ?msg ((?kind ?properties ...) ...) ?expr)
     '((?kind ?properties ...) ...))
    ))
