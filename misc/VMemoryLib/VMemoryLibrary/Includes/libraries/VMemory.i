	IFND	VMEMORY_I
VMEMORY_I	SET	1

	IFND	EXEC_TYPES_I
	include exec/types.i
	ENDC

* Structure of VMemoryEntry
* The Pagename of the Memblock is a simply Data-File, wich was created
* with the dos.library.
* The name is the Path, who was found in PagePath + ASCII-Value of the Index.

	STRUCTURE VMemoryEntry,0
	ULONG	vmem_Index			* Number of Entry
	ULONG	vmem_Size			* Size of MemoryBlock
	APTR	vmem_Adresse			* Adress of MemoryBlock
	LABEL	VMemory_SIZEOF

* Here are the ErrorCodes of the VMemorylibrary
* After you have called an Funktion of the VMemorylibrary, you will be able 
* to read the Errorcod in Register d0.

vmem_OK			EQU	0		* all Ok
vmem_TableFull		EQU	-1		* no more Entry's possible
vmem_NoPrefs		EQU	-2		* no Prefs-File created
vmem_NoStartMemory	EQU	-3		* no StartMemory for Entry's
vmem_NoFileOpen		EQU	-4		* no PageFile to open
vmem_FailWrite		EQU	-5		* Failure at Write Memory
vmem_NoEmptyEntry	EQU	-6		* no Empty Entry found
vmem_NoEntryFreed	EQU	-7		* no Memory-Block found
vmem_FailRead		EQU	-8		* Failure at Read Memory
vmem_NoEntryFound	EQU	-9		* no Entry found
vmem_PageOccupied	EQU	-10		* Page Occupied

	ENDC

