" ------------------------------------------------------------------- "
" Intuition Class is a Singleton class that allows the user to        "
" reference intuition-specific Tags & Flags in one spot.              "
""
" ALL singleton classes MUST contain the following:                   "
""
"   the methods:  isSingleton AND privateSetup     AND                "
"                 uniqueInstance Class instance variable.             "
" ------------------------------------------------------------------- "

Class Intuition :Object ! uniqueInstance private0 private1 myName !
[
   isSingleton

     ^ true  
|
   privateNew ! newInstance !
   
    newInstance <- <primitive 110 1>. " Object does NOT respond to new "
    
    ^ newInstance  
|
   new

     ^ (self privateSetup)
|
   privateSetup

     (uniqueInstance isNil)
       ifTrue: [ uniqueInstance <- self privateNew.
                
                 myName         <- 'AmigaTalk:prelude/listFiles/Intuition.dictionary'.

                 private0       <- <primitive 206 3>.

                 private1       <- <primitive 206 1 myName private0>. ].

     ^ self
|
   close     " Remove, Kill, Destroy, Burn the Bridge, etc! "

     private1   <- <primitive 206 0 private1 private0>.
     
     ^ private0 <- nil.
|
   systemTag: aSymbol

     " Search for aSymbol in the SystemDictionary & return it's
     * associated value:
     " 
     ^ <primitive 206 2 private0 aSymbol>
|
   printString

     ^ 'Intuition'  " myName "
]
