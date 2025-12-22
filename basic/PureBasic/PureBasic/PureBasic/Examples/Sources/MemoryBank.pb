
; ***************************************
;
;  MemoryBank example file for PureBasic
;
;      © 2000 - Fantaisie Software -
;
; ***************************************

Procedure ShowMemoryBank(Number.b)   ; shows all 64 bytes of a memory bank
  For I.b = 0 To 63
    If I & 15 = 0 And I > 0
      Print(":")                       ; print a ':' between every 16 bytes
    EndIf

    PrintNumber(PeekB(MemoryBankAddress(Number.b)+I))
                                   ; print a byte
  Next
  PrintN("")                           ; finish line
EndProcedure

InitMemoryBank(1)                    ; we need 2 memory banks

*Mem1 = AllocateMemoryBank(0, 64, #MEMF_CLEAR) ; allocate first memory bank
                                               ; with a size of 64 bytes
*Mem2 = AllocateMemoryBank(1, 64, #MEMF_CLEAR) ; allocate second memory bank
                                               ; with a size of 64 bytes

if *Mem1 and *Mem2

  FreeChip.l = AvailableMemory(#MEMF_CHIP) / 1024 ; get free Chip-RAM in kb (/1024)
  PrintNumber(FreeChip.l)                         ; and print it
  PrintN("k Chip-RAM free")

  FreeFast.l = AvailableMemory(#MEMF_FAST) / 1024 ; get free Fast-RAM in kb (/1024)
  PrintNumber(FreeFast.l)                         ; and print it
  PrintN("k Fast-RAM free")

  MouseWait()

  printn("")                     ; print an empty line

  PrintN("First memory bank:")
  ShowMemoryBank(0)
  PrintN("Second memory bank:")
  ShowMemoryBank(1)

  PrintN("")                     ; print an empty line

  FillMemory(*Mem1, 64, 7)       ; fill the first memory bank with 7
  CopyMemory(*Mem1, *Mem2, 23)   ; copy the first 23 bytes to memory bank 2
  PrintN("First memory bank:")
  ShowMemoryBank(0)
  PrintN("Second memory bank:")
  ShowMemoryBank(1)

  MouseWait()

  Else
  PrintN("Couldn't allocate memory banks.")
  EndIf

End ; all allocated memory banks will be automatically freed here
