/* VMem_Example.e (c) Simon/Maniacs - example of use vmem.library  */
/* VMem_Example.e (c) Simon/Maniacs - przykîad uûycia vmem.library */

OPT PREPROCESS

MODULE 'exec/memory', 'libraries/vmem', 'vmem'

CONST BLOK=500000

PROC main() HANDLE

 DEF vmb:PTR TO LONG, ptr

 vmembase:=NewM(1000, MEMF_ANY+MEMF_CLEAR)
 IF (vmembase:=OpenLibrary(VMEMNAME,0))=NIL THEN
	Raise('Nie mogë otworzyê vmem.library!')

 IF (vmb:=VmAllocBlock(BLOK, 1, MEMF_ANY+MEMF_CLEAR))=NIL THEN
	Raise('Nie mogë stworzyê bloku pamiëci wirtualnej!')

 ptr:=VmLock(vmb, 1)
 WriteF('ptr=\d\n', ptr)

EXCEPT DO

 IF vmb THEN VmUnLock(vmb, 1)
 IF vmb THEN VmFreeBlock(vmb)

 IF vmembase THEN CloseLibrary(vmembase)
 IF exception THEN WriteF('\s\n', exception)

ENDPROC
