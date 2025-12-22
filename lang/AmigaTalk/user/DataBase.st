" -------------------------------------------------------------------------- "
" DataBase Class is an interface to the dBC III Library of functions         " 
" written by Lattice Inc. for the Amiga.                                     "
" Issue ')i AmigaTalk:User/DataBase.st' from the Single Command Line String  "
" gadget in order to include these Classes into the AmigaTalk environment.   "
""
" Be sure to read (& hopefully understand) the Test files associated with    "
" these Classes!                                                             "
" -------------------------------------------------------------------------- "

Class DataBase :Object 
!
  private      private2           memoPresent    myTemplate   
  recordSize   myCurrentRecordNum howManyRecords currentRecStatus 
  numFields    myCurrentKey       myFileName
!
[
   lastErrorNumber
     ^ <primitive 209 9 3>
|
   numberOfRecords ! chk !

     chk <- <primitive 209 6 8 private>.
     
     (chk < 0)
        ifTrue: [ self printError: (self lastErrorNumber).
                  ^ nil ].
        
     ^ howManyRecords <- chk
|
   recordSize
     ^ recordSize
|
   numberOfFields
     ^ numFields
|
   currentRecordNumber
     ^ currentRecordNum
|
   printError: errNum ! dbErrs !
     dbErrs <- DBErrs new.

     (dbErrs errString: errNum) print.
     
     ^ nil
|
   failCheck: check with: failTest for: methodName
     (failTest)
       ifTrue: [ (methodName, ' method FAILED because:') print.

                 ^ self printError: check ].

     ^ nil
|
   xxxCloseMemoFile ! chk !                           " dBmclose() "
     chk <- <primitive 209 7 0 private2>.

     self failCheck: chk with: (chk ~= 0) for: 'xxxCloseMemoFile'
|
   xxxOpenMemoFile: memoFileName                      " dBmopen() "

     private2 <- <primitive 209 7 2 memoFileName>.

     (private2 isNil) 
       ifTrue: [ (memoFileName, ' FAILED to open!' ) print ]
     
     ^ private2
|
   xxxCreateMemoFile: memoFileName ! chk !            " dBmcreat() "
     chk <- <primitive 209 7 1 memoFileName>.

     self failCheck: chk with: (chk ~= 0) for: 'xxxCreateMemoFile'
|
   cleanup   " NOTE:  This (will be) is a time-consuming operation! "
     ^ nil
|
   restoreInactiveRecord: recordNumber ! chk !
     chk <- <primitive 209 6 9 private recordNumber>.

     self failCheck: chk with: (chk ~= 0) for: 'restoreInactiveRecord:'.
     
     (recordNumber = myCurrentRecordNum)
        ifTrue: [ currentRecStatus <- 0 ]
|   
   inactivateRecord: recordNumber ! chk !
     chk <- <primitive 209 6 11 private recordNumber>.

     self failCheck: chk with: (chk ~= 0) for: 'inactivateRecord:'.
     
     (recordNumber = myCurrentRecordNum)
        ifTrue: [ currentRecStatus <- 1 ]
|
   currentRecordStatus
     (currentRecStatus = 0)
       ifTrue:  [ ^ 'Active'   ]
       ifFalse: [ ^ 'Inactive' ] " (marked for deletion by '*' in DBaseIII) "
|
   getFileInformation ! chk !
     chk <- <primitive 209 6 4 private (self template)>.

     (chk isNil)
       ifTrue: [ self printError: (self lastErrorNumber) ].
       
     ^ chk
|
   create: fileName for: recordTemplate ! chk dbFileName dbMemoName numFields !

     " TESTED & WORKING! "

     currentRecStatus   <- 0.
     howManyRecords     <- 0.
     myCurrentRecordNum <- 0.
     memoPresent        <- false.
     dbFileName         <- (fileName, '.DBF').
     myFileName         <- dbFileName.
     numFields          <- recordTemplate numberOfFields.
     recordSize         <- recordTemplate recordSize.
     myCurrentKey       <- nil.
       
     chk <- <primitive 209 6 1 dbFileName numFields recordTemplate>.
     
     (chk isNil)
        ifTrue: [ ^ nil ].

     private <- chk.
      
     " Check recordTemplate to see if there are any memo fields present "

     (<primitive 209 6 0 recordTemplate> = true)
        ifTrue: [ dbMemoName <- (fileName, '.DBT').

                  memoPresent <- true.
                    
                  self xxxCreateMemoFile: dbMemoName.
                ].
     
     self xxxTemplate: recordTemplate.
     
     ^ private
|
   xxxTemplate: useThisTemplate
     myTemplate <- useThisTemplate
|
   template
     ^ myTemplate
|
   readTemplateFrom: fileName ! chk !
     " Open a .DBF file & read in the Record Field descriptors.
     * Create an instance of DBRecordTemplate & return it if all 
     * is okay, otherwise return nil.  The file is closed after 
     * we are done.  This method is only for existing DataBases!
     "
     chk <- <primitive 209 6 13 fileName 'DBRecordTemplate' >.
     
     (chk isNil)
        ifTrue: [ self printError: (self lastErrorNumber).
                  ^ nil ].
                  
     self xxxTemplate: chk.
     
     ^ chk
|
   open: fileName
     " So, you already filled myTemplate with readTemplateFrom:, right? "

     ^ self open: fileName for: (self template) 
|
   open: fileName for: recordTemplate  ! chk dbFileName dbMemoName !   

     " TESTED & WORKING! "

     currentRecStatus <- 0.
     dbFileName       <- (fileName, '.DBF').

     ((self template) isNil)
        ifTrue: [ self create: fileName for: recordTemplate ].
             
     chk <- <primitive 209 6 2 dbFileName>.
     
     (chk isNil)
       ifTrue: [ self printError: (self lastErrorNumber).
                 ^ nil ].
     
     private     <- chk.  
     memoPresent <- false.

     ((self template) notNil)
        ifTrue: [ memoPresent <- <primitive 209 6 0 (self template)>.

                  (memoPresent)

                  ifTrue: [ dbMemoName <- (fileName, '.DBT').
                   
                            chk <- self xxxOpenMemoFile: dbMemoName.
                   
                            (chk isNil)
                             ifTrue: [ self printError: (self lastErrorNumber).
                                       <primitive 209 6 3 private>.
                                       ^ chk ]. 
                              
                            private2 <- chk.
                          ]
                ].

     self numberOfRecords.

     myCurrentRecordNum <- 1.
     myFileName         <- dbFileName.
     numFields          <- recordTemplate numberOfFields.
     recordSize         <- recordTemplate recordSize.
     myCurrentKey       <- nil.

     self xxxTemplate: recordTemplate.
     
     ^ private
|
   close ! chk !

     " TESTED & WORKING! "

     chk <- <primitive 209 6 3 private>.
     
     self failCheck: chk with: (chk ~= 0) for: 'close'.
      
     (memoPresent)
        ifTrue: [ self xxxCloseMemoFile ]
|
   write: recordData as: recordNumber ! chk aMemo !

     " TESTED & WORKING! "

     (memoPresent = true)
        ifTrue: [ (1 to: (myTemplate numberOfFields)) 
                     do: [ :m | aMemo <- myTemplate fieldAt: m.

                          (aMemo fieldType = $M)
                            ifTrue: [ aMemo putMemo: (aMemo memoContents)
                                               into: private2.

                                      myTemplate at: m put: aMemo. 
                                    ]
                         ]
                ].
                                      
     chk <- <primitive 209 6 5 private recordNumber recordData self>.
 
     self failCheck: chk with: (chk ~= 0) for: 'write:as:'.    

     myCurrentRecordNum <- recordNumber.
     
     self numberOfRecords.
     
     ^ self updateFile
|
   read: recordNumber into: recordData ! chk memoPriv memoData !

     " TESTED & WORKING! "

     chk <- <primitive 209 6 6 private recordNumber recordData currentRecStatus>.

     self failCheck: chk with: (chk ~= 0) for: 'read:into:'.

     (memoPresent = true)
        ifTrue: [ " Need to read in a Memo field(s) also: "

                  (1 to: (myTemplate numberOfFields))
                   do: [ :m | 
 
                        memoPriv <- myTemplate fieldAt: m.
  
                        (memoPriv fieldType = $M)
                         ifTrue: [ memoData <- memoPriv getMemoFrom: private2.
                                       
                                   memoPriv memoContents: memoData. ]
                       ].
                ].

     myCurrentRecordNum <- recordNumber.
|
   updateFile ! chk !
     chk <- <primitive 209 6 7 private>.

     ^ self failCheck: chk with: (chk ~= 0) for: 'updateFile'.    
|
   add: keyString to: keyFileObject for: recordNumber ! chk ! " dBakey() "

     chk <- <primitive 209 8 11 keyFileObject keyString recordNumber>.

     myCurrentKey <- keyString.
     
     self failCheck: chk with: (chk ~= 0) for: 'addKey:to:for:'.
|
   putRecordTo: recordData using: keyString from: keyFileObject 
     ! chk ! " dBputrk() "
   
     " recData is a DBData Object "
     chk <- <primitive 209 8 15 keyFileObject private keyString recordData>.

     myCurrentKey <- keyString.

     self failCheck: chk with: (chk ~= 0) for: 'putRecordTo:using:from:'.    
|
   getRecordBy: keyString from: keyFileObject for: recordData 
     ! chk ! " dBgetrk() "

     " TESTED & WORKING! "

     " recordData is a DBData Object big enough to hold a record for the
     * DataBase & keyString is an ordinary String that contains the 
     * value(s) necessary to satisfy the key Expression required for the
     * given keyFileObject
     "
     chk <- <primitive 209 8 14 keyFileObject private keyString 
                                recordData    currentRecStatus  >.
     
     myCurrentKey <- keyString.

     (chk isNil) 
       ifTrue:  [ ('"getRecordBy:from:for:" FAILED!' ) print ].

     ^ chk
|
   readNextRecord: keyFileObject into: recordData ! chk ! " dBgetnr() "

     " recordData is a DBData Object "

     chk <- <primitive 209 8 5 keyFileObject private currentRecStatus recordData>.
     
     (chk isNil) 
       ifTrue:  [ ('"readNextRecord:into:" FAILED!' ) print ].

     ^ chk " The recordData "
|
   readPrevRecord: keyFileObject into: recordData ! chk !  " dBgetpr() "

     " recordData is a DBData Object "

     chk <- <primitive 209 8 6 keyFileObject private currentRecStatus recordData>.
     
     (chk isNil) 
       ifTrue:  [ ('"readPrevRecord:into:" FAILED!' ) print ].

     ^ chk " The recordData "
|
   update: recordData number: recNumber ! chk !
     chk <- <primitive 209 6 10 private recNumber recordData>.
     
     self failCheck: chk with: (chk ~= 0) for: 'update:number:'.
     
     myCurrentRecordNum <- recNumber
|
   removeRecord: recordNumber ! chk !

     " WARNING:  This is an IRREVERSIBLE operation! (Tested & working)"

     chk <- <primitive 209 6 12 private recordNumber>.
     
     self failCheck: chk with: (chk ~= 0) for: 'removeRecord:'
]

