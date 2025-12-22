" ---------------------------------------------------------------------
  ValueHolder is a very simple Model, no more than a value 
  holder with updates.

  Instance variables:
	value  <Object> the current value


  Object Reference:
  A ValueHolder is the simplest value model. It merely holds a value, 
  and notifies the dependents of that value whenever it is changed. 
  A ValueHolder is widely used to enfold the strings, numbers and 
  other data objects that are displayed in widgets.  For this reason, 
  every object has been made capable of enfolding itself in a ValueHolder 
  when it receives an #asValue message.  ValueHolder also provides both 
  general and specialized creation messages for enfolding a given value.
  ValueHolder has several specialized subclasses.  BufferedValueHolder 
  is the most general and reusable subclass -- it holds a working 
  copy of the value as well as a confirmed copy, for situations in 
  which the application must be prepared to undo a change in the 
  value until a confirmation step has been taken. 
 ----------------------------------------------------------------------
"

Class ValueHolder :ValueModel ! value !
[
   dependents

     ^ super dependents
|     
   newBoolean
     " Answer a new instance, initialized to false. "

     ^self with: false
|
   newFraction
     " Answer a new instance, initialized to 0.0. "

     ^ self with: 0.0
|
   newString
     " Answer a new instance, initialized to an empty string. "

     ^ self with: (String new: 0)
|
   with: initialValue
     " Answer a new instance, initialized to the given value. "

     ^ self new setValue: initialValue
|
   setValue: aValue
     " Just initialize the value without notifying
     * dependents of a change. 
     "

     value <- aValue

|
   value
     ^ value
|
   printOn: aStream 
     "Let what is printed reflect the value of the receiver."

     super printOn: aStream.

     aStream nextPutAll: ' on: '; print: self value
]
