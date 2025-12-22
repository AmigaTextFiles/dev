/* PortablE combined module for C++ AmigaOS */
  MODULE 'PE/FastMem'
->MODULE 'PE/FastMem_3_pThreadNode'
->MODULE 'PE/FastMem_2_pSemaphores'
->MODULE 'PE/FastMem_1_singleThreaded'

  MODULE 'PE/Mem', 'PE/Amiga/Mem'
->MODULE 'PE/CPP/Mem'
