" -------------------------------------------------------------------
  Class ProtocolAdaptor is an abstract class that introduces the 
  concept of a ValueModel which redirects the value and value: 
  messages to another object (the subject) and adds lazy dependency.  
  Lazy dependency means that the ProtocolAdaptor will only register 
  itself as a dependent of the subject if it has at least one dependent 
  and the subject will send update messages.  Subclasses which implement 
  value: are responsible for sending update messages if the subject 
  does not send update messages. 

  ProtocolAdaptors can have a collection of object used to transform 
  the subject into the 'target' which subclasses then operate on.

  A ProtocolAdaptor has either a constant or variable subject.  The 
  constant subject is initialized with the subject: or 
  subject:sendsUpdates: messages.  A variable subject is commonly used 
  when a set of adaptors all adapt a different part of the same subject 
  or the subject is changed after initialization.  A variable subject 
  requires the use of a ValueModel to inform the ProtocolAdaptor of the 
  new subject and is initialized using the subjectChannel: or 
  subjectChannel:sendsUpdates: messages.

  Dependents are notified of the value changing when the subject is changed.

    Instance Variables:
      subject              <Object> The object we're adapting.
      subjectSendsUpdates  <Boolean> When this is set to true, it is 
                                     assumed that the subject will 
        send update notices and we'll pass them on to our dependents 
        when received.  When set to false, the adaptor generates the 
        update notice to the dependents of the adaptor.  The lazy dependency
        mechanism avoids double-notificaton of dependents when the subject 
        does send updates.
   
      subjectChannel       <ValueModel> When this sends a change notice, 
                                        update the subject.

      accessPath    <SequencableCollection | nil> holds accessors to turn 
                                             the subject into the target


  Object Reference:
  ProtocolAdaptor is an abstract class that provides its subclasses with 
  the ability to get and set an embedded value in an object other than 
  the application model, such as an instance variable in a domain model. 
  Each such adaptor has a subject, which is typically a composite domain 
  model, and specialized value-getting and -setting messages for extracting 
  the desired value from the subject. 
  For example, suppose you are creating a canvas containing one input 
  field for each part of a Customer object: accountNumber, name, company, 
  address, and so on.  Since the accountNumber is held by a Customer 
  object rather than by the application model, an ordinary ValueHolder 
  offers no help in accessing it.  While you can create a duplicate 
  accountNumber variable in the application model, and charge the 
  application model with the responsibility of updating the Customer 
  object whenever the input field is changed, this is cumbersome, 
  especially for a large number of such fields.  A ProtocolAdaptor (in this 
  case, an AspectAdaptor) enables you to cut out the middle man by 
  getting and setting the accountNumber in the Customer object directly. 
  In this case, the Customer would be the subject of several 
  AspectAdaptors -- one adaptor translates #value and #value: into 
  #accountNumber and #accountNumber:, another adaptor manages the 
  customer name, and so on. 
  The subject can be changed during the life of an adaptor -- for 
  example, a new instance of Customer can become the focus of the adaptor's 
  inquiries.  When a change of subject is likely, it is most economical 
  to first enfold the subject in a value holder.  This value holder is 
  known as a subject channel, because it provides a channel to the subject. 
  In that case, the adaptor would be created via a #subjectChannel: 
  message rather than a #subject: message.  In the example, instead of 
  storing a Customer object in an instance variable of the application 
  model, we would store a value holder containing the Customer object. 
  Because both the adaptor and its subject are capable of sending 
  #update:with:from: messages to the same dependent, it is sometimes 
  necessary to disable the adaptor's update facility.  This is usually 
  done at instance creation time, via a #subjectSendsUpdates: message. 
  By default, the adaptor assumes that the subject does not send redundant 
  update messages. 
  ProtocolAdaptor is actually capable of extracting a value that is 
  deeply embedded in the subject.  For example, suppose the Customer 
  holds an AccountNumber object, which holds an AccountPrefix object, 
  which holds a prefixCharacter and a prefixNumber.  The AspectAdaptor 
  for the prefixNumber would need to send #accountNumber to the address, 
  then send #accountPrefix to the account number.  This series of messages 
  is called the access path, and is initialized via #accessPath:. 
  AspectAdaptor is the most commonly used subclass of ProtocolAdaptor. 
  IndexedAdaptor is used to access an element in a collection. 
  When creating a subclass, equip it with the following methods: 

     Instance protocol 
       setValueUsingTarget:to: 
       valueUsingTarget: 

  A subclass that implements #value: is responsible for sending an 
  update message if its subject does not send one. 
  ------------------------------------------------------------------------
"

