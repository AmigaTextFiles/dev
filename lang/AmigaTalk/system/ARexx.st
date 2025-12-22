"-----------------------------------------------------------------------"
" ARexxTags Class is a Singleton Class that gives the User access to    "
" the various Action codes that the ARexxPort Class uses in the         "
" setRMAction: method.                                                  "
""
" ALL singleton classes MUST contain the following:                     "
""
"   the methods:  isSingleton AND privateSetup     AND                  "
"                 uniqueInstance Class instance variable.               "
""
" NORMAL USAGE (Example): "
"   atags        <- ARexxTags new.                                      "
"   myActionCode <- atags arexxTag: #RXCOMM.                            "
"   myActionCode <- myActionCode + atags arexxTag: #RXFF_STRING.        "
"-----------------------------------------------------------------------"

Class ARexxTags :Dictionary ! uniqueInstance !
[
   isSingleton

     ^ true  
|  
   privateNew ! newinstance !

     newinstance <- super new.

     ^ newinstance
|
   new

     ^ (self privateSetup)
|
   arexxTag: aKey

     ^ self at: aKey
|
   privateSetup

     (uniqueInstance isNil)
       ifTrue: [uniqueInstance <- self privateNew.
  
                " The primary Action Codes: "

                self at: #RXCOMM    put: 16r01000000. " a command-level invocation "
                self at: #RXFUNC    put: 16r02000000. " a function call            "
                self at: #RXCLOSE   put: 16r03000000. " close the REXX server      "
                self at: #RXQUERY   put: 16r04000000. " query for information      "
                self at: #RXADDFH   put: 16r07000000. " add a function host        "
                self at: #RXADDLIB  put: 16r08000000. " add a function library     "
                self at: #RXREMLIB  put: 16r09000000. " remove a function library  "
                self at: #RXADDCON  put: 16r0A000000. " add/update a ClipList string "
                self at: #RXREMCON  put: 16r0B000000. " remove a ClipList string     "
                self at: #RXTCOPN   put: 16r0C000000. " open the trace console       "
                self at: #RXTCCLS   put: 16r0D000000. " close the trace console      "

                " Command modifier flag bits: "

                self at: #RXFF_NOIO    put: 16r10000.  " suppress I/O inheritance?   "
                self at: #RXFF_RESULT  put: 16r20000.  " result string expected?     "
                self at: #RXFF_STRING  put: 16r40000.  " program is a 'string file'? "
                self at: #RXFF_TOKEN   put: 16r80000.  " tokenize the command line?  "
                self at: #RXFF_NONRET  put: 16r100000. " a 'no-return' message?      "

                " Misc entries: "
                self at: #RXCODEMASK   put: 16rFF000000.
                self at: #RXARGMASK    put: 16r0000000F.

               ].
        ^ self
]

"-----------------------------------------------------------------------"
" This Class is used to create arguments for the ARexxPort Class.       "
"-----------------------------------------------------------------------"

Class ARexxArg :Object ! private myValue !
[
   new

     super error: 'Use "new: aString" to instantiate ARexxArg!'.

     ^ nil
|   
   new: aString ! length !

     length  <- aString size.
     
     myValue <- aString.

     private <- <primitive 211 3 aString length>.

     ^ self
|
   dispose

     " DO NOT use the instance after this method! "
     <primitive 211 4 private>.
     
     <primitive 250 5 0 private>.

     ^ nil
|
   length

     ^ <primitive 211 5 private>
|
   value

     ^ myValue
]

"-----------------------------------------------------------------------"
" ARexxPort Class allows the User to communicate with rexxmast,either   "
" within AmigaTalk programs, or to any defined arexxPort known to Exec. "
" The intent of this Class is only to allow communication between ARexx "
" & AmigaTalk, not full access to all the functions/commands available  "
" in ARexx.  This would result in a duplication of operations in other  "
" classes (such as file I/O), so just the methods that are necessary to "
" send & receive messages via ARexx ports is contained herein.          "
""
"   WARNING!  WARNING!  Danger, Will Robinson!                          "
"   You had better know what size & what Message any outside System     "
"   ARexxPort expects to see & respond to!                              "
""
" NOTES: "
"   1. argument is NOT the same as String Class.                       "
"-----------------------------------------------------------------------"

