" -------------------------------------------------------------------- "
" The Boopsi Class implements the AmigaTalk to BOOPSI functions.       "
" I'm NOT going to document how existing BOOPSI classes are imple-     "
" mented, you'll have to find that information from someone else!      "
" This class is equivalent to rootclass, since rootclass has no attri- "
" butes.                                                               "
""
" tag values are obtained via                                          "
"    'tagValue <- boopsiObj boopsiTag: #TAG_SYMBOL'                    "
""
" See BOOPSITags.st for special tags used by the BOOPSI system & look  "
" at BoopsiClassNames.st                                               "
" -------------------------------------------------------------------- "

Class Boopsi :Object 
! private rastPortObj iclassObj boopsiNames boopsiTags !
[
   dispose 

      " You eventually free the object using this method: "
      <primitive 238 16 private>.
      
      <primitive 250 5 0 private>.

      ^ nil
|
   disposeObject: boopsiObject
   
      <primitive 238 16 boopsiObject>.
      
      <primitive 250 5 0 boopsiObject>.
      
      ^ nil      
|
   new

      (boopsiNames isNil)
         ifTrue: [ boopsiNames <- BoopsiClassNames new ].

      (boopsiTags isNil)
         ifTrue: [ boopsiTags <- BoopsiTags new ].
                   
      ^ self
|
   boopsiTag: tagSymbol
   
      ^ boopsiTags systemTag: tagSymbol
|
   newBoopsiObject: classIDString in: iclassObject tags: tagArray

      " This is the general method of creating objects from 'boopsi' classes.
      * ('Boopsi' stands for basic object-oriented programming system for
      * Intuition.)
      * 
      * You specify a class either as iclassObject (for a private class) or
      * by its ID string (for public classes).  If iclassObject is nil,
      * then the classIDString is used.  (See BoopsiClassNames.st)
      * 
      * You further specify initial 'create-time' attributes for the
      * object via a TagItem list, and they are applied to the resulting
      * generic data object that is returned.  The attributes, their meanings,
      * attributes applied only at create-time, and required attributes
      * are all defined and documented on a class-by-class basis.
      *
      * RETURNS
      * A boopsi object, which may be used in different contexts such
      * as a gadget or image, and may be manipulated by generic functions.
      * You eventually free the object using the dispose method.
      "
      ^ private <- <primitive 238 1 iclassObject classIDString tagArray>
|
   boopsiName: classNameKey   
 
      " This method is how you obtain classIDStrings.
      * Known class ID String Keys:
      *
      *   classNameKey:     classIDString:
      *   ~~~~~~~~~~~~~     ~~~~~~~~~~~~~~
      *   #ROOTCLASS     is rootclass
      *   #IMAGECLASS    is imageclass
      *   #FRAMEICLASS   is frameiclass
      *   #SYSICLASS     is sysiclass
      *   #FILLRECTCLASS is fillrectclass
      *   #GADGETCLASS   is gadgetclass
      *   #PROPGCLASS    is propgclass
      *   #STRGCLASS     is strgclass
      *   #BUTTONGCLASS  is buttongclass
      *   #FRBUTTONCLASS is frbuttonclass
      *   #GROUPGCLASS   is groupgclass
      *   #ICCLASS       is icclass
      *   #MODELCLASS    is modelclass
      *   #ITEXTICLASS   is itexticlass
      *   #POINTERCLASS  is pointerclass
      "  
      ^ boopsiNames at: classNameKey   
|
   xxxAddBoopsiClass

      " You don't need to call this method, makeBoopsiClass:for:id:size:flags: 
      * will take care of it for you!
      "
      <primitive 238 2 iclassObj>
|      
   removeBoopsiClass

      " Makes a public class unavailable for public consumption.
      * It's OK to call this function for a class which is not
      * yet in the internal public class list, or has been
      * already removed.
      "
      <primitive 238 3 iclassObj>
|
   freeBoopsiClass ! success !

      success <- <primitive 238 4 iclassObj>.

      <primitive 250 5 0 iclassObj>. " Too late!  It's all gone! "
      
      ^ success                      " Returns true if successful "
|      
   makeBoopsiClass: classIDString 
               for: superClassObj 
                id: superClassIDString 
              size: size 
             flags: flags

      " Make your own BOOPSI Class.  classID & superClassID can be nil,
      * (which indicates a private BOOPSI Class).  superClassObj
      * should NEVER be nil.  size is the size of the instance data
      * that your class's objects will require, beyond that data defined 
      * for your superclass's objects.  flags should be zero for now 
      * (unless you KNOW otherwise): 
      "
      iclassObj <- <primitive 238 5 classIDString superClassIDString superClassObj size flags>.

      self xxxAddBoopsiClass.

      ^ iclassObj
|
   obtainGIRPort: gadgetInfoObject  

      " Sets up a RastPort for use (only) by custom gadget hook routines.
      * This function must be called EACH time a hook routine needing
      * to perform gadget rendering is called, and must be accompanied
      * by a corresponding call to releaseGIRPort.
      *
      * Note that if a hook function passes you a RastPort pointer,
      * e.g., GM_RENDER, you needn't call obtainGIRPort in that case.
      "
      ^ rastPortObj <- <primitive 238 6 gadgetInfoObject>
|
   releaseGIRPort

      " Release a custom gadget RastPort Object from obtainGIRPort: "

      <primitive 238 7 rastPortObj>
|
   getAttribute: attrID from: object into: storageObj

      ^ <primitive 238 8 attrID object storageObj>
|
   setAttributes: anObject tags: tagArray 

      " Specifies a set of attribute/value pairs with meaning as
      * defined by a 'boopsi' object's class.
      *
      * This function does not provide enough context information or
      * arbitration for boopsi gadgets which are attached to windows
      * or requesters.  For those objects, use setGadgetAttributes:from:req:tags:
      *
      * The object does whatever it wants with the attributes you provide.
      * The return value tends to be non-zero if the changes would require
      * refreshing gadget imagery, if anObject is a gadget.
      "
      ^ <primitive 238 9 anObject tagArray>
|
   setGadgetAttributes: gadObj from: winObj req: reqObj tags: tagArray

      " Same as setAttributes:tags:, but provides context information and
      * arbitration for classes which implement custom Intuition gadgets.
      *
      * You should use this function for boopsi gadget objects which have
      * already been added to a requester or a window, or for 'models' which
      * propagate information to gadget(s) already added.
      *
      * Typically, the gadgets will refresh their visuals to reflect
      * changes to visible attributes, such as the value of a slider,
      * the text in a string-type gadget, the selected state of a button.
      *
      * You can use this as a replacement for setAttributes:tags:, too,
      * if you specify nil for the 'winObj' and 'reqObj' parameters.
      *
      * The return value tends to be non-zero if the changes would require
      * refreshing gadget imagery, if the object is a gadget.
      "
      ^ <primitive 238 10 gadObj winObj reqObj tagArray>
|
   nextObject: fromObject 

      " This function is for boopsi class implementors only.
      *
      * When you collect a set of boopsi objects on an Exec List
      * structure by invoking their OM_ADDMEMBER method, you
      * can (only) retrieve them by iterations of this method.
      *
      * Works even if you remove and dispose the returned list
      * members in turn.
      " 
      ^ <primitive 238 11 fromObject>
|
   doGadgetMethod: gadObj from: winObj req: reqObj message: msgObj

      " Same as the DoMethod() function of amiga.lib, but provides context
      * information and arbitration for classes which implement custom
      * Intuition gadgets.  (reqObj can be nil).
      * 
      * You should use this method for boopsi gadget objects,
      * or for 'models' which propagate information to gadgets.
      *
      * The object does whatever it wants with the message you sent,
      * which might include updating its gadget visuals.
      *
      * The return value is defined per-method.
      "
      ^ <primitive 238 12 gadObj winObj reqObj msgObj>
|      
   translateBoopsiErrorNumber " into a String " 

      ^ <primitive 238 13>
|
   doSuperMethod: onObject message: msgObj

      " msgObj is a struct Msg pointer.
      * Do NOT know if this is needed, but it is included to 
      * complete the functionality of the Class:
      "
      ^ <primitive 238 14 iclassObj onObject msgObj>
|
   coerceMethod: onObject message: msgObj

      " msgObj is a struct Msg pointer.
      * Do NOT know if this is needed, but it is included to 
      * complete the functionality of the Class:
      "
      ^ <primitive 238 15 iclassObj onObject msgObj>
]

