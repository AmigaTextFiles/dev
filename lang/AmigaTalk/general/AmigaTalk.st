"--------------------------------------------------------------------"
" AmigaTalk Class is now a Singleton class.                          "
""
" HISTORY "
"    03-Nov-2003 - Reinstated the amigatalk pseuod-variable.         "
"    31-Oct-2003 - Added two methods to Set/Clear searching of the   "
"                  internal memory lists for free slots.  The Clear  "
"                  method will speed up code execution for large     "
"                  instantiations, such as the Intuition Class.      "
"    03-Oct-2003 - Added two new methods to add & remove User        "
"                  Script menu items for the main AmigaTalk command  "
"                  window (only!)                                    "
"    03-Feb-2003 - Added a new instance variable for controlling the "
"                  trace filing ability of AmigaTalk & three methods "
"                  for using it (traceState, tracingOn & tracingOff)."
""
" NOTES "
"     ALL singleton classes MUST contain the following:              "
""
"     the methods:  isSingleton AND privateSetup     AND             "
"                   uniqueInstance Class instance variable.          "
"--------------------------------------------------------------------"

Class AmigaTalk :Dictionary
! uniqueInstance atMsg wTitle globalDict traceControl !
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
   privateSetup
     (uniqueInstance isNil)
       ifTrue: [uniqueInstance <- self privateNew.
                globalDict     <- Dictionary new.
                traceControl   <- false. " Turn off tracing paradigm by default "
               ].

     ^ self
|
   getByteCodeArrayFrom: aClass for: aMethodString
      ^ <primitive 159 aClass aMethodString>
|
   traceState
      " Returns true if tracing ability is enabled, false if not. "
      ^ (traceControl ~= false)
|
   tracingOn
      " WARNING:  This method only enables tracing output, 
      * it does NOT open the tracing file.  Only the Trace
      * menu Item will do so.
      "
      traceControl <- true.
      tracingon
|
   tracingOff
      " WARNING:  This method only disables tracing output, 
      * it does NOT close the tracing file.  Only the Trace
      * menu Item will do so.
      "
      traceControl <- false.
      tracingoff
|
   turnOffSearch
      <primitive 186 12 0>
|
   turnOnSearch
      <primitive 186 12 1>
|
   searchState
      ^ <primitive 186 11>
|
   printString
      ^ <primitive 152 (self class)>   "Over-ride parent method"
|   
   clearScreen
      <primitive 162>  "For Curses & Plot3 only."
|
   globalDictionary
      ^ globalDict
|
   addGlobal: newGlobal key: newKey
      ^ (super at: newKey put: newGlobal)
|
   date
      ^ <primitive 160 >
|
   debug: n
      ^ <primitive 8 2 n>
|
   display
      ^ <primitive 8 1 1>
|
   displayAssign
      ^ <primitive 8 1 2>
|
   doPrimitive: primNumber withArguments: argArray
      ^ <primitive 30 primNumber argArray>
|
   noDisplay
      ^ <primitive 8 1 0>
|
   sh: command
      ^ <primitive 125 command >
|
   time: aBlock      ! start !
      start <- <primitive 161>.   "This is NOT very accurate!"
      aBlock value.
      ^ <primitive 161> - start
|
   getProcessAddress: procName
      ^ <primitive 250 0 0 procName>
|
   getTaskAddress: taskName
      ^ <primitive 250 0 1 taskName>
|
   getScreenAddress: screenName
      ^ <primitive 250 0 2 screenName>
|
   getWindowAddress: windowName
      ^ <primitive 250 0 3 windowName>
|
   getStringAddress: aString
      ^ <primitive 250 3 1 aString>    "NOT Kosher smalltalk!"
|
   getIntegerAddress: anInteger
      ^ <primitive 250 3 0 anInteger>  "NOT Kosher smalltalk!"
|
   getByteArrayAddress: aByteArray
      ^ <primitive 250 3 2 aByteArray> "NOT Kosher smalltalk!"
|
   getTaskAddressList ! array !
      ^ array <- <primitive 250 2 1>
|
   getProcessAddressList ! array!
      ^ array <- <primitive 250 2 0>
