" -------------------------------------------------------------------------

  An instance of BlockValue represents a computation that propagates 
  changes.  The value of an instance is recomputed by evaluating a block 
  when the value of any of the instance's arguments changes.  All 
  dependents are notified when the value has changed.

  Instance Variables:
	block		<BlockClosure>
	arguments	<SequenceableCollection of: ValueModel>
	numArgs	<SmallInteger>	the number of arguments block takes


  Object Reference:
  A BlockValue computes its value using a given BlockClosure and a 
  set of arguments for that block.  It registers itself as a dependent 
  of each argument, so the arguments are typically value models. 
  Whenever any of the argument objects changes its value, the BlockValue 
  is updated.  The result is similar to sending #onChangeSend:to: 
  to each of the argument objects, asking them to trigger a method that 
  updates a particular value.  Using a BlockValue eliminates the need 
  to create the method that is triggered -- instead, the block is 
  evaluated with the changed arguments.  The resulting value is cached 
  so that it need not be recomputed unless one of the block arguments 
  changes again.  Being able to use a block instead of a method is 
  especially helpful in the case of dialog that has been built from 
  scratch, such that a method in the application model would have 
  difficulty accessing some of the data in the dialog for its computation.
  A BlockValue is typically created by sending #block:arguments: to 
  this class.  The ValueModel class also provides a set of methods for 
  conveniently spawning a BlockValue from one of the argument objects 
  (see the constructing protocol in ValueModel).
  By default, a BlockValue recomputes its cached value whenever it is 
  notified that one of the block arguments has changed.  This is known 
  as eager evaluation.  In some situations, late evaluation may be 
  preferable -- then, the cached value is only recomputed when it is 
  requested via #value (assuming one of the block arguments has changed). 
  Late evaluation can be arranged by sending an #eagerEvaluation: 
  message to the BlockValue with false as the argument.  This is most 
  useful when the cached value is only requested infrequently and the 
  block computation is costly in terms of time or other resources. 
  -------------------------------------------------------------------------
"

Class BlockValue :ComputedValue  ! myBlock arguments numArgs !
[
   block: aBlock arguments: aCollection
     " Answer an instance of the receiver with aCollection as arguments "

     ^ self new setBlock: aBlock arguments: aCollection
|
   with: aBlock
     " Answer a new instance of the receiver that computes aBlock. "

     ^ self new setBlock: aBlock arguments: SequenceableCollection new
|
   dependOn: anObject
     " Make the receiver depend on anObject. "

     anObject addDependent: self.

     arguments <- self parts copyWith: anObject
|
   parts
     " Answer a collection of objects that have 
     * the receiver as a dependent.
     "
     (arguments == nil)
        ifTrue: [ arguments <- Array new].

     ^ arguments
|
   computeValue ! array !
     " Compute a value for the receiver. "

     (0 = numArgs) 
       ifTrue: [ ^ myBlock value].
     
     (1 = numArgs)
       ifTrue: [ ^ myBlock value: (arguments at: 1) value].
     
     (2 = numArgs) 
       ifTrue: [ ^ myBlock value: (arguments at: 1) value 
                           value: (arguments at: 2) value ].
     
     (3 = numArgs)
       ifTrue: [ ^ myBlock value: (arguments at: 1) value
                           value: (arguments at: 2) value
                           value: (arguments at: 3) value ].
                        
     array <- Array new: (numArgs min: arguments size).
     
     1 to: array size do: [:i | array at: i put: (arguments at: i) value].

     ^ myBlock valueWithArguments: array
|
   setBlock: aBlock
     " Set the block for the receiver to be aBlock. "

     myBlock     <- aBlock.
     numArgs     <- myBlock numArgs.

     super resetCache.              "cachedValue <- UnassignedValue. "

     arguments   <- #().
|
   setBlock: aBlock arguments: aCollection
     " Set the receiver's block to be aBlock and 
     * the arguments to be aCollection.
     "
     self setBlock: aBlock.
 
     arguments <- aCollection.
 
     1 to: arguments size do: [:i | (arguments at: i) addDependent: self]
]
