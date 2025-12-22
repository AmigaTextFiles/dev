" ------------------------------------------------------------
* A Controller coordinates a model, and user actions.  It
* provides scheduling (control) behavior to determine when the
* user wants to communicate with the model or view.
* ------------------------------------------------------------ 
"
Class Controller :Object ! myModel myWindow !
[
   initialize

      " Initialize the state of the receiver. Subclasses should 
      * include 'super initialize' when redefining this message 
      * to insure proper initialization.
      "

      "Controller initialize"
      ^ self
|
   window

      ^ myWindow
|
   window: newWindow

      myWindow <- newWindow
|
   release

     " Breaks the cycle between the receiver and its model. 
      * It is usually not necessary to send release provided 
      * the receiver's model has been properly 
      * released independently.
      "
      myModel <- nil.
|
   isInWorld

     ^ (myWindow ~~ nil)
|
   model

      " Answer the receiver's model which is the same as the 
      * model of the receiver's view.
      "
      ^ myModel
|
   model: aModel 

      " Controller/model: is sent in 
      * order to coordinate the links between the model, and 
      * controller.  In ordinary usage, the receiver is created 
      * and passed as the parameter to Model/addDependent: 
      * so that the receiver's model and controller links 
      * can be set up by the model.
      "
      myModel <- aModel
|
   refreshView
      (myModel notNil)
        ifTrue: [ myModel value ].
|
   controlInitialize

      " Sent by Controller | startUp as part of the 
      * standard control sequence, it provides a place in 
      * the standard control sequence for initializing the 
      * receiver (taking into account the current state of 
      * its model and controller).  It should be redefined 
      * in subclasses to perform some specific action.
      "
      ^ self
|
   controlLoop 

      " Sent by Controller|startUp as part of the standard 
      * control sequence.  Controller|controlLoop sends the 
      * message Controller|isControlActive to test for loop 
      * termination.  As long as true is returned, the loop 
      * continues.  When false is returned, the loop ends. 
      * Each time through the loop, the 
      * message Controller|controlActivity is sent.
      "
      [self isControlActive] 
         whileTrue: [ self controlActivity ]
|
   controlTerminate

      " Provide a place in the standard control sequence 
      * for terminating the receiver (taking into account 
      * the current state of its model and controller).  It 
      * should be redefined in subclasses to perform some 
      * specific action.
      "
      ^ self
|
   startUp

      " Give control to the receiver.  The default control 
      * sequence is to initialize (see 
      * Controller|controlInitialize), to loop 
      * (see Controller|controlLoop), and then to terminate 
      * (see Controller|controlTerminate).  After this 
      * sequence, control is returned to the sender of 
      * Control|startUp.  The receiver's control sequence is 
      * used to coordinate the interaction of its controller 
      * and model.  In general, this consists of waiting for 
      * user input, testing the input with respect to the 
      * current display of the controller, and updating the 
      * model to reflect intended changes.
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
   controlActivity

      " Pass control to the next control level (that is, 
      * to the Controller of a subView of the receiver's 
      * view) if possible. It is sent by 
      * Controller/controlLoop each time through the main 
      * control loop.
      "
      self checkControls.
|
   checkControls 
      
      " This must be redefined by subclasses to do something
      * useful, including telling the Model that changes 
      * have been made by the User.
      "
      ^ nil
|
   isControlActive

      " Answer whether receiver wishes to continue evaluating 
      * its controlLoop method.  It is sent by 
      * Controller/controlLoop in order to determine when the 
      * receiver's control loop should terminate, and should 
      * be redefined in a subclass if some special condition 
      * for terminating the main control loop is needed.
      "
      ^ self viewHasMouse
|
   refreshYourself

     " Since the User clicks on GUI elements & enters text 
     * into GUI elements, the Controller already has placed
     * the View Data into the View & sent the changes to 
     * the Model so all we have to do is:
     "
     myWindow refreshYourself   " Into Window.st on 09-Nov-2002 "
|
   viewHasMouse ! mousePt tl br xCoord yCoord !

      " Answer whether the mouse pointer is in the 
      * receiver's view. Controller/viewHasMouse is normally
      * used in internal methods.
      "
     (myWindow isNil)
       ifFalse: [ mousePt <- myWindow getMouseCoords.
                  tl      <- myWindow getOrigin.
                  br      <- myWindow getWindowSize.
                  xCoord  <- Interval new.
                  yCoord  <- Interval new.
                  
                  xCoord from: tl x to: br x.
                  yCoord from: tl y to: br y.
                  
                  (xCoord inRange: (mousePt x)
                     and: [yCoord inRange: (mousePt y)])
                   
                     ifTrue:  [ ^ true ] ].
     ^ false
|
   superController

     ^ nil  " SubControllers should override this. "
|
   new

     ^ super new  " initialize "
]