" -------------------------------------------------------------------------- "
" NOTE:  size has to be the size of the largest record expected to be in the "
"        DataBase. "
" TESTED & WORKING! "
" -------------------------------------------------------------------------- "

Class DBData :String ! theData mySize !
[
   print
     ^ theData print
|   
   new: size
      (size > 0)
         ifTrue: [ theData <- super new: size.

                   mySize  <- size.

                   ^ self ].
      
      ('size ', size asString, ' improper for DBData Class instance!') print.

      ^ nil
|
   reset
      " This method allows us to re-use an instance of this Class: "
      <primitive 209 9 9 theData mySize>
|
   modifyWith: dataString at: offset length: length 

      <primitive 209 9 7 theData dataString offset length mySize>.

      ^ self
|
   at: index
      ^ theData at: index
|
   retrieveFieldAt: offset length: length
      ^ <primitive 209 9 10 theData offset length>
|
   size
      ^ mySize
]

" -------------------------------------------------------------------------- "
" DBRecordTemplate Class (recordObject) is an Array of DBField Objects.      "
""
" This class is used to define the various fields that a DataBase will con-  "
" tain & is set up BEFORE you use it to create/open a DataBase.              "
" -------------------------------------------------------------------------- "

Class DBRecordTemplate :Object 
! fieldArray myRecordSize numberFields offsetArray !
[
   recordSize
     ^ myRecordSize
|
   numberOfFields
     ^ numberFields
|
   addField: fieldObject at: index
      fieldArray  at: index put: fieldObject.
      offsetArray at: index put: myRecordSize.
            
      myRecordSize <- myRecordSize + (fieldObject fieldWidth)
|
   fieldAt: index
      ^ fieldArray at: index
|
   offsetAt: index             
      " Simplify bookkeeping.  Now you only have to keep track of
      * the field index!
      "
      ^ offsetArray at: index
|
   new: howManyFields
     
      myRecordSize <- 0.
      
      numberFields <- howManyFields.

      fieldArray   <- Array new: howManyFields.
      offsetArray  <- Array new: howManyFields.

      ^ self
]

