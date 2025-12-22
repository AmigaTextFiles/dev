
;;; J script editing mode for Emacs
;;; Copyright (C) 1991 Free Software Foundation, Inc.
;;; This version 27 July 1991
;;; by Raul D Rockwell <deluth@gnu.ai.mit.edu>
;;;
;;; This file is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to the
;;; Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;;;
;;; ----------------------------------------------------------------
;;;
;;; You may want to add the following to your .emacs file:
;;;
;;; (autoload 'j-mode "j-mode" "major mode for editting j scripts" t)
;;;or
;;; (autoload 'j-mode (expand-file-name "~/j-mode")
;;;          "major mode for editting j scripts" t)
;;;or some other statement indicating to emacs where and when to find
;;;this file.
;;;
;;;also, to automatically use this mode:
;;; (or (assoc "\\.js$" auto-mode-alist)
;;;     (setq auto-mode-alist (cons '("\\.js$" . j-mode) auto-mode-alist)))
;;;
;;;and, to not be bothered by workspaces names similar to scripts':
;;; (or (memq ".jws" completion-ignored-extensions)
;;;     (setq completion-ignored-extensions
;;;           (cons ".jws" completion-ignored-extensions)))
;;;

(defvar j-mode-syntax-table
  (let ((tbl (make-syntax-table)))
    (mapcar
     '(lambda (x) (modify-syntax-entry x "_   " tbl))
     '(?! ?" ?# ?$ ?% ?, ?; ?? ?@ ?[ ?\\ ?] ?^ ?` ?{ ?} ?~))
;; these are symbols: ! " # $ , ; ? @ [ \ ] ^ ` { } ~
    (modify-syntax-entry ?' "\"   " tbl) ;  ' is a quote character
    (modify-syntax-entry ?: ".   "  tbl) ;  : is punctuation
    (modify-syntax-entry ?_ "w   "  tbl) ;  _ is a part of a word
    tbl)
  "Syntax table for editting j scripts")

(defvar j-mode-abbrev-table nil
  "abbreviations for use with j go here")
(define-abbrev-table 'j-mode-abbrev-table nil)

(defvar j-mode-map nil
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-?" 'backward-delete-char-untabify)
;; we don't have defun's in j, so recognize copulae instead:
    (define-key map "\M-\C-a" 'beginning-of-copula)
    (define-key map "\M-\C-e" 'end-of-copula)
    (define-key map "\M-\C-h" 'mark-copula))
  "see (j-mode) for more info")

(defun j-mode ()
  "Major mode for editing J scripts
Turning on j-mode calls the value of the variable j-mode-hook,
if that value is non-nil.

Special commands: \\{j-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (use-local-map j-mode-map)
  (mapcar '(lambda (x) (make-local-variable x))
          '(sentence-end
            comment-start comment-end comment-start-skip
            indent-line-function paragraph-ignore-fill-prefix))
  (setq mode-name "j"
        major-mode 'j-mode
        local-abbrev-table j-mode-abbrev-table
        comment-start "]'"
        comment-end "'"
        comment-start-skip "]\\s *'\\s *"
        indent-line-function 'indent-relative
        paragraph-ignore-fill-prefix t
        sentence-end "$")
  (set-syntax-table j-mode-syntax-table)
  (run-hooks 'j-mode-hook))

(defun beginning-of-copula (&optional arg)
  "Move backward to next beginning-of-copula (assignment statement)
With positive argument, move backwards from point that many times
With no argument, locate copula from end of current statement
With negative argument, move forward from point that many times.

Note that this command will not move into or out of a level of parenthesis.

Use \\[beginning of line] to move to the beginning of the current line."
  (interactive "p")
  (cond ((or (not arg) (= 0 arg)) (end-of-copula) (beginning-of-copula 1))
        ((< 0 arg) (while (<= 0 (setq arg (- arg 1)))
                     (and (re-search-backward "=:\\]=\\." nil 'move 1)
                          (backward-sexp)))
                   (while (not (looking-at "[('0-9A-Za-z]"))
                     (forward-char)))
        ((> 0 arg) (while (<= 0 (setq arg (- arg 1)))
                     (and (re-search-forward "=:\\]=\\." nil 'move 1)
                          (end-of-copula))))))

(defun end-of-copula ()
  "Move forward to the end of copula.
This is either an unmatched closing parenthesis or the end of this line."
  (interactive)
  (while (not (looking-at "\\s *\\()\\]\n\\]'\\(''\\][^\n']\\)*\n\\)"))
    (forward-sexp)))

(defun mark-copula (&optional arg)
  "Put mark at beginning of copula, point at end."
  (interactive "p")
  (push-mark (point))
  (end-of-copula)
  (push-mark (point))
  (beginning-of-copula (or arg 1)))

 