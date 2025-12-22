" -----------------------------------------------------------------
  Class BufferedValueHolder is a wrapper for a ValueModel (the 
  subject).  Clients see the current value of the subject until 
  value: provides a new value.  The new value is not provided to 
  the subject until the application directs it via a setting the 
  triggerChannel value to true.  The buffered value may be discarded 
  by setting the trigger channel value to false.

  Instance Variables:
     subject <ValueModel> The ultimate source/destination of the value.
     
     triggerChannel <ValueModel> When this changes, push the current
                                 value down to the subject.  If the
                    value is equal to notYetAssigned, do nothing.

   Class Variables:
     notYetAssigend <Object> A distinguished value used to 
                             indicate that value has not been set.

   A BufferedValueHolder is used to hold a temporary copy of the 
   value in another valueModel (known as the subject).  The 
   application modifies the temporary copy, but the Buffered-
   ValueHolder only gives this temporary value to its subject when 
   the application confirms the changes.  The application also has 
   the option of canceling the changes, resetting the temporary 
   copy to the subject's value. 

   For example, suppose the application provides a series of input
   fields for entering customer name, address, phone, etc., but we 
   only want the Customer object to be updated after the user has 
   finished entering data and has indicated completion by clicking 
   on an OK button.  This technique is often used in database 
   applications, to postpone updating the customer record in the 
   database until all changes to that record are completed.  In this
   application, the customer's old address would likely be held by 
   an AspectAdaptor on the Customer object.  The aspect adaptor would 
   become the subject of a BufferedValueHolder.  The Buffered-
   ValueHolder would make a temporary copy of the customer's address 
   and make that value available to the input field for editing. 
   The user could change the address, but so far only the temporary 
   copy has been altered.  Only when the users clicks on 'OK' does 
   the application notify each field's BufferedValueHolder to replace 
   the corresponding value in the Customer object. 
   
   A BufferedValueHolder is created by sending a #subject:triggerChannel: 
   message to this class.  The subject is a valueModel containing the 
   data value.  The triggerChannel is a ValueHolder containing the 
   boolean object false.  Later, when the user clicks on 'OK', the 
   application can cause the temporary copy to become the subject's 
   value by setting the triggerChannel's value to true.  The 
   application can also cancel any edits, by setting the trigger-
   Channel's value to false.  Note that the prior value in the 
   triggerChannel is not significant -- setting the value to true 
   when it is already true has the same effect as if it were 
   previously false. 
   
   By using the same triggerChannel for all of the Buffered-
   ValueHolders, the application can cause them all to be updated 
   at the same time.  This is the usual arrangement for a set of 
   related widgets. 
  ------------------------------------------------------------------
"

" ------------------------------------------------------------------ "
" This class exists because Little Smalltalk does not have Class     "
" variables available.                                               " 
" ALL singleton classes MUST contain the following:                  "
""
"   the methods:  isSingleton AND privateSetup     AND               "
"                 uniqueInstance Class instance variable.            "
" ------------------------------------------------------------------ "

Class BVHGlobalVar :Object ! uniqueInstance !
[
   isSingleton
     
      ^ true
|
   privateNew

     ^ super new
|
   new
     ^ (self privateSetup)
|
   privateSetup

     (uniqueInstance isNil)
       ifTrue: [uniqueInstance  <- self privateNew ].
       
     ^ self
|
   notYetAssigned

      ^ uniqueInstance
|
   notYetAssigned: aBoolean

      uniqueInstance <- aBoolean
]

