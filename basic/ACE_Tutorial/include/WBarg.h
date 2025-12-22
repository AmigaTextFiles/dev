{   Retrieve WorkBench argument info' 

    Workbench arguments are contained in the 
    WBStartup structure's ArgList after 
    a program has been launched from the 
    Workbench or an icon with a default tool 
    has been double-clicked.
 
    The order in which the arguments appear in 
    the list is the same as the order in which
    the icons (corresponding to the arguments)
    were single-clicked.
    
  - WBargcount returns the number of arguments 
    to a Workbench launched program. The name 
    of the program is included in this count.

  - WBarg$(N) returns the Nth Workbench argument
    as a string. The zeroth argument is the 
    program's name. Only the name of the argument
    is returned, not it's full path. To obtain
    the latter, use WBargPath$(N).

  - WBargLock&(N) returns the file lock of the
    Nth Workbench argument. It is primarily
    for use by WBargPath$(N).
 
  - WBargPath$(N) returns the full path of the 
    Nth Workbench argument as a string.

  Author: David J Benn
    Date: 25th December 1992
}

#include <stddef.h>

external WBenchMsg&	'..Task's WBStartup message (from startup.lib)

'..the structures
struct WBArg
  longint wa_Lock
  longint wa_Name
end struct

struct WBStartup
  string  sm_Message size 20
  longint sm_Process
  longint sm_Segment
  longint sm_NumArgs
  longint sm_ToolWindow
  longint sm_ArgList
end struct

struct FileInfoBlock
  longint fib_DiskKey
  longint fib_DirEntryType
  string  fib_FileName size 108
  longint fib_Protection
  longint fib_EntryType
  longint fib_Size
  longint fib_NumBlocks
  string  fib_Date size 12
  string  fib_Comment size 80
  string  fib_Reserved size 36
end struct


'..the functions
SUB WBargcount
declare struct WBStartup *WBinfo
declare struct WBArg *argptr

  { return # of WB args }

  WBinfo = WBenchMsg

  if WBinfo <> NULL then
    WBargcount = WBinfo->sm_NumArgs
  else
    WBargcount = 0
  end if
END SUB

SUB WBarg$(N)
declare struct WBStartup *WBinfo
declare struct WBArg *argptr
longint argptr,max_param,count

  { return the Nth WB arg }

  WBinfo = WBenchMsg

  if WBinfo <> NULL then
    max_param = WBinfo->sm_NumArgs
  else
    max_param = 0
  end if

  if max_param > 0 and N <= max_param then
    argptr = WBinfo->sm_ArgList

    count=0
    while count < N     
      argptr = argptr+sizeof(WBArg)
      ++count
    wend

    WBarg$ = cstr(argptr->wa_Name)
  else
    '..Nth argument is non-existent 
    WBarg$ = ""	
  end if
END SUB

SUB WBargLock&(N)
declare struct WBStartup *WBinfo
declare struct WBArg *argptr
longint argptr,max_param,count

  { return the Nth WB arg lock }

  WBinfo = WBenchMsg

  if WBinfo <> NULL then
    max_param = WBinfo->sm_NumArgs
  else
    max_param = 0
  end if

  if max_param > 0 and N <= max_param then
    argptr = WBinfo->sm_ArgList

    count=0
    while count < N     
      argptr = argptr+sizeof(WBArg)
      ++count
    wend

    WBargLock& = argptr->wa_Lock
  else
    '..Nth lock is non-existent
    WBargLock& = NULL	
  end if
END SUB

SUB get_abs_path(lock&,abspathaddr&)
string abspath address abspathaddr&
longint parentlock

declare struct FileInfoBlock info
declare function ParentDir& library dos
declare function Examine library dos

  { recursively get absolute path }

  if lock& <> NULL then
    parentlock = ParentDir(lock&) 
    get_abs_path(parentlock,abspathaddr&)
  end if    

  if lock& <> NULL then
    Examine(lock&,info)
    abspath = abspath + info->fib_FileName
    if parentlock <> NULL then 
      '..directory
      abspath = abspath + "/" 
    else 
      '..volume
      abspath = abspath + ":" 
    end if   
  end if
END SUB

SUB WBargPath$(N)
longint arglock
string  abspath

  { return full path of Nth WB arg }

  arglock = WBargLock&(N)

  if arglock <> NULL then
    get_abs_path(arglock,@abspath)
    WBargPath$ = abspath
  else
    WBargPath$ = ""
  end if
END SUB
