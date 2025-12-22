#pragma amicall(VMemoryBase, 0x1e, AllocVMem(a0,d0))
#pragma amicall(VMemoryBase, 0x24, FreeVMem(d0))
#pragma amicall(VMemoryBase, 0x2a, ReadVMem(d0))
#pragma amicall(VMemoryBase, 0x30, WriteVMem(d0))
#pragma amicall(VMemoryBase, 0x36, RenamePage(d0,d1))
#pragma amicall(VMemoryBase, 0x3c, SwapVMem(d0))
#pragma amicall(VMemoryBase, 0x42, AvailVMem())
#pragma amicall(VMemoryBase, 0x48, LBinHex(a0,d0))
#pragma amicall(VMemoryBase, 0x4e, ReadPath())


