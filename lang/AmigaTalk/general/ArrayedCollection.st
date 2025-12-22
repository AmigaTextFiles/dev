" --------------------------------------------------------------- "
" Added the with: methods on 04-Apr-2002.                         "
" --------------------------------------------------------------- "

Class ArrayedCollection :SequenceableCollection
! current !
[
    = anArray   ! i !
      
      amigatalk tracingOff.
      
      (self size ~= anArray size) 
         ifTrue: [^ false]. 
            
      i <- 0.

      self do: [:x | (x ~= (anArray at: (i <- i + 1)))
                                        ifTrue: [^ false]
               ].
      
      amigatalk tracingOn.
      
      ^ true
|
    at: key ifAbsent: exceptionBlock

      ((key <= 0) or: [key > self size])
         ifTrue: [^ exceptionBlock value].

      ^ self at: key
|
    coerce: aCollection      ! temp !

      temp <- self class new: aCollection size.

      temp replaceFrom: 1 to: aCollection size with: aCollection.

      ^ temp
|
    copyFrom: start to: stop       ! size temp !

      size <- stop - start + 1.

      temp <- self class new: size.

      temp replaceFrom: 1 to: size with: self startingAt: start.

      ^ temp
|
    currentKey
      ^ current
| 
    deepCopy ! newobj !
    
      amigatalk tracingOff.
      
      newobj <- self class new: self size.

      (1 to: self size) do: [:i | newobj at: i put: (self at: i) copy ].

      amigatalk tracingOff.
      
      ^ newobj
|
    do: aBlock

      amigatalk tracingOff.
      
      (1 to: self size) 
          do: [:i | current <- i. 
            aBlock value: (self at: i)].

      amigatalk tracingOff.
|
    first

      current <- 1.

      ^ (current <= self size) 
         ifTrue: [ self at: current]
|
    firstKey

      ^ 1
|
    lastKey

      ^ self size
|
    next

      current <- current + 1.

      ^ (current <= self size) 
         ifTrue: [ self at: current]
|
    padTo: length

      ^ (self size < length)
          ifTrue: [ self , (self class new: (length - self size) ) ]
         ifFalse: [ self ]
|
    shallowCopy ! newobj !

      newobj <- self class new: self size.

      (1 to: self size) do: [:i | newobj at: i put: (self at: i) ].

      ^ newobj
|
    with: anObject ! newCollection !

      " Answer a new instance of ArrayedCollection, containing only anObject."   
         
      newCollection <- self new: 1.   

      newCollection at: 1 put: anObject.   

      ^ newCollection 
| 
    with: firstObject with: secondObject ! newCollection !

      " Answer a new instance of ArrayedCollection, containing firstObject
      * and secondObject.
      "
      newCollection <- self new: 2.

      newCollection at: 1 put: firstObject.   
      newCollection at: 2 put: secondObject.   
   
      ^ newCollection 
| 
    with: firstObject with: secondObject with: thirdObject ! newCollection !

      " Answer a new instance of ArrayedCollection, 
      * containing only these three objects.
      "   
      newCollection <- self new: 3.   
     
      newCollection at: 1 put: firstObject.   
      newCollection at: 2 put: secondObject.   
      newCollection at: 3 put: thirdObject.   
     
      ^ newCollection 
| 
    with: firstObject with: secondObject with: thirdObject with: fourthObject    
      ! newCollection !
     
      " Answer a new instance of ArrayedCollection, containing the four
      * arguments as the elements.
      "   
      newCollection <- self new: 4.   
     
      newCollection at: 1 put: firstObject.   
      newCollection at: 2 put: secondObject.   
      newCollection at: 3 put: thirdObject.   
      newCollection at: 4 put: fourthObject.   
     
      ^ newCollection 
|     
    withAll: aCollection ! newCollection index !

      " Answer a new instance of this class, whose elements are 
      * the elements of aCollection. 
      "   
      newCollection <- self new: aCollection size.   
      index         <- 0.   
     
      aCollection do: [:element | newCollection at: (index := index + 1)
                                               put: element ].   
     
      ^ newCollection 
]
