;Author: Rahul Bhonsale
;Class: CS 401 - Programming Language
;Title: Scheme Parser
;Date: 1/30/2015


;println with string concat.
(define (prntTag str x)
	(write str)
	(write x)
	(newline)
	)

;println module.
(define (println x)
	(write x)
	(newline)
	)

;error message.
(define (ex)
	(println "Incorrect S-Expression")
	)

;initial call. Checks to see if first input is an operation, otherwise
;	it is not a correct s-expression.
(define (check)
	(define r (read))
	(cond
		((number? (car r)) (ex) )
		((eq? (car r) '*) (multCheck r))
		((eq? (car r) '-) (turnNeg r))
		(else
			(arrange r))
		))

;module for final s-expression transformation.
(define (fin lst)
	(write (cadr lst))
	(write (car lst))
	(println (caddr lst))
	)
	
(define (turnNeg lst)
	(cond
		((and (number? (cadr lst)) (symbol? (caddr lst)))
			(write '-)	
			(write (cadr lst))
			(write '+)
			(println (caddr lst))	
		)
		((and (list? (cadr lst)) (number? (caddr lst)))
			(write '-)
			(write (caddr lst))
			(write '+)
			(arrange (cadr lst))
		)
		((and (number? (cadr lst)) (list? (caddr lst)))
			(write '-)	
			(write (cadr lst))
			(write '+)
			(arrange (caddr lst))
		)
		((and (symbol? (cadr lst)) (number? (caddr lst)))
			(write '-)
			(write (caddr lst))
			(write '+)
			(println (cadr lst))
		)
		((and (number? (cadr lst)) (number? (caddr lst)))
			(arrange lst))
	)
)

;recursive function that returns reformatted s-expression.	
(define (arrange lst)
	(define lng (length lst))
	(cond 
		  ((and (and (number? (cadr lst)) (number? (caddr lst)))(= lng 3)) (fin lst)) 
		  ((number? (cadr lst)) (write (cadr lst)) (write (car lst)) (arrange (caddr lst)))
		  ((number? (caddr lst)) (write (caddr lst)) (write(car lst)) (arrange (cadr lst)))
		  )
	)
			

;//this is for the mulitply function on multiple s-Expressions			
(define (multCheck lst)
	(define lng (length lst))
	;(if (= lng 3) (arrange lst)

	; ex. (* (+ 2 3) 4)
	(if (and (list? (cadr lst)) (number? (caddr lst)))
		(dstRight lst (car lst) (caddr lst) )
		)
		
	; ex. (* 4 (+ 2 3))
	(if (and (list? (caddr lst)) (number? (cadr lst)))
  		(dstLeft lst (car lst) (cadr lst))
  		)
  		
  	(if (and (number? (cadr lst)) (number? (caddr lst)))
  		(arrange lst))
  	

	)
(define (dstRight lst op cons)
	(define xPr (cadr lst))
	(write cons)
	(write '*)
	(write (cadr xPr))
	(write (car xPr))
	(write cons)
	(write '*)
	(write (caddr xPr))
	(newline)
	)
	
(define (dstLeft lst op cons)
	(define xPr (caddr lst))
	(write cons)
	(write '*)
	(write (cadr xPr))
	(write (car xPr))
	(write cons)
	(write '*)
	(write (caddr xPr))
	(newline)
	)

(println "Please enter an S-Expression")
(check)


	
