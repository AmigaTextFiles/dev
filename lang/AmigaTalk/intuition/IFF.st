" ----------------------------------------------------------------------- "
" The BasicIFF Class interfaces AmigaTalk to the iffparse.library.  See   "
" class IDNumbers in IFFConstants.st file for valid ID numbers that       "
" identify valid IFF chunks that IFF files & Objects contain.             "
""
"    EXAMPLE:  16r424F4459 is 'BODY'                                      "
""
" You should have access to the documentation for iffparse.library (or    "
" wait for me to write some examples of how to use this Class ;).  I'm    "
" NOT going to re-hash the IFF documentation for iffparse.library.  The   "
" Help directory is getting complicated as it is.                         "
" ----------------------------------------------------------------------- "

Class BasicIFF :Object ! private !
[
   closeIFF

      <primitive 240 0 0 private>.
      
      <primitive 250 5 0 private>.
      
      ^ nil
|
   openIFF: iffFileName type: fileType mode: mode ! chk !

      " fileType here means: 0 for a file, & 1 for a clipboard. 
      * mode is either #IFFF_READ, IFFF_WRITE or IFFF_RWBITS:
      "
      chk <- <primitive 240 0 1 iffFileName fileType mode>.

      (chk isNil)
         ifTrue: ['Did NOT openIFF (nil returned!).' print.

                   ^ nil
                 ].
      
      ^ private <- chk
|
   initIFFHook: hookObj flags: flags 

      <primitive 240 1 0 private hookObj flags>
|
   initIFFAsDOS

      <primitive 240 1 1 private>
|
   initIFFAsClip

      <primitive 240 1 2 private>
|
   closeClipboard

      <primitive 240 2 0 private>
|
   openClipboard: clipUnitNumber  " Range for clipUnitNumber is 0 to 255 "

      ^ <primitive 240 2 1 private clipUnitNumber>
|
   parseIFF: mode

      " Control modes for parseIFF method:
      * #IFFPARSE_SCAN
      * #IFFPARSE_STEP
      * #IFFPARSE_RAWSTEP
      "
      ^ <primitive 240 2 2 private mode>
|
   readChunkBytes: byteArray size: numBytes

      ^ <primitive 240 2 3 private byteArray numBytes>
|
   readChunkRecords: byteArray size: numBytes number: numRecords

      ^ <primitive 240 2 4 private byteArray numBytes numRecords>
|
   writeChunkBytes: byteArray size: numBytes

      ^ <primitive 240 2 5 private byteArray numBytes>
|
   writeChunkRecords: byteArray size: numBytes number: numRecords

      ^ <primitive 240 2 6 private byteArray numBytes numRecords>
|
   stopChunk: type id: id

      " The most common types are: 
      *   #ID_ILBM, #ID_FTXT, #ID_SMUS, #ID_8SVX, #ID_ANIM
      *
      * See IDNumbers Class in IFFConstants.st for id values.
      "
      ^ <primitive 240 2 7 private type id>
|
   stopChunksWith: propertyArray size: numPairs

      " Do a bunch of stopChunk settings at once.
      *
      * The propertyArray is constructed as follows:
      * ele[1] <- type,     ele[2] <- id,
      * ele[3] <- nextType, ele[4] <- nextid,
      * ...
      "
      ^ <primitive 240 2 16 private propertyArray numPairs>
|
   currentChunk

      ^ <primitive 240 2 8 private>
|
   propertyChunk: type id: id

      ^ <primitive 240 2 9 private type id>
|
   propertyChunksWith: propertyArray size: numPairs

      " Do a bunch of propertyChunk settings at once.
      *
      * The propertyArray is constructed as follows:
      * ele[1] <- type,     ele[2] <- id,
      * ele[3] <- nextType, ele[4] <- nextid,
      * ...
      "
      ^ <primitive 240 2 17 private propertyArray numPairs>
|
   findProperty: type id: id

      ^ <primitive 240 2 10 private type id>
|
   collectionChunk: type id: id

      ^ <primitive 240 2 11 private type id>
|
   collectionChunksWith: propertyArray size: numPairs

      " Do a bunch of collectionChunk settings at once.
      * The propertyArray is constructed as follows:
      *
      * ele[1] <- type,     ele[2] <- id,
      * ele[3] <- nextType, ele[4] <- nextid,
      * ...
      "
      ^ <primitive 240 2 18 private propertyArray numPairs>
|
   findCollection: type id: id

      ^ <primitive 240 2 12 private type id>
|
   stopOnExit: type id: id

      ^ <primitive 240 2 13 private type id>
|
   addEntryHandlerHook: hookObj for: anObject type: type id: id position: pos

      ^ <primitive 240 2 14 private hookObj anObject type id pos>
|
   addExitHandlerHook: hookObj for: anObject type: type id: id position: pos

      ^ <primitive 240 2 15 private hookObj anObject type id pos>
|
   pushChunk: type id: id size: size

      " size can also be #IFFSIZE_UNKNOWN if you dont know the size "
      ^ <primitive 240 3 0 private type id size>
|
   popChunk

      ^ <primitive 240 3 1 private>
|
   parentChunk

      ^ <primitive 240 3 2 private>
|
   allocateLocalItem: ident type: type id: id size: dataSize

      ^ <primitive 240 4 0 private type id ident dataSize>
|
   getLocalItemData

      ^ <primitive 240 4 1 private>
|
   storeLocalItem: position

      ^ <primitive 240 4 2 private position>
|
   storeItemInContext

      <primitive 240 4 3 private>
|
   findPropertyContext

      ^ <primitive 240 4 4 private>
|
   findLocalItem: ident type: type id: id

      ^ <primitive 240 4 5 private type id ident>
|
   freeLocalItem

      <primitive 240 4 6 private>
|
   setLocalItemPurge: hookObj
      <primitive 240 4 7 private hookObj>
|
   getErrorString: errorNumber

      ^ <primitive 240 5 errorNumber>
|
   idToString: identifier

      ^ <primitive 240 6 identifier>
|
   getPropertySize: propertyObject

      ^ <primitive 240 7 0 propertyObject>
|
   getPropertyData: propertyObject

      ^ <primitive 240 7 1 propertyObject>
|
   getCollectionSize: collectionObject

      ^ <primitive 240 8 0 collectionObject>
|
   getCollectionData: collectionObject

      ^ <primitive 240 8 1 collectionObject>
]

