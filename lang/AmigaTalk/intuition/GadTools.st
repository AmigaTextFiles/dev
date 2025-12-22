" --------------------------------------------------------------------- " 
" GadTools class is the Parent class that interfaces AmigaTalk to the   "
" gadtools.library in AmigaDOS.                                         "
" --------------------------------------------------------------------- " 

Class GadTools :Glyph ! intuiMsgObj windowObj visualInfoObj !
[
   drawBoxFrom: sPoint to: ePoint tags: tagArray ! x y w h !
      " This is a beveled box.  The tags will say whether it's recessed or not "
      x <- sPoint x. " These are NOT checked against window boundaries "
      y <- sPoint y.
      w <- ePoint x.
      h <- ePoint y.
      
      <primitive 239 2 windowObj x y w h tagArray>
|
   beginRefresh
      <primitive 239 3 2 windowObj>
|
   endRefresh: completeFlag
      <primitive 239 3 3 windowObj completeFlag> " completeFlag = true or false"
|
   getIMsg
      ^ intuiMsgObj <- <primitive 239 3 4 windowObj>
|
   replyIMsg
      <primitive 239 3 5 intuiMsgObj>
|
   replyIMsg: thisIntuiMsg
      <primitive 239 3 5 thisIntuiMsg>
|
   getMessageClass: intuiMsgObject
      ^ <primitive 239 3 10 intuiMsgObject>
|
   getMessageCode: intuiMsgObject
      ^ <primitive 239 3 11 intuiMsgObject>
|
   getMessageQualifier: intuiMsgObject
      ^ <primitive 239 3 12 intuiMsgObject>
|
   getMessageIAddress: intuiMsgObject
      ^ <primitive 239 3 13 intuiMsgObject>
|
   getMessageMouseX: intuiMsgObject
      ^ <primitive 239 3 14 intuiMsgObject>
|
   getMessageMouseY: intuiMsgObject
      ^ <primitive 239 3 15 intuiMsgObject>
|
   getMessageSeconds: intuiMsgObject
      ^ <primitive 239 3 16 intuiMsgObject>
|
   getMessageMicros: intuiMsgObject
      ^ <primitive 239 3 17 intuiMsgObject>
|
   getGadgetType: intuiMsgObject
      ^ <primitive 239 3 18 intuiMsgObject>
|
   refreshWindow
      <primitive 239 3 6 windowObj>
|
   postFilterIMsg
      ^ intuiMsgObj <- <primitive 239 3 7 intuiMsgObj>
|
   filterIMsg
      ^ intuiMsgObj <- <primitive 239 3 8 intuiMsgObj>
|
   windowIs
      ^ windowObj " Tell subclasses what Window they are attached to "
|
   registerTo: aWindowObject
      ^ windowObj <- aWindowObject
|
   visualInfoObject
      ^ visualInfoObj
|
   freeVisualInfo
      <primitive 239 3 0 visualInfoObj>. 

      " visualInfoObj cannot be used after this unless you perform
      * getVisualInfo:tags: again
      "

      ^ visualInfoObj <- nil
|
   getVisualInfo: screenObj tags: tagArray
      visualInfoObj <- <primitive 239 3 1 screenObj tagArray>.

      (visualInfoObj isNil)
         ifTrue: [ 'ERROR: could NOT obtain visualInfo from screen!' print.
                   ^ nil
                 ].
                 
      ^ visualInfoObj
]

" --------------------------------------------------------------------- " 
" NewGadgets Class is the class that interfaces AmigaTalk to the        "
" new gadgets portion of gadtools.library                               "
" --------------------------------------------------------------------- " 

