(defun const-string-list (const-list)
  (mapcar #'(lambda (x) (sys::write-to-short-string x 35)) const-list))

(defun vcode (closure)
  (multiple-value-bind (req-cnt 
                        opt-cnt
                        rest-p
                        key-p
                        keyword-list
                        allow-other-keys-p
                        byte-list
                        const-list)
      (sys::signature closure)
    (let ((instructions (sys::disassemble-LAP byte-list const-list)))
      (loop for instr in instructions 
            collect
            (let ((instr-list (cdr instr)))
              (multiple-value-bind (type value index)
                  (sys::comment-values instr-list nil)
                (if value
                    (let ((new-instr-list (copy-list instr-list)))
                      (setf (nth index new-instr-list) value)
                      new-instr-list)
                    instr-list)))))))

(defun vcode-numeric (closure)
  (let ((instr-list (vcode closure)))
    (coerce 
     (loop for instr in instr-list
           collect 
           (if (consp instr)
               (cons (gethash (car instr) sys::instruction-codes)
                     (cdr instr))
               instr))
     'vector)))

(defun test (cnt)
  (loop for i from 0 below cnt collect i))