" -------------------------------------------------------------------- "
" Use this class to create instances of 'itexticlass' BOOPSI Objects.  "
" -------------------------------------------------------------------- "

Class BoopsiText :BoopsiImage ! itextObj textColor textOrigin tagArray !
[
   itextString: newITextString
   
     itextObj <- IText new: newITextString
|
   origin: originPoint
   
     textOrigin <- originPoint
     
|
   color: newTextColor
   
     textColor <- newTextColor
|
   initialize: textString at: origin color: newColor
   
     self itextString: textString.
     self origin:      origin.
     self color:       newColor.
     
     ^ self xxxSetup
|
   xxxSetup

     " Use initialize:at:color: method after creating an Instance. "

     (tagArray isNil)
        ifTrue: [ tagArray <- Array new: 9 ].
     
     itextObj setITextOrigin: textOrigin.
     itextObj setPens:        textColor @ 0.
     
     tagArray at: 1 put: (super boopsiTag: #IA_Data).
     tagArray at: 2 put: itextObj.
     tagArray at: 3 put: (super boopsiTag: #IA_FGPen).
     tagArray at: 4 put: textColor.
     tagArray at: 5 put: (super boopsiTag: #IA_Left).
     tagArray at: 6 put: (textOrigin x).
     tagArray at: 7 put: (super boopsiTag: #IA_Top).
     tagArray at: 8 put: (textOrigin y).
     tagArray at: 9 put: (super boopsiTag: #TAG_DONE).
     
     ^ super newBoopsiObject: (super boopsiName: #ITEXTCLASS) in: nil tags: tagArray.
]

" ---------------------------------------------------------------- "
" This class is an abstract class.  Normally, you do NOT create    "
" instances of this class, just it's subclasses.                   "
" ---------------------------------------------------------------- "

Class BoopsiGadget :Boopsi ! gadObj tagArray !
[
   new: numberOfTags

     super subclassResponsibility: 'new:'.

     ^ nil.
|
   initialize
   
     super subclassResponsibility: 'initialize'.
     
     ^ nil
|
   newBoopsiObject: classIDString
   
     ^ super newBoopsiObject: classIDString in: nil tags: tagArray.
|
   setTagArray: newTagArray
   
     tagArray <- newTagArray.
|
   tagArray
   
     ^ tagArray
|
   origin: originPoint
   
     tagArray at: 2 put: originPoint x.
     tagArray at: 4 put: originPoint y.
|
   extent: sizePoint     

     tagArray at: 6 put: sizePoint x.
     tagArray at: 8 put: sizePoint y.
|
   userData: userDataArray ! dataArray size !
   
     size      <- userDataArray size.

     dataArray <- Array new: size.
     
     (1 to: size)
        do: [ :i | dataArray at: i put: (userDataArray at: i) ].
        
     tagArray at: 10 put: dataArray.
|
   gadgetIntuiText: itextObj index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_IntuiText).
     tagArray at: (tagIndex + 1) put: itextObj.
|
   gadgetText: textString index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_Text).
     tagArray at: (tagIndex + 1) put: textString.
|
   gadgetLabelImage: imageObj index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_LabelImage).
     tagArray at: (tagIndex + 1) put: imageObj.
|
   gadgetImage: imageObj index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_Image).
     tagArray at: (tagIndex + 1) put: imageObj.
|
   gadgetID: idInteger index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_ID).
     tagArray at: (tagIndex + 1) put: idInteger.
|
   gadgetBorder: borderObj index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_Border).
     tagArray at: (tagIndex + 1) put: borderObj.
|
   gadgetSelectRender: selectObj index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_SelectRender).
     tagArray at: (tagIndex + 1) put: selectObj.