" -------------------------------------------------------------------------- "
" DBField is an Abstract Class.                                              "
" -------------------------------------------------------------------------- "

Class DBField :Object
[
   fieldObject
     ^ super subclassResponsibility: 'fieldObject'
|
   fieldName
     ^ super subclassResponsibility: 'fieldName'
|
   fieldType
     ^ super subclassResponsibility: 'fieldType'
|
   fieldWidth
     ^ super subclassResponsibility: 'fieldWidth'
|
   decimalPlaces
     ^ super subclassResponsibility: 'decimalPlaces'
|
   create: fieldName type: typeChar width: w decimalPlaces: d
     ^ super subclassResponsibility: 'create:type:width:decimalPlaces:'
|
   failCheck: check with: failTest for: methodName ! dbErrs error !
     (failTest)
        ifTrue: [ dbErrs <- DBErrs new.
                  error  <- dbErrs errString: check.

                  (methodName, ' method FAILED because:') print.
                  error print.
                ]
]

" -------------------------------------------------------------------------- "
" This Class is only needed for creating new DataBase DBRecordTemplate       "
" String-type Fields.                                                        "
" -------------------------------------------------------------------------- "

Class DBFieldString :DBField 
! private myFieldName private2 myFieldWidth private3 !
[
   fieldObject
     ^ private
|
   fieldName
     ^ myFieldName
|
   fieldType
     ^ $C
|
   fieldWidth
     ^ myFieldWidth
|
   decimalPlaces
     ^ private3
|
   create: fieldName length: w
     ^ self create: fieldName type: $C width: w decimalPlaces: 0
|   
   create: fieldName type: typeChar width: w decimalPlaces: d ! chk !

     " The fieldName can only be up to 10 characters 
     * long (DB-III limitation). 
     "
     chk <- <primitive 209 9 0 fieldName typeChar w d>. 
     
     (chk isNil)
        ifTrue:  [ ('create:type:width:decimalPlaces: FAILED!' ) print.

                   ^ nil
                 ].
        
     private      <- chk.
     myFieldName  <- fieldName.
     private2     <- typeChar.
     myFieldWidth <- w.
     private3     <- d.
     
     ^ self
]

" -------------------------------------------------------------------------- "
" This Class is only needed for creating new DataBase DBRecordTemplate       "
" Memo-type Fields.                                                          "
" -------------------------------------------------------------------------- "

Class DBFieldMemo :DBField 
! private myFieldName private2 private3 private4 maxSize myMemoContents !
[
   fieldObject
     ^ private
|
   fieldName
     ^ myFieldName
|
   fieldType
     ^ private2
|
   fieldWidth
     ^ private3
|
   decimalPlaces
     ^ private4
|
   memoContents
     ^ myMemoContents
|
   memoContents: newContents
     myMemoContents <- newContents     
|
   createMemo: fieldName ofSize: memoSize
     myMemoContents <- String new: memoSize.
     
     ^ self create: fieldName type: $M width: 10 decimalPlaces: 0
|   
   create: fieldName type: typeChar width: w decimalPlaces: d ! chk !

     " The fieldName can only be up to 10 characters 
     * long (DB-III limitation). 
     "
     chk <- <primitive 209 9 0 fieldName typeChar w d>. 
     
     (chk isNil)
        ifTrue:  [ ('create:type:width:decimalPlaces FAILED!' ) print.

                   ^ nil
                 ].
        
     private      <- chk.
     myFieldName  <- fieldName.
     private2     <- typeChar.
     private3     <- w.
     private4     <- d.
     
     ^ self
|
   setMaximumMemoSizeTo: maximumSize
      <primitive 209 7 5 maximumSize>.

      maxSize <- maximumSize.
|
   maximumMemoSize
      ^ maxSize <- <primitive 209 7 6>    
|
   getMemoFrom: memoFileObj  ! chk ! " dBgetm() "

     chk <- <primitive 209 7 3 memoFileObj private myMemoContents>.
      
     super failCheck: chk with: (chk ~= 0) for: 'getMemoFrom:'.
     
     ^ myMemoContents
|
   putMemo: memoString into: memoFileObj   ! chk ! " dBputm() "
     chk <- <primitive 209 7 4 memoFileObj memoString private>.
      
     super failCheck: chk with: (chk ~= 0) for: 'putMemo:into:'
]

" -------------------------------------------------------------------------- "
" This Class is only needed for creating new DataBase DBRecordTemplate       "
" Floating-point-type Fields.                                                "
" -------------------------------------------------------------------------- "

