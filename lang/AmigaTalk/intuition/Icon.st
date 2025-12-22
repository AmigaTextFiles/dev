"------------------------------------------------------------------"
" Icon Class implements control of Amiga Workbench Icons           "
" Chances are that Glyph is the wrong parent class for this class. "
"------------------------------------------------------------------"

Class Icon :Glyph ! private iconName !
[
   editToolTypes ! temp !

      temp <- <primitive 219 2 iconName>.
      
      (temp ~= true)
         ifTrue: ['ToolTypesEditor NOT found!' print]
|      
   displayIconInfo ! temp !

      temp <- <primitive 219 3 private iconName>.
      
      (temp ~= nil)
        ifTrue: ['Method displayIconInfo returned', temp print]
|
   displayIconImages

      <primitive 219 4 private iconName>
|
   setIconPosition: newPoint ! nx ny chk !

      nx  <- newPoint x.
      ny  <- newPoint y. 
      chk <- <primitive 219 5 private iconName nx ny>.

      (chk ~= nil)
         ifTrue: ['Method setIconPosition returned ', chk print]
|
   moveIcon: deltaPoint ! dx dy chk !

      dx  <- deltaPoint x.
      dy  <- deltaPoint y. 
      chk <- <primitive 219 6 private iconName dx dy>.

      (chk ~= nil)
         ifTrue: ['Method moveIcon returned ', chk print]
|
   editIcon: externalEditorName

      (<primitive 219 7 iconName externalEditorName> ~= true)
         ifTrue: ['Method editIcon: ',externalEditorName, 'did NOT run!' print]
|
   addToolType: toolString

      (<primitive 219 8 private iconName toolString> == false)
        ifTrue: ['ToolType ', toolString, 'NOT added!' print]
|
   deleteToolType: toolString

      (<primitive 219 9 private iconName toolString> == false)
        ifTrue: ['ToolType ', toolString, 'NOT deleted!' print]
|
   getIconWidth
      ^ <primitive 219 10 private>
|
   getIconHeight
      ^ <primitive 219 11 private>
|
   getIconFlags
      ^ <primitive 219 12 private>
|
   getIconImageObject
      ^ <primitive 219 13 private>
|
   getIconAlternateImageObject
      ^ <primitive 219 14 private>
|
   getIconType
      "  Valid types are:

         WBDISK     = 1
         WBDRAWER   = 2
         WBTOOL     = 3
         WBPROJECT  = 4
         WBGARBAGE  = 5
         WBDEVICE   = 6
         WBKICK     = 7
         WBAPPICON  = 8
      "
      ^ <primitive 219 15 private>
|
   getDefaultIcon: iconType
      ^ <primitive 219 36 iconType>  " See getIconType comments for iconType "
|
   newDiskObject: iconType
      ^ <primitive 219 41 iconType>  " See getIconType comments for iconType "
|
   getNewDiskObject: iconName
      ^ <primitive 219 38 iconName>
|
   getDefaultTool
      ^ <primitive 219 16 private>
|
   getStackSize
      ^ <primitive 219 17 private>
|
   getWindowWidth
      ^ <primitive 219 18 private>
|
   getWindowHeight
      ^ <primitive 219 19 private>
|
   getWindowTopEdge
      ^ <primitive 219 20 private>
|
   getWindowLeftEdge
      ^ <primitive 219 21 private>
|
   getIconBounds: diskObj   for: rectObj from: windowObj label: labelStr tags: tagArray
      " labelStr can be nil for this method "
      ^ <primitive 219 48 windowObj diskObj labelStr rectObj tagArray>
|
   setIconWidth: newWidth
      (<primitive 219 22 private iconName newWidth> ~= true)
         ifTrue: ['Method setIconWidth: ', newWidth, ' failed!' print]
|
   setIconHeight: newHeight
      (<primitive 219 23 private iconName newHeight> ~= true)
         ifTrue: ['Method setIconHeight: ', newHeight, ' failed!' print]
|
   setIconFlags: newFlags
      (<primitive 219 24 private iconName newFlags> ~= true)
         ifTrue: ['Method setIconFlags: ', newFlags, ' failed!' print]
|
   setIconImage: imageObject
      (<primitive 219 25 private iconName imageObject> ~= true)
         ifTrue: ['Method setIconImage: failed!' print]
|
   setIconAlternateImage: imageObject
      (<primitive 219 26 private iconName imageObject> ~= true)
         ifTrue: ['Method setIconAlternateImage: failed!' print]
|
   setIconType: newType
      "  Valid types are:

         WBDISK     = 1
         WBDRAWER   = 2
         WBTOOL     = 3
         WBPROJECT  = 4
         WBGARBAGE  = 5
         WBDEVICE   = 6
         WBKICK     = 7
         WBAPPICON  = 8
      "
      (<primitive 219 27 private iconName newType> ~= true)
         ifTrue: ['Method setIconType: ', newType, ' failed!' print]
|
   setDefaultTool: newDefaultTool
      (<primitive 219 28 private iconName newDefaultTool> ~= true)
         ifTrue: ['Method setDefaultTool: ', newDefaultTool, ' failed!' print]
|
   setStackSize: newStackSize
      (<primitive 219 29 private iconName newStackSize> ~= true)
         ifTrue: ['Method setStackSize: ', newStackSize, ' failed!' print]
|
   setWindowWidth: newWidth
      (<primitive 219 30 private iconName newWidth> ~= true)
         ifTrue: ['Method setWindowWidth: ', newWidth, ' failed!' print]
|
   setWindowHeight: newHeight
      (<primitive 219 31 private iconName newHeight> ~= true)
         ifTrue: ['Method setWindowHeight: ', newHeight, ' failed!' print]
|
   setWindowTopEdge: newTopEdge
      (<primitive 219 32 private iconName newTopEdge> ~= true)
         ifTrue: ['Method setWindowTopEdge: ', newTopEdge, ' failed!' print]
|
   setWindowLeftEdge: newLeftEdge
      (<primitive 219 33 private iconName newLeftEdge> ~= true)
         ifTrue: ['Method setWindowLeftEdge: ', newLeftEdge, ' failed!' print]
|
   readInAsciiImage: fileName
      (<primitive 219 34 private iconName fileName> ~= true)
         ifTrue: ['Method readInAsciiImage: ', fileName, ' failed!' print]
|
   writeAsciiImage: fileName
      (<primitive 219 35 private fileName> ~= true)
         ifTrue: ['Method writeAsciiImage: ', fileName, ' failed!' print]
|
   iconControl: diskObject tags: tagArray
      ^ <primitive 219 42 diskObject tagArray> " diskObject can be nil "
|
   findToolType: toolName in: diskObj
      ^ <primitive 219 45 diskObj toolName>
|
   matchTool: toolTypeString to: toolValueStr
      ^ <primitive 219 46 toolTypeString toolValueStr>
|
   storeDefaultIcon: diskObject
      ^ <primitive 219 37 diskObject>
|
   duplicateDiskObject: diskObject tags: tagArray
      ^ <primitive 219 40 diskObject tagArray>
|
   drawIcon: diskObj on: windowObj label: labelStr at: sPoint inState: whichState 
                                                                 tags: tagArray
   ! xOffset yOffset !

   " labelStr can be nil for this method "

      xOffset <- sPoint x.
      yOffset <- sPoint y.
      
      <primitive 219 43 windowObj diskObj labelStr xOffset yOffset whichState tagArray>
|
   layoutIcon: diskObj on: screenObj tags: tagArray

      ^ <primitive 219 44 diskObj screenObj tagArray>  " screenObj can be nil "
|
   bumpRevision: oldName to: newName

      " newName HAS to be a String object of at least 31 characters in length 
      * Just create it with:  newName <- String new: 32
      "
      ^ <primitive 219 47 newName oldName>
|
   changeColorToSelectedIconColor: colorRegisterObj

      " See icon.library docs for ChangeToSelectedIconColor() function "
      <primitive 219 53 colorRegisterObj>
|
   disposeFreeList: freeListObj

      <primitive 219 51 freeListObj>.
      
      <primitive 250 5 0 freeListObj>.
      
      ^ nil
|
   add: memoryObj toFreeList: freeListObj size: size

      ^ <primitive 219 52 freeListObj memoryObj size>
|
   deleteDiskObject: iconName

      ^ <primitive 219 39 iconName>
|
   closeIcon ! chk !

      chk <- <primitive 219 0 private iconName>.

      (chk ~= nil)
        ifTrue: ['Icon Object was NOT written out!' print]
|
   storeIcon: diskObj named: iconName tags: tagArray

      ^ <primitive 219 50 iconName diskObj tagArray>
|
   openIcon: iconFileName

      iconName <- iconFileName.

      ^ private  <- <primitive 219 1 iconFileName>.
|
   getIcon: iconName tags: tagArray

      " iconName can be nil for this method "
      ^ private <- <primitive 219 49 iconName tagArray>  
|
   new: iconFileName

      ^ (self openIcon: iconFileName) 
]
