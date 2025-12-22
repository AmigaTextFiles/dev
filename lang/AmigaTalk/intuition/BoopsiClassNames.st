" ------------------------------------------------------------------- "
" BoopsiClassNames Class is a Singleton class that allows the user to "
" reference BOOPSI Class name Strings as Symbols.  The Boopsi Class   "
" will create an instance of this for Boopsi Objects, so you do NOT   "
" have to use this class yourself.                                    "
""
"  EXAMPLE:  'myTag <- boopsiNames at: #IMAGECLASS'                   "
""
" ALL singleton classes MUST contain the following:                   "
""
"   the methods:  isSingleton AND privateSetup     AND                "
"                 uniqueInstance Class instance variable.             "
" ------------------------------------------------------------------- "

Class BoopsiClassNames :Dictionary ! uniqueInstance !
[
   isSingleton

     ^ true  
|  
   privateNew ! newInstance !

     newInstance <- super new.

     ^ newInstance
|
   new

     ^ (self privateSetup)
|
   privateSetup

     (uniqueInstance isNil)
       ifTrue: [ uniqueInstance  <- self privateNew.

                 self privateSetupDictionary.     ].
               
     ^ self
|
   privateSetupDictionary     

     " Class id strings for Intuition classes.  There's no real 
     * reason to use the uppercase constants over the lowercase 
     * strings, but this makes a good place to list the names of
     * the built-in (BOOPSI) classes:
     "
     self at: #ROOTCLASS     put: 'rootclass'.     " classusr.h	  "
     self at: #IMAGECLASS    put: 'imageclass'.    " imageclass.h "
     self at: #FRAMEICLASS   put: 'frameiclass'.
     self at: #SYSICLASS     put: 'sysiclass'.
     self at: #FILLRECTCLASS put: 'fillrectclass'.
     self at: #GADGETCLASS   put: 'gadgetclass'.   " gadgetclass.h "
     self at: #PROPGCLASS    put: 'propgclass'.
     self at: #STRGCLASS     put: 'strgclass'.
     self at: #BUTTONGCLASS  put: 'buttongclass'.
     self at: #FRBUTTONCLASS put: 'frbuttonclass'.
     self at: #GROUPGCLASS   put: 'groupgclass'.
     self at: #ICCLASS       put: 'icclass'.       " icclass.h "
     self at: #MODELCLASS    put: 'modelclass'.
     self at: #ITEXTICLASS   put: 'itexticlass'.
     self at: #POINTERCLASS  put: 'pointerclass'.  " pointerclass.h "
]
