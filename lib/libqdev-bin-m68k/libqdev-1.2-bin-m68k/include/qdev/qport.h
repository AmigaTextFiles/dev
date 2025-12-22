/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * qport.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QPORT'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QPORT'  is   distributed  in  the  hope  that  it  will  be useful,
 * but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
 * MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the
 * GNU General Public License for more details.
 *
 * You  should  have  received a copy of the GNU General Public License
 * along  with  'qdev';  if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   USA
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: qport.h 1.04 (23/01/2012) QPORT
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Compatibility kludge header.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___QPORT_H_INCLUDED___
#define ___QPORT_H_INCLUDED___

#ifdef __linux__

#define MEMF_PUBLIC     (1L <<  0)
#define MEMF_CLEAR      (1L << 16)

#define MODE_OLDFILE    1005
#define MODE_NEWFILE    1006
#define MODE_READWRITE  1004

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>



#define AllocVec(size, flags)                 \
({                                            \
  void *___m_ptr;                             \
  if ((___m_ptr = malloc(size)))              \
  {                                           \
    if (flags & MEMF_CLEAR)                   \
    {                                         \
      memset(___m_ptr, 0, size);              \
    }                                         \
  }                                           \
  ___m_ptr;                                   \
})

#define FreeVec(ptr)                          \
({                                            \
  free(ptr);                                  \
})



#define CopyMem(src, dst, size)               \
({                                            \
  memcpy(dst, src, size);                     \
})



#define SetSignal(task, sigmask)              \
({                                            \
  0;                                          \
})



#define InitSemaphore(ss)                     \
{(                                            \
  0;                                          \
})

#define ObtainSemaphore(ss)                   \
{(                                            \
  0;                                          \
})

#define ReleaseSemaphore(ss)                  \
{(                                            \
  0;                                          \
})



#define Open(name, mode)                      \
({                                            \
  char *___m_mode;                            \
  if (mode == MODE_OLDFILE)                   \
  {                                           \
    ___m_mode = "rb+";                        \
  }                                           \
  else if (mode == MODE_NEWFILE)              \
  {                                           \
    ___m_mode = "wb+";                        \
  }                                           \
  else if (mode == MODE_READWRITE)            \
  {                                           \
    ___m_mode = "ab+";                        \
  }                                           \
  else                                        \
  {                                           \
    ___m_mode = "?";                          \
  }                                           \
  (LONG)fopen(name, ___m_mode);               \
})

#define Close(fd)                             \
({                                            \
  fclose((FILE *)fd);                         \
})



#define Read(fd, ptr, size)                   \
({                                            \
  read(fileno((FILE *)fd), ptr, size);        \
})

#define Write(fd, ptr, size)                  \
({                                            \
  write(fileno((FILE *)fd), ptr, size);       \
})



#define FGets(fd, ptr, size)                  \
({                                            \
  fgets(ptr, size, (FILE *)fd);               \
})



#define CreateDir(name)                       \
({                                            \
  long stat = 0;                              \
  if (!(mkdir(name, S_IRWXU | S_IRWXG)))      \
  {                                           \
    stat = 1;                                 \
  }                                           \
  stat;                                       \
})



#define UnLock(lock)                          \
({                                            \
  0;                                          \
})



#define _RawPutChar(chr)                      \
({                                            \
  unsigned long ichr = chr;                   \
  ichr <<= 24;                                \
  Write(stderr, &ichr, 1);                    \
})

#define _RawIOInit()                          \
({                                            \
  0;                                          \
})



#define Disable()                             \
({                                            \
  0;                                          \
})

#define Enable()                              \
({                                            \
  0;                                          \
})

#else
#include "qclone.h"
#endif

#endif /* ___QPORT_H_INCLUDED___ */
