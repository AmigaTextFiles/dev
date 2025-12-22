
#pragma amicall(GadgetBase, 0x1e, gadAllocIntuiText(d0, d1, d2, d3, a0, a1, a2, a3))
#pragma amicall(GadgetBase, 0x24, gadFreeIntuiText(a0))
#pragma amicall(GadgetBase, 0x42, gadAllocGadgetA(d0, a0))
#pragma amicall(GadgetBase, 0x66, gadSetGadgetAttrsA(a0, a1, a2, a3))
#pragma amicall(GadgetBase, 0x6c, gadGetGadgetAttr(d0, a0, a1))
#pragma amicall(GadgetBase, 0x72, gadFreeGadget(a0))
#pragma amicall(GadgetBase, 0x78, gadFreeGadgetList(a0))
#pragma amicall(GadgetBase, 0x7e, gadFilterMessage(a0, d0))
