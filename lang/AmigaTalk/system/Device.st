"---------------------------------------------------------------------"
" Device Class is an abstract class.  Derived classes use its methods "
" to talk to the Amiga OS. "
"---------------------------------------------------------------------"

Class Device :Object
[
  initialize: initString
   super subClassResponsibility: 'initialize: initString'.
   ^ nil
|   
  clear
   super notImplemented: 'clear'.
   ^ nil
|
  flush: devName
   super subClassResponsibility: 'flush: devName'.
   ^ nil
|
  invalid
   super notImplemented: 'invalid'.
   ^ nil
|
  read: devName
   super notImplemented: 'read: devName'.
   ^ nil
|
  reset: devName
   super subClassResponsibility: 'reset: devName'.
   ^ nil
|
  query
   super subClassResponsibility: 'query'.
   ^ nil
|
  stop
   super notImplemented: 'stop'.
   ^ nil
|
  start
   super notImplemented: 'start'.
   ^ nil
|
  update
   super notImplemented: 'update'.
   ^ nil
|
  getDeviceAddressList
   ^ <primitive 250 2 4>  "Return an Array of Device Addresses."
|
  write: devName this: string
    super subClassResponsibility: 'write: devName this: string'.
    ^ nil
]
