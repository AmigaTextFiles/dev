* Hier die Includes der VMemory.library
	IFND	VMEMORY_INC
VMEMORY_INC	SET	1

_LVOAllocVMem		EQU	-30		* a0 = Adresse d0 = Groesse
_LVOFreeVMem		EQU	-36		* d0 = Kennung 
_LVOReadVMem		EQU	-42		* d0 = Kennung 
_LVOWriteVMem		EQU	-48		* d0 = Kennung
_LVORenamePage		EQU	-54		* d0 = Old d1 = New
_LVOSwapVMem		EQU	-60		* d0 = Kennung
_LVOAvailVMem		EQU	-66		* keine Parameter: d0 = Groesse
_LVOLBinHex		EQU	-72		* a0 = StringSpeicher d0 = Zahl
_LVOReadPath		EQU	-78		* keine Parameter

	ENDC

