" -------------------------------------------------------------------
  ComputedValue is an abstract class that represents a computation 
  that propagates changes to dependents.  It caches the result of the 
  computation.  Kinds of ComputedValues can not respond to the message 
  value:.  Subclasses must implement:   
  
    accessing models   computeValue
    
    Instance Variables:   
    
    cachedValue     <Object>   
    eagerEvaluation <Boolean> controls whether to wait until the 
                              receiver is asked to perform the 
                              computation (eager vs. late)

    Class Variables:   
    
    unassignedValue <Object> a unique object that is guaranteed to 
                             be used by no one else in the system,
    used to denote that the value has not yet been computedObject 

  Reference:
    ComputedValue is an abstract class that provides support 
    for creating a BlockClosure that recomputes a cached value
  whenever one of the block arguments changes its value.  When asked 
  for its #value, a ComputedValue supplies its cached value, 
  recomputing it if necessary.  This is useful when object3 is 
  computed using object1 and object2, which are expected to be 
  value models.  ComputedValue has a single subclass, 
  BlockValue.  For usage instructions, see BlockValue.  When creating 
  a subclass, equip it with the following methods:

    parts       computeValue 
    
  Subclasses should not implement:    value:  
  -------------------------------------------------------------------
"
Class ComputedValue :ValueModel 
! cachedValue eagerEvaluation unassignedValue !
[
   initialize
      unassignedValue <- Object new.
      cachedValue     <- unassignedValue.   
      eagerEvaluation <- true 
|
   resetCache
      cachedValue <- unassignedValue
|
   releaseParts   
      " Remove any dependencies involving the receiver. "   
      self parts do: [:m | m removeDependent: self]. 
|  
   eagerEvaluation: aBoolean    
      " If aBoolean is true the receiver will do late evaluation of its
      * computation; otherwise the receiver will do eager computation.
      "   
      eagerEvaluation <- aBoolean 
| 
   parts  " defined in BlockValue: " 
      " Answer a collection of objects that have the receiver as a dependent. " 
  
      ^ self subclassResponsibility: 'parts'
| 
   value   
      " Answer the cached value for the receiver. If the value is unknown,    
      * then compute the value.
      "   
      (cachedValue == unassignedValue) 
         ifTrue: [cachedValue <- self computeValue].   
   
      ^ cachedValue
| 
   value: anObject   
      self shouldNotImplement 
|  
   update: aspect with: parameter from: sender    
      " If a model is propogating a change, then reset the receiver and
      * propogate change to dependents.
      "   
      self resetValue 
|  
   printOn: aStream   
      " Print the receiver`s value on aStream. "   
     
      (cachedValue == unassignedValue) 
        ifFalse: [^super printOn: aStream].   
     
      aStream print: self class.   
      aStream nextPutAll: ' with: TheUnassignedValue'. 
|
   computeValue   
      " Compute a value for the receiver. "   
      ^ self subclassResponsibility: 'computeValue'
| 
   resetValue   
      " Set the receiver`s value to unknown.  
      * Propogate change to dependents.
      "   
      (eagerEvaluation = true)      
         ifFalse: [cachedValue <- unassignedValue]      
          ifTrue: [cachedValue <- self computeValue].   
     
      self changed: #value 
]
