#ifdef __LCLINT__
    typedef char * STRPTR;
    typedef char * CONST_STRPTR;
    typedef char   TEXT;
    #define ASM
    #define REG(x)
    #define __inline
    #undef __chip
    #define __chip
    #define __STORM__
#endif
