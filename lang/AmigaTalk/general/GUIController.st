" --------------------------------------------------------------------
* The GUIController Class allows the User (& Models) to interface with
* a view of some other Objects (Usually Data Entry Gadgets).
*
* This class is NOT finished!
* -------------------------------------------------------------------- 
"
Class GUIController :Controller ! guiWindow ctrlDictionary !
[
   new
      
      super new.
      
      ctrlDictionary <- Dictionary new.
      
      ^ self
|
   startUp

      " Give control to the receiver.  The default control 
      * sequence is to initialize (see Controller/controlInitialize), 
      * to loop (see Controller|controlLoop), and then to terminate 
      * (see Controller|controlTerminate).  After this sequence, 
      * control is returned to the sender of Control|startUp. 
      * The receiver's control sequence is used to coordinate the 
      * interaction of its view and model.  In general, this consists 
      * of polling the sensor for user input, testing the 
      * input with respect to the current display of the view,
      * and updating the model to reflect intended changes.
      "
      self controlInitialize.
      self controlLoop.
      self controlTerminate
|
   terminateAndInitializeAround: aBlock

      self controlTerminate.

      aBlock value.

      self controlInitialize
|
   controlInitialize

      " Sent by 'startUp' as part of the standard control sequence, it 
      * provides a place in the standard control sequence for 
      * initializing the receiver (taking into account the current
      * state of its model and view).
      "
      super initialize.
|
   controlLoop ! notDone userData !

      " Sent by startUp as part of the standard control sequence. 
      * As long as false is NOT returned, the loop continues. 
      * When false is returned, the loop ends:
      "
      notDone <- true.
      
      [notDone ~= false]
        whileTrue: [ userData <- self checkForUserData.

                     (userData notNil)
                        ifTrue: [notDone <- self decode: userData].

                     " Somehow, we should poll the models for any
                     * changes right here:
                     "
                     (super model hasUnacceptedEdits)
                        ifTrue: [ super refreshView ]
                   ].

      ^ false  " Inform everyone that we are done "
|
   controlTerminate   ! ele controlObj !
      
      " User did something to exit the Controller Loop.
      * Provide a place in the standard control sequence for 
      * terminating the receiver (taking into account the 
      * current state of its model and view).
      "
      ele <- ctrlDictionary first.
      
      [ele notNil]
         whileTrue: [ controlObj <- ctrlDictionary at: ele.
                      
                      controlObj dispose.
                                             
                      ctrlDictionary removeKey: ele ifAbsent: [ ^ nil ].

                      ele <- ctrlDictionary next. 
                    ].
      ^ nil
|
   addControl: controlObject named: ctrlID

      ctrlDictionary at: ctrlID put: controlObject.

      controlObject registerTo: guiWindow
|
   addHotKey: keyValue to: controlObject

      " Upper-case & lower-case keys are equivalent here: " 
      <primitive 239 3 12 keyValue controlObject>
|
   addMenuSelection: menuObject named: menuID

      ctrlDictionary at: menuID put: menuObject

      menuObject registerTo: guiWindow
|
   addMenuHotKey: keyValue to: menuObject

      <primitive 239 1 12 keyValue menuObject>
|
   checkForUserData

      " userData is an Array of three elements, first is the 
      * Gadget (controlObject) value, second is the userData 
      * (a #methodSymbol for this Class), third is the hotKey value.
      *
      * If the User selected a menu item, the first element is
      * the menuitem userData, second is the menuitem Label, 
      * third is Command Key equivalent (a through z, 0 through 9, 
      * or A through Z only [for now!]) 
      * If the User did NOT generate a usable IDCMP event,
      * this method will return nil.
      "
      ^ <primitive 239 3 19 guiWindow>
|
   closeGUIWindow

      " <primitive 181 0 guiWindow>. "
      
      ^ false
|
   rawKey: keyCode

      ^ true
|
   vanillaKey: keyCode

      ^ true
|
   newSizeWindow

      ^ true
|
   changeWindow

      ^ true
|
   decode: controlData ! ctrlType ctrlID ctrlSymbol hotKey ctrlValue !

      ctrlType   <- controlData at: 1. " Integer, String or nil  "
      ctrlID     <- controlData at: 2. " String or Integer       "
      ctrlSymbol <- controlData at: 3. " Usually a Symbol        "
      hotKey     <- controlData at: 4. " Raw, Vanilla key or nil "
      ctrlValue  <- controlData at: 5. " String, Integer or nil  "

      (ctrlSymbol = #closeWindow)
         ifTrue: [ ^ self closeGUIWindow ].
         
      (ctrlSymbol = #rawKey)
         ifTrue: [ ^ self rawKey: hotKey ].
                  
      (ctrlSymbol = #vanillaKey)
         ifTrue: [ ^ self vanillaKey: hotKey ].
                  
      (ctrlSymbol = #newSizeWindow)
         ifTrue: [ ^ self newSizeWindow ].
                  
      (ctrlSymbol = #changeWindow)
         ifTrue: [ ^ self changeWindow ].
                  
      ^ (ctrlDictionary at: ctrlID) perform: ctrlSymbol
|
   testNewMenuUserData ! rval !

      rval <- self waitForUserData.
      
      ('menu userData[1] is: ', (rval at: 1) asString) print.
      ('menu userData[2] is: ', (rval at: 2) asString) print.
      ('menu userData[3] is: ', (rval at: 3) asString) print
]
