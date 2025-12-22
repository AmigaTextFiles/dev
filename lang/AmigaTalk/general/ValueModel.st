" ---------------------------------------------------------------------
 I am a simple Model that provides direct access to some kind of value.  
 I notify dependents when the value changes.
 The collection accessing protocol is here as a convenience, to 
 avoid some of the need for special collection models.

 Subclasses must implement the following messages:
	accessing
		value
		setValue:


 Object Reference:

 ValueModel is an abstract class that provides model-like abilities for 
 an enfolded object -- that is, it notifies dependent objects whenever 
 its held object is changed. 
 Value models are most commonly used to hold data models on which widgets 
 such as input fields depend.  To understand why a value model is needed, 
 take the case of an input field that displays a number.  The input 
 field needs to be notified whenever the application changes the number, 
 so it registers itself as a dependent of the number.  If that dependency 
 were established on the raw number, however, the dependency would be 
 obsolete as soon as the application substituted a different number, 
 defeating its purpose.  Instead, a value model is used to hold the 
 number, and the input field registers itself as a dependent of the 
 value model.  The application can insert a new number and the value 
 model then notifies the input field of the change so the field can 
 get the new number and display it.  Since the value model remains in 
 place while its value is changed, the dependency that was established 
 by the input field remains alive as long as the application is running. 
 The most commonly used subclass of ValueModel is ValueHolder, which 
 would be used in the simple case described above.  Because value 
 holders are widely used, every object inherits from the Object class 
 the ability to enfold itself in a value holder -- sending #asValue to 
 any object returns a ValueHolder on the object.  A consequence of 
 inserting a value holder as an adaptor or mediator between a data object 
 and its dependents is that you must send #value to the value model, 
 thus extracting the enfolded object, before you can send a message 
 to that object.  For example, suppose the numeric input field mentioned 
 above uses an instance variable named salesCommission to hold its 
 ValueHolder.  If the application wanted to retrieve the actual number 
 for use in a computation, it would use the expression 'self 
 salesCommission value' instead of simply 'self salesCommission.'  The 
 fact that a value model always gets its enfolded object in response to 
 #value, and sets that value in response to #value:, simplifies 
 communications for widgets.  Another commonly used subclass of ValueModel 
 is AspectAdaptor, which is used to enfold an embedded value.  For 
 example, suppose we have an AccountNumber class that has a string part 
 and a number part, for a composite account number such as 'TEL-4792'. 
 We might want to use a separate input field for each part of this 
 account number.  One AspectAdaptor could be used to enfold the string part, 
 and another the numeric part.  The most flexible subclass of ValueModel 
 is PluggableAdaptor, because it can be configured to transform the value 
 on its way to and from the dependent.  While the TypeConverter subclass 
 provides commonly used transformations, such as number-to-string, 
 PluggableAdaptor can be configured with blocks to perform highly 
 specialized transformations.  Other subclasses of ValueModel are more 
 specialized.  A BufferedValueHolder is used to hold a working copy of 
 the value as well as a confirmed copy.  A BlockValue enables a computation 
 inside a block to have dependents.  An IndexedAdaptor enfolds an element 
 in a collection.  A PrintConverter transforms its enfolded value to and 
 from its printed form.  A RangeAdaptor enfolds an interval of numbers, 
 and is chiefly used by slider widgets.  SlotAdaptor and 
 DependencyTransformer are mainly used by system machinery.  A ValueModel 
 provides a convenient way for an application to arrange to receive a 
 particular message whenever the value is changed.  Making such an 
 arrangement is known as expressing an interest in the value, and 
 involves sending #onChangeSend:to:.  Retracting an interest is
 achieved via #retractInterestsFor:.  When creating a subclass, equip 
 it with the following methods: 
	Instance protocol 
		value 
		setValue: 
---------------------------------------------------------------------------
"

Class ValueModel :Model
[
   new
     ^ super new initialize
|
   initialize
     "Initialize the instance.  Subclasses may extend this."

     ^ self
|
   dependents
     ^ super dependents
|
   release
     self releaseParts.

     super release
|
   releaseParts
     " Break the dependency links from any parts of myself to myself.
     * Subclasses holding composite values will implement this in 
     * a non-trivial way. 
     "
     ^ nil
|
   setValue: newValue
     " Set the currently stored value, without notifying dependents. "

     self subclassResponsibility: 'setValue:'
|
   value
     " Answer the currently stored value. "

     ^ self subclassResponsibility: 'value'
|
   value: newValue
     " Set the currently stored value, and notify dependents."

     self setValue: newValue.
     self changed: #value
|
   valueUsingSubject: aSubject

     ^ aSubject value
|
   asValue
     " Since the receiver is already a ValueModel, merely return self."

     ^ self
|
   onChangeSend: aSymbol to: anObject 
     " Arrange for anObject to receive a message named aSymbol when 
     * I signal that my attribute #value has changed.
     "

     self expressInterestIn: #value for: anObject sendBack: aSymbol

|
   retractInterestsFor: anObject 
     " Undo a send of onChangeSend:to:."

     self retractInterestIn: #value for: anObject
|
   compute: aBlock 
     " Answer a BlockValue that computes aBlock with the receiver's value 
     * as the argument. aBlock will become a dependent of the receiver, 
     * and will be sent the message value: when the receiver is sent the 
     * message value:.
     "

     ^ BlockValue block: aBlock arguments: (Array with: self)
|
   receive: aSelector 
     " Answer a BlockValue that responds to the message value by sending 
     * aSelector as a message to the receiver. This BlockValue will become a 
     * dependent of the receiver, and will be sent the message value: when 
     * the receiver is sent the message value:.
     "

     ^ BlockValue block: [:rcvr | rcvr perform: aSelector] arguments: (Array with: self)

|
   receive: aSelector with: value1 
     " Answer a BlockValue that responds to the message value by sending 
     * aSelector as a message to the receiver. This BlockValue will become a 
     * dependent of the receiver, and will be sent the message value: when 
     * the receiver is sent the message value:. The message aSelector has 
     * one argument, value1. It is assumed that value1 itself responds to 
     * the message value (i.e., may be a kind of ValueModel)."

     ^ BlockValue block: [:rcvr :arg1 | rcvr perform: aSelector with: arg1]
              arguments: (Array with: self with: value1)

|
   with: value2 compute: aBlock 
     " Answer a BlockValue that computes aBlock with the receiver and 
     * value2 as the first and second arguments, respectively. This 
     * BlockValue will become a dependent of the receiver, and will be sent 
     * the message value: when the receiver is sent the message value:. It 
     * is assumed that value2 itself responds to the message value (i.e., 
     * may be a kind of ValueModel).
     "
     ^ BlockValue block: aBlock arguments: (Array with: self with: value2)

|
   with: value2 with: value3 compute: aBlock 
     " Answer a BlockValue that computes aBlock with the receiver, value2, 
     * and value3 as the first, second and third arguments, respectively. 
     * This BlockValue will become a dependent of the receiver, and will be 
     * sent the message value: when the receiver is sent the message 
     * value:. It is assumed that the objects value2 and value3 respond to 
     * the message value (i.e., may be a kind of ValueModel).
     "

     ^ BlockValue block: aBlock arguments: (Array with: self with: value2 with: value3)
|
   isBuffering
     " ValueModels by default do not buffer values, only special
     * subclasses who should reimplement this message for themselves.
     "
     ^ false
]
