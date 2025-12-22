" ------------------------------------------------------------------ "
" DisplayPic.st - Display a graphic file using the DataType classes. "
" ------------------------------------------------------------------ "

Class DisplayPic :Object 
! 
  dtLibrary modeID objName intuition dtTags logoPic dtAttrs
  dtoTags   dto
!
[
   new
     dtLibrary <- Library new: 'datatypes.library'.
     dtLibrary openVersion: 44.

     modeID    <- 0.
     objName   <- String new: 80.

     intuition <- Intuition new.
     dtTags    <- DataTypeTags new.

     logoPic   <- DataType new.

     dtAttrs   <- Array new: 5.
     dtoTags   <- Array new: 7.

     dtAttrs at: 1 put: (dtTags systemTag: #DTA_ObjName).
     dtAttrs at: 2 put: (amigatalk getStringAddress: objName).
     dtAttrs at: 3 put: (dtTags systemTag: #PDTA_ModeID).
     dtAttrs at: 4 put: (amigatalk getIntegerAddress: modeID).
     dtAttrs at: 5 put: 0.

     dtoTags at: 1 put: (intuition systemTag: #GA_Relverify).
     dtoTags at: 2 put: 1.
     dtoTags at: 3 put: (intuition systemTag: #GA_Immediate).
     dtoTags at: 4 put: 1.
     dtoTags at: 5 put: (dtTags systemTag: #DTA_DataType).
     dtoTags at: 6 put: 0.
     dtoTags at: 7 put: 0.
|
   cleanup
     dto disposeDTObject.
     dtLibrary close
|
   viewPic: filename
     self new. 

     dto <- logoPic newDTObject: filename tags: dtoTags.

     (dto == nil)
        ifTrue: [ logoPic translateDTErrorNum print.
                  ^ nil  
                ].

     dto getDTAttrs: dtAttrs.
     ...
     self cleanup.
]
