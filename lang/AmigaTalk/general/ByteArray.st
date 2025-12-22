Class ByteArray :ArrayedCollection
[
   at: index
      ^ <primitive 118 self index>
|
   at: index put: value
      <primitive 119 self index value>
|
   printString   ! str !
      str <- '#[ '.
      (1 to: self size)
         do: [:i | str <- str , (self at: i) printString , ' '].

      ^ str , ']'
|
   displayBytes: title
    <primitive 229 22 self title>
|
   printAsChars " Added on 17-Nov-2002 (JTS) "

      <primitive 209 9 11 self> print.
|
   size
      ^ <primitive 117 self>
|
   new: size
      ^ <primitive 116 size>
]