|
   gadgetSpecialInfo: specialObj index: tagIndex

     " tagIndex has to be >= 11 for this method: "   

     tagArray at:  tagIndex      put: (super boopsiTag: #GA_SpecialInfo).
     tagArray at: (tagIndex + 1) put: specialObj.
|
   gadgetDisabled: boolean index: tagIndex ! ival !

     " tagIndex has to be >= 11 for this method: "   

     (boolean)
        ifTrue:  [ival <- 1]
        ifFalse: [ival <- 0].
        
     tagArray at:  tagIndex      put: (super boopsiTag: #GA_Disabled).
     tagArray at: (tagIndex + 1) put: ival.
]

Class BoopsiButtonGadget :BoopsiGadget
! imageObj !
[
   new: numberOfTags ! tagArray !

     (numberOfTags < 11)
        ifTrue:  [ tagArray <- Array new: 11 ]
        ifFalse: [ tagArray <- Array new: numberOfTags ]. 

     " Minimum required tagArray has to have the following: "
     
     tagArray at:  1 put: (super boopsiTag: #GA_Left).
     tagArray at:  2 put: 0.
     tagArray at:  3 put: (super boopsiTag: #GA_Top).
     tagArray at:  4 put: 0.
     tagArray at:  5 put: (super boopsiTag: #GA_Width).
     tagArray at:  6 put: 50.     
     tagArray at:  7 put: (super boopsiTag: #GA_Height).
     tagArray at:  8 put: 20.
     tagArray at:  9 put: (super boopsiTag: #GA_UserData).     
     tagArray at: 10 put: nil.
     tagArray at: 11 put: (super boopsiTag: #TAG_DONE).     

     super setTagArray: tagArray

     ^ self
|
   initialize
   
     ^ super newBoopsiObject: (super boopsiName: #BUTTONGCLASS) 
]

Class BoopsiFramedButton :BoopsiButtonGadget
! frameType !
[
  junk
  
    ^ nil
]

Class BoopsiPropGadget :BoopsiGadget
! totalSize visibleSize currentValue orientation !
[
  junk
  
    ^ nil
]

Class BoopsiStringGadget :BoopsiGadget
! font pens maxLength mode justification !
[
  junk
  
    ^ nil
]

" ---------------------------------------------------------------- "
" This class is an abstract class.  Normally, you do NOT create    "
" instances of this class, just it's subclasses.                   "
" ---------------------------------------------------------------- "

Class BoopsiImage :Boopsi
! origin extent pens imageData !
[
  junk
  
    ^ nil
]

Class BoopsiFillRect :BoopsiImage
! fillPattern drawMode patternSize !
[
  junk
  
    ^ nil
]

Class BoopsiFrame :BoopsiImage
[
  junk
  
    ^ nil
]

Class BoopsiSystemImage :BoopsiImage
! whichImage drawInfo imageSize !
[
  junk
  
    ^ nil
]

" ---------------------------------------------------------------- "
" The list of available BOOPSI Tags is located in:                 "
" AmigaTalk:prelude/listfiles/BoopsiTags.dictionary                "
" Use this class to make a tagArray for the map instance variable  "
" in BoopsiIC class.                                               "
" ---------------------------------------------------------------- "
 
Class BoopsiMap :TagList
! numTags tagArray boopsiTags !
[
   new: howManyTags ! intuition !

      " Be sure to allow for the #TAG_DONE at the end of your
      * tagArray.  This means that, in general, howManyTags will be
      * an odd number >= 3.
      "
      (intuition isNil)
         ifTrue: [ intuition <- Intuition new ].
         
      (boopsiTags isNil)
         ifTrue: [ boopsiTags <- BoopsiTags new ].

      numTags  <- howManyTags.
      
      tagArray <- super new: numTags.

      " Make sure tagArray is terminated properly: "

      tagArray at: numTags put: (intuition systemTag: #TAG_DONE).
      
      ^ self
|
   setTag: tagSymbol index: arrayIndex
   
      ^ (super setTag: (self xxxBoopsiTag: tagSymbol) index: arrayIndex)
|
   setTagValue: tagSymbol value: newTagValue
   
      (super setTagValue: (self xxxBoopsiTag: tagSymbol) value: newTagValue)
|
   xxxBoopsiTag: tagSymbol
   
      ^ boopsiTags systemTag: tagSymbol
]

Class BoopsiIC :Boopsi
! target map specialCode !
[
  junk
  
    ^ nil
]

Class BoopsiModel :BoopsiIC
[
  junk
  
    ^ nil
]

