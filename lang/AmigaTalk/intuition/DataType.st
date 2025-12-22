" ---------------------------------------------------------------------- "
" DataType Class allows the user to access the DataType functions from   "
" AmigaTalk."
" ---------------------------------------------------------------------- "

Class DataType :Object ! private !
[
   newDTObject: dtName tags: tagArray

      " dtName is the name of a BOOPSI class gadget to make.  Returns 
      * nil to 'private' if there is a problem, so verify that you
      * receive something other than nil!
      "
      private <- <primitive 210 0 dtName tagArray>. "Create a new DataType Object"

      ^ private
|
   disposeDTObject: thisObject

      <primitive 210 1 thisObject>.  "Delete a DataType Object from memory"
      
      <primitive 250 5 0 thisObject>.
      
      ^ nil
|
   addDTObject: windowObj position: glistPos

      " Add a DataType Object to the given window & place it in 
      * the glistPos slot.  Make sure that windowObj is a window
      * address obtained by 'aWindow getWindowObject' or by
      * 'amigatalk getWindowAddress: windowTitle'
      "
      ^ <primitive 210 2 windowObj glistPos private>
|      
   removeDTObject: windowObj

      " Remove a DataType Object from the given window: "
      ^ <primitive 210 3 windowObj private>
|
   doAsyncLayout: layoutMsg

      " Call the DTM_ASYNCLAYOUT method on a separate AmigaOS process.
      * layoutMsg is a gpLayout AmigaOS Object:
      "
      ^ <primitive 210 4 private layoutMsg>
|
   doDTMethod: windowObj req: reqObj msg: message

      " Perform the given DataType Method (message):"

      ^ <primitive 210 5 private windowObj reqObj message>
|
   getDTAttrs: tagArray

      " Retrieve the DataType attributes requested & place them in the
      * given tagArray OBJECT, overwriting any old values found there.
      "
      ^ <primitive 210 6 private tagArray>
|
   getDTMethods

      " Retrieve an array of methods that the DataType object supports:"
      ^ <primitive 210 7 private>
|
   getDTString: stringID

      " return a (error?) String for the given stringID Integer: "
      ^ <primitive 210 8 stringID>
|
   getDTTriggerMethods

      " Retrieve an Array of DTMethod Objects that the DataType object
      * responds to:
      "
      ^ <primitive 210 9 private>
|
   examineFile: filename attrs: tagArray

      " Examine the data that the file points to & 
      * return a DataType record address that describes the data:
      "
      ^ <primitive 210 10 filename tagArray>
|
   examineClip: clipHandle attrs: tagArray

      " Examine the data that the clipboard handle points to & 
      * return a DataType record address that describes the data:
      "
      ^ <primitive 210 11 clipHandle tagArray>
|
   printDTObject: windowObj req: reqObj prtObj: prtMsg

      " Tell the DataType Object to call the DTM_PRINT Method on a 
      * separate process.  Returns true or false:
      "
      ^ <primitive 210 12 private windowObj reqObj prtMsg>
|
   refreshDTObject: windowObj attrs: tagArray

      " Refresh the object, by sending GM_RENDER to it: "
      <primitive 210 13 private windowObj tagArray>
|
   releaseDTObject

      " Release a DataType struct obtained via ObtainDataTypeA()"
      ^ <primitive 210 14 private>
|
   setDTAttrs: windowObj req: reqObj tags: tagArray

      " Set the attributes for a DataType Object.  nil returned on error:"
      ^ <primitive 210 15 private windowObj reqObj tagArray>
|
   translateDTErrorNum
      ^ <primitive 210 16>  "Return a string for the IoErr() code"
|
   copyDTMethods: theArray include: inclusions exclude: exclusions

      " Clone and modify DTA_Methods array.  nil returned on error: "
      ^ <primitive 210 17 theArray inclusions exclusions>
|
   copyDTTriggerMethods: methods include: incl exclude: excl
      
      " Clone and modify DTA_TriggerMethods array.  nil returned on error: "
      ^ <primitive 210 18 methods incl excl>
|
   obtainDomain: obj  window: windowObj  req: reqObj rport: rastPort 
          which: type domain: domain    tags: attrTags 

      " Obtain the min/nom/max domains of a dt object.  This is equivalent
      * to the DoDTDomainA() function call in C.
      * On success, the domain box Object will be filled with the
      * gadget's domain dimensions for this particular GDOMAIN_#? id.
      * nil is returned if there is an error:
      "
      ^ <primitive 210 19 obj windowObj reqObj rastPort type domain attrTags>
|
   drawDTObject: obj rport: rastPort start: point1 end: point2 
              h: htop    v: vtop     attrs: attrTags ! x y w h !

      " This method is used to draw a DataTypes object into a RastPort.
      * This method can be used for strip printing the object or
      * embedding it within a document.  Returns true if successful:
      "
      x <- point1 x.
      y <- point1 y.
      w <- point2 x.
      h <- point2 y.

      ^ <primitive 210 20 obj rastPort x y w h htop vtop attrTags>
|
   findThisMethod: method in: methodsArrayObj 

      " Find a specified method in methods array.  Returns nil on error: "
      ^ <primitive 210 21 methodsArrayObj method>
|
   findToolNode: toolList attrs: attrTags

      " This method searches for a given tool in a list of tool nodes. 
      * nil is returned if there is an error:
      "
      ^ <primitive 210 22 toolList attrTags>
|
   findTriggerMethod: dtnObj command: cmdStr method: methodNumber

      " This Method searches for a given trigger method in a given methods
      * array like that obtained from getDTTriggerMethods.
      *
      * If one of the 'command' or 'method' args matches a array item, this
      * method returns a pointer to it.  Returns nil on error:
      "
      ^ <primitive 210 23 dtnObj cmdStr methodNumber>
|
   freeDTMethods: methodsArray

      " Free methods array obtained by CopyDT#?Methods. "
      <primitive 210 24 methodsArray>
|
   getDTTriggerMethodDataFlags: methodNumber

      " This method returns the kind of data which can be attached
      * to the stt_Data field in the dtTrigger method body.
      *
      * The data type can be specified by or'ing the method id (within
      * STMF_METHOD_MASK value) with one of the STMD_#? identifiers:
      *
      *    STMD_VOID    - stt_Data MUST be NULL
      *    STMD_ULONG   - stt_Data contains an unsigned long value
      *    STMD_STRPTR  - stt_Data is a string pointer
      *    STMD_TAGLIST - stt_Data points to an array of struct TagItem's,
      *                   terminated with TAG_DONE
      "
      ^ <primitive 210 25 methodNumber>