Class DBFieldFloat :DBField 
! private myFieldName myFieldType myFieldWidth myDecPlaces !
[
   fieldObject
     ^ private
|
   fieldName
     ^ myFieldName
|
   fieldType
     ^ myFieldType
|
   fieldWidth
     ^ myFieldWidth
|
   decimalPlaces
     ^ myDecPlaces
|
   ascii: aFloatString toField: fieldString width: w 
                 decimalPlaces: d                      " dBatofld() "
     ! chk !
     
     chk <- <primitive 209 9 4 aFloatString fieldString w d>.
     
     super failCheck: chk with: (chk ~= 0) 
                 for: 'ascii:toField:width:decimalPlaces:'.
     
     ^ fieldString
|
   field: aFieldString toASCII: floatString width: w 

     ! chk ! " dBfldtoa() "

     chk <- <primitive 209 9 5 aFieldString w floatString>.
     
     super failCheck: chk with: (chk ~= 0) for: 'field:toASCII:width:'.

     ^ floatString
|
   create: fieldName type: typeChar width: w decimalPlaces: d ! chk !

     " The fieldName can only be up to 10 characters 
     * long! (DB-III limitation)
     *
     * Valid values for typeChar are (Uppercase is preferred):
     *
     *   $N - Numeric field
     "
     chk <- <primitive 209 9 0 fieldName typeChar w d>. 
     
     (chk isNil)
        ifTrue:  [ ('create:type:width:decimalPlaces: FAILED!' ) print.

                   ^ nil
                 ].
        
     private       <- chk.
     myFieldName   <- fieldName.
     myFieldType   <- typeChar.
     myFieldWidth  <- w.
     myDecPlaces   <- d.
     
     ^ self
]

" -------------------------------------------------------------------------- "
" This Class is only needed for creating new DataBase DBRecordTemplate       "
" Date-type Fields.                                                          "
" -------------------------------------------------------------------------- "

Class DBFieldDate :DBField 
! private myFieldName myFieldType myFieldWidth myDecPlaces !
[
   fieldObject
     ^ private
|
   fieldName
     ^ myFieldName
|
   fieldType
     ^ myFieldType
|
   fieldWidth
     ^ myFieldWidth
|
   decimalPlaces
     ^ myDecPlaces
|
   ascii: aDateString toField: fieldString width: w " dBatofld() "
     ! chk !
     
     chk <- <primitive 209 9 4 aDateString fieldString w 0>.
     
     super failCheck: chk with: (chk ~= 0) for: 'ascii:toField:width:'.
     
     ^ fieldString
|
   field: aFieldString toASCII: dateString width: w ! chk ! " dBfldtoa() "
     chk <- <primitive 209 9 5 aFieldString w dateString>.
     
     super failCheck: chk with: (chk ~= 0) for: 'field:toASCII:width:'.

     ^ dateString
|
   create: fieldName
     ^ self create: fieldName type: $D width: 8 decimalPlaces: 0
|
   create: fieldName type: typeChar width: w decimalPlaces: d ! chk !

     " The fieldName can only be up to 10 characters
     * long! (DB-III limitation)
     *
     * Valid values for typeChar are (Uppercase is preferred):
     *
     *   $D - Date field
     "
     chk <- <primitive 209 9 0 fieldName typeChar w d>. 
     
     (chk isNil)
        ifTrue:  [ ('create:type:width:decimalPlaces: FAILED!' ) print.

                   ^ nil
                 ].
        
     private       <- chk.
     myFieldName   <- fieldName.
     myFieldType   <- typeChar.
     myFieldWidth  <- w.
     myDecPlaces   <- d.
     
     ^ self
]

" -------------------------------------------------------------------------- "
" This Class is only needed for creating new DataBase DBRecordTemplate       "
" Integer-type Fields.                                                       "
" -------------------------------------------------------------------------- "

Class DBFieldInteger :DBField 
! private myFieldName myFieldType myFieldWidth myDecPlaces !
[
   fieldObject
     ^ private
|
   fieldName
     ^ myFieldName
|
   fieldType
     ^ myFieldType
|
   fieldWidth
     ^ myFieldWidth
|
   decimalPlaces
     ^ myDecPlaces
|
   ascii: anIntegerString toField: fieldString width: w " dBatofld() "
     ! chk !
     
     chk <- <primitive 209 9 4 anIntegerString fieldString w 0>.
     
     super failCheck: chk with: (chk ~= 0) for: 'ascii:toField:width:'.
     
     ^ fieldString
|
   field: aFieldString toASCII: integerString width: w ! chk ! " dBfldtoa() "
     chk <- <primitive 209 9 5 aFieldString w integerString>.
     
     super failCheck: chk with: (chk ~= 0) for: 'field:toASCII:width:'.

     ^ integerString
|
   create: fieldName width: w
     ^ self create: fieldName type: $N width: w decimalPlaces: 0
|
   create: fieldName type: typeChar width: w decimalPlaces: d ! chk !

     " The fieldName can only be up to 10 characters 
     * long! (DB-III limitation)
     *
     * Valid values for typeChar are (Uppercase is preferred):
     *
     *   $N - Numeric field
     "
     chk <- <primitive 209 9 0 fieldName typeChar w d>. 
     
     (chk isNil)
        ifTrue:  [ ('create:type:width:decimalPlaces: FAILED!' ) print.

                   ^ nil
                 ].
        
     private       <- chk.
     myFieldName   <- fieldName.
     myFieldType   <- typeChar.
     myFieldWidth  <- w.
     myDecPlaces   <- d.
     
     ^ self
]

" -------------------------------------------------------------------------- "
" This Class is only needed for creating new DataBase DBRecordTemplate       "
" Boolean-type Fields.                                                       "
" -------------------------------------------------------------------------- "

