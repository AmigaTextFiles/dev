OUTPUT_FORMAT("amiga")
OUTPUT_ARCH(m68k)
SEARCH_DIR(/gg/os-lib); SEARCH_DIR(/gg/lib); SEARCH_DIR(/gg/amiga/lib);
SECTIONS
{
  . = 0x0;
  .text :
  {
    ___machtype = ABSOLUTE(0x0);
    _stext = .;
    __stext = .;
    *(.text)
    ___datadata_relocs = .;
    _etext = .;
    __etext = .;
    ___text_size = ABSOLUTE(_etext - _stext);
  }
  . = ALIGN(0x0);
  .data :
  {
    _sdata = .;
    __sdata = .;
    CONSTRUCTORS
    *(.data)
    xlibs.o
    ___a4_init = 0x7ffe;
    ___data_size = ABSOLUTE(_edata - _sdata);
    ___bss_size = ABSOLUTE(0);
  }
  .bss :
  {
    *(.bss)
    *(COMMON)
    _edata  =  .;
    __edata  =  .;
    __bss_start  =  .;
    _end = ALIGN(4) ;
    __end = ALIGN(4) ;
    ___shared_lib_ptr = . ;
