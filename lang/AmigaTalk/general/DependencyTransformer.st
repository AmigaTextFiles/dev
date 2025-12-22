" ----------------------------------------------------------------
  DependencyTransformer transforms update messages from an object 
  into concrete messages to a receiver.
  
  Objects understand:   
   expressInterestIn: anAspect for: anObject sendBack: aSelector  

  by creating a DependencyTransformer that looks for upates on anAspect 
  and sending aSelector to anObject 
  
  retractInterestIn: anAspect for: anObject 
    removes the DependencyTransformer created above.

  ValueModels understand      
    onChangeSend: aSelector to: anObject retractInterestsFor: anObject   
    
    since ValueModels only do changed: #value 
    the aspect can be dropped.
    
    Instance Variables:   
      receiver     <Object>  the object to receive a message on update   
      selector     <Object>  the message selector to send   
      numArguments <Object>  number of arguments in the message selector
      aspect       <Object>  the change aspect to look for 
  ----------------------------------------------------------------
"
Class DependencyTransformer :Object ! receiver selector numArguments aspect !
[
   setReceiver: aReceiver aspect: anAspect selector: aSymbol      
     receiver     <- aReceiver.   
     aspect       <- anAspect.   
     selector     <- aSymbol.   
     numArguments <- selector numArgs.   
     
     numArguments > 2 
        ifTrue: [self error: 'selector expects too many arguments' ] 
|  
   aspect   
     ^ aspect
|
   receiver   
     ^ receiver 
|
   selector   
     ^ selector 
|  
   matches: anObject forAspect: anAspect   
     ^ receiver == anObject and: [aspect == anAspect] 
|  
   update: anAspect with: parameters from: anObject
     (aspect == anAspect) 
       ifFalse: [ ^ self].   
       
     (numArguments == 0) 
       ifTrue: [ ^ receiver perform: selector].   
       
     (numArguments == 1) 
       ifTrue: [ ^ receiver perform: selector with: parameters].   
       
     (numArguments == 2)
       ifTrue: [ ^ receiver perform: selector with: parameters with: anObject] 
|  
   = anObject 
     " Two DependencyTransformers are equivalent if their receiver
     * aspect and selectors are identical.
     "   
     ^ self class == anObject class and: [receiver == anObject receiver 
                                    and: [aspect   == anObject aspect   
                                    and: [selector == anObject selector] ] ] 
|
   hash   
     " Redefined because #= is redefined."   
     ^ (receiver identityHash bitXor: aspect identityHash) bitXor: selector identityHash 
]
