
===========================================================================
;;; $Header
;;;
;;;                             NO WARRANTY
;;;
;;; This software is distributed free of charge and is in the public domain.
;;; Anyone may use, duplicate or modify this program.  Thinking Machines
;;; Corporation does not restrict in any way the use of this software by
;;; anyone.
;;;
;;; Thinking Machines Corporation provides absolutely no warranty of any kind.
;;; The entire risk as to the quality and performance of this program is with
;;; you.  In no event will Thinking Machines Corporation be liable to you for
;;; damages, including any lost profits, lost monies, or other special,
;;; incidental or consequential damages arising out of the use of this program.
;;;
;;; 3/4/91
;;;
;;; **************************************************************************
;;; A session manager for J -mjab Fri Feb 22 16:18:30 1991
;;;
;;; INSTRUCTIONS
;;;
;;; This is a mode for interacting with J.  It is based on my earlier
;;; apl-interaction mode, but is much simpler since it doesn't have to
;;; deal with funny characters.
;;;
;;; M-x run-j or run-remote-j  will put you in the *J-interaction*
;;; window after first starting up a J.
;;;
;;; Use run-j to run on the same machine on which emacs is running.
;;; Use run-remote-j to run on another machine. (For instance, I run my
;;; emacs on a Sun 3 and run J on a remote Sun 4).
;;;
;;; If there is something you would like to have happen every time you
;;; run J, put it on the j-interaction-mode-hook in your .emacs file.
;;; For instance, you might use the hook to always copy in named cover
;;; functions via j-load-ws for all the "system commands" if you have the
;;; same trouble I do remembering arbitrary numeric arguments.
;;;
;;; j-edit-verb:
;;; meta-control-g will prompt you for the name of a J verb to edit.
;;; It brings up two small windows, one for the monadic definition and one
;;; for the dyadic definition.
;;;
;;; FUNCTIONS
;;;
;;; The following GNU EMACS functions have been given bindings which
;;; are meant to be slightly mnemonic.  They may also be called via
;;; M-x function-name.
;;;
;;; j-edit-verb:
;;; meta-control-g (remember where the Del used to be?) will prompt
;;; you for the name of a function to edit.
;;;
;;; j-edit-adverb:
;;; meta-control-a will prompt you for the name of a J adverb to edit.
;;;
;;; j-edit-conjunction:
;;; meta-control-c will prompt you for the name of a J conjunction to edit.
;;;
;;; j-edit-existing-object:
;;; meta-control-e will prompt you for the name of an object to edit.
;;; The object must already exist in the workspace so that its name class
;;; can be determined.
;;;
;;; j-send-and-fix:
;;; meta-control-x will fix the definition of the verb, adverb, or conjunction
;;; you are currently editing.  You must be in one of the J definition buffers
;;; when you invoke this command.
;;;
;;; j-load-ws:
;;; meta-control-l will load the contents of a stored workspace into the
;;; active ws without you having to remember the magic son of I-beam numbers.
;;; If there is some workspace from which you often want to copy, setq the
;;; variable j-ws-to-copy in your .emacs file.  For example:
;;; (setq j-ws-to-copy "/u/mjab/j/system-fns.jws")
;;;
;;; j-save-ws
;;; meta-control-s will save the active workspace to a file without you
;;; having to remember the right son of I-beam number.
;;;
;;; j-list-verbs
;;; meta-control-v will list the verbs from the current ws in the minibuffer.
;;;
;;; j-list-nouns
;;; meta-control-n will list the nouns from the current ws in the minibuffer.
;;;
;;; j-list operators
;;; meta-control-o will list the adverbs and conjunctions from the current ws
;;; in the minibuffer.
;;;
;;; j-execute-to-minibuffer:
;;; escape-escape will execute a J expression and print the result in the
;;; minibuffer.
;;;
;;; j-execute-to-buffer:
;;; meta-control-b will execute a J expression and place the result in the
;;; current buffer.
;;;
;;; This elisp code was written by, and may possibly be maintained by, Michael Berry:
;;;
;;; Internet:  mjab@think.com
;;; uucp:      {harvard, uunet}!think!mjab
;;; telephone: (617) 234-2056
;;;
;;; If a lot of time has passed since March, 1991, you may be able to get a
;;; more recent version of this code by anonymous FTP from think.com in the
;;; file /public/j/gmacs/j-interaction-mode.el.
;;;
;;; The J language may be obtained for an ever increasing list of computers
;;; by sending $24.00 (as of 2/91) to:
;;;
;;; Iverson Software Inc.
;;; 33 Major Street
;;; Toronto, Ontario
;;; CANADA  M5S 2K9
;;; (416) 925-6096