Class NewGadgets :GadTools ! private gadgetList aNewGadgetObj windowObj !
[
   dispose
      ^ nil
|
   disposeGadgetList: gadgetListObj
      " Equivalent to FreeGadgets() from gadtools.library: "
      <primitive 239 0 0 gadgetListObj>
|
   allocateGadgetList
      ^ gadgetList <- <primitive 239 0 1>.
|
   createGadgetList
      " Equivalent to CreateContext() from gadtools.library: "
      ^ private <- <primitive 239 0 2 gadgetList>.
|
   disposeNewGadget: unNeededNewGadgetObj
      " You will have to keep track of every newGadgetObj returned
      * from makeNewGadget: & use this method on ALL of them 
      * (unless you have memory to burn).  Once you've called
      * addGadgetToList:type:tags:, a newGadgetObj is no longer
      * needed & perhaps you should use this method afterwards:
      "
      <primitive 239 0 7 unNeededNewGadgetObj>.

      ^ nil
|
   makeNewGadget: structureArray ! desiredSize !
      desiredSize <- 12.
      
      " structureArray is an Array Object with the following
      * elements in the given order:
      *   ele[1]  <- ng_LeftEdge,   ele[2]  <- ng_TopEdge,
      *   ele[3]  <- ng_Width,      ele[4]  <- ng_Height,
      *   ele[5]  <- ng_GadgetText, ele[6]  <- ng_TextAttr,
      *   ele[7]  <- ng_GadgetID,   ele[8]  <- ng_Flags,
      *   ele[9]  <- ng_VisualInfo, ele[10] <- ng_UserData
      *
      *   ele[11] <- NewGadget Type Tag
      *   ele[12] <- HotKey or nil.
      *
      *   ele[10] (UserData) can be any AmigaTalk object 
      *   but I recommend that you use a #methodSymbol.
      *
      *   ele[7] (GadgetID) should be a 16-Bit Integer value.
      "
      ^ aNewGadgetObj <- <primitive 239 0 3 structureArray desiredSize>
|
   newStructArray: initArray ! newArray !
      " Example usage:
      * gType        <- intuition getGadgetType: #BUTTON_KIND
      * newGadget    <- NewGadgets new
      * vi           <- newGadget visualInfoObject
      * hotKey       <- $K
      * newStruct    <- newGadget newStructArray: #( 10 40 100 20 'My _Gadget'
      *                                              textAttrObj gadgetID 
      *                                              myFlags vi
      *                                              userData gType hotKey)
      * newGadgetObj <- newGadget makeNewGadget: newStruct
      "
      newArray <- Array new: 12.
      
      newArray at: 1  put: (initArray at: 1).
      newArray at: 2  put: (initArray at: 2).
      newArray at: 3  put: (initArray at: 3).
      newArray at: 4  put: (initArray at: 4).
      newArray at: 5  put: (initArray at: 5).
      newArray at: 6  put: (initArray at: 6).
      newArray at: 7  put: (initArray at: 7).
      newArray at: 8  put: (initArray at: 8).
      newArray at: 9  put: (initArray at: 9).
      newArray at: 10 put: (initArray at: 10).
      newArray at: 11 put: (initArray at: 11).
      newArray at: 12 put: (initArray at: 12).

      ^ newArray
|
   addGadgetToList: newGadgetObj at: gadgetObj type: gType tags: tagArray
      " Equivalent to CreateGadgetA() from gadtools.library: "
      ^ <primitive 239 0 4 gadgetObj newGadgetObj gType tagArray>
|
   setGadgetAttrs: gadgetObj with: tagArray
      " Equivalent to GT_SetGadgetAttrsA() from gadtools.library: "
      <primitive 239 0 5 gadgetObj windowObj tagArray>
|
   getGadgetAttrs: gadgetObj with: tagArray
      " Equivalent to GT_GetGadgetAttrsA() from gadtools.library: "
      ^ <primitive 239 0 6 gadgetObj windowObj tagArray>
|
   registerTo: aWindowObject
      (aWindowObject isNil)
         ifTrue: [ 'NewGadgets Object given a nil Window object!' print.
                   ^ nil
                 ].
                 
      ^ windowObj <- aWindowObject
|
   waitForGadgetValue ! rval !
      " Use the returned Object (or copy it) BEFORE using any method 
      * that uses <primitive 239 3 9 windowObj> again!
      "
      rval <- <primitive 239 3 9 windowObj>.
      
      ^ (rval at: 1)
|
   waitForGadgetUserData ! rval !
      " Smalltalk code has to call this inside a loop if there
      * is more than one IDCMP event expected.  You do NOT
      * need to use beginRefresh or endRefresh arround this
      * method.  Any AmigaTalk Object is valid as the
      * UserData stored in the NewGadget.
      *
      * Use the returned Object (or copy it) BEFORE using any method 
      * that uses <primitive 239 3 9 windowObj> again!
      "
      rval <- <primitive 239 3 9 windowObj>.
      
      ^ (rval at: 2)
|
   checkForGadgetValue ! rval ! 

      " Use the returned Object (or copy it) BEFORE using any method 
      * that uses <primitive 239 3 19 windowObj> again!
      "
      rval <- <primitive 239 3 19 windowObj>.
      
      (rval notNil)
         ifTrue: [ ^ (rval at: 1)]
      
      ^ rval " Simply return the nil "
|
   checkForGadgetUserData ! rval !
      " Smalltalk code has to call this inside a loop if there
      * is more than one IDCMP event expected.  You do NOT
      * need to use beginRefresh or endRefresh arround this
      * method.  Any AmigaTalk Object is valid as the
      * UserData stored in the NewGadget.
      *
      * Use the returned Object (or copy it) BEFORE using any method 
      * that uses <primitive 239 3 19 windowObj> again!
      "
      rval <- <primitive 239 3 19 windowObj>.

      (rval notNil)      
         ifTrue: [^ (rval at: 2)]

      ^ rval " Simply return the nil "
