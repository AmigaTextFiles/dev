" ------------------------------------------------------------------
  Class IndexedAdaptor provides the appearance of a ValueHolder, but 
  redirects the value and value: methods to the target by sending 
  at: and at:put:, respectively.

  When there is no target, the value is always nil; setValue: is a 
  no-op; and value: only notifies the dependents.

  Instance Variables:
	index <Integer> The index to adapt.


  An IndexedAdaptor is used to get and set an element in a collection. 
  It is typically created by sending a #subject: message to this 
  class, with the collection as the argument.  It is then equipped with 
  the index number or other lookup key of the desired element, via 
  #forIndex:. 
  An IndexedAdaptor can manage a collection element that is embedded 
  multiple levels within the subject, via an access path.  It can also 
  be told to withhold its update messages to avoid duplicating those 
  sent by its subject.  See ProtocolAdaptor for a fuller discussion of 
  these abilities. 
  -------------------------------------------------------------------
"
Class IndexedAdaptor :ProtocolAdaptor ! index !
[
   forIndex: anIndex
     " Create a new IndexedAdaptor and initialize the index to adapt. 
     * The subject or subjectChannel and whether the subject sends
     * updates must be initialized separately.
     "
     ^ self new setIndex: anIndex
|
   forIndex: anIndex accessPath: aSequencableCollection
     " Create a new IndexedAdaptor and initialize the index to adapt.
     * The subject or subjectChannel and whether the subject sends 
     * updates must be initialized separately.
     "
     ^ (self accessPath: aSequencableCollection) forIndex: anIndex
|
   forIndex
     " Answer the index we're adapting. "

     ^ index
|
   setIndex: anIndex

     index <- anIndex
|
   setValueUsingTarget: anObject to: newValue
     " Set the value in anObject using at:put: "

     (anObject == nil)
       ifFalse: [anObject at: index put: newValue]
|
   valueUsingTarget: anObject	
     " Answer the value returned by sending anObject with at: "

     (anObject == nil)
       ifFalse: [^anObject at: index]
        ifTrue: [^nil]
|
   update: anAspect with: aParameter from: anObject

     (anObject == super subject)
        ifTrue: [(anAspect == #at: and: [aParameter = index])
                      ifTrue: [super dependents update: #value with: nil from: self]]

       ifFalse: [super update: anAspect with: aParameter from: anObject]
|
   printOn: aStream

     aStream print: self class.

     aStream nextPut: $(.

     self target printOn: aStream.

     aStream space.

     self printPathOn: aStream.

     aStream nextPutAll: index printString.

     aStream nextPut: $).
]