|
   launchTool: toolObj project: projectString attrs: attrTags

      " This method launches an application with a specified project.
      * The application and it's launch mode and other attributes are
      * specified through the 'Tool' structure.
      *
      * INPUTS
      * tool    - Pointer to a Tool structure.  nil is a valid arg.
      * project - Name of the project to execute or nil.
      * attrs   - Additional attributes.
      *
      * TAGS
      *    NP_Priority (BYTE) - sets the priority of the launched tool
      *                         Defaults to the current process's priority for
      *    Shell and ARexx programs; Workbench applications
      *    default to 0 except when overridden by the TOOLPRI tooltype.
      *
      *    NP_Synchronous (BOOL) - don't return until lauched application 
      *                            process finishes.  Defaults to false.
      * Returns false for failure, true otherwise.
      "
      ^ <primitive 210 26 toolObj projectString attrTags>
|
   lockDataType: dtObj

      " This method is used to lock a DataType structure obtained
      * by examineFile:attrs:, examineClip:attrs: or a datatypes 
      * object (DTA_DataType attribute).
      *
      * All calls to lockDataType, examineFile:attrs: or examineClip:attrs:
      * must match the same number of releaseDataType calls, otherwise 
      * havoc will break out:
      "
      <primitive 210 27 dtObj>
|
   obtainDTDrawInfo: object attrs: attrTags

      " This method is used to prepare a DataTypes object for
      * drawing into a RastPort.
      *
      * This method will send the DTM_OBTAINDRAWINFO method
      * to the object using the opSet message structure.
      * Returns nil on error, an Integer handle (for releaseDTDrawInfo:handle:)
      * otherwise:
      "
      ^ <primitive 210 28 object attrTags>
|
   releaseDTDrawInfo: anObject handle: aHandle

      " This method is used to release the information obtained
      * with obtainDTDrawInfo:attrs:
      *
      * This method invokes the object's DTM_RELEASEDRAWINFO method
      * using the dtReleaseDrawInfo message structure.
      "
      <primitive 210 29 anObject aHandle>
|
   saveDTObject: obj    window: windowObj  req: reqObj 
           file: filename mode: filemode  flag: saveIconBool attrs: attrTags
      
      " This method saves the contents of an object into a file.
      *
      * The method opens the named file and saves the object's contexts
      * into it (DTM_WRITE).  Then it closes the file.
      * If the DTM_WRITE method returns success and saveIconBool is
      * true, the matching icon is saved.
      *
      * If DTM_WRITE returns 0, the file will be deleted.  Returns nil on
      * failure, an Integer otherwise.
      "
      ^ <primitive 210 30 obj windowObj reqObj filename filemode saveIconBool attrTags>  
|
   startDragSelect: onObject

      " This method starts drag-selection by the user (marking).
      *
      * This method replaces the old flag-fiddling method to
      * start drag-select.
      *
      * The drag-select will only be started if the object supports
      * DTM_SELECT, is in a window or requester and no layout-process
      * is working on the object.  If all conditions are good, it sets
      * the DTSIF_DRAGSELECT flag and returns true for success.
      *   onObject is from 'newDTObject:tags:'
      "
      ^ <primitive 210 31 onObject>
|
   cleanupDataTypes

      " Use this method only once, when you are finished with your DataType 
      * Object.  Using it more than once only slows the System down, no 
      * other harm is done.  If you don't use this method, datatypes.library
      * will remain open!
      " 
      <primitive 210 36>
|
   getFileDataType: fileName

      " Return the DataType header name, or nil if there is a failure."
      ^ <primitive 210 37 fileName>
]
