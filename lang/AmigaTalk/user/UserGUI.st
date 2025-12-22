" --------------------------------------------------------------------
* The UserGUI Class allows the User to interface with
* a view of some other Objects (Usually Data Entry Gadgets).
* The User is the only entity that can change the data in the display,
* hence the User serves as the Model UserGUI is a combination of the
* View & Controller of the MVC triad.
* --------------------------------------------------------------------
"
Class UserGUI :Object ! guiWindow guiScreen ctrlDictionary !
[
   controls
   
      ^ ctrlDictionary
|
   controlAt: index
   
      ^ ctrlDictionary at: index
|
   new

      ctrlDictionary <- Dictionary new.
      
      ^ self
|
   setScreen: newScreen

      guiScreen <- newScreen
|       
   screen

      ^ guiScreen
|
   setWindow: newWindow

      guiWindow <- newWindow       
|
   window

      ^ guiWindow
|
   textAttributes

      ^ guiScreen getFontObject
|
   visualInfo

      ^ guiScreen getVisualInfo: nil
|
   startUp 

      " Give control to the receiver.  The default control sequence is 
      * to initialize (see UserGUI/controlInitialize), to loop (see 
      * UserGUI/controlLoop), and then to terminate (see 
      * UserGUI/controlTerminate).  After this sequence, control is 
      * returned to the sender of UserGUI/startUp.  The receiver's control 
      * sequence is used to coordinate the interaction of the User with
      * the underlying data contained in the GUI.
      "
      self controlInitialize.

      self controlLoop.

      self controlTerminate.
|
   terminateAndInitializeAround: aBlock 

      self controlTerminate.

      aBlock value. 

      self controlInitialize.
|
   controlInitialize ! ele ctrlObject !

      " Sent by 'startUp' as part of the standard control sequence, it 
      * provides a place in the standard control sequence for 
      * initializing the receiver (taking into account the current
      * state of its data).
      "
      ^ nil
|
   controlLoop ! notDone userData ! 

      " Sent by startUp as part of the standard control sequence. 
      * As long as true is returned, the loop continues. 
      * When false is returned, the loop ends.
      "
      notDone <- true.
      
      [notDone ~= false]
         whileTrue: [ userData <- self waitForUserData.
                      
                      (userData isNil)
                         ifFalse: [ notDone <- self decode: userData ] 
                    ].
      ^ false
|
   controlTerminate ! ele controlObj !
      
      " User did something to exit the UserGUI Loop.
      * Provide a place in the standard control sequence for 
      * terminating the receiver (taking into account the 
      * current state of its data).
      "
      ^ nil
|
   addControl: controlObject named: ctrlID 
   
      ctrlDictionary at: ctrlID put: controlObject.

      controlObject registerTo: guiWindow.

      controlObject perform: #initializeControl.
|
   addHotKey: keyValue to: controlObject 

      " This method is only needed if you decide to change a Gadget hotKey
      * value.  If you specify a valid hotKey when the Gadget is created,
      * you do NOT have to use this method.
      "   
      <primitive 239 3 12 keyValue controlObject>.
|
   addMenuSelection: menuObject named: menuID 

      ctrlDictionary at: menuID put: menuObject.
      
      menuObject registerTo: guiWindow.
|
   addMenuHotKey: keyValue to: menuObject " NOT really needed. "

      <primitive 239 1 12 keyValue menuObject>.
|
   waitForUserData 

      " userData is an Array of five elements, first is the 
      * Gadget Type, second is the Gadget ID, third is the userData 
      * (a #methodSymbol for this Class), fourth is the hotKey value,
      * fifth is the Gadget value.
      * 
      * If the User selected a menu item, the first element is
      * the menu Type, second is the menuitem Label, 
      * third is the menu Symbol fourth is the Command Key equivalent
      * (a through z, 0 through 9, or A through Z only [for now!]).  
      *
      * The AmigaOS will wait at the IDCMP port of the controller
      * window until the User initiates an IDCMP event. 
      "
      ^ <primitive 239 3 9 guiWindow>
|
   closeGUIWindow 
     
      ^ false " User should close & dispose of this (for now). "
|
   rawKey: keyCode  "SubClasses should re-define this method "

      " Example:  This will determine what key each keyCode is attached to:
      *    ('You pressed: ', keyCode asString, ' (keyCode)') print
      "  
      ^ true
|
   vanillaKey: keyCode  "SubClasses should re-define this method "

      " Vanilla keys are alpha-numeric keys only! "

      " Example: 
      *   (keyCode = 'q' or: [keyCode = 'Q'])  Quit KeyPress found?
      *      ifTrue: [ ^ false ]               Which will tell controlLoop to exit
      "
      ^ true
|
   decode: controlData ! ctrlID ctrlSymbol hotKey !
   
      ctrlID     <- controlData at: 2. " Integer, String or nil "
      ctrlSymbol <- controlData at: 3. " Symbol (please!)       " 
      hotKey     <- controlData at: 4. " Character or nil       "

      (ctrlSymbol = #closeWindow)
         ifTrue: [ ^ self closeGUIWindow ].

      (ctrlSymbol = #rawKey)
         ifTrue: [ ^ self rawKey: hotKey ].

      (ctrlSymbol = #vanillaKey)
         ifTrue: [ ^ self vanillaKey: hotKey ].

      " IDCMP_MenuPick, IDCMP_GadgetUp & IDCMP_GadgetDown: "  

      ^ (ctrlDictionary at: ctrlID) perform: ctrlSymbol. 
| 
   testNewMenuUserData ! rval !
   
      rval <- self waitForUserData.
      
      ('menu userData[1] is: ', (rval at: 1) asString) print.
      ('menu userData[2] is: ', (rval at: 2) asString) print.
      ('menu userData[3] is: ', (rval at: 3) asString) print.
      ('menu userData[4] is: ', (rval at: 4) asString) print.
      ('menu userData[5] is: ', (rval at: 5) asString) print.
]
