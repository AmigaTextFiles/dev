" ----------------------------------------------------------------------
  Class SlotAdaptor redirects the value and value: methods to the 
  target by sending instVarAt: and instVarAt:put:, respectively.

  When there is no target, the value is always nil; setValue: is a 
  no-op; and value: only notifies the dependents.

  The subject is assumed to not send updates.  However, if it uses 
  #at as the aspect and provides the index as the parameter, it will 
  be treated as a change notice an propogated to the dependents of 
  the SlotAdaptor.
  ----------------------------------------------------------------------
"
Class SlotAdaptor :IndexedAdaptor
[
   forIndex: instVarIndex

     super setIndex: instVarIndex
|
   setValueUsingTarget: anObject to: newValue
     " Set the value in anObject using instVarAt:put: "

     (anObject == nil)
        ifFalse: [anObject instVarAt: (super forIndex) put: newValue]
|
   valueUsingTarget: anObject	
     " Answer the value returned by sending anObject instVarAt: "

     (anObject == nil)
       ifFalse: [ ^ anObject instVarAt: (super forIndex)]
       ifTrue:  [ ^ nil ]
|
   printOn: aStream

     aStream print: self class.

     aStream nextPut: $(.

     self target printOn: aStream.

     aStream space.

     self printPathOn: aStream.

     aStream nextPutAll: 'instVarAt: '.
     aStream nextPutAll: (super forIndex) printString.
     aStream nextPut: $).
]
