#ifndef PRAGMAS_DPKERNEL_EXTRAS_H
#define PRAGMAS_DPKERNEL_EXTRAS_H 1

#ifdef __STORM__
 #pragma tagcall(DPKBase,0x05A,InitTags(a1,a0))
 #pragma amicall(DPKBase,0x3B4,InitTagList(a1,a0))
#endif

#ifdef __SASC_60
 #pragma tagcall DPKBase InitTags 05A 8902
#endif

#if defined(_DCC) || defined(__SASC)
 #pragma libcall DPKBase InitTagList         05A 8902
 #pragma libcall DPKBase AddSysObjectTagList 156 891004
 #pragma libcall DPKBase DPrintFTagList      10E DC02
#endif

#ifdef _DCC
 #ifdef _DCCTAGS

  APTR InitTags(APTR container, unsigned long tag1, ...) {
    return(InitTagList(container, (struct TagItem *)&tag1));
  }

  APTR AddSysObjectTags(WORD ClassID, WORD ObjectID, BYTE *Name, unsigned long tag1, ...) {
    return(AddSysObjectTagList(ClassID, ObjectID, Name, (struct TagItem *)&tag1));
  }

  void DPrintFTagList(BYTE *Header, struct TagItem *);

  void DPrintF(BYTE *Header, const BYTE *tag1, ...) {
    DPrintFTagList(Header, (struct TagItem *)&tag1);
  }
 #endif
#endif

#endif /* PRAGMAS_DPKERNEL_EXTRAS_H */
