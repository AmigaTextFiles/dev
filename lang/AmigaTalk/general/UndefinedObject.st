"----------------------------------------------------------------"
"'nil' Should be the only Undefined Object in the system.        "
"----------------------------------------------------------------"

Class UndefinedObject :Object
[
   isNil
     ^ true
|
   notNil
     ^ false
|
   ifNil: aBlock
     ^ aBlock value 
|
   printString
     ^ 'nil'
]
