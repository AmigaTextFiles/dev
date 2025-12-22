"---------------------------------------------------------------------"
" MsgPort Class allows the User to communicate using MsgPorts, either "
" within AmigaTalk programs, or to any defined MsgPort known to Exec. "
""
"   WARNING!  WARNING!  Danger, Will Robinson!                        "
"   You had better know what size & what Message any outside System   "
"   MsgPort expects to see & respond to!                              "
"---------------------------------------------------------------------"

Class MsgPort :Object ! private portName !
[
   killPort

      <primitive 191 0 private>.

      <primitive 250 5 0 private>. "One-way ticket to death!"
      
      ^ nil
|
   addPort: msgSize priority: priority
    
      " Register the MsgPort with the AmigaOS System PortList. 
      * Use 'new: newPortName' method first! 
      "
      (<primitive 191 1 private msgSize priority> == nil)
      
        ifTrue: [ self error: 'MsgPort ', portName, ' NOT added to System!'.
                  ^ false
                ].
      ^ true
|
   getMessage
    
      " If no message ever gets sent, you'll freeze AmigaTalk!! "

      " This method has waitPort: getMsg: & replyMsg: built-in  "
      
      " Returns an array of bytes that represents the actual 
      * message, not including the operating system overhead. 
      "
      ^ <primitive 191 2 private>  
|
   sendMessage: atalkMsgPortObj msg: bytesArray
    
      " This method has putMsg: & waitPort: (wait for a reply)
      * built-in.  The reply is thrown away.
      * bytesArray has to be <= than the size given with 
      * addPort:priority:
      "
      <primitive 191 3 private atalkMsgPortObj bytesArray>
|
   selectMessagePort

      " Display a ListView of all known message Ports so that
      * the User can select a msgPortObj to send messages to.
      "
      ^ <primitive 250 0 8>
|
   sendMessageOutsideTo: systemPortObj msg: bytesArray

      " This method has putMsg:, waitPort: & getMsg: built-in. "
      " Send a message to a MsgPort outside the AmigaTalk System.
      * WARNING!  WARNING!  Danger, Will Robinson!
      * You had better know what size & what Message the port expects!
      "
      <primitive 191 7 private systemPortObj bytesArray>
|
   checkForPort

      " See if the MsgPort Object is known to the AmigaOS: "
      ^ <primitive 191 4 private> "Return either true or false."
|
   getNamedSystemPort: sysPortName

      " Return a msgPortObj that represents the System Port Name given: "
      ^ <primitive 191 5 sysPortName>
|
   getMsgPort

      " Returns this instance's msgPortObj "
      ^ <primitive 191 8 private>
|
   new: newPortName

     " Allocate & initialize a new MsgPort for AmigaTalk: "
     private  <- <primitive 191 6 newPortName>.

     portName <- newPortName.
     
     ^ self
|
   new

     " Maybe this should be: printClassUsedInError "
     super new.
     
     ^ (self new: 'Default_AmigaTalk_MPort')
]