Class DBFieldBoolean :DBField 
! private myFieldName private2 private3 private4 !
[
   fieldObject
     ^ private
|
   fieldName
     ^ myFieldName
|
   fieldType
     ^ private2
|
   fieldWidth
     ^ private3
|
   decimalPlaces
     ^ private4
|
   create: fieldName
     ^ self create: fieldName type: $L width: 1 decimalPlaces: 0
|
   create: fieldName type: typeChar width: w decimalPlaces: d ! chk !

     " The fieldName can only be up to 10 characters 
     * long! (DB-III limitation) 
     "
     chk <- <primitive 209 9 0 fieldName typeChar w d>. 
     
     (chk isNil)
        ifTrue:  [ ('create:type:width:decimalPlaces: FAILED!' ) print.

                   ^ nil
                 ].
        
     private     <- chk.
     myFieldName <- fieldName.
     private2    <- typeChar.
     private3    <- w.
     private4    <- d.
     
     ^ self
]

" ------------------------------------------------------------------ "
" This Class is only used to store temporary Objects for DataBases.  "
" ------------------------------------------------------------------ "

Class FieldString :String ! private ! 
[
   new: aString
     ^ self xxxFormat: aString to: (aString size) adjMode: $L
|
   size
     ^ (self value) size
|     
   value
     ^ <primitive 209 9 8 private>
|   
   xxxFormat: aString to: length adjMode: leftOrRightChar 
      ! chk ! " dBstrcpy() "

      " If leftOrRightChar is $r or $R, right-adjust aString,
      * any other value is for left-adjust.
      "
      chk <- <primitive 209 9 1 aString leftOrRightChar length>.
      
      (chk isNil)
        ifTrue:  [ ('xxxFormat:to:adjMode: FAILED!' ) print.

                   ^ nil
                 ].
      
      private <- chk.

      ^ self
|
   dispose ! chk !
      <primitive 209 9 2 private>.

      chk <- <primitive 209 9 3>. "lastErrorNumber"

      (chk ~= 0)
         ifTrue: [ ('Look up ERROR number ', (chk asString)) print ].
         
      ^ private <- nil
]

" ----------------------------------------------------------------- "
" This Class handles most of the interface to DBaseIII index (key)  "
" files.  There are some more methods in the DataBase Class that    "
" also require DBKeyFile Objects                                    "
" ----------------------------------------------------------------- "

Class DBKeyFile :Object ! private myFileName !
[
   printError: errNum ! dbErrs !
     dbErrs <- DBErrs new.

     (dbErrs errString: errNum) print.
     
     ^ nil
|
   failCheck: check with: failTest for: methodName
     (failTest)
       ifTrue: [ (methodName, ' method FAILED because:') print.

                 ^ self printError: check ].

     ^ nil
|
   keyFileObject
     ^ private
|
   keyToRecordNumber: thisKey ! chk !    " dBtkey() "
   
     chk <- <primitive 209 8 4 private thisKey>.
     
     (chk isNil) 
       ifTrue:  [ (thisKey, ' FAILED to translate!' ) print ].

     ^ chk " This is the recordNumber translated from thisKey "
|
   readKeyExpressionInto: keyExprString ! chk ! " dBkexpr() "

     " Returns a keyType value (67 for Character, 78 for Numeric or Date)
     * or nil on failure.  keyString will contain a sequence
     * of characters that describe the logical value (in fields) of the 
     * key expression found in the keyFile.
     "
     chk <- <primitive 209 8 16 private keyExprString>.
     
     self failCheck: chk with: (chk isNil) for: 'readKeyExpressionInto:'.
     
     ^ keyExprString
|
   windKeyFile ! chk !                         " dBfwd()  "
     chk <- <primitive 209 8 10 private>.
     
     self failCheck: chk with: (chk ~= 0) for: 'windKeyFile'.
|
   rewindKeyFile ! chk !                       " dBrewind() "
     chk <- <primitive 209 8 18 private>.
   
     self failCheck: chk with: (chk ~= 0) for: 'rewindKeyFile'.
|
   removeKey: keyString for: recNumber ! chk !               " dBrmvkey() "
     chk <- <primitive 209 8 9 private keyString recNumber>.
     
     self failCheck: chk with: (chk ~= 0) for: 'removeKey:for:'.
     
     (chk = 0)
        ifTrue: [ recNumber <- 0 ]
|
   readCurrentKeyInto: keyString for: recNumber ! chk ! " dBckey() "
     chk <- <primitive 209 8 17 private keyString recNumber>.

     self failCheck: chk with: (chk ~= 0) for: 'readCurrentKeyInto:for:'.
     
     ^ recNumber
|
   readNextKeyInto: keyString for: recNumber ! chk ! " dBnkey() "
     chk <- <primitive 209 8 8 private keyString recNumber>.

     self failCheck: chk with: (chk ~= 0) for: 'readNextKeyInto:'.
     
     ^ recNumber
|
   readPrevKeyInto: keyString for: recNumber ! chk ! " dBpkey() "

     chk <- <primitive 209 8 7 private keyString recNumber>.

     self failCheck: chk with: (chk ~= 0) for: 'readPrevKeyInto:'.
|
   cleanup ! chk !
   
     " NOTE:  This is a time-consuming operation! "

     chk <- <primitive 209 8 3 private>. " dBiflsh()  "
     
     self failCheck: chk with: (chk ~= 0) for: 'flushFile'.
|
   close ! chk ! " dBiclose() "

     " TESTED & WORKING! "

     chk <- <primitive 209 8 2 private>.
     
     self failCheck: chk with: (chk ~= 0) for: 'closeKeyFile'.
|
   open: dbKeyFileName  ! chk !  " dBiopen() "

     " TESTED & WORKING! "

     myFileName <- (dbKeyFileName, '.NDX').

     chk <- <primitive 209 8 1 dbKeyFileName>.

     (chk isNil) 
       ifTrue: [ (dbKeyFileName, ' FAILED to open!' ) print.

                 ^ nil
               ].

     private <- chk.
     
     ^ self
|
   createKeyFile: dbKeyFileName for: keyObject 
     ! chk keyExpr type ! " dBicreat() "

     " keyObject has to be a subclass of DBKey " 

     myFileName <- (dbKeyFileName, '.NDX').

     keyExpr <- keyObject keyExpression.
     type    <- keyObject keyType.
     
     " keyExpr MUST be less than 100 characters long!
     *
     * Valid values for type are:
     *
     *   $C -- key is a String
     *   $N -- key is a Number
     *   $D -- key is a Date
     "
     chk <- <primitive 209 8 0 dbKeyFileName keyExpr type>.
     
     self failCheck: chk with: (chk ~= 0) for: 'createKeyFile:for:'.
]