|
   getUserData: intuiMsgObj
      " User pressed a gadget, so get the User Data associated with it: "
      ^ <primitive 239 0 8 intuiMsgObj>
|
   getGadgetID: intuiMsgObj
      " User pressed a gadget, so get the GadgetID associated with it: "
      ^ <primitive 239 0 9 intuiMsgObj>
]

" --------------------------------------------------------------------- " 
" NewMenus Class is the class that interfaces AmigaTalk to the          "
" new Menus portion of gadtools.library                                 "
""
"   Making a menu: "

""
"   menu <- NewMenus new "
"   menu allocateNewMenu: 3 "
"   menu1Array <- Array new: 6 "
"   menu2Array <- Array new: 6 "
"   intuition  <- Intuition new "
""
"   menu1Array at: 1 put: (intuition getGadToolAttr: #NM_TITLE)"
"   menu1Array at: 2 put: 'PROJECT' "
"   menu1Array at: 3 put: 0  NO nm_CommKey for a Menu Title! "
"   menu1Array at: 4 put: 0 "
"   menu1Array at: 5 put: 0 "
"   menu1Array at: 6 put: 0 "
""
"   menu2Array at: 1 put: (intuition getGadToolAttr: #NM_ITEM)"
"   menu2Array at: 2 put: 'Load a file..' "
"   menu2Array at: 3 put: 'L' "
"   menu2Array at: 4 put: 0 "
"   menu2Array at: 5 put: 0 "
"   menu2Array at: 6 put: 0 "
""
"   menu fillNewMenuItem: 1 with: menu1Array "
"   menu fillNewMenuItem: 2 with: menu2Array "
""
"   You MUST have one of these for a valid menu strip: "
"   menu fillNewMenuItem: 3 with: (menu endOfMenuArray: intuition) "
""
"   chk1 <- menu createMenuStrip: tagArray1 -- CreateMenusA() tags apply here "
"   chk2 <- initializeMenus: tagArray2      -- LayoutMenusA() tags apply here "
" --------------------------------------------------------------------- " 

