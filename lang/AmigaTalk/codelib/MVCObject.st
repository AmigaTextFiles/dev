"-----------------------------------------------------------------"
" MVCObject Class is used to create Model-View-Controller Objects."
" These types of objects have dependency capabilities.            "
"-----------------------------------------------------------------"

Class MVCObject :Object ! dependentsCollection eventsCollection !
[
   new
      dependentsCollection <- KeyedCollection new.
      eventsCollection     <- KeyedCollection new.

      ^ self
|
   myDependents
      ^ dependentsCollection at: self ifAbsent: []
|
   myDependents: aCollectionOrNil
      (aCollectionOrNil == nil)
         ifTrue: [dependentsCollection removeKey: self ifAbsent: []]
        ifFalse: [dependentsCollection at: self put: aCollectionOrNil]
|
   dependents
      ^ self myDependents ifNil: [#()]
|
   changed
      self changed: nil
|
   changed: anAspectSymbol
      self changed: anAspectSymbol with: nil
|
   changed: anAspectSymbol with: aParameter
      self myDependents update: anAspectSymbol with: aParameter from: self
|
   update: anAspectSymbol with: aParameter from: aSender
      ^ self update: anAspectSymbol with: aParameter
|
   update: anAspectSymbol with: aParameter from: aSender
      ^ self update: anAspectSymbol
|
   update: anAspectSymbol
      ^ self
|
   expressInterestIn: anAspectSymbol for: aDependent sendBack: aSelector
|
   retractInterestIn: anAspectSymbol for: aDependent
|
   onChangeSend: aSelector to: aDependent
|
   breakDependents
      self myDependents: nil
|
   release
      self breakDependents.
      self removeAllEventsTriggered
|
   evaluate: actionBlock wheneverChangeIn: aspectBlock
      ! viewerThenObject objectThenViewer !
      
      objectThenViewer <- self.
      
      viewerThenObject <- ObjectViewer on: objectThenViewer.
      
      objectThenViewer become: viewerThenObject.
      
      objectThenViewer xxxViewedObject: viewerThenObject
                              evaluate: actionBlock
                      wheneverChangeIn: aspectBlock
|
   canDiscardEdits
      self dependents do: [:each | each canDiscardEdits ifFalse: [^ false]
                          ]
                 without: self.
      ^ true
|
   hasUnacceptedEdits
      self dependents do: [:each | each hasUnacceptedEdits ifTrue: [^ true]
                          ]
                 without: self.
      ^ false
|
   addDependent: anObject ! tempDependents !
      tempDependents <- self dependents.
      
      (tempDependents includes: anObject)
        ifFalse: [self myDependents: (tempDependents copyWith: anObject)].
      
      ^ anObject
|
   removeDependent: anObject ! tempDependents !
      tempDependents <- self dependents reject: [:each | each == anObject].

      self myDependents: (tempDependents isEmpty 
                            ifFalse: [tempDependents]
                         ).

      ^ anObject
   
]
