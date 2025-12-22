"-----------------------------------------------------------------"
" Object Class is the Root of all other Classes in AmigaTalk.     "
" The perform: methods are NOT part of the original Little        "
" Smalltalk code.  They might be moved sometime in the future.    "
"                                                                 "
" HISTORY                                                         "
"    07-Oct-2003 - Added the instVarAt: & instVarAt:put: methods, "
"                  which are only used in the ?? Class.           "
"                                                                 "
"-----------------------------------------------------------------"

Class Object
[
   instVarAt: index

      " Answer with a fixed variable in an object.  The numbering 
      * of the variables corresponds to the named instance variables.  
      * Fail if the index is not an Integer or is not the index 
      * of a fixed variable.
      "
      ^ <primitive 95 0 index self>
|
   instVarAt: anInteger put: anObject

      " Store a value into a fixed variable in the receiver.  
      * The numbering of the variables corresponds to the named 
      * instance variables.  Fail if the index is not an Integer or 
      * is not the index of a fixed variable.
      * Answer with the value stored as the result.  (Using this
      * message violates the principle that each object has 
      * sovereign control over the storing of values into its 
      * instance variables)
      "
      ^ <primitive 95 1 anInteger anObject self>
|
    identityHash                 " Added on 02-Apr-2002 "   

      ^ <primitive 5 self>
|       
    == anObject

      ^ <primitive 7 self anObject >
|
    ~~ x

      ^ (self == x) not
|
    = x

      ^ (self == x)              "Is the receiver equal to x??"
|
    ~= x

      ^ (self = x) not           "Is the receiver NOT equal to x??"
|
    asString

      ^ <primitive 152 (self class)> "Avoid recursion!"
      "^ self class printString" "<<--Infinite recursive method."
|
    asSymbol

      ^ self asString asSymbol   "Return the class a Symbol."
|
    yourself                     "Synonym for self."

      ^ self
|
    class

      ^ <primitive 1 self>
|
    copy

      ^ self shallowCopy postCopy
|
    asValue                                      " Added on 07-Oct-2003 "  

      " Return a ValueHolder on the receiver: "

      ^ ValueHolder with: self
|
    postCopy                                     " Added on 07-Oct-2003 "
      " Finish doing whatever is required, beyond a shallowCopy,
      * to implement 'copy'. Answer the receiver.  This message
      * is only intended to be sent to the newly created instance.
      * Subclasses may add functionality, but they should 
      * always do super postCopy first.
      *
      * Note that any subclass that 'mixes in Modelness' (i.e.,
      * implements dependents with an instance variable) must 
      * include the equivalent of 'self breakDependents' in 
      * its implementation of postCopy. 
      "
      ^ self
|
    deepCopy  ! size newobj !

      size <- <primitive 4 self>.

      ((size bitAnd: 16r0F000000) ~= 0) 
          ifTrue: [^ self]                    "if built-in, just return self"

         ifFalse: [ newobj <- self class new.

                    1 to: size
                      do: [ :idx !
                            <primitive 112 newobj idx (<primitive 111 self idx> copy)> ].

                    ^ newobj ]
|
    first

      ^ self
|
    do: aBlock     ! item !
      
      item <- self first.

      ^ [item notNil] 
          whileTrue: [ aBlock value: item.  
                       item <- self next
                     ]
|
    do: aBlock without: anObject ! item !  "Added on 20-Jun-2001 (JTS)"

      (anObject == nil)
         ifFalse: [ item <- self first.

                    ^ [item notNil] 
                        whileTrue: [ (item ~~ anObject) 
                                       ifTrue: [aBlock value: item].
                       
                                     item <- self next 
                                   ]
                  ]
                  
          ifTrue: [ self do: aBlock ]
|
    error: aString

      <primitive 122 aString self>
|
    isKindOf: aClass ! objectClass !

      objectClass <- self class.

      [objectClass notNil] whileTrue:
             [(objectClass == aClass) ifTrue: [^ true].

                 objectClass <- objectClass superClass].
      ^ false
|
    isMemberOf: aClass
    
       ^ (aClass == self class)
|
    ifKindOf: aClass thenDo: aBlock

       ^ (self isKindOf: aClass) 
            ifTrue: [aBlock value: self]
|
    isNil

       ^ false
|
    ifNil: nilBlock

       ^ self       " only nil will evaluate nilBlock "
|
    next

       ^ nil
|
    notNil

       ^ true
|
    print

       <primitive 121 (self printString)>
|
    printNoReturn

       <primitive 120 (self printString)>
|
    printString

       ^ self asString
|    
    respondsTo: cmd

       ^ self class respondsTo: cmd
|    
    shallowCopy ! size newobj !

       size <- <primitive 4 self>.

       ((size bitAnd: 16r0F000000) ~= 0) 
          ifTrue: [^ self]                    "if built-in, just return self"

         ifFalse: [ newobj <- self class new.

                    1 to: size
                      do: [ :i ! <primitive 112 newobj i <primitive 111 self i > > ].

                    ^ newobj ]
|
   asciiToString: aNumber ! masked !

      " Convert aNumber into a single-character String: "

      masked <- <primitive 23 aNumber 16rFF>.
      
      ^ <primitive 96 masked> 
|
   subclassResponsibility: methodString ! msg !

     msg <- String new: 'Method ',methodString,' should be implemented in a SubClass!'.

     ^ <primitive 181 13 msg 'User ERROR:' 'OKAY'>
|
   notImplemented: methodString ! msg ! 

     msg <- String new: 'Method ',methodString,' NOT implemented!'.

     ^ <primitive 181 13 msg 'User ERROR:' 'OKAY'>
|
   doesNotUnderstand: methodString ! msg !

     msg <- String new: 'Method ',methodString,' NOT understood!'.

     ^ <primitive 181 13 msg 'User ERROR:' 'OKAY'> 
|
   shouldNotImplement: methodString ! msg !

     msg <- String new: 'Method ',methodString,' should NOT BE implemented!'.

     ^ <primitive 181 13 msg 'User ERROR:' 'OKAY'>
|
   notYetImplemented

     ^ <primitive 181 13 'NOT yet implemented!' 'User ERROR:' 'OKAY'>
|
   perform: selector  ! argArray ! 
   
      " Send the unary selector to the receiver: "

      (selector isMemberOf: Symbol)
         ifFalse: [^ self error: 'Selector argument must be a Symbol!'].

      (self respondsTo: selector)
         ifFalse: [^ self error: 'Does NOT respondTo:  ', selector ].

      argArray <- Array new: 1.

      argArray at: 1 put: self.
      
      ^ <primitive 143 argArray selector>
|
   perform: selector orSendTo: otherTarget
   
      " If I wish to intercept and handle selector myself, 
      * do it; else send it to otherTarget
      "
      ^ otherTarget perform: selector
|
   perform: selector with: anObject  ! argArray !
      
      " Send the selector, aSymbol, to the receiver with 
      * anObject as its argument:
      "
      (selector isMemberOf: Symbol)
         ifFalse: [^ self error: 'Selector argument must be a Symbol!'].

      (self respondsTo: selector)
         ifFalse: [^ self error: 'Does NOT respondTo:  ', selector ].

      argArray <- Array new: 2.
      
      argArray at: 1 put: self.
      argArray at: 2 put: anObject.
      
      ^ <primitive 143 argArray selector>
|
   perform: selector withArguments: argArray ! lsArray !
      
      " Send the selector, aSymbol, to the receiver with 
      * arguments in argArray.  Fail if the number of 
      * arguments expected by the selector does not match 
      * the size of lsArray:
      "
      (argArray size = 0)
         ifTrue: [ ^ self perform: selector ]. " Short-circuit stupid User "

      (argArray size = 1)  " Short-circuit stupid User: "
         ifTrue: [ ^ self perform: selector with: (argArray at: 1) ].
         
      " Go the long way around: "

      lsArray <- Array new: ((argArray size) + 1).

      (selector isMemberOf: Symbol)
         ifFalse: [^ self error: 'Selector argument must be a Symbol!'].

      (selector numArgs = argArray size)
         ifFalse: [^ self error: 'Incorrect number of arguments!'].
        
      (self respondsTo: selector)
         ifFalse: [^ self error: 'Does NOT respondTo:  ', selector ].

      lsArray at: 1 put: self.
      
      (2 to: lsArray size)
         do: [:ele ! lsArray at: ele put: (argArray at: (ele - 1))].
      
      ^ <primitive 143 lsArray selector>
|
   perform: selector with: firstObject with: secondObject ! argArray ! 

      " Send the selector, aSymbol, to the receiver with the 
      * given arguments.
      "
      selector isMemberOf: Symbol
         ifFalse: [^ self error: 'Selector argument must be a Symbol!'].

      (self respondsTo: selector)
         ifFalse: [^ self error: 'Does NOT respondTo:  ', selector ].

      argArray <- Array new: 3.
   
      argArray at: 1 put: self.
      argArray at: 2 put: firstObject.
      argArray at: 3 put: secondObject.

      ^ <primitive 143 argArray selector>
|
   perform: selector with: firstObject with: secondObject with: thirdObject ! argArray !
   
      " Send the selector, aSymbol, to the receiver with the given arguments: "

      (selector isMemberOf: Symbol)
         ifFalse: [^ self error: 'Selector argument must be a Symbol!'].

      (self respondsTo: selector)
         ifFalse: [^ self error: 'Does NOT respondTo:  ', selector ].

      argArray <- Array new: 4.

      argArray at: 1 put: self.
      argArray at: 2 put: firstObject.
      argArray at: 3 put: secondObject.
      argArray at: 4 put: thirdObject.
      
      ^ <primitive 143 argArray selector>
|
   performUpdate: aSymbol with: anObject

      self perform: aSymbol with: anObject
|
   performUpdate: aSymbol

      self perform: aSymbol
|
   breakPoint: msgString

      ^ <primitive 209 10 0 msgString>
|
   xxxReport

      " Users do NOT need to use this method.  It is for use by 
      * the Author of AmigaTalk for debugging the AmigaTalk System
      "   
      ^ <primitive 250 5 1 self>
|
   xxxAddress: object

      " Users do NOT need to use this method.  It is for use by 
      * the Author of AmigaTalk for debugging the AmigaTalk System
      "   
      ^ <primitive 250 5 2 object>
]
