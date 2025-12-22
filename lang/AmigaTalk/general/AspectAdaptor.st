" ----------------------------------------------------------------------
  Class AspectAdaptor provides the appearance of a ValueHolder, but 
  redirects the value and value: methods to the target by sending 
  getSelector and putSelector, respectively.  The putSelector is assumed 
  to take a single argument which is the argument provided to value:.

  When there is no target, the value is always nil; setValue: is a no-op; 
  and value: only notifies the dependents.

  Instance Variables:
     getSelector   <Symbol>  0-arg message selector
     putSelector   <Symbol>  1-arg message selector
     aspect        <Symbol | nil> aspect for which the adaptor is willing to 
                              field updates.  If nil, use the getSelector instead
  Object Reference:
  An AspectAdaptor is widely used in applications, to get and set an 
  embedded value.  While a ValueHolder typically manages a value held by 
  an application model, an AspectedAdaptor typically manages a value held 
  by a domain model, which itself is held by the application model.  The 
  domain model is the adaptor's subject, and the adaptor must be equipped 
  with messages (getSelector and putSelector) for accessing the desired value 
  in the subject.  See ProtocolAdaptor (the parent class) for a descriptive 
  example. 
  
  An AspectAdaptor is typically created by sending a #subject: message to 
  this class, with the domain model as the argument.  The getSelector and 
  putSelector are typically the same message (with a colon, in the case of 
  the putSelector) and can be set via #forAspect:.  When the getSelector and 
  putSelector are dissimilar, use #accessWith:assignWith: to set them. 
  
  An AspectAdaptor can manage a value that is embedded multiple levels within 
  the subject, via an access path.  It can also be told to withhold its 
  update messages to avoid duplicating those sent by its subject.  See 
  ProtocolAdaptor for a fuller discussion of these abilities. 
  -----------------------------------------------------------------------
"
Class AspectAdaptor :ProtocolAdaptor
! getSelector putSelector aspect !
[
   accessWith: getSymbol assignWith: putSymbol
     " Create a new AspectAdaptor and initialize the getSelector and putSelector
     * with getSymbol and putSymbol, respectively. The subject or subjectChannel
     * and whether the subject sends updates must be initialized separately.
     "
     ^ self new assignAccessWith: getSymbol assignWith: putSymbol
|
   accessWith: getSymbol assignWith: putSymbol accessPath: aSequencableCollection
     "Create a new AspectAdaptor and initialize the getSelector and putSelector
     * with getSymbol and putSymbol, respectively. The subject or subjectChannel
     * and whether the subject sends updates must be initialized separately.
     "

     ^ (self accessPath: aSequencableCollection) 
             accessWith: getSymbol 
             assignWith: putSymbol
|
   forAspect: anAspectSymbol
     " Create a new AspectAdaptor and initialize the getSelector and putSelector
     * based on anAspectSymbol and the symbol with a colon appended.
     * The subject or subjectChannel and whether the subject sends updates must
     * be initialized separately.
     "
     ^ self new setAspect: anAspectSymbol
|
   forAspect: anAspectSymbol accessPath: aSequencableCollection
     "Create a new AspectAdaptor and initialize the getSelector and putSelector
     * based on anAspectSymbol and the symbol with a colon appended.
     * The subject or subjectChannel and whether the subject sends updates must
     * be initialized separately.
     "

     ^ (self accessPath: aSequencableCollection) forAspect: anAspectSymbol
|
   assignAccessWith: getSymbol assignWith: putSymbol
     " Set or change the symbols used to access the subject. "

     self accessWith: getSymbol assignWith: putSymbol aspect: nil
|
   accessWith: getSymbol assignWith: putSymbol aspect: aspectSymbol
     " Set or change the symbols used to access the subject. "

     getSelector <- getSymbol.
     putSelector <- putSymbol.
     aspect      <- aspectSymbol
|
   forAspect
     " Answer the aspect we're adapting. "

     ^ aspect == nil
         ifTrue: [getSelector]
        ifFalse: [aspect]
|
   setAspect: anAspectSymbol
     "Set or change the symbols used to access the subject."

     self accessWith: anAspectSymbol assignWith: (anAspectSymbol, ':') asSymbol
|
   initialize

     super initialize.
     self accessWith: #value assignWith: #value:
|
   setValueUsingTarget: anObject to: newValue
     " Set the value of anObject by sending the receiver's 
     * store (put) selector to the anObject with argument newValue.
     "

     (anObject == nil)
        ifFalse: [anObject perform: putSelector with: newValue]
|
   valueUsingTarget: anObject
     " Answer the value returned by sending the receiver's retrieval 
     * (get)  selector to anObject
     "

      (anObject == nil)
         ifFalse:   [ ^ anObject perform: getSelector]
          ifTrue:   [ ^ nil]
|
   update: anAspect with: parameter from: sender
     " Propagate change if the sender is the receiver's subject 
     * and anAspect is the receiver's aspect.
     "
     (sender == super subject and: [anAspect == self forAspect])
         ifTrue: [super dependents update: #value with: parameter from: self]
        ifFalse: [super update: anAspect with: parameter from: sender]
|
   printOn: aStream

     aStream print: self class.
     
     aStream nextPut: $(.
     
     self target printOn: aStream.
     
     aStream space.
     
     self printPathOn: aStream.
     
     aStream nextPutAll: getSelector.
     
     aStream nextPut: $).
]