Class ProtocolAdaptor :ValueModel
! subject subjectSendsUpdates subjectChannel accessPath !
[
   dependents
     ^ super dependents
|     
   accessPath: aSequenceableCollection
     " Answer a new instance of the receiver with accessPath
     * aSequenceableCollection.
     "
     ^ self new setAccessPath: aSequenceableCollection
|
   new
     ^ super new initialize
|
   subject: aSubject
     " Answer a new ProtocolAdaptor with a constant subject 
     * (aSubject).  By default, the ProtocolAdaptor's subject 
     * does not send update notices to its dependents.
     * Note:  For a ProtocolAdaptor which will change subjects
     * frequently, or a group of ProtocolAdaptors which should 
     * all share a subject and change at the same time, 
     * subjectChannel: provides a convenient interface.
     "
     ^ self subject: aSubject sendsUpdates: false
|
   subject: aSubject accessPath: aSequenceableCollection
     " Create and initialize the ProtocolAdaptor. "

     ^ (self accessPath: aSequenceableCollection) subject: aSubject
|
   subject: aSubject sendsUpdates: aBoolean
     " Answer a new ProtocolAdaptor with a constant subject 
     * (aSubject).  This ProtocolAdaptor will send update 
     * messages when the value changes if aBoolean is false.
     * Note:  For a ProtocolAdaptor which will change subjects
     * frequently, or a group of ProtocolAdaptors which should 
     * all share a subject and change at the same time, 
     * subjectChannel:sendsUpdates: provides a convenient interface.
     "
     ^ (self new) setASubject: aSubject; subjectSendsUpdates: aBoolean
|
   subject: aSubject sendsUpdates: aBoolean 
                       accessPath: aSequencableCollection
     " Create and initialize the ProtocolAdaptor. "

     ^ (self accessPath: aSequencableCollection) 
                subject: aSubject;
             subjectSendsUpdates: aBoolean
|
   subjectChannel: aValueModel
     " Answer a new ProtocolAdaptor with a variable subject 
     * (aValueModel is the subject channel) to notify it of 
     * changes in the subject.  By default, the   ProtocolAdaptor's 
     * subject does not send update notices to its dependents.
     * Note:  A ProtocolAdaptor which will not change subjects
     * does not need to   use a subject channel.  It is more 
     * efficient and convenient to set the subject using subject:
     "
     ^ self subjectChannel: aValueModel sendsUpdates: false
|
   subjectChannel: aValueModel accessPath: aSequenceableCollection

     ^ (self accessPath: aSequenceableCollection) subjectChannel: aValueModel
|
   subjectChannel: aValueModel sendsUpdates: aBoolean
     " Answer a new ProtocolAdaptor with a variable subject
     * (aValueModel is the subject channel) to notify it of 
     * changes in the subject.  The ProtocolAdaptor will send 
     * update messages when the value changes if aBoolean is false.
     * Note:  A ProtocolAdaptor which will not change subjects 
     * does not need to use a subject channel.  It is more 
     * efficient and convenient to set the subject
     * using subject:sendsUpdates:
     "
     ^ (self new) subjectSendsUpdates: aBoolean; subjectChannel: aValueModel
|
   subjectChannel: aValueModel sendsUpdates: aBoolean 
       accessPath: aSequenceableCollection

     ^ (self accessPath: aSequenceableCollection)
             subjectSendsUpdates: aBoolean;
             subjectChannel: aValueModel
|
   initialize

     super initialize.

     subjectSendsUpdates <- false
|
   releaseParts
     " Remove the receiver as a dependent of the receiver's subject. "

     (subject notNil and: [super dependents notNil])
         ifTrue:   [ self unhookFromSubject ].
   
     (subjectChannel notNil)
         ifTrue:   [subjectChannel removeDependent: self].
|
   subject
     " Answer the current subject. "

     ^ subject
|
   setASubject: anObject ! sc !
     " Set the subject to be anObject.  Send an update since the value has
     * probably changed too.  If this ProtocolAdaptor has a subject channel,
     * delegate setting the new subject to it so that others depending 
     * on the same subject channel value model will be informed automatically.
     * Note:  For a ProtocolAdaptor which will change subjects frequently,
     * or a group of ProtocolAdaptors which should all share a subject and
     * change at the same time, subjectChannel: provides a convenient interface.
     "
     ((sc <- self subjectChannel) notNil)
         ifTrue:   [ sc value: anObject ]
        ifFalse:   [ self setSubject: anObject ]
|
   setSubject: anObject
     " Set the subject to be anObject.  Send an update since the
     * value has probably changed too.
     "

     (subject notNil and: [super dependents notNil])
        ifTrue:   [ self unhookFromSubject ].

     subject <- anObject.

     (subject notNil and: [super dependents notNil])
        ifTrue:   [ self hookupToSubject ].

     super dependents update: #value with: nil from: self
|
   subjectChannel
     " Answer the ValueModel used to provide new subjects."

     ^ subjectChannel
|
   setSubjectChannel: aValueModel
     " Set or change the ValueModel we depend on to provide the latest subject.
     * In the rare cases where the subject channel needs to be reinitialized an
     * update message is sent on the assumption that the value has changed.
     "
     (subjectChannel notNil)
        ifTrue:   [ subjectChannel removeDependent: self ].

     subjectChannel <- aValueModel.
 
     (subjectChannel notNil)
        ifTrue:   [ subjectChannel addDependent: self ].

     self changedSubject
|
   subjectSendsUpdates
     " Does our subject send updates to its dependents?"

     ^ subjectSendsUpdates
|
   subjectSendsUpdates: aBoolean
     " Set or change the nature of the subject.
     * If the subject does not send updates, we 
     * won't bother to depend on it.
     "
     (subject notNil and: [super dependents notNil])
        ifTrue:   [ self unhookFromSubject ].

     subjectSendsUpdates <- aBoolean.

     (subject notNil and: [super dependents notNil])
        ifTrue:   [ self hookupToSubject ]
|
   accessPath
     " Answer the receiver's accessPath.  This is a collection
     * of accessors used to turn the receiver's subject into 
     * the target for messages.
     "
     ^ accessPath
|
   setAccessPath: aSequenceableCollection
     " Set the receiver's accessPath to be aSequenceableCollection.
     * This will be used to turn the subject into the target.
     "

     accessPath <- aSequenceableCollection.
|
   setValue: newValue
     " Set a new value using the reciever's target."

     self setValueUsingTarget: self target to: newValue
|
   target
     " Answer the receiver's target for operations.
     * If there is an accessPath it will hold accessors that 
     * will be used to turn the subject into the target.
     "

     ^ self targetUsingSubject: subject
|
   value
     " Answer the value returned by sending the receiver's 
     * retrieval (get) selector to the receiver's target.
     "

     ^ self valueUsingSubject: subject
|
   value: newValue
     " Set the currently stored value, and notify dependents. "

     self setValue: newValue.
    
     (subjectSendsUpdates = true)
        ifFalse: [self changed: #value ]
|
   valueUsingSubject: aSubject
     " Answer a value for the subject if aSubject were the receiver's subject."

     ^ self valueUsingTarget: (self targetUsingSubject: aSubject)
|
   addDependent: anObject
     " Add anObject as one of the receiver's dependents."

     (super dependents == nil)
        ifTrue: [self hookupToSubject].
  
     ^ super addDependent: anObject
|
   removeDependent: anObject
     " Remove the argument, anObject, as one of the receiver's dependents."

     super removeDependent: anObject.
  
     (super dependents == nil)
        ifTrue: [self unhookFromSubject].
   
     ^ anObject
|
   update: anAspect with: parameters from: anObject
     " If the update is from the subjectChannel, it must be because
     * there is a new subject.
     "
     (anObject == subjectChannel)
        ifTrue: [self changedSubject]
|
   isProtocolAdaptor
     " Answer as to whether the receiver transduces protocol
     * into ValueModel protocol.
     "
     ^ true
|
   printOn: aStream

     super printOn: aStream.
     
     aStream nextPut: $(.
     
     self target printOn: aStream.
     
     aStream nextPut: $).
|
   printPathOn: aStream ! path !

     ((path <- self accessPath) notNil and: [path isEmpty not])
        ifTrue: [path do: [:elt | (elt isSymbol)
                                    ifTrue: [aStream nextPutAll: elt]
                                   ifFalse: [elt printOn: aStream].

                            aStream space ] ].
|
   access: anObject with: anAccessor

     ^ (anAccessor isSymbol)
         ifTrue:  [anObject perform: anAccessor]
         ifFalse: [(anAccessor isInteger)
                     ifTrue: [anObject at: anAccessor]
                     ifFalse: [anAccessor value: anObject ] ]
|
   changedSubject
     " The subject has changed. "

     self setSubject: self subjectChannel value
|
   hookupToSubject
     " Add the receiver as a dependent of the receiver's subject."

     (subjectSendsUpdates)
        ifTrue: [(subject notNil)
                   ifTrue: [subject addDependent: self]]
|
   makeAdaptorForRenderingStoreLeafInto: pair

     pair at: 1 put: self.
     self subjectChannel: nil.
   
     ^ (subject isProtocolAdaptor)
         ifTrue: [subject <- subject copy.
                  subject makeAdaptorForRenderingStoreLeafInto: pair]
        ifFalse: [pair]
|
   renderingValueUsingSubject: aSubject ! pair cpy cell !

     (subject isProtocolAdaptor)
        ifFalse: [^self valueUsingSubject: aSubject].

     cpy  <- self copy.
     pair <- Array new: 2.

     pair at: 2 put: cpy.

     cell <- cpy makeAdaptorForRenderingStoreLeafInto: pair.

     cell first subjectChannel: aSubject asValue.

     ^ cell last value
|
   setValueUsingTarget: anObject to: newValue
     "Using anObject set a new value."
  
     ^ self subclassResponsibility: 'setValueUsingTarget:to:'
|
   targetUsingSubject: aSubject ! obj path !

     obj <- aSubject.
     path <- self accessPath.

     1 to: path size do: [:i | (obj == nil)
                                 ifTrue: [^nil].

                           obj <- self access: obj with: (path at: i)].
     ^ obj
|
   unhookFromSubject
     " Remove the receiver as a dependent of the receiver's subject. "

     (subjectSendsUpdates)
        ifTrue: [subject removeDependent: self]
|
   valueUsingTarget: anObject   
     " Answer the value returned by using anObject. "

     ^ self subclassResponsibility: 'valueUsingTarget:'
]
