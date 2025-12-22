" -------------------------------------------------------------
  Class Model provides a variant representation for objects 
  that are expected to have dependents.

  Instance Variables:
    modelDependents  <nil | Object | DependentsCollection>

  Model is an abstract class whose subclasses represent various 
  kinds of information models.  An information model is an 
  object on which user-interface objects such as input fields 
  depend for their data -- thus, the interface objects are 
  said to be dependents of the model.  The Model class provides 
  a fast means of finding dependents.
  
  Here, dependents are kept in an instance variable. 
  For this reason, a new class that is expected to have one or more 
  dependents has to be made a subclass of Model. 

  While Model does not provide any new abilities, it has many 
  subclasses that do.  An ApplicationModel mediates between a 
  set of data models and the user interface that is used to 
  manipulate the data.  Various kinds of ValueModel are able to 
  adapt simple data objects so they behave like full-fledged models. 
  --------------------------------------------------------------
"

Class Model :Object ! modelDependents modelAdaptors haveAChange linkedMethods !
[
   myAdaptors: aCollectionOrNil
      (aCollectionOrNil == nil)
         ifTrue: [modelAdaptors removeKey: self ifAbsent: []]
        ifFalse: [modelAdaptors at: self put: aCollectionOrNil]
|
   adaptors
      ^ modelAdaptors at: self ifAbsent: []
|
   dependenciesAt: anObject
      ^ modelDependents at: anObject ifAbsent: [ ^ nil ]
|
   broadcast: aSymbol ! theseDependents !
      theseDependents <- modelDependents at: self ifAbsent: [ nil ].
      
      (theseDependents isNotNil)
         ifTrue: [theseDependents do: [ :d | d perform: aSymbol ] ]
|
   broadcast: aSymbol with: anObject ! theseDependents !
      theseDependents <- modelDependents at: self ifAbsent: [ nil ].
      
      (theseDependents isNotNil)
         ifTrue: [theseDependents do: [ :d | d perform: aSymbol with: anObject ] ]
|
   myDependents
     " Answer the receiver's dependents or nil. "

     ^ modelDependents at: self ifAbsent: [nil]
|
   myDependents: dependentsOrNil
     " Set the receiver's dependents to aDependentsCollection "

     (dependentsOrNil == nil)
        ifTrue: [modelDependents removeKey: self ifAbsent: []]
       ifFalse: [modelDependents at: self put: dependentsOrNil]
|
   postCopy
     " Do not copy the dependents list. "

     super postCopy.

     self breakDependents
|
   initialize
     modelDependents <- nil.
     modelAdaptors   <- nil.
     haveAChange     <- 0. 
|
   addDependent: anObject
      "Make the given object one of the receiver's dependents."

      (modelDependents == nil)
         ifTrue: [ modelDependents <- Array new: 1.
                   modelDependents at: 1 put: anObject
                 ]
        ifFalse: [ "done if anObject is already a dependent"
                   modelDependents do: [:o | (o == anObject) ifTrue: [^ self] ].
                   "otherwise, add it"
                   modelDependents <- modelDependents grow: anObject
                 ].
|
   changeComplete
      (haveAChange > 0)
         ifTrue:  [ haveAChange <- haveAChange - 1.
                    ^ false ]
         ifFalse: [ ^ true ]
|
   changeMade
      haveAChange <- haveAChange + 1
|
   release
      self breakDependents
|
   breakDependents
      " Remove all of the receiver's dependents "

      self myDependents: nil
|
   onChangeSend: aSelector to: aDependent
      self expressInterestIn: #value for: aDependent sendBack: aSelector
|
   expressInterestIn: anAspect for: anObject sendBack: aSelector 
      ! dt deps !

      " Arrange for anObject to receive a message named aSelector when
      * I signal that my attribute anAspect has changed.
      "
      dt <- DependencyTransformer new.

      dt setReceiver: anObject aspect: anAspect selector: aSelector.
	
      deps <- self myDependents.

      (deps class == DependentsCollection)
         ifTrue: [deps includes: dt]
        ifFalse: [(deps = dt)
                    ifTrue: [ ^ self ] ].

      self addDependent: dt
|
   retractInterestIn: anAspect for: anObject ! deps !
      " Undo a send of expressInterestIn:for:sendBack: "

      deps <- self myDependents.

      (deps == nil)
         ifTrue: [ ^ self ].

      (deps class == DependencyTransformer and: [deps matches: anObject forAspect: anAspect])
         ifTrue: [ ^ self removeDependent: deps].

      (deps class == DependentsCollection) 
         ifFalse: [ ^ self ].

      1 to: deps size do: [:i | ((deps at: i) class == DependencyTransformer and:
                                   [(deps at: i) matches: anObject forAspect: anAspect])
		                ifTrue: [ ^ self removeDependent: (deps at: i) ] ]
|
   asDependentsAsCollection
      " Answer the receiver, considered as a collection of dependents, 
      * as a real Collection.  Since the receiver represents
      * a singleton dependents collection, answer a Collection 
      * containing only	the receiver. 
      "
      ^ Array with: self
|
   asDependentsWith: anObject
      " Answer the receiver, considered as a collection of dependents,
      * with anObject added.  Since the receiver represents a 
      * singleton dependents collection, answer a Collection 
      * containing the receiver and anObject. 
      "
      ^ DependentsCollection with: self with: anObject
|
   asDependentsWithout: anObject
      " Answer the receiver, considered as a collection of dependents,
      * with the first occurrence of anObject (if any) removed.
      * If anObject does not occur in the receiver, answer the receiver. 
      * Since the receiver represents a	singleton dependents collection,
      * answer either the receiver or nil. 
      "
      ^ anObject == self
           ifTrue: [ nil  ]
          ifFalse: [ self ]
|
   canDiscardEdits
      " Answer true if none of the views on this 
      * model has unaccepted edits that matter.
      "
      (modelDependents == nil)
         ifTrue: [^ true].

      (haveAChange < 1)
         ifTrue: [ ^ true ].
         
      ^ false
|
   dependents: dependentsOrNil
     " Set the receivers dependents. "

     modelDependents <- dependentsOrNil
|
   dependents
      " Answer a collection of objects that are 'dependent' 
      * on the receiver; that is, all objects that should 
      * be notified if the receiver changes.
      "

      (modelDependents == nil) 
         ifTrue: [^ #() ].

      ^ modelDependents
|
   hasUnacceptedEdits
      " Answer true if any of the views on this model 
      * has unaccepted edits.
      "

      (modelDependents == nil)
          ifTrue: [^ false].
      
      (haveAChange > 1)
         ifTrue: [ ^ true ].
         
      ^ false
|
   removeDependent: anObject ! newDependents !

      "Remove the given object as one of the receiver's dependents."

      (modelDependents == nil) 
         ifTrue: [^ self].

      newDependents <- modelDependents select: [:d | (d == anObject) not].

      (newDependents isEmpty)
         ifTrue:  [modelDependents <- nil]
         ifFalse: [modelDependents <- newDependents].
|
   topController
      " Find the first top controller on me.  Is there any danger
      * of their being two with the same model?  Any danger 
      * from ungarbage collected old controllers?
      "
      modelDependents ifNil: [^ nil].

      modelDependents do: [:v | ((v isKindOf: Controller) 
                                    and: [v isInWorld]) 
           
                             ifTrue: [^ v] ].

      modelDependents do: [:v | (v superController) 
                              ifNil: [(v model == self) 
                                         ifTrue: [ ^ v ] ] ].

      ^ nil
|
   linkMethod: classAndMethod

      "Make a message list and put this method in it"

      (linkedMethods isNil)
         ifTrue: [ linkedMethods <- KeyedCollection new ].

      linkedMethods add: classAndMethod
|
   value   "SubClasses must override this: "
      super subclassResponsibility: 'value'.

      ^ nil
|
   new
      modelDependents <- DependentsCollection new.
      modelAdaptors   <- Array new.
      linkedMethods   <- KeyedCollection new.
      haveAChange     <- 0.
|
   perform: selector orSendTo: otherTarget
      " Selector was just chosen from a Control by a User.  
      * If I can respond, then perform it on myself.  If not, send 
      * it to otherTarget.
      " 
      ^ otherTarget perform: selector.
|
   windowIsClosing
      " This message is used to inform a model(s) that its window
      * is closing.  Most models do nothing, but some, must do 
      * some cleanup.  Note that this mechanism must be used 
      * with care by models that support multiple views, since 
      * one view may be closed while others have been left open.
      * Default response is no-op:
      "
      ^ nil
|
   modelSleep
      " A window with me as model is being exited or collapsed or closed.
      * Default response is no-op:
      "
      ^ nil
|
   modelWakeUp
      " A window with me as model is being entered or expanded.  
      * Default response is no-op:
      "
      ^ nil
|
   modelWakeUpIn: aWindow
      " A window with me as model is being entered or expanded.  
      * Default response is no-op:
      " 
      self modelWakeUp
|
   contentsChanged
      self changed: #contentsChanged
|
   okToChange
      " Allows a controller to ask this of any model "

      ^ true
|
   changed
      " Receiver changed in a general way; inform all the dependents by 
      * sending each dependent an update: message.
      "
      self changed: nil
|
   changed: anAspectSymbol

      " Receiver changed.  The change is denoted by the argument
      * anAspectSymbol.  Usually the argument is a Symbol that 
      * is part of the dependent's change protocol. Inform all 
      * of the dependents.
      "
      self changed: anAspectSymbol with: nil
|
   changed: anAspectSymbol with: aParameter
      self modelDependents update: anAspectSymbol with: aParameter from: self
|
   update: anAspectSymbol with: aParameter from: aSender
      ^ self update: anAspectSymbol with: aParameter
|
   update: anAspectSymbol with: aParameter
      ^ self update: anAspectSymbol
|
   update: anAspectSymbol
      " Receive a change notice from an object of whom the 
      * receiver is a dependent.  The default behavior is 
      * to do nothing; a subclass might want 
      * to change itself in some way.
      "
      ^ self
]
