" ----------------------------------------------------------------- "
" Workbench Class implements the functions that the AmigaOS uses to "
" interface to workbench.  Dealings with Icons are performed in the "
" Icon Class in Icons.st.                                           "
" ----------------------------------------------------------------- "

Class Workbench :Object ! private ! "appWindow appWindowDropZone appIcon appMenuItem"
[
   closeWorkbench

      ^ <primitive 209 1 14>  " Returns true or false "
|      
   openWorkbench    

      ^ <primitive 209 1 15>  " Returns true or false "
|
   workbenchToBack

      ^ <primitive 209 1 16>  " Returns true or false "
|
   workbenchToFront

      ^ <primitive 209 1 17>  " Returns true or false "
|
   addAppWindow: windowObj port: msgPort id: id data: userData tags: tagArray

     " ULONG id, ULONG userdata, struct Window *window, 
     * struct MsgPort *msgport, struct TagItem *taglist );
     "
     " Returns an appWindow Object or nil: "

     ^ <primitive 209 1 3 private id userData windowObj msgPort tagArray> 
|
   removeAppWindow: appWindowObject

     " Returns true or false: "

     ^ <primitive 209 1 2 private appWindowObject>
|
   addAppIcon: text port: msgPort   id: id data: userData lock: fileBptrLock 
                    icon: diskObj tags: tagArray

     " Returns an appIcon Object or nil: "

     ^ <primitive 209 1 4 private id userData text msgPort fileBptrLock diskObj tagArray> 
|
   removeAppIcon: appIconObject

     " Returns true or false: "

     ^ <primitive 209 1 5 private appIconObject>
|
   addAppMenuItem: text port: msgPort id: id data: userData tags: tagArray

     "( ULONG id, ULONG userdata, UBYTE *text, 
     * struct MsgPort *msgport, struct TagItem *taglist );
     "
     " Returns an appMenuItem Object or nil: "

     ^ <primitive 209 1 6 private id userData text msgPort tagArray> 
|
   removeAppMenuItem: appMenuItemObject

     " Returns true or false: "

     ^ <primitive 209 1 7 private appMenuItemObject>
|
   workbenchInfo: objName lock: fileLock screen: screenObject

     <primitive 209 1 8 private fileLock objName screenObject>
|
   openWorkbenchObject: objName tags: tagArray

     " returns true or false: "

     ^ <primitive 209 1 1 private objName tagArray> 
|
   closeWorkbenchObject: objName tags: tagArray

     " returns true or false: "

     ^ <primitive 209 1 0 private objName tagArray> 
|
   workbenchControl: objName tags: tagArray

     " returns true or false: "

     ^ <primitive 209 1 9 private objName tagArray> 
|
   addAppWindowDropZone: appWindow id: id data: userData tags: tagArray

     " struct AppWindow *aw, ULONG id, ULONG userdata, struct TagItem *tags ); "
     " Returns an appWindowDropZone Object or nil: "

     ^ <primitive 209 1 10 private appWindow id userData tagArray> 
|
   removeAppWindowDropZone: appWindow dropZone: appWindowDropZoneObject

     " returns true or false: "

     ^ <primitive 209 1 11 private appWindow appWindowDropZoneObject> 
| 
   changeWorkbenchSelection: objName hook: hookObject tags: tagArray

     " returns true or false: "

     ^ <primitive 209 1 12 private objName hookObject tagArray> 
|
   makeWorkbenchObjectVisible: objName tags: tagArray

     " returns true or false: "

     ^ <primitive 209 1 13 private objName tagArray> 
]
