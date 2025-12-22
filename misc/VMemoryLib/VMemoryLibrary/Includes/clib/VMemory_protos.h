#ifndef  VMEMORY_LIB_PROTOS_H
#define  VMEMROY_LIB_PROTOS_H

ULONG AllocVMem( APTR MemBlock, ULONG MemBlockSize );
ULONG FreeVMem( ULONG IndexNum );
ULONG ReadVMem( ULONG IndexNum );
ULONG WriteVMem( ULONG IndexNum );
ULONG RenamePage ( ULONG OldIndex, ULONG NewIndex );
ULONG SwapVMem( ULONG IndexNum );
ULONG AvailVMem( );
void LBinHex( APTR Space, ULONG Number );
void ReadPath ( );
#endif	 /* VMEMORY_LIB_PROTOS_H */