Class BufferedValueHolder :ValueHolder 
! value subject triggerChannel na !
[
   subject: aSubject triggerChannel: aTrigger
      " Create a new BufferedValueHolder which provides buffering
      * for the ValueModel aSubject, and which pushes the buffered
      * value into the subject when the ValueModel aTrigger changes.
      "
      ^ (self new)
                 subject: aSubject;
          triggerChannel: aTrigger
|
   initialize

      na    <- BVHGlobalVar new.

      super initialize.

      value <- na notYetAssigned
|
   releaseParts

      " Remove the receiver as dependents of the triggerChannel
      * and subject.
      "
      (triggerChannel notNil)
         ifTrue: [ triggerChannel removeDependent: self ].

      (super dependents notNil)
         ifTrue: [ self unhookFromSubject ].

      super releaseParts
|
   subject

      " The subject of our adapting logic.  The saved value will
      * be sent to the subject when the trigger channel indicates
      * that it is time to do so.
      "
      ^ subject
|
   subject: aValueModel

      " The subject is the actual respository for the value
      * held in this object.
      "
      (subject notNil and: [super dependents notNil])
          ifTrue: [ self unhookFromSubject ].

      subject <- aValueModel.

      self value: na notYetAssigned.

      (subject notNil and: [super dependents notNil])
          ifTrue: [ self hookupToSubject ]
|
   triggerChannel
      " The object we depend on which sends an update message
      * when the saved value should be inserted into the subject.
      "
      ^ triggerChannel
|
   triggerChannel: aValueModel
      " An object to depend on which will send an update message
      * to trigger the copy of the saved value to the subject.
      "
      (triggerChannel notNil)
         ifTrue: [ triggerChannel removeDependent: self ].

      triggerChannel <- aValueModel.

      (triggerChannel notNil)
         ifTrue: [ triggerChannel addDependent: self ]
|
   value

      " Answer the current value. "

      (value == na notYetAssigned)
         ifTrue: [ ^ subject value ]
        ifFalse: [ ^ value ]
|
   valueUsingSubject: aSubject

      ^ subject valueUsingSubject: aSubject
|
   addDependent: anObject

      " Add anObject as one of the receiver's dependents. "

      (super dependents == nil) 
         ifTrue: [self hookupToSubject].

      ^ super addDependent: anObject
|
   removeDependent: anObject

      " Remove the argument, anObject, as one of the
      * receiver's dependents.
      "
      super removeDependent: anObject.
      
      (super dependents == nil) 
         ifTrue: [self unhookFromSubject].
      
      ^ anObject
|
   changedTrigger

      " Process the trigger notification. "
      " Unhooking and rehooking the subject prevents 
      * dependency notification being propogated thru this object.
      * The dependents of this object have already been informed
      * of the current value.
      "
      " There's nothing to do if no new value has been set
      * since the last trigger.
      * Save or reset?
      "
      (self triggerChannel value)
      
         ifTrue: [ " Send the buffered value to the subject. "
                   (value == na notYetAssigned) 
                      ifTrue: [ ^ self ].
                   
                   self unhookFromSubject.
                   self subject value: value.
                   
                   value <- na notYetAssigned.
                   self hookupToSubject ]

        ifFalse: [ " Reset the buffered value to show thru the
                   * subject's value.
                   "
                   value <- na notYetAssigned.
                   
                   super dependents update: #value 
                                      with: #reset 
                                      from: self   ]
|
   hookupToSubject

      " Add the receiver as a dependent of the
      * receiver's subject.
      "
      subject addDependent: self
|
   renderingValueUsingSubject: aSubject

      ^ subject renderingValueUsingSubject: aSubject
|
   unhookFromSubject

      " Remove the receiver as a dependent of the
      * receiver's subject.
      "
      subject removeDependent: self
|
   update: anAspect with: parameters from: anObject

      (anObject == triggerChannel)

         ifTrue: [ self changedTrigger ]

        ifFalse: [ (anObject == subject)
                   ifTrue: [ (value == na notYetAssigned) 
                             ifTrue: [ super dependents update: anAspect 
                                             with: parameters 
                                             from: self ] ]
 
                  ifFalse: [ super update: anAspect 
                                     with: parameters 
                                     from: anObject ] ]
|
   isBuffering

      " Answer true if a value is being buffered "

      ^ value ~~ na notYetAssigned
]
