(import (chicken condition) test test-extras)

(test-begin)

(test-group "test-error*"

  (test-error* "raises hoopla with qux=\"wat\" buzz=\"fizz\", baz with bar=\"foo\""
               (hoopla qux "wat" buzz "fizz")
               (baz bar "foo")
               (signal (condition '(hoopla qux "wat" buzz "fizz") '(baz bar "foo"))))

  (test-error* "raises exn with message=\"division by zero\", arithmetic"
               (exn message "division by zero")
               arithmetic
               (/ 42 0))

  (test-error* "raises exn with message=\"whoops\""
               (exn message "whoops")
               (error "whoops")))

  ; default message: "raises exn, arithmetic"
  ; (test-error* exn arithmetic (/ 42 0))

  ; default message: "raises exn"
  ; (test-error* exn (error "whoops"))

(test-end)
