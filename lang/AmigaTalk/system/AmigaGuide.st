" ------------------------------------------------------------------------- "
" AmigaGuide Class implements the Amigatalk interface to amigaguide.library "
" This Class is only one step removed from primitives, so use it to derive  "
" a Class that is really Object-Oriented! "
" ------------------------------------------------------------------------- "

Class AmigaGuide :Object ! private private2 private3 !
[
   addAmigaGuideHost: hostNameString hook: hookObj tags: tagArray
     " Returns nil if unable to add the AmigaGuide Host named: "
     private2 <- <primitive 209 2 2 hookObj hostNameString tagArray>
|
   removeAmigaGuideHost: tagArray " tagArray should be nil for now. "
     (private2 isNotNil)
        ifTrue: [^ <primitive 209 2 3 private2 tagArray>]
|
   getAmigaGuideSignal
     ^ <primitive 209 2 4 private>
|
   closeAmigaGuide

     <primitive 209 2 0 private>.
     
     <primitive 250 5 0 private>.
     
     ^ nil
|
   getAmigaGuideAttribute: attrTag into: storageObj
     " For attrTag, see AGuideTags Class below "
     ^ <primitive 209 2 5 attrTag private storageObj>
|
   getAmigaGuideMsg
     " Returns nil if there was no message: "
     ^ <primitive 209 2 6 private>
|
   getAGMsgType: aGuideMsgObj
     " aGuideMsgObj is from getAmigaGuideMsg method: "
     ^ <primitive 209 2 31 aGuideMsgObj>
|
   getAGMsgData: aGuideMsgObj
     " aGuideMsgObj is from getAmigaGuideMsg method: "
     ^ <primitive 209 2 32 aGuideMsgObj>
|
   getAGMsgDataType: aGuideMsgObj
     " aGuideMsgObj is from getAmigaGuideMsg method: "
     ^ <primitive 209 2 33 aGuideMsgObj>
|
   getAGMsgDataSize: aGuideMsgObj
     " aGuideMsgObj is from getAmigaGuideMsg method: "
     ^ <primitive 209 2 34 aGuideMsgObj>
|
   getAGMsgReturnPrimaryValue: aGuideMsgObj
     " aGuideMsgObj is from getAmigaGuideMsg method: "
     ^ <primitive 209 2 35 aGuideMsgObj>
|
   getAGMsgReturnSecondaryValue: aGuideMsgObj
     " aGuideMsgObj is from getAmigaGuideMsg method: "
     ^ <primitive 209 2 36 aGuideMsgObj>
|
   getAmigaGuideString: stringIDNumber
     " Returns a String Object or nil: "
     ^ <primitive 209 2 7 stringIDNumber>
|
   lockAmigaGuideBase                        " You DO NOT need to use this method!! "
     " Returns a key for unlockAmigaGuideBase: "
     ^ <primitive 209 2 8 private>
|
   unlockAmigaGuideBase: keyFromLockMethod   " You DO NOT need to use this method!! "
     <primitive 209 2 9 keyFromLockMethod>
|
   openAmigaGuide: tagArray
     " For valid tags, see AGuideTags Class below "
     ^ private <- <primitive 209 2 1 private3 tagArray>
|
   openAmigaGuideASync: tagArray
     " For valid tags, see AGuideTags Class below "
     ^ private <- <primitive 209 2 10 private3 tagArray>
|
   replyAmigaGuideMsg: amigaGuideMsgObj
     " Reply to the msg Object obtained from the getAmigaGuideMsg method: "
     <primitive 209 2 11 amigaGuideMsgObj>
|
   sendAmigaGuideCommand: commandString tags: tagArray " tagArray should be nil for now. "
     " The following are the currently valid action commands:
     *
     *   ALINK <name> - Load the named node into a new window.
     *
     *   LINK <name>  - Load the named node.
     *
     *   RX <macro>   - Execute an ARexx macro.
     *
     *   RXS <cmd> - Execute an ARexx string file.  To display a picture,
     *               use 'ADDRESS COMMAND DISPLAY <picture name>', to
     *               display a text file 'ADDRESS COMMAND MORE <doc>'.
     *
     *   CLOSE - Close the window (should only be used on windows
     *           that were started with ALINK).
     *
     *   QUIT  - Shutdown the current database.
     *
     *   This method returns true if the message was sent:
     "
     ^ <primitive 209 2 12 private commandString tagArray>
|
   sendAmigaGuideContext: tagArray " tagArray should be nil for now. "
     ^ <primitive 209 2 13 private tagArray> 
|
   setAmigaGuideAttributes: tagArray
     " For valid tags, see AGuideTags Class below "
     ^ <primitive 209 2 14 private tagArray>
|
   setAmigaGuideContext: idNumber tags: tagArray " tagArray should be nil for now. "
     ^ <primitive 209 2 15 private idNumber tagArray>
|
   loadCrossReferencesFrom: fileName in: directoryLock
     " Returns an integer with the following meanings:
     *
     *    -1 - indicates that the load was aborted by CTRL-C from the User.
     *     0 - indicates failure to load.
     *     1 - indicates a successful load.
     *     2 - indicates that the table is already loaded.
     "
     ^ <primitive 209 2 18 directoryLock fileName>
|
   expungeCrossReferences " Unload the cross-reference table from memory. "
     <primitive 209 2 19> 
|
   createNewAmigaGuideObject
     ^ private3 <- <primitive 209 0 1 250>  " STRUCT_NewAmigaGuide = 250 "
|
   disposeNAG

     <primitive 209 0 2 private3>.
     
     <primitive 250 5 0 private3>.

     ^ nil 
|
   setNAGDirectoryLock: directoryLock
     <primitive 209 2 20 private3 directoryLock>     
|
   setNAGName: databaseName
     <primitive 209 2 21 private3 databaseName>     
|
   setNAGScreen: screenObject
     <primitive 209 2 22 private3 screenObject>
|
   setNAGPulicScreen: publicScreenName
     <primitive 209 2 23 private3 publicScreenName>     
|
   setNAGARexxClientPort: clientPortName
     <primitive 209 2 24 private3 clientPortName>
|
   setNAGFlags: newFlags
     " Valid values for newFlags is any of the following:
     *    HTF_LOAD_INDEX
     *    This flag only applies to an ansynchronous open.
     *    Force the index of the database to always be
     *    loaded.  The AmigaGuide system maintains two date
     *    stamps, one for the last time that the database was
     *    opened and the other for the last time that the
     *    database was accessed by the user. The hyper system
     *    makes several calculations based on the current
     *    date stamp and the other two date stamps to
     *    determine what portions of the database need to be pre-cached.
     *
     *    HTF_LOAD_ALL
     *    Load the entire database, and all its nodes into memory.
     *
     *    HTF_CACHE_NODE
     *    Don't flush a node from memory after the user is finished viewing it.
     *
     *    HTF_CACHE_DB
     *    Don't remove buffers when closed.  This will cause
     *    the buffers to remain until the library is expunged.
     " 
     <primitive 209 2 25 private3 newFlags>     
|
   setNAGContextStrings: nodeStringsArray " Last element of Array MUST be nil! "
     <primitive 209 2 26 private3 nodeStringsArray>     
|
   disposeContext 
     " Use this after all 'setNAGContextStrings:' have been done (unless
     * you have memory to burn!)
     "
     <primitive 209 2 30 private3>
