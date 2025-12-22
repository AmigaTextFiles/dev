#-FFI(error "Foreign Function Interface (FFI) no available")

(in-package "FFI-DEMOS")
(use-package "FFI")

(def-c-struct node
  (ln-Succ uint32)
  (ln-Pred uint32)
  (ln-Type uint8)
  (ln-Pri  sint8)
  (ln-Name c-string))

(def-c-struct task
  (tc_Node  node)
  (tc_Flags     uint8)
  (tc_State     uint8)
  (tc_IDNestCnt sint8)
  (tc_TDNestCnt sint8)
  (tc_SigAlloc  uint32)
  (tc_SigWait   uint32)
  (tc_SigRevd   uint32)
  (tc_SigExcept uint32)
  (tc_TrapAlloc uint16)
  (tc_TrapAble  uint16)
  (tc_ExceptData uint32)
  (tc_ExceptCode c-pointer)
  (tc_TrapData   uint32)
  (tc_TrapCode   c-pointer)
  (tc_SPReg      uint32)
  (tc_SPLower    uint32)
  (tc_SPUpper    uint32)
  (tc_Switch     uint32) ; function
  (tc_Launch     uint32) ; function
 ;(tc_Mementry   list)   ; not defined here
 ;(tc_UserData   uint32)
)


(def-lib-call-out FindTask-pointer "exec.library"
  (:name "FindTask")
  (:offset -294)
  (:arguments
   (name    c-string :in :alloca :a1))
  (:return-type c-pointer :none))
(def-lib-call-out FindTask-ptr "exec.library"
  (:name "FindTask")
  (:offset -294)
  (:arguments
   (name    c-string :in :alloca :a1))
  (:return-type (c-ptr-null task) :none))
(def-lib-call-out FindTask-int "exec.library"
  (:name "FindTask")
  (:offset -294)
  (:arguments
   (name    c-string :in :alloca :a1))
  (:return-type uint32 :none))

;; a FOREIGN-ADDRESS can only be tested for NULL with EQUALP against a known
;; NULL address. Where to get this first one?

#|
(FindTask-pointer "ramlib")
(FindTask-pointer nil)
(ffi::foreign-address-variable "task" * 0 (ffi::parse-c-type 'task))
(ffi::foreign-value *)
|#
