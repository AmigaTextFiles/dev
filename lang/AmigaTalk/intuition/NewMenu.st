" ---------------------------------------------------------------------
* MenuStrip class is an Array of NewMenu Objects.  It also contains the
* methods to set & clear itself from a parent Window.
* --------------------------------------------------------------------- 
"
Class MenuStrip :Object ! mStrip parentWindow menuSize !
[
   attachedTo

     ^ parentWindow
|
   attachTo: aWindow ! check !

     parentWindow <- aWindow windowObject.

     " This all-in-one primitive does CreateMenus(), LayoutMenus() &
     * SetMenuStrip():
     "
     check <- <primitive 181 21 mStrip parentWindow>.
     
     (check ~= true)
        ifTrue: [ 'Menu Strip NOT Attached!!' print.
                   parentWindow <- nil ]
|
   hide

     <primitive 181 22 parentWindow>
|
   append: newMenuObject

     (1 to: menuSize) 
        do: [ :i | ((mStrip at: i) isNil)
                     ifTrue: [mStrip at: i put: newMenuObject. 
                                                 
                              ^ self ] ].
     ^ self
|
   new: numberOfElements  " Must include space for NM_END as well. "

     menuSize <- numberOfElements.
     
     mStrip   <- Array new: numberOfElements.
     
     ^ self
]

