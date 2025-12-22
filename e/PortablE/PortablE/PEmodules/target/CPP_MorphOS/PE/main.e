/* PortablE combined module for C++ AmigaOS */
  MODULE 'PE/FastMem_simple'
->MODULE 'PE/FastMem'		->this does not currently work on MorphOS, due to AmiDevCpp adding a spurious extra pad byte into each object
->MODULE 'PE/FastMem_3_ThreadNode'
->MODULE 'PE/FastMem_2_pSemaphores'
->MODULE 'PE/FastMem_1_singleThreaded'

->MODULE 'PE/Mem', 'PE/Amiga/Mem'		->this probably won't work on MorphOS for the same reason
  MODULE 'PE/CPP/Mem'
