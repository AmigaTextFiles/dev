" ------------------------------------------------------------------- "
" Library Class is temporarily derived from Object.                   "
""
" WARNING:  The following methods are NOT really necessary for your   "
"           use: "
""
"   addLibrary:                            "
"   makeLibrary:struct:init:size:segments: "
"   removeLibrary:                         "
"   setFunctionIn:at:to:                   "
"   sumLibrary:                            "
" ------------------------------------------------------------------- "

Class Library :Object ! private libName !
[
   makeLibrary: funcInitObj struct: structInitObj init: libInitFuncObj 
                              size: dataSize      segments: segList

      " Ordinary users should use openLibrary:version: or new: instead! "

      ^ <primitive 209 4 27 funcInitObj structInitObj libInitFuncObj dataSize segList>
|
   addLibrary: libraryObj
      " Used after makeLibrary:struct:init:size:segments: method " 
      <primitive 209 4 21 libraryObj>
|
   removeLibrary: libraryObj
      " Only use this method if you used the addLibrary: method "
      <primitive 209 4 22 libraryObj>
|
   setFunctionIn: libraryObj at: funcOffset to: newFuncPtrObj
      " The returned value is the oldFuncPtrObj, which MUST BE 
      * saved so that you can restore the libraryObj back to it's
      * original state.  There is currently NO AmigaTalk method 
      * that can create a funcPtrObj, so DO NOT USE THIS METHOD!
      "
      ^ <primitive 209 4 23 libraryObj funcOffset newFuncPtrObj>
|
   sumLibrary: libraryObj
      <primitive 209 4 24 libraryObj>
|
   getLibraryObject
     ^ private
|
   openLibrary: libraryName version: ver
     private <- <primitive 190 1 libraryName ver>.

     libName <- libraryName.

     ^ self
|
   close

     <primitive 190 0 private>.
     
     <primitive 250 5 0 private>.
     
     ^ nil
|
   getIDString
     ^ libName
|
   getVersion
     ^ <primitive 190 2 4 private>
|
   getNegSize
     ^ <primitive 190 2 1 private>
|
   getPosSize
     ^ <primitive 190 2 2 private>
|
   getFlags
     ^ <primitive 190 2 3 private>
|
   getRevision
     ^ <primitive 190 2 5 private>
|
   getCheckSum
     ^ <primitive 190 2 6 private>
|
   getOpenCount
     ^ <primitive 190 2 7 private>
|
   new: libname

     self openLibrary: libname version: 0.

     ^ self
] 
