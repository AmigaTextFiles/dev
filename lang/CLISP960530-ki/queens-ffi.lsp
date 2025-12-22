(in-package "FFI-DEMOS")
(use-package "FFI")

(def-call-out queens
  (:name "queens")
  (:arguments (num uint16))
  (:return-type uint32))