" ------------------------------------------------------------------- "
" DBKey Class is an Abstract class for the different types of keys    "
" known to the DBC-III library of functions.                          "
" ------------------------------------------------------------------- "
 
Class DBKey :Object
[
   printError: errNum ! dbErrs !
     dbErrs <- DBErrs new.

     (dbErrs errString: errNum) print.
     
     ^ nil
|
   failCheck: check with: failTest for: methodName
     (failTest)
       ifTrue: [ (methodName, ' method FAILED because:') print.

                 ^ self printError: check ].

     ^ nil
|
   keyExpression
     ^ super subclassResponsibility: 'keyExpression'
|
   keyExpression: newKeyExpression
     ^ super subclassResponsibility: 'keyExpression:'
|
   keyType
     ^ super subclassResponsibility: 'keyType'
|
   keyLength
     ^ super subclassResponsibility: 'keyLength'
|
   keyToASCII: aKeyValue
     ^ super subclassResponsibility: 'keyToASCII:'
|
   asciiToKey: aStringValue
     ^ super subclassResponsibility: 'asciiToKey:'
|   
   value
     ^ super subclassResponsibility: 'value'
|
   new: newKeyType

     ^ super subclassResponsibility: 'new:'
]

" --------------------------------------------------------------------- "
" This Class is for date-type keys only.                                "
" --------------------------------------------------------------------- "

Class DBDateKey :DBKey ! myKeyValue myKeyExpr myKeyLength !
[
   keyExpression
     ^ myKeyExpr
|
   keyExpression: newKeyExpression
     myKeyExpr <- newKeyExpression
|
   keyType
     ^ 68      " key Type is date = $D "
|
   keyLength
     ^ myKeyLength
|
   keyToASCII: dateString ! chk ! " dBkeytoa() "

     " Receiver HAS to be 8 bytes in size. "

     chk <- <primitive 209 8 13 dateString myKeyValue 68>.
     
     super failCheck: chk with: (chk ~= 0) for: 'keyToASCII:'.
     
     ^ dateString
|
   asciiToKey: dateString ! chk ! " dBatokey() "

     " Receiver HAS to be 8 bytes in size. "

     chk <- <primitive 209 8 12 dateString myKeyValue 68>.
     
     super failCheck: chk with: (chk ~= 0) for: 'asciiToKey:'.
     
     ^ myKeyValue
|
   value
     ^ myKeyValue
|
   new: newKeyType

     myKeyValue  <- String new: 8. 
     " FORMAT is 19YYMMDD for DBaseIII compatibility.
     * If DBaseIII compatibility is not needed, put the 
     * correct date inside (such as 20YYMMDD). 
     "

     myKeyLength <- 8.
     myKeyExpr   <- nil.
     
     ^ self
]

" --------------------------------------------------------------------- "
" This Class is for numeric keys, integers only.                        "
" --------------------------------------------------------------------- "

Class DBIntegerKey :Object ! myKeyValue myKeyExpr myKeyLength !
[
   keyExpression
     ^ myKeyExpr
|
   keyExpression: newKeyExpression
     myKeyExpr <- newKeyExpression
|
   keyType
     ^ 78      " key Type is numeric = $N "
|
   keyLength
     ^ myKeyLength
|
   keyToASCII: numberString ! chk ! " dBkeytoa() "

     " Receiver HAS to be 8 bytes in size.  The first byte in 
     * numberString is the number of decimal places (0 to 60) in the converted
     * numberString, which is only meaningful for this Class.
     *
     * numberString can be up to 64 characters long, so make sure that
     * you create a String that is sized this large!
     *
     *   EXAMPLE:  nString <- String new: 64.
     *             nString at: 1 put: (numDecimalPlaces asCharacter).
     *             dbIndex keyToASCII: nString
     "
     chk <- <primitive 209 8 13 numberString myKeyValue 78>.
     
     super failCheck: chk with: (chk ~= 0) for: 'keyToASCII:'.
     
     ^ numberString
|
   asciiToKey: numberString ! chk ! " dBatokey() "

     " Receiver HAS to be 8 bytes in size.  "

     chk <- <primitive 209 8 12 numberString myKeyValue 78>.
     
     super failCheck: chk with: (chk ~= 0) for: 'asciiToKey:'.
     
     ^ myKeyValue
|
   value
     ^ myKeyValue
|
   new: newKeyType

     myKeyValue  <- String new: 8.
     myKeyLength <- 8.
     myKeyExpr   <- nil.
     
     ^ self
]

" -------------------------------------------------------------------- "
" This Class is for keys that are characters in nature, as opposed to  "
" numeric.                                                             "
" -------------------------------------------------------------------- "

Class DBCharKey :DBKey ! myKeyValue myKeyExpr myKeyLength !
[
   keyExpression
     ^ myKeyExpr
|
   keyExpression: newKeyExpression
     myKeyExpr <- newKeyExpression
|
   keyType
     ^ 67      " key Type is character = $C "
|
   keyLength
     ^ myKeyLength
|
   keyToASCII: aString ! chk ! " dBkeytoa() "

     " Receiver HAS to be 8 bytes in size.
     *
     * aString can be up to 64 characters long, so make sure that
     * you create a String that is sized this large!
     *
     *   EXAMPLE:  nString <- String new: 64.
     *             dbIndex keyToASCII: aString
     "
     chk <- <primitive 209 8 13 aString myKeyValue 67>.
     
     super failCheck: chk with: (chk ~= 0) for: 'keyToASCII:'.
     
     ^ aString
|
   asciiToKey: aString ! chk ! " dBatokey() "

     " Receiver HAS to be 8 bytes in size.  "

     chk <- <primitive 209 8 12 aString myKeyValue 67>.
     
     super failCheck: chk with: (chk ~= 0) for: 'asciiToKey:'.
     
     ^ myKeyValue
|
   value
     ^ myKeyValue
|
   new: newKeyType

     myKeyValue  <- String new: 8.
     myKeyLength <- 8.
     myKeyExpr   <- nil.
     
     ^ self
]

