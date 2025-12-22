" --------------------------------------------------------------------
  I provide a level of indirection between a View/Controller and an 
  underlying model.  The View and Controller send my instances the 
  standard messages value and value:, which I convert into arbitrary 
  actions defined by blocks.

  Instance Variables:
	model	<ValueModel>  the underlying model (only used for 
                              dependency and for isActive testing)
	getBlock	<BlockClosure>  evaluate this block to get the value
	putBlock	<BlockClosure>  evaluate this block to set the value
	updateBlock	<BlockClosure>  evaluate this block to handle 
                                        an update from the model; if it 
                                        returns true, notify our dependents

  The getBlock is evaluated with one argument, the model.  
  The putBlock is evaluated with two arguments, the model and the 
  new value.  The updateBlock is evaluated with three arguments, 
  the model, the update aspect, and the update parameter.

  We use blocks rather than selectors because blocks are much more 
  flexible than selectors for representing encapsulated behavior.  
  They can reference more than one object, and they can include 
  embedded parameters such as a collection index.


  Object Reference:
    A PluggableAdaptor is the most flexible of the value models, 
    because its activities are highly configurable.  This flexibility 
    comes at the cost of a certain conceptual complexity, however. 
    At one time, PluggableAdaptor was the only value model -- now, 
    more convenient value models exist for the most common situations 
    in which a PluggableAdaptor was formerly applied.  In particular, 
    the subclass TypeConverter performs several of the most common 
    conversions from one type of object to another, such as converting 
    a number to a string and back again.  Still, demanding situations 
    remain in which a PluggableAdaptor is the most economical solution.
  
  A PluggableAdaptor has a model, which can either be an application 
  model or a domain model, from which it obtains the desired data value. 
  The adaptor is configured via three blocks, which enable it to 
  perform customized actions at three junctures in the flow of 
  communications between the dependent (typically a widget) and the 
  model.  The first block, the getBlock, controls what happens when a 
  value is requested (via #value).  The block takes one argument, 
  the model.  The block returns the value, after fetching it from 
  the model and applying any necessary computations or transformations. 
  For example, the following getBlock fetches an accountNumber from 
  the model, converts it to a string and pads it with leading zeroes: 

	[ :model | 
		| paddedString | 
		paddedString <- model accountNumber printString. 
		6 - paddedString size 
			timesRepeat: [paddedString <- '0', paddedString]. 
		paddedString] 

   The second block, the putBlock, controls what happens when a value 
   is stored (via #value:).  The block takes two arguments, the model 
   and the value to be stored.  The block stores the value in the 
   model after applying any necessary computations or transformations. 
   For example, the following putBlock converts a padded 
   accountNumber string back into a number and stores the number 
   in the model: 
	
        [ :model :val | 
		model accountNumber: val asNumber]. 

   The third block, the updateBlock, controls what happens when the 
   adaptor receives an #update:with:from: message.  It receives that 
   message whenever the model sends a variant of #changed:with: to 
   itself -- in the accountNumber example, the model would send such 
   a message when its accountNumber had been changed.  The block takes 
   three arguments: the model and the first two arguments from the 
   #update:with: message (known as the update aspect and the update 
   parameter).  The block returns true or false, usually after testing 
   the aspect to see whether the adaptor cares about that type of 
   change in the model.  When the updateBlock returns true, the 
   adaptor's getBlock is invoked to update the widget's value.  When 
   the updateBlock returns false, no action is taken.  For example, 
   the following updateBlock causes the widget to refetch the value 
   only when the update aspect is #accountNumber and the parameter 
   (an accountNumber string) is less than 1000: 

	[ :model :aspect :parameter | 
		aspect == #accountNumber and: [parameter asNumber < 1000]]. 

   A PluggableAdaptor is created by sending #on: to this class, 
   with the model as the argument.  The three blocks are then 
   initialized via #getBlock:putBlock:updateBlock.  The protocol 
   named 'initialize algorithm' contains shortcuts for configuring the 
   three blocks for common situations. 
  ----------------------------------------------------------------------
"

Class PluggableAdaptor :ValueModel ! model getBlock putBlock updateBlock !
[
   on: aModel
     ^ self new model: aModel
|
   getBlock: aBlock1 putBlock: aBlock2 updateBlock: aBlock3
     " Set the blocks used for dealing with the model. "

     getBlock    <- aBlock1.
     putBlock    <- aBlock2.
     updateBlock <- aBlock3
|
   initialize
     super initialize.

     " Initialize the blocks on the assumption that the 
     * underlying model is a ValueModel.  This is wrong, 
     * of course. 
     "
     self getBlock: [:m | m value]
          putBlock: [:m :v | m value: v]
       updateBlock: [:m :a :p | a == #value ]
|
   model: aModel
     model removeDependent: self.
     
     model <- aModel.
     
     (super dependents notNil)
        ifTrue: [model addDependent: self]
|
   subjectChannel: aValueHolder

     self model: aValueHolder
|
   collectionIndex: index
     " Initialize the receiver to access
     * the given element of a collection
     * that is the value of the model. 
     "
     self
         getBlock: [:m | m value at: index]
         putBlock: [:m :v | m value at: index put: v.
                            m changed: #at with: index]

      updateBlock: [:m :a :p | a == #value or: [a == #at and: [p = index]]]
|
   getSelector: aSymbol0 putSelector: aSymbol1
     " Initialize the receiver to act like
     * the old pluggable classes. 
     "
     self
           getBlock: [:m | m perform: aSymbol0]
           putBlock: [:m :v | m perform: aSymbol1 with: v]
        updateBlock: [:m :a :p | a == #value or: [a == aSymbol0]]
|
   performAction: aSelector
     " Initialize the receiver to perform the action
     * when assigned a value 
     "

     self
           getBlock: [:m | false]
           putBlock: [:m :v | m perform: aSelector]
        updateBlock: [:m :a :p | false]
|
   selectValue: aValue  ! cacheValue !
     " Initialize the receiver to act like a Boolean 
     * that is true when the model's value is equal to aValue. 
     "
     cacheValue <- nil.

     self
           getBlock: [:m | cacheValue <- m value = aValue]
           putBlock: [:m :v | (v)
                               ifTrue: [m value: aValue]
                              ifFalse: [m value = aValue ifTrue: [m value: nil]]]
        updateBlock: [:m :a :p | ((m value = aValue) = cacheValue)
                                   ifFalse: [ ^ true ]
                                    ifTrue: [ ^ false] ]
|
   model
     ^ model
|
   setValue: newValue
     putBlock value: model value: newValue
|
   value
     ^ getBlock value: model
|
   valueUsingSubject: aSubject

     aSubject == nil ifTrue: [^nil].
     
     ^ getBlock value: aSubject
|
   update: aspect with: parameter from: sender

     (updateBlock value: model value: aspect value: parameter)
         ifTrue: [self changed: #value ]
|
   addDependent: aDependent 

     (super dependents isNil) 
        ifTrue: [model addDependent: self].
     
     super addDependent: aDependent.
|
   removeDependent: aDependent 

     super removeDependent: aDependent.

     (super dependents isNil) 
        ifTrue: [model removeDependent: self]
|
   isProtocolAdaptor
     " Answer as to whether the receiver transduces
     * protocol into ValueModel protocol.
     "
     ^ true
|
   makeAdaptorForRenderingStoreLeafInto: pair

     pair at: 1 put: self.
     ^ (model isProtocolAdaptor)
         ifTrue: [model <- model copy.
                           model makeAdaptorForRenderingStoreLeafInto: pair]
        ifFalse: [pair]
|
   renderingValueUsingSubject: aSubject ! pair aCopy cell !

     (model isProtocolAdaptor)
        ifFalse: [ ^ self valueUsingSubject: aSubject ].
     
     aCopy <- self copy.
     pair  <- Array new: 2.
     
     pair at: 2 put: aCopy.
     
     cell <- aCopy makeAdaptorForRenderingStoreLeafInto: pair.
     
     cell first subjectChannel: aSubject asValue.
     
     ^ cell last value
]
