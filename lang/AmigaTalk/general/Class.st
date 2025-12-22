" ----------------------------------------------------------"
" Added getByteArray: methodString  method on 09/26/98.     "
"-----------------------------------------------------------"

Class Class
[
  edit

    <primitive 150 self>
|
  list

    <primitive 157 self>
|
  basicNew        ! superclass newinstance !

    amigatalk tracingOff.
    
    superclass <- <primitive 151 self>.         " Get the Parent Class. "

    <primitive 3 superclass>                    " Parent respondsTo: new?? "
      ifTrue: [newinstance <- superclass new].

    newinstance <- <primitive 153 self newinstance>. "Make a new instance"

    <primitive 155 self #new>                   "new object respondsTo: new???" 
      ifTrue: [newinstance <- newinstance new].

    amigatalk tracingOn.
    
    ^ newinstance
|
  new ! newObject test !

    amigatalk tracingOff.
    
    (<primitive 91 #Singleton_Class <primitive 250 4 0 self>>)

       ifTrue: [ " This Class is a Singleton Class, so see if it's
                 * been initialized yet:
                 "
                 test <- <primitive 250 4 3 self>.
        
                 (test == nil)
                   ifTrue: [ " Initialize this Singleton Class: "
                             newObject <- self basicNew.

                             <primitive 250 4 4 self newObject>.

                             ^ newObject
                           ].

                 " Singleton Class is already initialized: "
                 ^ test
               ].

    " This Class is an Ordinary Class: "
    amigatalk tracingOn.

    ^ self basicNew 
|
  basicNew: aValue  ! superclass newinstance !

    amigatalk tracingOff.
    
    superclass <- <primitive 151 self>.

    <primitive 3 superclass>
      ifTrue: [newinstance <- superclass new ]. 

    newinstance <- <primitive 153 self newinstance>.

    <primitive 155 self #new:>
      ifTrue: [newinstance <- newinstance new: aValue].

    amigatalk tracingOn.
    
    ^ newinstance
|
  new: aValue ! newObject test ! 

    amigatalk tracingOff.
    
    (<primitive 91 #Singleton_Class <primitive 250 4 0 self>>)

       ifTrue: [ " This Class is a Singleton Class, so see if it's
                 * been initialized yet:
                 "
                 test <- <primitive 250 4 3 self>.
        
                 (test == nil)
                   ifTrue: [ " Initialize this Singleton Class: "
                             newObject <- self basicNew: aValue.
                             
                             <primitive 250 4 4 self newObject>.
                             
                             ^ newObject
                           ].

                 " Singleton Class is already initialized: "
                 ^ test
               ].
       
    " This Class is an Ordinary Class: "
    amigatalk tracingOn.
    
    ^ self basicNew: aValue
|
  printClassString

    ^ <primitive 152 self>
|
  respondsTo

    <primitive 154 self>
|
  respondsTo: aSymbol ! aClass !

    aClass <- self.

    [aClass notNil] 
       whileTrue: [ <primitive 155 aClass aSymbol> 
                     ifTrue: [ ^ true ].
             
                    aClass <- aClass superClass ].
    ^ false
|
  superClass

    ^ <primitive 151 self>
|
  variables

    ^ <primitive 158 self>
|
  view

    <primitive 156 self>
|
  getByteArray: methodString

    ^ <primitive 159 self methodString> "159 was an unused primitive."
]
