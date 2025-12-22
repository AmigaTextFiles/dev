;
; ***************************************
;
; Linked List example file for Pure Basic
;
;     © 1999 - Fantaisie Software -
;
; ***************************************
;
;

Structure MyList
  Pad.w
  Name.s
EndStructure

NewList TestList.MyList()

AddElement(TestList())
TestList()\Name = "Hello"

AddElement(TestList())
TestList()\Name = "World"

AddElement(TestList())
TestList()\Name = "CooooL"

;FirstElement(TestList())
;KillElement (TestList())
;
;ResetList   (TestList())
;FirstElement(TestList())
;LastElement (TestList())
;
;AddElement(TestList())
;TestList()\Name = "I'm Here"

ResetList(TestList())

While NextElement(TestList())
  PrintN(TestList()\Name)
Wend

LastElement(TestList())

While PreviousElement(TestList())
  PrintN(TestList()\Name)
Wend

NewList Trial.s()

PrintNumberN(CountList(TestList()))

LastElement(TestList())
PrintNumberN(ListIndex(TestList()))

MouseWait()

End