|
   setNAGStartNode: nodeName
     <primitive 209 2 27 private3 nodeName>
|
   setNAGStartLine: lineNumber
     <primitive 209 2 28 private3 lineNumber>     
|
   setNAGTags: tagArray
     " For valid tags, see AGuideTags Class below "
     <primitive 209 2 29 private3 tagArray>     
|
   setNAGBaseName: appBaseName        " appBaseName can be nil "
     <primitive 209 2 37 appBaseName>
]

" ------------------------------------------------------------------- "
" AGuideTags Class is a Singleton class that allows the user to       "
" reference special AmigaGuide Flags & Tags as #Symbols.              "
""
" ALL singleton classes MUST contain the following:                   "
""
"   the methods:  isSingleton AND privateSetup     AND                "
"                 uniqueInstance Class instance variable.             "
" ------------------------------------------------------------------- "

Class AGuideTags :Dictionary ! uniqueInstance !
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
   privateInitializeDictionary

     self at: #StartupMsgID     put: 16r11001.  " Startup message         "
     self at: #LoginToolID      put: 16r11002.  " Login a tool SIPC port  "
     self at: #LogoutToolID     put: 16r11003.  " Logout a tool SIPC port "

     self at: #ShutdownMsgID    put: 16r11004.  " Shutdown message      "
     self at: #ActivateToolID   put: 16r11005.  " Activate tool         "
     self at: #DeactivateToolID put: 16r11006.  " Deactivate tool       "
     self at: #ActiveToolID     put: 16r11007.  " Tool Active           "
     self at: #InactiveToolID   put: 16r11008.  " Tool Inactive         "
     self at: #ToolStatusID     put: 16r11009.  " Status message        "
     self at: #ToolCmdID        put: 16r1100A.  " Tool command message  "
     self at: #ToolCmdReplyID   put: 16r1100B.  " Reply to tool command "
     self at: #ShutdownToolID   put: 16r1100C.  " Shutdown tool         "

     " Attributes accepted by getAmigaGuideAttribute:into: "

     self at: #AGA_Path         put: 16r80000001.
     self at: #AGA_XRefList     put: 16r80000002.
     self at: #AGA_Activate     put: 16r80000003.
     self at: #AGA_Context      put: 16r80000004.
     self at: #AGA_HelpGroup    put: 16r80000005. " Unique Integer identifier "
     self at: #AGA_Reserved1    put: 16r80000006.
     self at: #AGA_Reserved2    put: 16r80000007.
     self at: #AGA_Reserved3    put: 16r80000008.

     " msgPortObject that is an ARexx message port: "

     self at: #AGA_ARexxPort     put: 16r80000009.
 
     " String used to specify the ARexx port name (not copied): "

     self at: #AGA_ARexxPortName put: 16r8000000A.

     self at: #AGA_Secure        put: 16r8000000B.

     " public Client flags (For setNAGFlags: method): "

     self at: #HTF_LOAD_INDEX  put: 1.  " Force load the index at init time "
     self at: #HTF_LOAD_ALL    put: 2.  " Force load the entire database at init "
     self at: #HTF_CACHE_NODE  put: 4.  " Cache each node as visited "
     self at: #HTF_CACHE_DB    put: 8.  " Keep the buffers around until expunge "

     self at: #HTF_UNIQUE      put: 16r8000.  " Unique ARexx port name "
     self at: #HTF_NOACTIVATE  put: 16r10000. " Don't activate window  "

     self at: #HTFC_SYSGADS    put: 16r80000000.

     " Callback function ID's "

     self at: #HTH_OPEN        put: 0.
     self at: #HTH_CLOSE       put: 1.

     " Error message numbers: "

     self at: #HTERR_NOT_ENOUGH_MEMORY  put: 100.
     self at: #HTERR_CANT_OPEN_DATABASE put: 101.
     self at: #HTERR_CANT_FIND_NODE     put: 102.
     self at: #HTERR_CANT_OPEN_NODE     put: 103.
     self at: #HTERR_CANT_OPEN_WINDOW   put: 104.
     self at: #HTERR_INVALID_COMMAND    put: 105.
     self at: #HTERR_CANT_COMPLETE      put: 106.
     self at: #HTERR_PORT_CLOSED        put: 107.
     self at: #HTERR_CANT_CREATE_PORT   put: 108.
     self at: #HTERR_KEYWORD_NOT_FOUND  put: 113.

     " Methods "

     self at: #HM_FINDNODE    put: 1.  " opFindHost "
     self at: #HM_OPENNODE    put: 2.  " opNodeIO "
     self at: #HM_CLOSENODE   put: 3.  " opNodeIO "
     self at: #HM_EXPUNGE     put: 10. " Expunge DataBase  (opExpungeNode) "

     " onm_Flags (opNodeIO) "

     self at: #HTNF_KEEP      put: 1.  " Don't flush this node until database is closed "
     self at: #HTNF_RESERVED1 put: 2.  " Reserved for system use "
     self at: #HTNF_RESERVED2 put: 4.  " Reserved for system use "
     self at: #HTNF_ASCII     put: 8.  " Node is straight ASCII "
     self at: #HTNF_RESERVED3 put: 16. " Reserved for system use "
     self at: #HTNF_CLEAN     put: 32. " Remove the node from the database "
     self at: #HTNF_DONE      put: 64. " Done with node "

     " onm_Attrs (opNodeIO) "

     self at: #HTNA_Screen    put: 16r80000001. " screenObject that window resides in "
     self at: #HTNA_Pens      put: 16r80000002. " Pen array (from DrawInfo) "
     self at: #HTNA_Rectangle put: 16r80000003. " Window box                "
     self at: #HTNA_HelpGroup put: 16r80000005. " unique Integer identifier "

     " Types of cross reference nodes "

     self at: #XR_GENERIC     put: 0.
     self at: #XR_FUNCTION    put: 1.
     self at: #XR_COMMAND     put: 2.
     self at: #XR_INCLUDE     put: 3.
     self at: #XR_MACRO       put: 4.
     self at: #XR_STRUCT      put: 5.
     self at: #XR_FIELD       put: 6.
     self at: #XR_TYPEDEF     put: 7.
     self at: #XR_DEFINE      put: 8.
|
   privateSetup
     (uniqueInstance isNil)
       ifTrue: [uniqueInstance <- self privateNew.

                self privateInitializeDictionary
               ].
               
     ^ self    "or ^ uniqueInstance??"
]