" ---------------------------------------------------------------------
* NewMenu Class is the class that creates NewMenu items that are
* used by the gadtools.library
*
* structureArray is an Array Object with the following
* elements in the given order:
* ele[1] <- nm_Type,          ele[2] <- nm_Label,
* ele[3] <- nm_CommKey,       ele[4] <- nm_Flags,
* ele[5] <- nm_MutualExclude, ele[6] <- nm_UserData 
*
* ele[6] is an Array as follows:
*
*    udele[1] <- Menu Type (#NM_TITLE, #NM_ITEM, #NM_SUB, #IM_ITEM,
*                           or #IM_SUB)
*    udele[2] <- menu ID_String,
*    udele[3] <- userData (Usually a #methodSymbol,
*    udele[4] <- equivalent to ele[3] (nm_CommKey)
*
*   Making a menu:
*
*   menuStrip  <- MenuStrip new: 3
*   menu1      <- NewMenu new
*   menu1Array <- menu1 titleMenuArray: 'PROJECT'
*   menu2      <- NewMenu new
*
*   menuAction <- Array new: 3
*   menuAction at: 1 put: #loadFileActionMethod
*   menuAction at: 2 put: 'Load a file...'
*   menuAction at: 3 put: 'L'
*
*   menu2Array <- menu2 menuItemArray: 'Load a file...' key: 'L' 
*                               flags: 0 data: menuAction
*
*   menu3      <- NewMenu new
*
*   You MUST have one of these for a valid menu strip:
*   menu3 fillNewMenuItemWith: (menu3 endOfMenuArray)
*
*   menuStrip at: 1 put: menu1
*   menuStrip at: 2 put: menu2
*   menuStrip at: 3 put: menu3
*
*   menuStrip attachTo: myWindow
* --------------------------------------------------------------------- 
" 
Class NewMenu :Object
! private intuition windowObj structArray myAction !
[
   xxxDisposeMenu

      <primitive 239 1 0 (self xxxMenu)>.
      
      <primitive 250 5 0 private>.
|
   dispose               " Synonym for xxxDisposeMenu "

      self xxxDisposeMenu.
      
      ^ nil
|
   new: newAction

      intuition   <- Intuition new.   
      structArray <- Array     new: 6.
      private     <- <primitive 239 1 1 1>.

      self value: newAction.
      
      ^ self
|
   addedTo: menuStrip

      ^ menuStrip append: (self xxxMenu).
|
   registerTo: myWindowObject
   
      (myWindowObject isNil)
         ifTrue: [ 'NewMenu Object given a nil Window object!' print.
                   ^ nil
                 ].

      ^ windowObj <- myWindowObject
|
   xxxMenu

      " In order to avoid changing the underlying primitive code
      * (again!), this method will return the NewMenu Object
      * from the private Object:
      "
      ^ (private at: 1)
|
   value: newAction       " testMenu is an example Action "
      
      ^ myAction <- newAction
|
   value
      
      ^ myAction
|
   initializeControl  " Only NewGadgets need this method to do something: "
   
      ^ nil
|
   testMenu ! ans !  
   
      " this is a test method for UserGUI to use & is setup
      * by setting >> userData at: 3 put: #testMenu << 
      "
      amigatalk setIOTitle: 'Menu Test Action:'.
      
      ans <- amigatalk getUserResponse: ('You selected: "', 
                                         ((structArray at: 2) asString), 
                                         '" Do you want to continue?').
      
      (ans = 0)
         ifTrue:  [ ^ true  ]
         ifFalse: [ ^ false ] " Terminate UserGUI/controlLoop "
|
   menuUserData: userDataArray
   
      structArray at: 6 put: userDataArray
|
   fillNewMenuItemWith: structureArray
   
      (1 to: 6) do: [ :i | structArray at: i 
                                      put: (structureArray at: i) ].
      
      (<primitive 239 1 2 1 structArray private> ~= true)
         ifTrue: [ self xxxDisposeMenu.
                   'ERROR:  Could NOT fill a NewMenu entry!' print.
                   ^ nil
                 ] 
|
   endOfMenuArray ! endArray !  " Required by ALL menuStrips "

      endArray <- self xxxMakeArray: nil k: nil f: 0 data: 0.
      
      endArray at: 1 put: (intuition systemTag: #NM_END).

      ^ endArray
|
   titleMenuArray: title ! rval ! " Make a new Menu TITLE: "

      rval <- self xxxMakeArray: title k: nil f: 0 data: nil.

      rval at: 1 put: (intuition systemTag: #NM_TITLE).

      self fillNewMenuItemWith: rval.
      
      ^ rval
|
   barLabel ! rval ! " Make a new Menu item NM_BARLABEL: "

      rval <- self xxxMakeArray: nil k: nil f: 0 data: nil.

      rval at: 1 put: (intuition systemTag: #NM_BARLABEL).
      
      self fillNewMenuItemWith: rval.

      ^ rval
|
   menuItemArray: title key: commKey flags: flags data: userData ! rval !    
   
      " Make a new Menu ITEM: "

      rval <- self xxxMakeArray: title    k: commKey 
                              f: flags data: userData.

      rval at: 1 put: (intuition systemTag: #NM_ITEM).

      self fillNewMenuItemWith: rval.
            
      ^ rval
|
   subItemArray: title key: commKey flags: flags data: userData ! rval !

      " Make a new menu SUB: "

      rval <- self xxxMakeArray: title    k: commKey 
                              f: flags data: userData.

      rval at: 1 put: (intuition systemTag: #NM_SUB).
      
      self fillNewMenuItemWith: rval.

      ^ rval
|
   menuItemSpace ! rval !    
   
      " Make a new Menu ITEM that is blank #NM_IGNORE: "

      rval <- self xxxMakeArray: nil k: nil f: 0 data: nil.

      rval at: 1 put: (intuition systemTag: #NM_IGNORE).
      
      self fillNewMenuItemWith: rval.

      ^ rval
|
   menuImageArray: image key: commKey flags: flags data: userData ! rval !

      " Make a new Menu IM_ITEM: "

      rval <- self xxxMakeArray: image    k: commKey 
                              f: flags data: userData.

      rval at: 1 put: (intuition systemTag: #IM_ITEM).
      
      self fillNewMenuItemWith: rval.

      ^ rval
|
   subImageArray: image key: commKey flags: flags data: userData ! rval !

      " Make a new Menu IM_SUB: "

      rval <- self xxxMakeArray: image    k: commKey 
                              f: flags data: userData.

      rval at: 1 put: (intuition systemTag: #IM_SUB).

      self fillNewMenuItemWith: rval.
      
      ^ rval
|
   xxxMakeArray: t k: k f: f data: data

      structArray at: 2 put: t.     " menu title string   "
      structArray at: 3 put: k.     " menu shortcut key   "
      structArray at: 4 put: f.     " menu flags          "
      structArray at: 5 put: 0.     " mutualexclude value "
      structArray at: 6 put: data.  " menu userdata       "
      
      ^ structArray
]