" ----------------------------------------------------------------------- "
" The ExamineIFF Class allows the User to obtain various chunks from an   "
" IFF file (NOT clipboards).                                              "
" ----------------------------------------------------------------------- "

Class ExamineIFF :BasicIFF ! dataTypeTags ilbm rmode form body ftxt !
[
   initialize

      dataTypeTags <- DataTypeTags new.
      body         <- dataTypeTags systemTag: #ID_BODY.
      form         <- dataTypeTags systemTag: #ID_FORM.
      ilbm         <- dataTypeTags systemTag: #ID_ILBM.
      ftxt         <- dataTypeTags systemTag: #ID_FTXT.
      rmode        <- dataTypeTags systemTag: #IFFF_READ.
 
      ^ self
|
   privateObtainChunk: chunkType from: fileName id: chunkID parent: pID ! iffObj chk rval !
      
      iffObj <- super openIFF: fileName type: 1 mode: rmode.
      
      iffObj initIFFAsDOS.
      
      chk <- iffObj propertyChunk: chunkType id: chunkID. " Look for this chunk "
      
      (chk ~= 0 or: [chk isNil])
         ifTrue: [ (iffObj getErrorString: chk) print.

                   iffObj closeIFF.

                   ^ nil                 ].
         
      chk <- iffObj stopChunk: chunkType id: pID.

      (chk ~= 0 or: [chk isNil])
         ifTrue: [ (iffObj getErrorString: chk) print.

                   iffObj closeIFF.

                   ^ nil                 ].

      chk <- iffObj parseIFF: (dataTypeTags systemTag: #IFFPARSE_SCAN).

      (chk ~= 0 or: [chk isNil])
         ifTrue: [ (iffObj getErrorString: chk) print.

                   iffObj closeIFF.

                   ^ nil                 ].

      rval <- iffObj findProperty: chunkType id: chunkID.

      (rval isNil)
         ifTrue: [ 'NO bitmap header found!' print.

                   iffObj closeIFF.

                   ^ nil                 ].
         
      iffObj closeIFF.

      ^ rval
|
   obtainBMHD: fileName ! bmhd !

      bmhd <- dataTypeTags systemTag: #ID_BMHD.
      
      ^ self privateObtainChunk: ilbm from: fileName id: bmhd parent: body
|
   obtainCMAP: fileName ! cmap !

      cmap <- dataTypeTags systemTag: #ID_CMAP.
      
      ^ self privateObtainChunk: ilbm from: fileName id: cmap parent: body
|
   obtainCAMG: fileName ! camg !

      camg <- dataTypeTags systemTag: #ID_CAMG.
      
      ^ self privateObtainChunk: ilbm from: fileName id: camg parent: body
|
   obtainPixelData: fileName

      ^ self privateObtainChunk: ilbm from: fileName id: body parent: form
|
   obtainCHRS: fileName ! chrs !

      chrs <- dataTypeTags systemTag: #ID_CHRS.
      
      ^ self privateObtainChunk: ftxt from: fileName id: chrs parent: form
|
   obtainVHDR: fileName ! vhdr svx8 !

      svx8 <- dataTypeTags systemTag: #ID_8SVX.
      vhdr <- dataTypeTags systemTag: #ID_VHDR.
      
      ^ self privateObtainChunk: svx8 from: fileName id: vhdr parent: form
|
   obtainVoiceData: fileName ! svx8 !

      svx8 <- dataTypeTags systemTag: #ID_8SVX.
      
      ^ self privateObtainChunk: svx8 from: fileName id: body parent: form
]
