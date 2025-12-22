" ------------------------------------------------------------------- "
" TagList Class is mainly used for Amiga function calls that utilize  "
" Tags.  AmigaTalk converts TagLists internally into what the AmigaOS "
" expects for real Amiga tags.                                        "
" Since TagList is an Array to AmigaTalk, you should realize that     "
" you have to set Tags & Values in pairs.  Example:                   "
""
"     myTags    <- TagList new: 24                                    "
""
"     myTags setTag:      (intuition systemTag: #WA_Left) index: 0    "
"     myTags setTagValue: (intuition systemTag: #WA_Left) value: 16   "
""
"     myTags setTag:      (intuition systemTag: #WA_Top)  index: 2    "
"     myTags setTagValue: (intuition systemTag: #WA_Top)  value: 0    "
"     ...                                                             "
"     myTags setTag:      (intuition systemTag: #TAG_DONE) index: 24  "
""
" Until myTags is filled.                                             "
" WARNING:  Do NOT forget to terminate your TagList with              "
"           (intuition systemTag: #TAG_DONE)                          "
" ------------------------------------------------------------------- "

Class TagList :Array
[
   new: newSize

     ^ (super new: newSize)
|
   getTagValue: theTag

     ^ <primitive 210 33 self theTag>
|
   setTagValue: theTag value: newTagValue

     <primitive 210 32 self theTag newTagValue>
|
   addTagPair: newTag value: newTagValue   "expensive, memory fragmenter"

     ^ <primitive 210 34 self newTag newTagValue>
|
   deleteTagPair: theTag

     ^ <primitive 210 35 self theTag>
|
   setTag: newTag index: idx

     ^ (super at: idx put: newTag)
]
