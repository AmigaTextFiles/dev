#ifdef LIBRARY

#pragma amicall(GadgetBase, 0x06, myOpen())
#pragma amicall(GadgetBase, 0x0c, myClose())
#pragma amicall(GadgetBase, 0x12, myExpunge())

#pragma amicall(GadgetBase, 0x2a, gadAllocBevelBorderA(a0))
#pragma amicall(GadgetBase, 0x30, gadAllocBoolGadgetA(a0))
#pragma amicall(GadgetBase, 0x36, gadAllocTextButtonGadgetA(a0))
#pragma amicall(GadgetBase, 0x3c, gadAllocCheckMarkGadgetA(a0))
#pragma amicall(GadgetBase, 0x48, gadAllocArrowGadgetA(a0))
#pragma amicall(GadgetBase, 0x54, gadAllocStringGadgetA(a0))
#pragma amicall(GadgetBase, 0x5a, gadAllocIntGadgetA(a0))
#pragma amicall(GadgetBase, 0x60, gadAllocScrollbarGadgetA(a0))
#pragma amicall(GadgetBase, 0x84, gadAllocTextGadgetA(a0))
#pragma amicall(GadgetBase, 0x8a, gadAllocListviewGadgetA(a0))
#pragma amicall(GadgetBase, 0x90, gadAllocCycleGadgetA(a0))
#pragma amicall(GadgetBase, 0x96, gadAllocGetFileGadgetA(a0))
#pragma amicall(GadgetBase, 0x9c, gadAllocPaletteGadgetA(a0))

#endif