Class NewMenus :GadTools ! private newMenuArrayObj windowObj !
[
   disposeMenu
      <primitive 239 1 0 private newMenuArrayObj>
|
   dispose               " Synonym for disposeMenu: "
      self disposeMenu
|
   allocateNewMenu: numItems ! chk !
      " newMenuArrayObj is an Array of NewMenu objects "

      chk <- <primitive 239 1 1 numItems>.

      (chk isNil)
         ifTrue: [ 'Did NOT allocateNewMenu:' print].
         
      ^ newMenuArrayObj <- chk
|
   endOfMenuArray: intuitionObj ! endArray !
      endArray  <- Array new: 6.

      endArray at: 1 put: (intuitionObj getGadToolAttr: #NM_END).
      endArray at: 2 put: nil. " NO nm_Label        "
      endArray at: 3 put: nil. " NO nm_CommKey      "
      endArray at: 4 put: 0.   " NO nm_Flags        "
      endArray at: 5 put: 0.   " NO nm_MutualExclude"
      endArray at: 6 put: 0.   " NO nm_UserData     "

      ^ endArray
|
   xxxMakeArray: t k: k f: f x: ex data: data ! rval !
      " See fileNewMenuItem comments: "

      rval <- Array new: 6.

      rval at: 2 put: t.
      rval at: 3 put: k.
      rval at: 4 put: f.
      rval at: 5 put: ex.
      rval at: 6 put: data.
      
      ^ rval
|
   initMenuArray: intObj title: title key: commKey flags: flags exclude: mx data: userData 
      ! rval !
      " Make a new Menu.  See fileNewMenuItem comments: "
      rval <- self xxxMakeArray: title k: commKey f: flags x: mx data: userData.

      rval at: 1 put: (intObj getGadToolAttr: #NM_TITLE).
      
      ^ rval
|
   initMenuItemArray: intObj title: title key: commKey flags: flags exclude: mx data: userData 
      ! rval !
      " Make a new MenuItem.  See fileNewMenuItem comments: "
      rval <- self xxxMakeArray: title k: commKey f: flags x: mx data: userData.

      rval at: 1 put: (intObj getGadToolAttr: #NM_ITEM).
      
      ^ rval
|
   initSubItemArray: intObj title: title key: commKey flags: flags exclude: mx data: userData 
      ! rval !
      " Make a new SubItem.  See fileNewMenuItem comments: "

      rval <- self xxxMakeArray: title k: commKey f: flags x: mx data: userData.

      rval at: 1 put: (intObj getGadToolAttr: #NM_SUB).
      
      ^ rval
|
   initMenuImageArray: intObj title: title key: commKey flags: flags exclude: mx data: userData
      ! rval !
      " Make a new MenuItem.  See fileNewMenuItem comments: "

      rval <- self xxxMakeArray: title k: commKey f: flags x: mx data: userData.

      rval at: 1 put: (intObj getGadToolAttr: #IM_ITEM).
      
      ^ rval
|
   initSubImageArray: intObj title: title key: commKey flags: flags exclude: mx data: userData
      ! rval !
      " Make a new SubItem.  See fileNewMenuItem comments: "

      rval <- self xxxMakeArray: title k: commKey f: flags x: mx data: userData.

      rval at: 1 put: (intObj getGadToolAttr: #IM_SUB).
      
      ^ rval
|
   fillNewMenuItem: itemNumber with: structureArray
      " structureArray is an Array Object with the following
      * elements in the given order:
      * ele[1] <- nm_Type,          ele[2] <- nm_Label,
      * ele[3] <- nm_CommKey,       ele[4] <- nm_Flags,
      * ele[5] <- nm_MutualExclude, ele[6] <- nm_UserData 
      *
      * ele[6] is an Array as follows:
      *
      *    udele[1] <- menu Type
      *    udele[2] <- menu ID Integer or String,
      *    udele[3] <- userData (Usually a #methodSymbol,
      *    udele[4] <- equivalent to ele[2] (nm_CommKey)
      "
      (<primitive 239 1 2 itemNumber structureArray newMenuArrayObj> ~= true)
         ifTrue: [ self disposeMenu.
                   'ERROR:  Could NOT fill a NewMenu entry!' print.
                   ^ nil
                 ] 
|
   createMenuStrip: tagArray ! chk !
      chk <- <primitive 239 1 3 newMenuArrayObj tagArray>.
      
      (chk isNil)
         ifTrue: [ 'Did NOT createMenuStrip:' print.
                   ^ nil
                 ].
         
      ^ private <- chk
|
   visualInfo
      ^ (super visualInfoObject)
|
   initializeMenus: tagArray ! chk viObj !
      " This method returns true if successful, false if the menus
      * could NOT be laid-out, nil if there is an error condition.
      "
      viObj <- self visualInfo.
      chk   <- <primitive 239 1 4 private viObj tagArray>.

      (chk ~= true)
         ifTrue: [ 'Did NOT initialize NewMenus object!' print.
                   ^ false
                 ].
      ^ true
|
   initializeMenus: viObj tags: tagArray ! chk !
      " This method returns true if successful, false if the menus
      * could NOT be laid-out, nil if there is an error condition.
      "
      chk   <- <primitive 239 1 4 private viObj tagArray>.

      (chk ~= true)
         ifTrue: [ 'Did NOT initialize NewMenus object!' print.
                   ^ false
                 ].
      ^ true
|
   waitForMenuString ! rval !
      " Smalltalk code has to call this inside a loop if there
      * is more than one IDCMP event expected.  You do NOT
      * need to use beginRefresh or endRefresh arround this
      * method.
      *
      * Use the returned Object (or copy it) BEFORE using any method 
      * that uses <primitive 239 3 9 windowObj> again!
      "
      rval <- <primitive 239 3 9 windowObj>.
      
      ^ (rval at: 2)
|
   waitForMenuUserData ! rval !
      " Smalltalk code has to call this inside a loop if there
      * is more than one IDCMP event expected.  You do NOT
      * need to use beginRefresh or endRefresh arround this
      * method.  Make sure that you use only AmigaTalk Objects
      * as the UserData stored in the NewMenu.  This method will
      * return nil if the Menu Item selected was NULL.
      *
      * Use the returned Object (or copy it) BEFORE using any method 
      * that uses <primitive 239 3 9 windowObj> again!
      "
      rval <- <primitive 239 3 9 windowObj>.
      
      ^ (rval at: 1)
|
   getMenuUserData: intuiMsgCode
      " User selected a menu item, so return the User Data associated with it: "
      ^ <primitive 239 1 5 windowObj intuiMsgCode>
|
   getMenuItem: intuiMsgCode
      " Returns the MenuItem selected as an Object: "
      ^ <primitive 239 1 6 windowObj intuiMsgCode>
|
   isMenuNull: intuiMsgCode
      " check to see if the intuiMsgCode is MENUNULL, return true or false: "
      ^ <primitive 239 1 7 private intuiMsgCode>
|
   getMenuNumber: intuiMsgCode
      ^ <primitive 239 1 8 intuiMsgCode>
|
   getMenuItemNumber: intuiMsgCode
      ^ <primitive 239 1 9 intuiMsgCode>
|
   getSubNumber: intuiMsgCode
      ^ <primitive 239 1 10 intuiMsgCode>
|
   getFullMenuNumber: intuiMsgCode
      ^ <primitive 239 1 11 intuiMsgCode>
|
   registerTo: aWindowObject
      (aWindowObject isNil)
         ifTrue: [ 'NewMenus Object given a nil Window object!' print.
                   ^ nil
                 ].
                 
      ^ windowObj <- aWindowObject
]