" -------------------------------------------------------------------- "
" DBErrs Class is a Singleton class that allows the user to            "
" reference DBase error strings by error number, effectivley trans-    "
" an error number into something (potentially) understandable by a     "
" Human.  The other DataBase Classes contained in this file will       "
" instantiate this Class when necessary, so ignore it.                 "
""
"  EXAMPLE:  'errStr <- dbErrs errString: 102.                         "
""
" ALL singleton classes MUST contain the following:                    "
""
"   the methods:  isSingleton AND privateSetup     AND                 "
"                 uniqueInstance Class instance variable.              "
" -------------------------------------------------------------------- "

Class DBErrs :Dictionary ! uniqueInstance !
[
   isSingleton
     ^ true
|
   privateNew ! newinstance !
     newinstance <- super new.

     ^ newinstance
|
   new
     ^ self privateSetup
|
   privateSetup
     (uniqueInstance isNil)
       ifTrue: [uniqueInstance <- self privateNew.

                self privateInitializeDictionary.
               ].
               
     ^ self    "or ^ uniqueInstance??"
|
   errString: aKey
     ^ self at: aKey
|
   privateInitializeDictionary

     self at: 101  put: 'Number of Fields is 0 (zero).'.
     self at: 102  put: 'Number of Fields is > 128.'.
     self at: 103  put: 'Field Name > 10 characters.'.
     self at: 104  put: 'Invalid Field type specified.'.
     self at: 105  put: 'Field length is 0 or > 254 bytes.'.
     self at: 106  put: 'Record length is > 4000 bytes.'. 
     self at: 107  put: 'Failed to create .DBF file at physical level.'.
     self at: 108  put: 'Failed to write to .DBF file at physical level.'.
     self at: 114  put: 'Dynamic Memory Allocation Failure!'.
     self at: 115  put: 'Environment NOT initialized!'.
     self at: 116  put: 'Variable NOT big enough!'.

     self at: 201  put: 'Maximum number of .DBF files already open.'.
     self at: 202  put: '.DBF file open failure at physical level.'.
     self at: 203  put: 'Failed to read .DBF file at physical level.'.
     self at: 204  put: 'File not recognized as a .DBF file.'.
     self at: 205  put: 'File cannot be recognized as a .DBF file.'.

     self at: 301  put: 'Failed to seek the .DBF file at physical level.'.
     self at: 302  put: 'Failed to write onto the .DBF file at physical level.'.
     self at: 303  put: 'Failed to close the .DBF file at physical level.'.
     self at: 390  put: 'The .DBF file is NOT open!'.

     self at: 401  put: 'Record number too big or zero.'.
     self at: 402  put: 'Failed to seek the .DBF file at physical level.'.
     self at: 403  put: 'Failed to read the .DBF file at physical level.'.

     self at: 501  put: 'Record number too big or zero.'.

     self at: 601  put: 'Record number too big or zero.'.

     self at: 701  put: 'Record number too big or zero.'.
     self at: 702  put: 'Failed to seek or read the .DBF file at physical level.'.
     self at: 703  put: 'Failed to seek or read the .DBF file at physical level.'.
     self at: 704  put: 'Failed to seek or read the .DBF file at physical level.'.
     self at: 705  put: 'Static data corrupted possibly by application overwrite.'.

     self at: 1001 put: 'Static data corrupted possibly by application overwrite.'.

     self at: 1201 put: 'Failed to seek the .DBF file at physical level.'.
     self at: 1202 put: 'Failed to seek the .DBF file at physical level.'.
     self at: 1203 put: 'Failed to seek the .DBF file at physical level.'.
     self at: 1204 put: 'Failed to seek the .DBF file at physical level.'.
     self at: 1205 put: 'Static data corrupted possibly by application overwrite.'.
     self at: 1206 put: 'Failed to write the .DBF file at physical level.'.
     self at: 1210 put: 'Failed to allocate dynamic memory for shift-down operation.'.
     self at: 1211 put: 'Failed to read the .DBF file for shift-down operation.'.
     self at: 1212 put: 'Failed to seek the .DBF file for shift-down operation.'.
     self at: 1213 put: 'Failed to write the .DBF file for shift-down operation.'.
     self at: 1214 put: 'Failed to seek the .DBF file for shift-down operation.'.
     self at: 1215 put: 'Failed to seek the .DBF file for shift-down operation.'.
     self at: 1216 put: 'Failed to seek the .DBF file after shift-down operation.'.
     self at: 1220 put: 'Failed to allocate dynamic memory for shift-up operation.'.
     self at: 1221 put: 'Failed to seek the .DBF file for shift-up operation.'.
     self at: 1222 put: 'Failed to read the .DBF file for shift-up operation.'.
     self at: 1223 put: 'Failed to seek the .DBF file for shift-up operation.'.
     self at: 1224 put: 'Failed to write the .DBF file for shift-up operation.'.
     self at: 1225 put: 'Failed to seek the .DBF file for shift-up operation.'.
     self at: 1226 put: 'Failed to seek the .DBF file after shift-up operation.'.

     self at: 1301 put: 'Undefined "keytype" specified.'.
     self at: 1302 put: 'Key length too long or zero.'.
     self at: 1303 put: 'Failed to allocate dynamic memory.'.
     self at: 1304 put: 'Key expression too long or zero.'.
     self at: 1305 put: 'Failed to create the .NDX file at physical level.'.
     self at: 1306 put: 'Failed to write the .NDX file at physical level.'.

     self at: 1401 put: 'Maximum # of .NDX files already open!'.
     self at: 1402 put: 'Failed to open the .NDX file at physical level.'.
     self at: 1403 put: 'Failed to allocate dynamic memory.'.
     self at: 1404 put: 'Failed to read the .NDX file at physical level.'.
     self at: 1405 put: 'File cannot be recognized as a .NDX file!'.

     self at: 1501 put: 'No longer used as error code.'.
     self at: 1502 put: 'No longer used as error code.'.
     self at: 1503 put: 'Failed to seek or write the .NDX file at physical level.'.
     self at: 1504 put: 'Failed to close the .NDX file at physical level.'.
     self at: 1590 put: 'The .NDX file is NOT open!'.

     self at: 1601 put: 'Failed to allocate dynamic memory.'.
     self at: 1602 put: 'Failed to allocate dynamic memory.'.
     self at: 1603 put: 'Failed to allocate dynamic memory.'.
     self at: 1604 put: 'Failed to allocate dynamic memory.'.
     self at: 1605 put: 'Failed to seek the .NDX file at physical level.'.
     self at: 1606 put: 'Failed to write the .NDX file at physical level.'.
     self at: 1607 put: 'Failed to seek the .NDX file at physical level.'.
     self at: 1608 put: 'Failed to write the .NDX file at physical level.'.
     self at: 1609 put: 'Failed to allocate dynamic memory.'.

     self at: 1701 put: 'Requested key NOT found! (New .NDX file?)'.
     self at: 1702 put: 'Requested key NOT found in the .NDX file.'.
     self at: 1703 put: 'The .NDX file corrupted.'.
     self at: 1710 put: 'Failed to allocate dynamic memory.'.

     self at: 1810 put: 'Top of the .NDX file reached.'.
     self at: 1820 put: 'No keys found in .NDX file!'.

     self at: 1901 put: 'No current key positioned.'.
     self at: 1902 put: 'End of the .NDX file reached.'.

     self at: 2010 put: 'End of the .NDX file reached.'.
     self at: 2020 put: 'No keys found in .NDX file!'.

     self at: 2101 put: 'The .DBF file is NOT open!'.
     self at: 2102 put: 'The .NDX file is NOT open!'.

     self at: 2201 put: 'The .DBF file is NOT open!'.
     self at: 2202 put: 'The .NDX file is NOT open!'.

     self at: 2301 put: 'The .DBF file is NOT open!'.
     self at: 2302 put: 'The .NDX file is NOT open!'.

     self at: 2401 put: 'The .DBF file is NOT open!'.
     self at: 2402 put: 'The .NDX file is NOT open!'.
     self at: 2403 put: 'The .DBF & .NDX out of sync!'.

     self at: 2501 put: 'Failed to seek the .NDX file at physical level.'.
     self at: 2502 put: 'Failed to allocate dynamic memory.'.
     self at: 2503 put: 'Failed to read the .NDX file at physical level.'.
     self at: 2504 put: 'Key expression in .NDX file TOO LONG!'.

     self at: 2601 put: 'No key exists in the .NDX file.'.
     self at: 2602 put: 'Synonymous to MAYBE.'.
     self at: 2603 put: 'End of the .NDX file reached (Key is past the end!).'.

     self at: 2701 put: 'Failed to seek the .NDX file at physical level.'.
     self at: 2702 put: 'Failed to read the .NDX file at physical level.'.
     self at: 2703 put: 'Failed to allocate dynamic memory.'.
     self at: 2704 put: 'Failed to seek the .NDX file at physical level.'.
     self at: 2705 put: 'Failed to read the .NDX file at physical level.'.

     self at: 2801 put: 'Failed to seek the .NDX file at physical level.'.
     self at: 2802 put: 'Failed to seek or write the .NDX file at physical level.'.

     self at: 3301 put: 'Failed to allocate dynamic memory.'.

     self at: 3401 put: 'Failed to allocate dynamic memory.'.

     self at: 4001 put: 'Failed to create the .DBT file at physical level.'.
     self at: 4002 put: 'Failed to write the .DBT file at physical level.'.

     self at: 4101 put: 'Maximum # of .DBT files already open!'.
     self at: 4102 put: 'Failed to open the .DBT file at physical level.'.
     self at: 4103 put: 'Failed to read the .DBT file at physical level.'.

     self at: 4201 put: 'Failed to seek or write the .DBT file at physical level.'.
     self at: 4202 put: 'Failed to close the .DBT file at physical level.'.
     self at: 4290 put: 'The .DBT file is NOT open!'.

     self at: 4301 put: 'Memo field contents invalid.'.
     self at: 4302 put: 'Failed to seek the .DBT file at physical level.'.
     self at: 4303 put: 'Failed to allocate dynamic memory.'.
     self at: 4304 put: 'Failed to read the .DBT file at physical level.'.
     self at: 4305 put: '_dbcmsig value too small, .DBT file corrupted!'.

     self at: 4401 put: 'Failed to seek the .DBT file at physical level.'.
     self at: 4402 put: 'Failed to seek the .DBT file at physical level.'.
     self at: 4403 put: 'The .DBT file is corrupted!'.
     self at: 4404 put: 'Failed to allocate dynamic memory.'.
     self at: 4405 put: 'Failed to write the .DBT file at physical level.'.
     self at: 4406 put: 'Failed to allocate dynamic memory.'.
     self at: 4407 put: 'Failed to write the .DBT file at physical level.'.

     " My Additions to the error report strings: "

     self at: 4408 put: 'Attempt to free a NULL Pointer!'. 
     self at: 4409 put: 'Data was NULL (or nil).'.
     self at: 4410 put: 'Could NOT re-open file after updating # of records!'.
     self at: 4411 put: 'Could NOT close file to update # of records!'. 
]
