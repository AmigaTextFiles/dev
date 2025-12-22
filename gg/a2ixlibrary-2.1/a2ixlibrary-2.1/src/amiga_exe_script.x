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
    _edata = .;
    __edata = .;
    ___data_size = ABSOLUTE(_edata - _sdata);
  }
  . = ALIGN(0x0);
  .bss :
  {
     __bss_start = .;
    *(.bss)
    *(COMMON)
    _end = . ;
    __end = . ;
    ___bss_size = ABSOLUTE(_end - __bss_start);
    ___shared_lib_ptr = . ;