(require 'shell)
(provide 'j-interaction-mode)

(defvar j-interaction-mode-map nil "keymap for J interaction")
(setq j-interaction-mode-map (copy-alist shell-mode-map))
(defvar j-fned-map nil "keymap J function definition buffers")
(setq j-fned-map (copy-alist text-mode-map))

(defvar j-interaction-mode-hook nil "user supplied hook")

(define-key j-interaction-mode-map "\C-\M-e" 'j-edit-existing-object)
(define-key j-interaction-mode-map "\C-\M-g" 'j-edit-verb) ;because del is there
(define-key j-interaction-mode-map "\C-\M-a" 'j-edit-adverb)
(define-key j-interaction-mode-map "\C-\M-c" 'j-edit-conjunction)
(define-key j-interaction-mode-map "\e\e" 'j-execute-to-minibuffer)
(define-key j-interaction-mode-map "\C-\M-l" 'j-load-ws)
(define-key j-interaction-mode-map "\C-\M-s" 'j-save-ws)
(define-key j-interaction-mode-map "\C-\M-v" 'j-list-verbs)
(define-key j-interaction-mode-map "\C-\M-n" 'j-list-nouns)
(define-key j-interaction-mode-map "\C-\M-o" 'j-list-operators)

(define-key j-fned-map "\C-\M-x" 'j-send-and-fix)
(define-key j-fned-map "\C-\M-g" 'j-edit-verb) ;because del is there
(define-key j-fned-map "\C-\M-a" 'j-edit-adverb)
(define-key j-fned-map "\C-\M-c" 'j-edit-conjunction)
(define-key j-fned-map "\C-\M-e" 'j-edit-existing-object)
(define-key j-fned-map "\C-\M-v" 'j-list-verbs)
(define-key j-fned-map "\C-\M-n" 'j-list-nouns)
(define-key j-fned-map "\C-\M-o" 'j-list-operators)
(define-key j-fned-map "\e\e" 'j-execute-to-minibuffer)
(define-key j-fned-map "\C-\M-b" 'j-execute-to-buffer)

;;; The following defvars should be customized to your site.
;;; Users may overide the defvar settings via setq in their .emacs files.

(defvar j-startup-command "/public/j/sun4/j" "*Command to start up a J session")

(defvar j-wait 9 "*How many seconds to wait before giving up on a response from J")

(defvar last-remote-j-host "godot" "Machine on which to run remote J sessions")

(defvar j-ws-to-copy "/public/j/ws/system.jws" "*Default ws to copy")

(defvar j-last-saved-ws "foo.jws" "Most recently saved workspace")

(defun run-j ()
  "Run an inferior J process, input and output via buffer *J-interaction*"
  (interactive)
  (switch-to-buffer (make-shell "J-interaction"  "/bin/sh"))
  (setq j-startup-command (read-string "J executable to use: " j-startup-command))
  (shell-send-input)
  (wait-for-response 3)
  (insert j-startup-command)
  (shell-send-input)
  (j-wait-for-prompt)
  (setq shell-prompt-pattern (regexp-quote "   "))
  (j-interaction-mode))

(defun run-remote-j ()
  "Run an inferior J process on another host"
  (interactive)
  (setq last-remote-j-host (read-string "Host? " last-remote-j-host))
  (setq j-startup-command (read-string "J executable to use: " j-startup-command))

  ;; The followind doesn't seem to work. Hence all the rlogin mess.
  ;(switch-to-buffer (make-shell
  ;                  "J-interaction"
  ;                  "/usr/ucb/rsh"
  ;                  nil
  ;                  last-remote-j-host j-startup-command))

  (set-buffer (make-shell "J-interaction" nil))
  (wait-for-response 5)
  (insert (concat "rlogin " last-remote-j-host))
  (shell-send-input)
  (wait-for-response 5)
  (shell-send-input)     ;in case remote host prompts for something
  (wait-for-response 5)
  (shell-send-input)     ;in case remote host prompts for something
  (wait-for-response 5)
  (shell-send-input)     ;in case remote host prompts for something
  (wait-for-response 5)
  (insert "stty nl -echo")
  (shell-send-input)
  (wait-for-response 5)
  (insert "setenv TERM emacs")
  (shell-send-input)
  (wait-for-response 5)
  (delete-region (point-min) (point))
  (switch-to-buffer (current-buffer))
  (insert j-startup-command)
  (shell-send-input)
  (wait-for-response 5)
  (j-wait-for-prompt)
  (setq shell-prompt-pattern (regexp-quote "   "))
  (j-interaction-mode))


(defun j-interaction-mode ()
  "Mode for interacting with J from within Emacs."
  (interactive)
  (setq major-mode 'J-interaction-mode)
  (setq mode-name "J-interaction")
  (use-local-map j-interaction-mode-map)
  (setq shell-prompt-pattern (regexp-quote "   "))
  (message "J interaction mode")
  (run-hooks 'j-interaction-mode-hook))

(defun j-quietly-execute (s)
  "run over to the J interaction window and do something sneaky"
  (interactive "sJ expression: ")
  (set-buffer "*J-interaction*")
  (let ((old-end (point-max))
        (j-output-start)
        (i 0)
        (j-result))
    (save-excursion
      (goto-char old-end)
      (insert s ?\n)
      (setq j-output-start (point-max))
      (let ((process (get-buffer-process "*J-interaction*")))
        (process-send-region-carefully process old-end j-output-start)
        (set-marker (process-mark process) (point)))
      (while (and (= j-output-start (point-max)) (< i j-wait)) ;at left margin
        (setq i (+ 1 i))
        (sleep-for 1))                  ;Wait for J to respond
      (if (= j-output-start (point-max))
          (progn
            (message "%s" "J is not responding.")
            nil)
        (j-wait-for-prompt)                     ;give J a chance to finish writing
        (skip-chars-backward " \n")     ;can't use this if trailing blanks and newlines are expected
        (setq j-result (buffer-substring j-output-start (point)))
        (delete-region old-end (point-max))
        (values j-result)))))

(defun j-execute-to-minibuffer (s)
  "execute J expression placing result in minibuffer"
  (interactive "sJ expression: ")
  (princ (j-quietly-execute s)))

(defun j-execute-to-buffer (s)
  "execute J expression placing result in current buffer"
  (interactive "sJ expression: ")
  (let*((buffer (buffer-name))
        (result (j-quietly-execute s)))
    (set-buffer buffer)
    (insert result)))

(defun j-edit-verb (fn)
  "Edit a verb in two buffers -- one for the mondad, one for the dyad"
  (interactive "sFunction Name: ")
  (let ((monad-buffer (concat fn "-monad.j"))
        (dyad-buffer (concat fn "-dyad.j"))
        (monad)
        (dyad)
        (nc))
    (setq nc (j-quietly-execute (concat "4!:0 <'" fn "'")))
    (cond ((equal nc "0")
           (message (concat fn " is not currently defined in the active workspace"))
           (get-buffer-create monad-buffer)
           (get-buffer-create dyad-buffer)
           (pop-to-buffer dyad-buffer)
           (use-local-map j-fned-map)
           (pop-to-buffer monad-buffer)
           (use-local-map j-fned-map))
          ((equal nc "3")
           (message (concat "redefining " fn))
           (setq monad (j-quietly-execute (concat  ">0{ 5!:2 <'" fn "'")))
           (setq dyad (j-quietly-execute (concat  ">2{ 5!:2 <'" fn "'")))
           (get-buffer-create monad-buffer)
           (get-buffer-create dyad-buffer)
           (pop-to-buffer dyad-buffer)
           (delete-region (point-min) (point-max))
           (insert dyad)
           (skip-chars-backward " ")
           (use-local-map j-fned-map)
           (pop-to-buffer monad-buffer)
           (delete-region (point-min) (point-max))
           (insert monad)
           (skip-chars-backward " ")
           (use-local-map j-fned-map))
          (t
            (error "%s is not a verb.  It has name class %s." fn nc)))))

(defun j-edit-adverb (fn)
  "Edit an adverb (monadic operator)"
  (interactive "sAdverb Name: ")
  (let ((adverb-buffer (concat fn "-adverb.j"))
        (monad)
        (nc))
    (setq nc (j-quietly-execute (concat "4!:0 <'" fn "'")))
    (cond ((equal nc "0")
           (message (concat fn " is not currently defined in the active workspace"))
           (get-buffer-create adverb-buffer)
           (pop-to-buffer adverb-buffer)
           (use-local-map j-fned-map))
          ((equal nc "4")
           (message (concat "redefining " fn))
           (setq monad (j-quietly-execute (concat  ">2{ 5!:2 <'" fn "'")))
           (get-buffer-create adverb-buffer)
           (pop-to-buffer adverb-buffer)
           (delete-region (point-min) (point-max))
           (insert monad)
           (skip-chars-backward " ")
           (use-local-map j-fned-map))
          (t
            (error "%s is not an adverb.  It has name class %s." fn nc)))))

(defun j-edit-conjunction (fn)
  "Edit a conjunction (dyadic operator)"
  (interactive "sConjunction Name: ")
  (let ((conjunction-buffer (concat fn "-conjunction.j"))
        (monad)
        (nc))
    (setq nc (j-quietly-execute (concat "4!:0 <'" fn "'")))
    (cond ((equal nc "0")
           (message (concat fn " is not currently defined in the active workspace"))
           (get-buffer-create conjunction-buffer)
           (pop-to-buffer conjunction-buffer)
           (use-local-map j-fned-map))
          ((equal nc "5")
           (message (concat "redefining " fn))
           (setq monad (j-quietly-execute (concat  ">2{ 5!:2 <'" fn "'")))
           (get-buffer-create conjunction-buffer)
           (pop-to-buffer conjunction-buffer)
           (delete-region (point-min) (point-max))
           (insert monad)
           (skip-chars-backward " ")
           (use-local-map j-fned-map))
          (t
            (error "%s is not a conjunction.  It has name class %s." fn nc)))))

(defun j-send-and-fix-verb()
  "send the contents of the current buffer and its mate to define a verb"
  (interactive)
  (let ((m-string)
        (d-string)
        (verb)
        (msg)
        (j-output)
        (j-input))
    (save-excursion
      (cond ((string= "dyad.j" (substring (buffer-name) -6 nil)) ;in the dyad buffer
             (setq verb (substring (buffer-name) 0 -7)))
            ((string= "monad.j" (substring (buffer-name) -7 nil)) ;in the monad buffer
             (setq verb (substring (buffer-name) 0 -8)))
            (t
              (error "%s does not appear to be a J verb definition buffer"
(buffer-name))))
      (setq m-string (trim-buffer-string (concat verb "-monad.j")))
      (setq d-string (trim-buffer-string (concat verb "-dyad.j")))
      (setq m-string (mapconcat (function (lambda (char) (format "%d" char))) m-string " ")) ;av indices
      (setq d-string (mapconcat (function (lambda (char) (format "%d" char))) d-string " ")) ;av indices
      (setq j-input  (concat "((<;._1) 10 "
                             m-string
                             "{a.) :: ((<;._1) 10 "
                             d-string
                             "{a.)"))
      (setq j-output (j-quietly-execute (concat verb "=. " j-input)))
      (setq msg  (concat "***** new definition of " verb " from emacs at "
                         (current-time-string) ": "
                         (if (string= "\n" j-output)  "succesful" j-output)))
      (message " %s" msg)
      (insert-before-markers msg ?\n)
      (shell-send-input))))

(defun j-send-and-fix-operator()
  "send the contents of the current buffer to define an adverb or conjunction"
  (interactive)
  (let ((def-string)
        (operator)
        (nc)
        (msg)
        (j-output)
        (j-input))
    (save-excursion
      (cond ((string= "adverb.j" (substring (buffer-name) -8 nil)) ;in an adverb buffer
             (setq nc "1 ")
             (setq operator (substring (buffer-name) 0 -9)))
            ((string= "conjunction.j" (substring (buffer-name) -13 nil)) ;in a conjunction buffer
             (setq nc "2 ")
             (setq operator (substring (buffer-name) 0 -14)))
            (t
              (error "%s does not appear to be a J operator definition buffer"
(buffer-name))))
      (setq def-string (trim-buffer-string (current-buffer)))
      (setq def-string (mapconcat (function (lambda (char) (format "%d" char))) def-string " ")) ;av indices
      (setq j-input  (concat nc
                             " :: ((<;._1) 10 "
                             def-string
                             "{a.)"))
      (setq j-output (j-quietly-execute (concat operator "=. " j-input)))
      (setq msg  (concat "***** new definition of " operator " from emacs at "
                         (current-time-string) ": "
                         (if (string= "\n" j-output)  "succesful" j-output)))
      (message " %s" msg)
      (insert-before-markers msg ?\n)
      (shell-send-input))))

(defun trim-buffer-string (buf)
  (save-excursion
    (let ((start))
      (set-buffer buf)
      (goto-char (point-min))
      (skip-chars-forward " \n\t\v\f\r\b")
      (setq start (point))
      (goto-char (point-max))
      (skip-chars-backward " \n\t\v\f\r\b" start)
      (buffer-substring start (point)))))

(defun j-wait-for-prompt ()
  "wait until the J prompt appears or j-wait seconds whichever comes first"
  (set-buffer "*J-interaction*")
  (let ((prompt "\n   ")
        (i 0))
    (while (< i j-wait)
      (if (equal prompt (buffer-substring (max (point-min) (- (point-max) 4))
(point-max)))
          (setq i j-wait)
        (message "waiting for a sign of life from J")
        (sleep-for 1)
        (setq i (+ 1 i))))))

(defun wait-for-response (limit)
  "wait until the buffer changes size, or the limit is reached"
  (let ((max (point-max))
        (count 0))
    (message "waiting for a response")
    (while (and (= max (point-max)) (< count limit))
      (setq count (1+ count))
      (sleep-for 1))
    (message "waiting for response to finish")
    (setq max (point-max))
    (sleep-for 1)
    (while (< max (point-max))
      (sleep-for 1)
      (setq max (point-max)))))

(defun j-load-ws (ws)
  "copy contents of saved ws into active ws"
  (interactive (list (read-string "Copy workspace: " j-ws-to-copy)))
  (let ((response))
    (setq  j-ws-to-copy ws)
    (setq response (j-quietly-execute (concat "2!:4 <'" ws "'")))
    (message (if (string= "1" response) "copy succeded" response))))

(defun j-save-ws (ws)
  "save contents of the active ws to a file"
  (interactive (list (read-string "Save in: " j-last-saved-ws)))
  (let ((response)
        (msg))
    (setq  j-last-saved-ws ws)
    (setq response (j-quietly-execute (concat "2!:2 <'" ws "'")))
    (setq msg (if (string= "1" response)
                  (concat "***** " ws " saved " (current-time-string)
                          response)))
    (insert-before-markers msg ?\n)
    (shell-send-input)
    (message  msg)))

(defun j-send-and-fix ()
  "send and fix the j object being edited"
  (interactive)
  (cond ((not (string= ".j" (substring (buffer-name) -2 nil)))
         (error "%s is not a J definition buffer" (buffer-name)))
        ((string= "-dyad.j" (substring (buffer-name) -7 nil))
         (message "sending definition as verb")
         (j-send-and-fix-verb))
        ((string= "-monad.j" (substring (buffer-name) -8 nil))
         (message "sending definition as verb")
         (j-send-and-fix-verb))
        ((string= "-adverb.j" (substring (buffer-name) -9 nil))
         (message "sending definition as adverb")
        (j-send-and-fix-operator))
        ((string= "-conjunction.j" (substring (buffer-name) -14 nil))
         (message "sending definition as conjunction")
         (j-send-and-fix-operator))
        (t
          (error "%s is not a J definition buffer" (buffer-name)))))

(defun j-edit-existing-object (name)
    "edit an existing object in the J workspace"
  (interactive "sName of object: ")
  (let ((nc))
    (setq nc (j-quietly-execute (concat "4!:0 <'" name "'")))
    (cond ((string= nc "0")
           (error "use j-edit-verb, j-edit-adverb, or  j-edit-conjunction to edit a new object"))
          ((string= nc "2")
           (error "Alas, noun editing is not yet available"))
          ((string= nc "3")
           (j-edit-verb name))
          ((string= nc "4")
           (j-edit-adverb name))
          ((string= nc "5")
           (j-edit-conjunction))
          (t
            (error "unable to determine name class of %s. 4!:0 returned %s" name nc)))))


(defun j-list-verbs ()
  "list user defined verbs"
  (interactive)
  (j-execute-to-minibuffer ",' ',\"1 >4!:1 (3)"))

(defun j-list-nouns ()
  "list user defined nouns"
  (interactive)
  (j-execute-to-minibuffer ",' ',\"1 >4!:1 (2)"))

(defun j-list-operators()
  "list user defined adverbs and conjunctions"
  (interactive)
  (j-execute-to-minibuffer ",' ',\"1 >4!:1 (4 5)"))


;;; These are stolen from shell-hist.el in the TMC hacks.  I don't know why
;;; it works, but it seems to.  Without this, J was being sent lines which
;;; were too long for it.  This resulted in it getting in a state where it
;;; said nothing but cntrl-g  -mjab Wed Mar 20 17:17:20 1991

(defconst process-send-region-carefully-limit 250
  "Maximum line size for process-send-region-carefully;
   it tries to break them up using Control-D beyond this limit.")

(defun process-send-region-carefully (process start end)
  "Send current contents of region as input to PROCESS, respecting 255-char buffer.
   The arguments are the same as process-send-region:
   PROCESS may be a process name. START and END are the region."
  (if (< end start) (setq end (prog1 start (setq start end))))
  (let (flag
        (limit (max 10 process-send-region-carefully-limit)))
  (save-excursion
    (goto-char start)
    (while (< start end)
      ;; Here, start=point.
      (beginning-of-line 2)
      (and (> (point) end) (goto-char end))
      (setq flag
            (if (< (- (point) start) limit)
                nil
              (goto-char (min end (+ start limit)))
              t))
      (process-send-region process start (point))
      (and flag (process-send-eof process))
      (setq start (point))))))

 