Class ARexxPort :Object ! private myRexxMsg portName !
[
   open: arexxPortName 

     portName  <- arexxPortName.

     private   <- <primitive 211 1 arexxPortName>.

     myRexxMsg <- <primitive 211 25 private>.
        
     ^ private  " ^ self "
|
   errorIs: errorNumber

     ^ <primitive 211 2 errorNumber>
|
   defaultExtension  

     " What is the default file extension for ARexx 
     * scripts (normally '.rexx')? 
     "
     ^ <primitive 211 6>
|
   fileExtension: newExtString

     <primitive 211 20 private newExtString>
|
   fileExtension

     ^ <primitive 211 21 private>
|
   findARexxPort: portName

     " This method returns a msgPortObj or nil on failure. "

     ^ <primitive 211 23 portName>      
|
   selectARexxPort

     " Display a ListView of all known message Ports so that
     * the User can select a msgPortObj to send messages to.
     "
     ^ <primitive 250 0 8>
|
   createRexxMsg: msgPortObj extension: extString port: newPortName

     " This method returns a rexxMsgObj or nil if there is a problem.
     * Use this method to create a message for a foreign ARexx port.
     "
     ^ <primitive 211 7 msgPortObj extString newPortName>
|     
   sendOutMessage: aString to: rexxMsgObj

     " Be sure to use 'port setRMAction: myActionCode' first!
     * Returns true if successful, false on failure.          
     "
     ^ <primitive 211 24 private rexxMsgObj aString> 
|
   disposeRexxMsg: rexxMsgObj

     " Do NOT use the rexxMsgObj after this method! " 
     <primitive 211 8 rexxMsgObj>.
     
     <primitive 250 5 0 rexxMsgObj>.
     
     ^ nil
|
   clearRexxMsg: rexxMsgObj count: c

     " Release one or more arguments from the rexxMsgObj.
     * This method is not normally needed.
     "
     <primitive 211 9 rexxMsgObj c>
|
   fillRexxMsg: rexxMsgObj count: c mask: m

     " Convert & install arguments into the rexxMsgObj.
     * The argument array must already be set to either Strings
     * or Integers.  The count argument c specifies the number
     * of fields to convert, beginning with the first one.
     * Bits 0 - 15 of the mask argument m specify whether the
     * corresponding argument is a String (bit clear) or an
     * Integer (bit set).
     * This method is not normally needed.
     "
     ^ <primitive 211 10 rexxMsgObj c m>
|      
   isRexxMsg: chkThisObject

     " Returns true or false. "
     ^ <primitive 211 11 chkThisObject>
|
   sendRexxCmd: aString

     " Be sure to use 'port setRMAction: myActionCode' first! " 
     ^ <primitive 211 12 private aString>
| 
   arrayToArgs: inputArray

     " Each element of the inputArray should be a String. 
     * This method will store the arguments away.
     * The ARexx system only has space for 16 arguments.
     " 
     (inputArray size > 16)
        ifTrue: [ 'inputArray too large for ARexxPort method!' print.
                  ^ nil ].

     <primitive 211 13 private inputArray>
|
   getRexxMsg

     ^ <primitive 211 14 private>
|
   setRMAction: actionCode

     " Normally, the actionCode should be:
     * #RXCOMM + #RXFF_STRING (See ARexxTags Class notes)
     "
     <primitive 211 15 private actionCode>
|
   getPrimaryResult

     ^ <primitive 211 16 private>
|
   getSecondaryResult

     ^ <primitive 211 17 private>
|
   setArgument: argNumber for: rexxMsgObj to: argument

     " This method is for setting the arguments for external
     * rexxMsg Objects only.  Valid range for argNumber is 
     * 1 to 16.  a Value of 1 will be overwritten by 
     * sendOutMessage:to: or by sendRexxCmd:, so just 
     * use this method for setting arguments 2 through 16 only.
     " 
     (argNumber > 1 and: [argNumber <= 16])
        ifTrue: [ <primitive 211 18 rexxMsgObj (argNumber - 1) argument> ].
     
     (argNumber <= 1)
        ifTrue: [ <primitive 211 18 rexxMsgObj 0 argument> ].

     (argNumber > 16)
        ifTrue: [ 'argNumber value out of range for setArgument:to:' print ]
|
   setArgument: argNumber to: argument

     " For setting this instance's arguments only. "
     self setArgument: argNumber for: myRexxMsg to: argument
|
   getArgument: argNumber

     (argNumber > 1 and: [argNumber <= 16])
        ifTrue: [ <primitive 211 19 private (argNumber - 1)> ].
     
     (argNumber <= 1)
        ifTrue: [ <primitive 211 19 private 0> ].

     (argNumber > 16)
        ifTrue: [ 'argNumber value out of range for getArgument:' print ]
|
   checkRexxMsg

     " NOT TESTED YET! "
     " Returns true if the message is from ARexx: "
     ^ <primitive 211 26 private>
|
   getRexxVar: varName into: resultString

     " NOT TESTED YET! "
     " Get the value of a variable from a running ARexx program. 
     * A return of zero indicates success, any other value is
     * an error indication as follows:
     *    3  means Insufficient Storage,
     *    9  means the String is too long, and
     *    10 means the Message is Invalid
     "
     ^ <primitive 211 27 private varName resultString>
|
   setRexxVar: varName with: valueString

     " NOT TESTED YET! "
     " Set the value of a variable from a running ARexx program
     * to the valueString.
     * A return of zero indicates success, any other value is
     * an error indication as follows:
     *    3  means Insufficient Storage,
     *    9  means the String is too long, and
     *    10 means the Message is Invalid
     "
     ^ <primitive 211 28 private varName valueString>
|
   portNameIs

     ^ <primitive 211 22 private>
|
   close

     <primitive 211 0 private>.

     <primitive 250 5 0 private>.
     
     myRexxMsg <- nil.     

     ^ nil
]
