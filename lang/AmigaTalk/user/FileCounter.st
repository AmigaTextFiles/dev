"--------------------------------------------------------------------------"
" Count the number of files that match the regular expression given.       "
" After parsing this into AmigaTalk, enter the following commands into the "
" Command Line Gadget:                                                     "
"    iconCounter <- FileCounter new "
"    iconCounter test    or         "
""
"    iconCounter main: 'yourDirectory' regEx: 'searchPattern' "
""
" in order to see how to use the AmigaDOS classes.                         "
"--------------------------------------------------------------------------"

Class FileCounter :Object
! safe unsafe danger dflags rmode fibType err !
[
   initialize
      danger  <- DangerousDOS new. 
      unsafe  <- UnSafeDOS    new. 
      safe    <- SafeDOS      new.
      dflags  <- DosSystem    new.

      rmode   <- dflags getDosFlag:  #ACCESS_READ.
      fibType <- dflags getDosFlag:  #DOS_FIB.
      err     <- dflags getDosError: #ERROR_NO_MORE_ENTRIES.
|
   countDirectoriesIn: rootLock ! fib rval tLock !
      rval <- 0.
      fib  <- danger allocDosObject: fibType tags: nil.
       
       (fib isNil)
          ifTrue: [ 'Could NOT allocate a Dos Object (fib)!' print.
                    ^ 0
                  ].
       
       tLock <- unsafe duplicateLock: rootLock.

       (tLock isNil) 
          ifTrue: [ danger freeDosObject: fib type: fibType.
                    ('Could NOT duplicate lock!') print.  
                    ^ 0
                  ].
          
       ((unsafe examine: tLock into: fib) ~= true or: [unsafe isFileIn: fib])
          ifTrue: [ unsafe unLock: tLock.
                    danger freeDosObject: fib type: fibType.
                    ('Please supply a Directory!') print.
                    ^ 0
                  ].

       [(unsafe examineNext: tLock into: fib) ~= false or: [safe getIoErr ~= err]]
          whileTrue: [(unsafe isFileIn: fib)
                         ifFalse: [ rval <- rval + 1 ] " Count as a Directory "
                     ].

      unsafe unLock: tLock.

      danger freeDosObject: fib type: fibType.

      ^ rval
|
   countFilesIn: rootLock using: regularExpression ! abuffer bufsize fib rval tLock !
      rval <- 0.
      fib  <- danger allocDosObject: fibType tags: nil.
       
       (fib isNil)
          ifTrue: [ 'Could NOT allocate a Dos Object (fib)!' print.
                    ^ 0
                  ].

       bufsize <- (regularExpression size) * 4.
       abuffer <- String new: bufsize.
      
       ((unsafe parsePatternNoCase: regularExpression into: abuffer ofSize: bufsize) isNil)
          ifTrue: [ danger freeDosObject: fib type: fibType.
                    ('Could NOT parse ', regularExpression) print.
                    ^ 0
                  ].
       
       tLock <- unsafe duplicateLock: rootLock.

       (tLock isNil) 
          ifTrue: [ danger freeDosObject: fib type: fibType.
                    ('Could NOT duplicate lock!') print.  
                    ^ 0
                  ].
          
       ((unsafe examine: tLock into: fib) ~= true or: [unsafe isFileIn: fib])
          ifTrue: [ unsafe unLock: tLock.
                    danger freeDosObject: fib type: fibType.
                    ('Please supply a Directory!') print.
                    ^ 0
                  ].

       [(unsafe examineNext: tLock into: fib) ~= false or: [safe getIoErr ~= err]]
          whileTrue: [(unsafe isFileIn: fib)
                         ifTrue: [(unsafe matchPatternNoCase: abuffer 
                                                          in: (unsafe getFileNameFrom: fib))
                                     ifTrue: [rval <- rval + 1]
                                 ].
                     ].

      unsafe unLock: tLock.

      danger freeDosObject: fib type: fibType.

      ^ rval
|
   test ! myLock howMany !
      howMany <- 0.
      
      self initialize.
      'Initialization done!' print.
      
      myLock  <- unsafe lockFile: 'AmigaTalk:' mode: rmode.
      
      (myLock isNil)
         ifTrue: [ 'Could NOT lock on directory!' print.
                   ^ nil
                 ].
         
      howMany <- self countFilesIn: myLock using: '#?.info'.

      (howMany ~= 0)
          ifTrue: [('There are ', (howMany asString), ' files that match  #?.info') print ]
         ifFalse: [ 'There are no files that match #?.info' print ]
|
   matchFilesIn: myDirectory regEx: regularExpression ! howMany myLock !
      howMany <- 0.
      
      self initialize.

      myLock  <- unsafe lockFile: myDirectory mode: rmode.

      (myLock isNil)
         ifTrue: [ ('Could NOT lock on ', myDirectory, '!' ) print.
                   ^ nil
                 ].
         
      howMany <- self countFilesIn: myLock using: regularExpression.
      
      (howMany ~= 0)
          ifTrue: [('There are ', (howMany asString), ' files that match ',
                                  regularExpression) print
                  ]
         ifFalse: [('There are no files that match', regularExpression) print]
|
   countDirectories: myRootDirectory ! howMany myLock !
      howMany <- 0.
      
      self initialize.

      myLock  <- unsafe lockFile: myDirectory mode: rmode.

      (myLock isNil)
         ifTrue: [ ('Could NOT lock on ', myDirectory, '!' ) print.
                   ^ nil
                 ].
         
      howMany <- self countDirectoriesIn: rooLock

      (howMany ~= 0)
          ifTrue: [('There are ', (howMany asString), ' Directoriesfiles in ',
                                  myRooDirectory) print
                  ]
         ifFalse: [('There are no Directories in ', myRootDirectory) print]
]
