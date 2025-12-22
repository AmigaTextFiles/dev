
Class Interval :SequenceableCollection
! lower upper step current !
[
   from: lowerBound to: upperBound by: stepSize

     current <- lower <- lowerBound.
     upper   <- upperBound.
     step    <- stepSize
|  
   from: lowerBound to: upperBound

     current <- lower <- lowerBound.
     upper   <- upperBound.
     step    <- 1
|
   lowerBound " Added on 16-Oct-2003 for V2.5+"

     ^ lower  
|
   upperBound " Added on 16-Oct-2003 for V2.5+"

     ^ upper
|
   stepSize   " Added on 16-Oct-2003 for V2.5+"
   
     ^ step
|
   size   

     ^ ((step strictlyPositive) 
          ifTrue:  [upper < lower]
          ifFalse: [lower < upper] )

        ifTrue:  [ 0 ]
        ifFalse: [upper - lower // step + 1]
|  
   inRange: value

     (step > 0)   "(step strictlyPositive)"
        ifTrue:  [^ ((value >= lower) and: [value <= upper]) ]
        ifFalse: [^ ((value >= upper) and: [value <= lower]) ]
| 
   first

     current <- lower.

     ^ (self inRange: current) ifTrue: [current]
|
   last

     current <- upper.

     ^ (self inRange: current) ifTrue: [current]
|   
   next

     current <- current + step.

     ^ (self inRange: current) ifTrue: [current]
|
   at: index ifAbsent: exceptionBlock   ! val !

     val <- lower + (step * (index - 1)).

     ^ (self inRange: val)
         ifTrue: [ val ]
        ifFalse: [exceptionBlock value]
| 
   printString

     ^ 'Interval ', lower printString , ' to ',
                    upper printString , ' by ' , step printString 
|   
   coerce: newcollection

     ^ newcollection asArray
|   
   at: index put: val

     ^ self error: 'cannot store into Interval'
|   
   add: val

     ^ self error: 'cannot store into Interval'
|   
   removeKey: key ifAbsent: exceptionBlock

     self error: 'cannot remove from Interval'.

     ^ exceptionBlock value
|
   deepCopy

     ^ lower to: upper by: step
|   
   shallowCopy

     ^ lower to: upper by: step
]