|
   getScreenAddressList ! array !
      ^ array <- <primitive 250 2 2> "return an Array of Screen addresses."
|
   getWindowAddressList ! array !
      ^ array <- <primitive 250 2 3> "return an Array of Window addresses."
|
   showTaskProcessList
      ^ <primitive 250 1 4>
|
   showScreenWindowList
      ^ <primitive 250 1 5>
|
   displayProcessInfo: procAddress
      ^ <primitive 250 1 0 procAddress>
|
   displayTaskInfo: taskAddress
      ^ <primitive 250 1 1 taskAddress>
|
   displayScreenInfo: screenAddress
      ^ <primitive 250 1 2 screenAddress>
|
   displayWindowInfo: windowAddress
      ^ <primitive 250 1 3 windowAddress>
|
   setIOMessage: newMessage
      atMsg <- newMessage.
|
   setIOTitle: newTitle
      wTitle <- newTitle.
|
   getUserResponse: questionString ! window !
      
      window <- self activeWindow.

      ^ window yesNoReq: questionString title: wTitle
|
   informUser: informationString ! window !
      
      window <- self activeWindow.

      ^ window infoReq: informationString title: wTitle
|
   newIO: msgString title: title
      self setIOMessage: msgString.
      self setIOTitle: title.
|
   setIODirectory: newDirectory
      atMsg <- newDirectory.
|
   setIOScreenName: newScreenName
      atMsg <- newScreenName.
|
   getString
      ^ <primitive 186 0 atMsg wTitle>  "Return a String from the User."
|
   getInteger
      ^ <primitive 186 1 atMsg wTitle>  "Return an Integer from the User."
|
   getFileName
      ^ <primitive 186 5 atMsg wTitle>  "Get a filename from ASL."
|
   getScreenModeID        "atMsg is the Screen title for this method"
      ^ <primitive 186 6 atMsg wTitle>  "Get a ScreenModeID from ASL."
|
   displayFile: fileName
      <primitive 186 2 fileName>
|      
   displayString: string
      <primitive 186 3 string atMsg wTitle>
|
   displayInteger: integer
      <primitive 186 4 integer atMsg wTitle>
|
   listClassDictionaryTo: fileName indent: numSpaces
      ^ <primitive 137 0 0 fileName numSpaces>  
|
   listClassesOf: classObj to: fileName indent: numSpaces
      ^ <primitive 137 0 1 classObj fileName numSpaces>  
|
   fileInPrimitiveFile: fileName
      " Primitive files end with .p (NOT enforced) 
      * & represent parsed Class source code 
      "
      <primitive 138 0 0 fileName>
|
   activeScreen
      " Returns a Screen Object: "
      ^ <primitive 186 7>
|
   activeWindow
      " Returns a Window Object or nil: "
      ^ <primitive 186 8>
|
   addUserScript: scriptMenuName toCall: scriptFileName
      ^ <primitive 186 9 scriptMenuName scriptFileName>
|
   removeUserScript: scriptMenuName
      <primitive 186 10 scriptMenuName>
|
   systemPrivate
      <primitive 137 0 2 'AmigaTalk:Browser/GeneralClasses' 'AmigaTalk:General' 0>.
      <primitive 137 0 3 'AmigaTalk:Browser/GeneralClassInstanceVars' 'AmigaTalk:General'>.

      <primitive 137 0 2 'AmigaTalk:Browser/IntuitionClasses' 'AmigaTalk:Intuition' 0>.
      <primitive 137 0 3 'AmigaTalk:Browser/IntuitionClassInstanceVars' 'AmigaTalk:Intuition'>.

      <primitive 137 0 2 'AmigaTalk:Browser/SystemClasses' 'AmigaTalk:System' 0>.
      <primitive 137 0 3 'AmigaTalk:Browser/SystemClassInstanceVars' 'AmigaTalk:System'>
|
   updateUserBrowserFiles
      <primitive 137 0 2 'AmigaTalk:Browser/UserClasses' 'AmigaTalk:User' 0>.
      <primitive 137 0 3 'AmigaTalk:Browser/UserClassInstanceVars' 'AmigaTalk:User'>
]
