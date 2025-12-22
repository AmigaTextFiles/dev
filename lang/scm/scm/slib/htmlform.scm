;;; "htmlform.scm" Generate HTML 2.0 forms; service CGI requests. -*-scheme-*-
; Copyright 1997, 1998 Aubrey Jaffer
;
;Permission to copy this software, to redistribute it, and to use it
;for any purpose is granted, subject to the following restrictions and
;understandings.
;
;1.  Any copy made of this software must include this copyright notice
;in full.
;
;2.  I have made no warrantee or representation that the operation of
;this software will be error-free, and I am under no obligation to
;provide any services, by way of maintenance, update, or otherwise.
;
;3.  In conjunction with products arising from the use of this
;material, there shall be no use of my name in any advertising,
;promotional, or sales literature without prior written consent in
;each case.

(require 'sort)
(require 'scanf)
(require 'printf)
(require 'line-i/o)
(require 'parameters)
(require 'fluid-let)
(require 'dynamic-wind)
(require 'pretty-print)
(require 'object->string)
(require 'string-case)
(require 'string-port)
(require 'string-search)
(require 'database-utilities)
(require 'common-list-functions)

;;;;@code{(require 'html-form)}

;;@body Procedure names starting with @samp{html:} send their output
;;to the port @0.  @0 is initially the current output port.
(define *html:output-port* (current-output-port))

(define (html:printf . args) (apply fprintf *html:output-port* args))

;;@body Returns a string with character substitutions appropriate to
;;send @1 as an @dfn{attribute-value}.
(define (make-atval txt)		; attribute-value
  (if (symbol? txt) (set! txt (symbol->string txt)))
  (if (number? txt)
      (number->string txt)
      (string-subst (if (string? txt) txt (object->string txt))
		    "&" "&amp;"
		    "\"" "&quot;"
		    "<" "&lt;"
		    ">" "&gt;")))

;;@body Returns a string with character substitutions appropriate to
;;send @1 as an @dfn{plain-text}.
(define (make-plain txt)		; plain-text `Data Characters'
  (if (symbol? txt) (set! txt (symbol->string txt)))
  (if (number? txt)
      (number->string txt)
      (string-subst (if (string? txt) txt (object->string txt))
		    "&" "&amp;"
		    "<" "&lt;"
		    ">" "&gt;")))

;;@args title backlink tags ...
;;@args title backlink
;;@args title
;;
;;Outputs headers for an HTML page named @1.  If string arguments @2
;;... are supplied they are printed verbatim within the @t{<HEAD>}
;;section.
(define (html:start-page title . args)
  (define backlink (if (null? args) #f (car args)))
  (if (not (null? args)) (set! args (cdr args)))
  (html:printf "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">\\n")
  (html:printf "<HTML>\\n")
  (html:comment "HTML by SLIB"
		"http://swissnet.ai.mit.edu/~jaffer/SLIB.html")
  (html:printf "<HEAD>%s<TITLE>%s</TITLE></HEAD>\\n"
	       (apply string-append args) (make-plain title))
  (html:printf "<BODY><H1>%s</H1>\\n"
	       (or backlink (make-plain title))))

;;@body Outputs HTML codes to end a page.
(define (html:end-page)
  (html:printf "</BODY>\\n")
  (html:printf "</HTML>\\n"))

;;@body Writes (using @code{html:printf}) the strings @1, @2 as
;;@dfn{PRE}formmated plain text (rendered in fixed-width font).
;;Newlines are inserted between @1, @2.  HTML tags (@samp{<tag>})
;;within @2 will be visible verbatim.
(define (html:pre line1 . lines)
  (html:printf "<PRE>\\n%s" (make-plain line1))
  (for-each (lambda (line) (html:printf "\\n%s" (make-plain line))) lines)
  (html:printf "</PRE>\\n"))

;;@body Writes (using @code{html:printf}) the strings @1 as HTML
;;comments.
(define (html:comment line1 . lines)
  (html:printf "<!")
  (if (substring? "--" line1)
      (slib:error 'html:comment "line contains --" line1)
      (html:printf "--%s--" line1))
  (for-each (lambda (line)
	      (if (substring? "--" line)
		  (slib:error 'html:comment "line contains --" line)
		  (html:printf "\\n  --%s--" line)))
	    lines)
  (html:printf ">\\n"))

;;@section HTML Tables

;;@body
(define (html:start-table caption)
  (html:printf "<TABLE BORDER WIDTH=\"100%%\">\\n")
  (html:printf "<CAPTION ALIGN=BOTTOM>%s</CAPTION>\\n" (make-plain caption)))

;;@body
(define (html:end-table)
  (html:printf "</TABLE>\\n"))

;;@body Outputs a heading row for the currently-started table.
(define (html:heading columns)
  (html:printf "<TR VALIGN=\"TOP\">\\n")
  (for-each (lambda (datum) (html:printf "<TH>%s\\n" (or datum ""))) columns))

;;@body Outputs a heading row with column-names @1 linked to URLs @2.
(define (html:href-heading columns urls)
  (html:heading
   (map (lambda (column url)
	  (if url
	      (sprintf #f "<A HREF=\"%s\">%s</A>" url column)
	      column))
	columns urls)))

;;@args k foreigns
;;
;;The positive integer @1 is the primary-key-limit (number of
;;primary-keys) of the table.  @2 is a list of the filenames of
;;foreign-key field pages and #f for non foreign-key fields.
;;
;;@0 returns a procedure taking a row for its single argument.  This
;;returned procedure prints the table row to @var{*html:output-port*}.
(define (make-row-converter pkl foreigns)
  (lambda (data-row)
    (define anchored? #f)
    (define (present datum)
      (cond ((or (string? datum) (symbol? datum))
	     (html:printf "%s" (make-plain datum)))
	    (else
	     (html:printf
	      "<PRE>\\n%s</PRE>\\n"
	      (make-plain (call-with-output-string
			   (lambda (port)
			     (pretty-print datum port))))))))
    (html:printf "<TR VALIGN=\"TOP\">")
    (for-each (lambda (datum foreign)
		(html:printf "<TD>")
		(cond ((not datum))
		      ((null? datum))
		      ((not anchored?)
		       (html:printf "<A NAME=\"")
		       (cond
			((zero? pkl)
			 (html:printf "%s" (make-atval datum)))
			(else (html:printf
			       "%s" (make-atval (car data-row)))
			      (do ((idx 1 (+ 1 idx))
				   (contents (cdr data-row) (cdr contents)))
				  ((>= idx pkl))
				(html:printf
				 " %s" (make-atval (car contents))))))
		       (html:printf "\">")
		       (set! anchored? (not (zero? pkl)))))
		(cond ((not datum)) ((null? datum))
		      ((not foreign) (present datum))
		      ((zero? pkl)
		       (html:printf "<A HREF=\"%s\">" foreign)
		       (present datum)
		       (html:printf "</A>"))
		      (else
		       (html:printf "<A HREF=\"%s#%s\">"
				    foreign (make-atval datum))
		       (present datum)
		       (html:printf "</A>"))))
	      data-row foreigns)
    (html:printf "\\n")))

;;@body
;;Returns the symbol @1 converted to a filename.
(define (table-name->filename table-name)
  (and table-name (string-append
		   (string-subst (symbol->string table-name) "*" "" ":" "_")
		   ".html")))

(define (table-name->column-table-name db table-name)
  ((((db 'open-table) '*catalog-data* #f) 'get 'coltab-name)
   table-name))

;;@args caption db table-name match-key1 @dots{}
;;Writes HTML for @2 table @3 to @var{*html:output-port*}.
;;
;;The optional @4 @dots{} arguments restrict actions to a subset of
;;the table.  @xref{Table Operations, match-key}.
(define (table->html caption db table-name . args)
  (let* ((table ((db 'open-table) table-name #f))
	 (foreigns (table 'column-foreigns))
	 (tags (map table-name->filename foreigns))
	 (names (table 'column-names))
	 (primlim (table 'primary-limit)))
    (html:start-table caption)
    (html:href-heading
     names
     (append (make-list primlim (table-name->filename
				 (table-name->column-table-name db table-name)))
	     (make-list (- (length names) primlim) #f)))
    (html:heading (table 'column-domains))
    (html:href-heading foreigns tags)
    (html:heading (table 'column-types))
    (apply (table 'for-each-row) (make-row-converter primlim tags) args)
    (html:end-table)))

;;@body
;;Writes a complete HTML page to @var{*html:output-port*}.  The string
;;@3 names the page which refers to this one.
(define (table->page db table-name index-filename)
  (dynamic-wind
      (lambda ()
	(if index-filename
	    (html:start-page
	     table-name
	     (sprintf #f "<A HREF=\"%s#%s\">%s</A>"
		      index-filename
		      (make-atval table-name)
		      (make-plain table-name)))
	    (html:start-page table-name)))
      (lambda () (table->html table-name db table-name))
      html:end-page))

;;@body
;;Writes HTML for the catalog table of @1 to @var{*html:output-port*}.
(define	(catalog->html db caption)
  (html:start-table caption)
  (html:heading '(table columns))
  ((((db 'open-table) '*catalog-data* #f) 'for-each-row)
   (lambda (row)
     (cond ((and (eq? '*columns* (caddr row))
		 (not (eq? '*columns* (car row)))))
	   (else ((make-row-converter
		   0 (list (table-name->filename (car row))
			   (table-name->filename (caddr row))))
		  (list (car row) (caddr row))))))))

;;@body
;;Writes a complete HTML page for the catalog of @1 to
;;@var{*html:output-port*}.
(define (catalog->page db caption)
  (dynamic-wind
      (lambda () (html:start-page caption))
      (lambda ()
	(catalog->html db caption)
	(html:end-table))
      html:end-page))

;;@section HTML Forms

(define (html:dt-strong-doc name doc)
  (if (and (string? doc) (not (equal? "" doc)))
      (html:printf "<DT><STRONG>%s</STRONG> (%s)\\n"
		   (make-plain name) (make-plain doc))
      (html:printf "<DT><STRONG>%s</STRONG>\\n" (make-plain name))))

(define (html:checkbox name doc pname)
  (html:printf "<DT><INPUT TYPE=CHECKBOX NAME=%#a VALUE=T>\\n"
	       (make-atval pname))
  (if (and (string? doc) (not (equal? "" doc)))
      (html:printf "<DD><STRONG>%s</STRONG> (%s)\\n"
		   (make-plain name) (make-plain doc))
      (html:printf "<DD><STRONG>%s</STRONG>\\n" (make-plain name))))

(define (html:text name doc pname default)
  (cond (default
	  (html:dt-strong-doc name doc)
	  (html:printf "<DD><INPUT NAME=%#a SIZE=%d VALUE=%#a>\\n"
		       (make-atval pname)
		       (max 20 (string-length
				(if (symbol? default)
				    (symbol->string default) default)))
		       (make-atval default)))
	(else
	 (html:dt-strong-doc name doc)
	 (html:printf "<DD><INPUT NAME=%#a>\\n" (make-atval pname)))))

(define (html:text-area name doc pname default-list)
  (html:dt-strong-doc name doc)
  (html:printf "<DD><TEXTAREA NAME=%#a ROWS=%d COLS=%d>\\n"
	       (make-atval pname) (max 2 (length default-list))
	       (apply max 32 (map (lambda (d) (string-length
					       (if (symbol? d)
						   (symbol->string d)
						   d)))
				  default-list)))
  (for-each (lambda (line) (html:printf "%s\\n" (make-plain line))) default-list)
  (html:printf "</TEXTAREA>\\n"))

(define (html:s<? s1 s2)
  (if (and (number? s1) (number? s2))
      (< s1 s2)
      (string<? (if (symbol? s1) (symbol->string s1) s1)
		(if (symbol? s2) (symbol->string s2) s2))))

(define (html:select name doc pname arity default-list value-list)
  (set! value-list (sort! value-list html:s<?))
  (html:dt-strong-doc name doc)
  (html:printf "<DD><SELECT NAME=%#a SIZE=%d%s>\\n"
	       (make-atval pname)
	       (case arity
		 ((single optional) 1)
		 ((nary nary1) 5))
	       (case arity
		 ((nary nary1) " MULTIPLE")
		 (else "")))
  (for-each (lambda (value)
	      (html:printf "<OPTION VALUE=%#a%s>%s\\n"
			   (make-atval value)
			   (if (member value default-list)
			       " SELECTED" "")
			   (make-plain value)))
	    (case arity
	      ((optional nary) (cons (string->symbol "") value-list))
	      (else value-list)))
  (html:printf "</SELECT>\\n"))

(define (html:buttons name doc pname arity default-list value-list)
  (set! value-list (sort! value-list html:s<?))
  (html:dt-strong-doc name doc)
  (html:printf "<DD><MENU>")
  (case arity
    ((single optional)
     (for-each (lambda (value)
		 (html:printf
		  "<LI><INPUT TYPE=RADIO NAME=%#a VALUE=%#a%s> %s\\n"
		  (make-atval pname) (make-atval value)
		  (if (member value default-list) " CHECKED" "")
		  (make-plain value)))
	       value-list))
    ((nary nary1)
     (for-each (lambda (value)
		 (html:printf
		  "<LI><INPUT TYPE=CHECKBOX NAME=%#a VALUE=%#a%s> %s\\n"
		  (make-atval pname) (make-atval value)
		  (if (member value default-list) " CHECKED" "")
		  (make-plain value)))
	       value-list)))
  (html:printf "</MENU>"))

;;@body The symbol @1 is either @code{get}, @code{head}, @code{post},
;;@code{put}, or @code{delete}.  @0 prints the header for an HTML
;;@dfn{form}.
(define (html:start-form method action)
  (cond ((not (memq method '(get head post put delete)))
	 (slib:error 'html:start-form "method unknown:" method)))
  (html:printf "<FORM METHOD=%#a ACTION=%#a>\\n"
	       (make-atval method) (make-atval action))
  (html:printf "<DL>\\n"))

;;@body @0 prints the footer for an HTML @dfn{form}.  The string @2
;;appears on the button which submits the form.
(define (html:end-form pname submit-label)
  (html:printf "</DL>\\n")
  (html:printf "<INPUT TYPE=SUBMIT NAME=%#a VALUE=%#a> <INPUT TYPE=RESET>\\n"
	       (make-atval '*command*) (make-atval submit-label))
  (html:printf "</FORM><HR>\\n"))

(define (html:generate-form comname method action docu pnames docs aliases
			    arities types default-lists value-lists)
  (define aliast (map list pnames))
  (for-each (lambda (alias) (if (> (string-length (car alias)) 1)
				(let ((apr (assq (cadr alias) aliast)))
				  (set-cdr! apr (cons (car alias) (cdr apr))))))
	    aliases)
  (dynamic-wind
   (lambda ()
     (html:printf "<H2>%s:</H2><BLOCKQUOTE>%s</BLOCKQUOTE>\\n"
		  (make-plain comname) (make-plain docu))
     (html:start-form 'post action))
   (lambda ()
     (for-each
      (lambda (pname doc aliat arity default-list value-list)
	(define longname
	  (remove-if (lambda (s) (= 1 (string-length s))) (cdr aliat)))
	(set! longname (if (null? longname) #f (car longname)))
	(cond (longname
	       (case (length value-list)
		 ((0) (case arity
			((boolean) (html:checkbox longname doc pname 'Y))
			((single optional)
			 (html:text longname doc pname
				    (if (null? default-list)
					#f (car default-list))))
			(else
			 (html:text-area longname doc pname default-list))))
		 ((1) (html:checkbox longname doc pname (car value-list)))
		 (else ((case arity
			  ((single optional) html:select)
			  (else html:buttons))
			longname doc pname arity default-list value-list))))))
      pnames docs aliast arities default-lists value-lists))
   (lambda ()
     (html:end-form comname comname))))

;;@body The symbol @2 names a command table in the @1 relational
;;database.
;;
;;@0 writes an HTML-2.0 @dfn{form} for command @3 to the
;;current-output-port.  The @samp{SUBMIT} button, which is labeled @3,
;;invokes the URI @5 with method @4 with a hidden attribute
;;@code{*command*} bound to the command symbol submitted.
;;
;;An action may invoke a CGI script
;;(@samp{http://www.my-site.edu/cgi-bin/search.cgi}) or HTTP daemon
;;(@samp{http://www.my-site.edu:8001}).
;;
;;This example demonstrates how to create a HTML-form for the @samp{build}
;;command.
;;
;;@example
;;(require (in-vicinity (implementation-vicinity) "build.scm"))
;;(call-with-output-file "buildscm.html"
;;  (lambda (port)
;;    (fluid-let ((*html:output-port* port))
;;      (html:start-page 'commands)
;;      (command->html
;;       build '*commands* 'build 'post
;;       (or "/cgi-bin/build.cgi"
;;           "http://localhost:8081/buildscm"))
;;      html:end-page)))
;;@end example
(define (command->html rdb command-table command method action)
  (define rdb-open (rdb 'open-table))
  (define (row-refer idx) (lambda (row) (list-ref row idx)))
  (let ((comtab (rdb-open command-table #f))
	(domain->type ((rdb-open '*domains-data* #f) 'get 'type-id))
	(get-domain-choices
	 (let ((for-tab-name
		((rdb-open '*domains-data* #f) 'get 'foreign-table)))
	   (lambda (domain-name)
	     (define tab-name (for-tab-name domain-name))
	     (if tab-name
		 (do ((dlst (((rdb-open tab-name #f) 'get* 1)) (cdr dlst))
		      (out '() (if (member (car dlst) (cdr dlst))
				   out (cons (car dlst) out))))
		     ((null? dlst) out))
		 '())))))
    (define row-ref
      (let ((names (comtab 'column-names)))
	(lambda (row name) (list-ref row (position name names)))))
    (let* ((command:row ((comtab 'row:retrieve) command))
	   (parameter-table (rdb-open (row-ref command:row 'parameters) #f))
	   (pcnames (parameter-table 'column-names))
	   (param-rows (sort! ((parameter-table 'row:retrieve*))
			      (lambda (r1 r2) (< (car r1) (car r2))))))
      (let ((domains (map (row-refer (position 'domain pcnames)) param-rows))
	    (parameter-names
	     (rdb-open (row-ref command:row 'parameter-names) #f)))
	(html:generate-form
	 command
	 method
	 action
	 (row-ref command:row 'documentation)
	 (map (row-refer (position 'name pcnames)) param-rows)
	 (map (row-refer (position 'documentation pcnames)) param-rows)
	 (map list ((parameter-names 'get* 'name))
	      (map (parameter-table 'get 'name)
		   ((parameter-names 'get* 'parameter-index))))
	 (map (row-refer (position 'arity pcnames)) param-rows)
	 (map domain->type domains)
	 (map cdr (fill-empty-parameters
		   (map slib:eval
			(map (row-refer (position 'defaulter pcnames))
			     param-rows))
		   (make-parameter-list
		    (map (row-refer (position 'name pcnames)) param-rows))))
	 (map get-domain-choices domains))))))

(define (cgi:process-% str)
  (define len (string-length str))
  (define (sub str)
    (cond
     ((string-index str #\%)
      => (lambda (idx)
	   (if (and (< (+ 2 idx) len)
		    (string->number (substring str (+ 1 idx) (+ 2 idx)) 16)
		    (string->number (substring str (+ 2 idx) (+ 3 idx)) 16))
	       (string-append
		(substring str 0 idx)
		(string (integer->char
			 (string->number
			  (substring str (+ 1 idx) (+ 3 idx))
			  16)))
		(sub (substring str (+ 3 idx) (string-length str)))))))
     (else str)))
  (sub str))

(define (form:split-lines txt)
  (let ((idx (string-index txt #\newline))
	(carriage-return (integer->char #xd)))
    (if idx
	(cons (substring txt 0
			 (if (and (positive? idx)
				  (char=? carriage-return
					  (string-ref txt (+ -1 idx))))
			     (+ -1 idx)
			     idx))
	      (form:split-lines
	       (substring txt (+ 1 idx) (string-length txt))))
	(list txt))))

(define (form-urlencoded->query-alist txt)
  (if (symbol? txt) (set! txt (symbol->string txt)))
  (set! txt (string-subst txt " " "" "+" " "))
  (do ((lst '())
       (edx (string-index txt #\=)
	    (string-index txt #\=)))
      ((not edx) lst)
    (let* ((rxt (substring txt (+ 1 edx) (string-length txt)))
	   (adx (string-index rxt #\&))
	   (name (cgi:process-% (substring txt 0 edx))))
      (set!
       lst (append
	    lst
	    (map
	     (lambda (value) (list (string->symbol name)
				   (if (equal? "" value) #f value)))
	     (form:split-lines
	      (cgi:process-% (substring rxt 0 (or adx (string-length rxt))))))))
      (set! txt (if adx (substring rxt (+ 1 adx) (string-length rxt)) "")))))

(define (query-alist->parameter-list alist optnames arities types)
  (define (can-take-arg? opt)
    (not (eq? (list-ref arities (position opt optnames)) 'boolean)))
  (let ((parameter-list (make-parameter-list optnames)))
    (for-each
     (lambda (lst)
       (let* ((value (cadr lst))
	      (name (car lst)))
	 (cond ((not (can-take-arg? name))
		(adjoin-parameters! parameter-list (list name #t)))
	       (value
		(adjoin-parameters!
		 parameter-list
		 (let ((type (list-ref types (position name optnames))))
		   (case type
		     ((expression) (list name value))
		     ((symbol)
		      (if (string? value)
			  (call-with-input-string
			   value
			   (lambda (port)
			     (do ((tok (scanf-read-list " %s" port)
				       (scanf-read-list " %s" port))
				  (lst '()
				       (cons (string-ci->symbol (car tok))
					     lst)))
				 ((or (null? tok) (eof-object? tok))
				  (cons name lst)))))
			  (list name (coerce value type))))
		     (else (list name (coerce value type))))))))))
     alist)
    parameter-list))

;;@c node HTTP and CGI service, Printing Scheme, HTML Forms, Textual Conversion Packages
;;@section HTTP and CGI service

;;@code{(require 'html-form)}

;;;; Now that we have generated the HTML form, process the ensuing CGI request.

;;@body Reads a @samp{"POST"} or @samp{"GET"} query from
;;@code{(current-input-port)} and executes the encoded command from @2
;;in relational-database @1.
;;
;;This example puts up a plain-text page in response to a CGI query.
;;
;;@example
;;(display "Content-Type: text/plain") (newline) (newline)
;;(require 'html-form)
;;(load (in-vicinity (implementation-vicinity) "build.scm"))
;;(cgi:serve-command build '*commands*)
;;@end example
(define (cgi:serve-command rdb command-table)
  (serve-urlencoded-command rdb command-table (cgi:read-query-string)))

;;@body Reads attribute-value pairs from @3, converts them to
;;parameters and invokes the @1 command named by the parameter
;;@code{*command*}.
(define (serve-urlencoded-command rdb command-table urlencoded)
  (let* ((alist (form-urlencoded->query-alist urlencoded))
	 (comname #f)
	 (comtab ((rdb 'open-table) command-table #f))
	 (names (comtab 'column-names))
	 (row-ref (lambda (row name) (list-ref row (position name names))))
	 (comgetrow (comtab 'row:retrieve)))
    (set! alist (remove-if (lambda (elt)
			     (cond ((not (and (list? elt) (pair? elt)
					      (eq? '*command* (car elt)))) #f)
				   (comname
				    (slib:error
				     'serve-urlencoded-command
				     'more-than-one-command? comname
				     (string->symbol (cadr elt))))
				   (else (set! comname
					       (string-ci->symbol (cadr elt)))
					 #t)))
			   alist))
    (let* ((command:row (comgetrow comname))
	   (parameter-table ((rdb 'open-table)
			     (row-ref command:row 'parameters) #f))
	   (comval ((slib:eval (row-ref command:row 'procedure)) rdb))
	   (options ((parameter-table 'get* 'name)))
	   (positions ((parameter-table 'get* 'index)))
	   (arities ((parameter-table 'get* 'arity)))
	   (defaulters (map slib:eval ((parameter-table 'get* 'defaulter))))
	   (domains ((parameter-table 'get* 'domain)))
	   (types (map (((rdb 'open-table) '*domains-data* #f) 'get 'type-id)
		       domains))
	   (dirs (map (rdb 'domain-checker) domains)))

       (let* ((params (query-alist->parameter-list alist options arities types))
	     (fparams (fill-empty-parameters defaulters params)))
	(and (list? fparams) (check-parameters dirs fparams)
	     (comval fparams))))))

(define (serve-query-alist-command rdb command-table alist)
  (let ((command #f))
    (set! alist (remove-if (lambda (elt)
			     (cond ((not (and (list? elt) (pair? elt)
					      (eq? '*command* (car elt)))) #f)
				   (command
				    (slib:error
				     'serve-query-alist-command
				     'more-than-one-command? command
				     (string->symbol (cadr elt))))
				   (else (set! command
					       (string-ci->symbol (cadr elt)))
					 #t)))
			   alist))
    ((make-command-server rdb command-table)
     command
     (lambda (comname comval options positions
		      arities types defaulters dirs aliases)
       (let* ((params (query-alist->parameter-list alist options arities types))
	      (fparams (fill-empty-parameters defaulters params)))
	 (and (list? fparams) (check-parameters dirs fparams)
	      (apply comval
		     (parameter-list->arglist positions arities fparams))))))))

(define http:crlf (string (integer->char 13) #\newline))
(define (http:read-header port)
  (define alist '())
  (do ((line (read-line port) (read-line port)))
      ((or (zero? (string-length line))
	   (and (= 1 (string-length line))
		(char-whitespace? (string-ref line 0)))
	   (eof-object? line))
       (if (and (= 1 (string-length line))
		(char-whitespace? (string-ref line 0)))
	   (set! http:crlf (string (string-ref line 0) #\newline)))
       (if (eof-object? line) line alist))
    (let ((len (string-length line))
	  (idx (string-index line #\:)))
      (if (char-whitespace? (string-ref line (+ -1 len)))
	  (set! len (+ -1 len)))
      (and idx (do ((idx2 (+ idx 1) (+ idx2 1)))
		   ((or (>= idx2 len)
			(not (char-whitespace? (string-ref line idx2))))
		    (set! alist
			  (cons
			   (cons (string-ci->symbol (substring line 0 idx))
				 (substring line idx2 len))
			   alist)))))
      ;;Else -- ignore malformed line
      ;;(else (slib:error 'http:read-header 'malformed-input line))
      )))

(define (http:read-query-string request-line header port)
  (case (car request-line)
    ((get head)
     (let* ((request-uri (cadr request-line))
	    (len (string-length request-uri)))
       (and (> len 3)
	    (string-index request-uri #\?)
	    (substring request-uri
		       (+ 1 (string-index request-uri #\?))
		       (if (eqv? #\/ (string-ref request-uri (+ -1 len)))
			   (+ -1 len)
			   len)))))
    ((post put delete)
     (let ((content-length (assq 'content-length header)))
       (and content-length
	    (set! content-length (string->number (cdr content-length))))
       (and content-length
	    (let ((str (make-string content-length #\ )))
	      (do ((idx 0 (+ idx 1)))
		  ((>= idx content-length)
		   (if (>= idx (string-length str)) str (substring str 0 idx)))
		(let ((chr (read-char port)))
		  (if (char? chr)
		      (string-set! str idx chr)
		      (set! content-length idx))))))))
    (else #f)))

(define (http:send-status-line status-code reason)
  (html:printf "HTTP/1.1 %d %s%s" status-code reason http:crlf))
(define (http:send-header alist)
  (for-each (lambda (pair)
	      (html:printf "%s: %s%s" (car pair) (cdr pair) http:crlf))
	    alist)
  (html:printf http:crlf))

(define *http:byline*
  "<A HREF=http://swissnet.ai.mit.edu/~jaffer/SLIB.html>SLIB </A>HTTP/1.1 server")

(define (http:send-error-page code str port)
  (fluid-let ((*html:output-port* port))
    (http:send-status-line code str)
    (http:send-header '(("Content-Type" . "text/html")))
    (html:start-page (sprintf #f "%d %s" code str))
    (and *http:byline* (html:printf "<HR>\\n%s\\n" *http:byline*))
    (html:end-page)))

;;@body reads the @dfn{query-string} from @1.  If this is a valid
;;@samp{"POST"} or @samp{"GET"} query, then @0 calls @3 with two
;;arguments, the query-string and the header-alist.
;;
;;Otherwise, @0 replies (to @2) with appropriate HTML describing the
;;problem.
(define (http:serve-query input-port output-port serve-proc)
  (let ((request-line (http:read-request-line input-port)))
    (cond ((not request-line)
	   (http:send-error-page 400 "Bad Request" output-port))
	  ((string? (car request-line))
	   (http:send-error-page 501 "Not Implemented" output-port))
	  ((not (case (car request-line)
		  ((get post) #t)
		  (else #f)))
	   (http:send-error-page 405 "Method Not Allowed" output-port))
	  (else (let* ((header (http:read-header input-port))
		       (query-string
			(http:read-query-string
			 request-line header input-port)))
		  (cond ((not query-string)
			 (http:send-error-page 400 "Bad Request" output-port))
			(else (http:send-status-line 200 "OK")
			      (serve-proc query-string header))))))))

;;@ This example services HTTP queries from port 8081:
;;
;;@example
;;(define socket (make-stream-socket AF_INET 0))
;;(socket:bind socket 8081)
;;(socket:listen socket 10)
;;(dynamic-wind
;; (lambda () #f)
;; (lambda ()
;;   (do ((port (socket:accept socket)
;;              (socket:accept socket)))
;;       (#f)
;;     (dynamic-wind
;;      (lambda () #f)
;;      (lambda ()
;;        (fluid-let ((*html:output-port* port))
;;          (http:serve-query
;;           port port
;;           (lambda (query-string header)
;;             (http:send-header
;;              '(("Content-Type" . "text/plain")))
;;             (with-output-to-port port
;;               (lambda ()
;;                 (serve-urlencoded-command
;;                  build '*commands* query-string)))))))
;;      (lambda () (close-port port)))))
;; (lambda () (close-port socket)))
;;@end example

(define (http:read-start-line port)
  (do ((line (read-line port) (read-line port)))
      ((or (not (equal? "" line)) (eof-object? line)) line)))

;;@body Reads the first non-blank line from @1 and, if successful,
;;returns a list of three itmes from the request-line:
;;
;;@enumerate 0
;;
;;@item Method
;;
;;Either one of the symbols @code{options}, @code{get}, @code{head},
;;@code{post}, @code{put}, @code{delete}, or @code{trace}; Or a string.
;;
;;@item Request-URI
;;
;;A string.  At the minimum, it will be the string @samp{"/"}.
;;
;;@item HTTP-Version
;;
;;A string.  For example, @samp{HTTP/1.0}.
;;@end enumerate
(define (http:read-request-line port)
  (let ((lst (scanf-read-list "%s %s %s %s" (http:read-start-line port))))
    (and (list? lst)
	 (= 3 (length lst))
	 (let ((method
		(assoc
		 (car lst)
		 '(("OPTIONS" . options) ; Section 9.2
		   ("GET"     . get)	; Section 9.3
		   ("HEAD"    . head)	; Section 9.4
		   ("POST"    . post)	; Section 9.5
		   ("PUT"     . put)	; Section 9.6
		   ("DELETE"  . delete)	; Section 9.7
		   ("TRACE"   . trace)	; Section 9.8
		   ))))
	   (cons (if (pair? method) (cdr method) (car lst)) (cdr lst))))))

;;@body Reads the @dfn{query-string} from @code{(current-input-port)}.
;;@0 reads a @samp{"POST"} or @samp{"GET"} queries, depending on the
;;value of @code{(getenv "REQUEST_METHOD")}.
(define (cgi:read-query-string)
  (define request-method (getenv "REQUEST_METHOD"))
  (cond ((and request-method (string-ci=? "GET" request-method))
	 (getenv "QUERY_STRING"))
	((and request-method (string-ci=? "POST" request-method))
	 (let ((content-length (getenv "CONTENT_LENGTH")))
	   (and content-length
		(set! content-length (string->number content-length)))
	   (and content-length
		(let ((str (make-string content-length #\ )))
		  (do ((idx 0 (+ idx 1)))
		      ((>= idx content-length)
		       (if (>= idx (string-length str))
			   str
			   (substring str 0 idx)))
		    (let ((chr (read-char)))
		      (if (char? chr)
			  (string-set! str idx chr)
			  (set! content-length idx))))))))
	(else #f)))
