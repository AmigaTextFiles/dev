pattern Open(_name,_accessMode) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_accessMode;;
	a6:=DOSBase; jsr [a6-30];
	pop d2\a6;
endp;															# OPEN

pattern Close(_file) is
	push a6;
	d1.l:=_file;
	a6:=DOSBase; jsr [a6-36];
	pop a6;
endp;															# CLOSE

pattern Read(_file,_buffer,_length) is
	push d2\d3\a6;
	safe d1.l:=_file; d2.l:=_buffer; d3.l:=_length;;
	a6:=DOSBase; jsr [a6-42];
	pop d2\d3\a6;
endp;															# READ

pattern Write(_file,_buffer,_length) is
	push d2\d3\a6;
	safe d1.l:=_file; d2.l:=_buffer; d3.l:=_length;;
	a6:=DOSBase; jsr [a6-48];
	pop d2\d3\a6;
endp;															# WRITE

pattern Input is
	push a6;
	a6:=DOSBase; jsr [a6-54];
	pop a6;
endp;															# INPUT

pattern Output is
	push a6;
	a6:=DOSBase; jsr [a6-60];
	pop a6;
endp;															# OUTPUT

pattern Seek(_file,_position,_offset) is
	push d2\d3\a6;
	safe d1.l:=_file; d2.l:=_position; d3.l:=_offset;;
	a6:=DOSBase; jsr [a6-66];
	pop d2\d3\a6;
endp;															# SEEK

pattern DeleteFile(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-72];
	pop a6;
endp;															# DELETEFILE

pattern Rename(_oldName,_newName) is
	push d2\a6;
	safe d1.l:=_oldName; d2.l:=_newName;;
	a6:=DOSBase; jsr [a6-78];
	pop d2\a6;
endp;															# RENAME

pattern Lock(_name,_type) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_type;;
	a6:=DOSBase; jsr [a6-84];
	pop d2\a6;
endp;															# LOCK

pattern UnLock(_lock) is
	push a6;
	d1.l:=_lock;
	a6:=DOSBase; jsr [a6-90];
	pop a6;
endp;															# UNLOCK

pattern DupLock(_lock) is
	push a6;
	d1.l:=_lock;
	a6:=DOSBase; jsr [a6-96];
	pop a6;
endp;															# DUPLOCK

pattern Examine(_lock,_fileInfoBlock) is
	push d2\a6;
	safe d1.l:=_lock; d2.l:=_fileInfoBlock;;
	a6:=DOSBase; jsr [a6-102];
	pop d2\a6;
endp;															# EXAMINE

pattern ExNext(_lock,_fileInfoBlock) is
	push d2\a6;
	safe d1.l:=_lock; d2.l:=_fileInfoBlock;;
	a6:=DOSBase; jsr [a6-108];
	pop d2\a6;
endp;															# EXNEXT

pattern Info(_lock,_parameterBlock) is
	push d2\a6;
	safe d1.l:=_lock; d2.l:=_parameterBlock;;
	a6:=DOSBase; jsr [a6-114];
	pop d2\a6;
endp;															# INFO

pattern CreateDir(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-120];
	pop a6;
endp;															# CREATEDIR

pattern CurrentDir(_lock) is
	push a6;
	d1.l:=_lock;
	a6:=DOSBase; jsr [a6-126];
	pop a6;
endp;															# CURRENTDIR

pattern IoErr is
	push a6;
	a6:=DOSBase; jsr [a6-132];
	pop a6;
endp;															# IOERR

pattern CreateProc(_name,_pri,_segList,_stackSize) is
	push d2\d3\d4\a6;
	safe d1.l:=_name; d2.l:=_pri; d3.l:=_segList; d4.l:=_stackSize;;
	a6:=DOSBase; jsr [a6-138];
	pop d2\d3\d4\a6;
endp;															# CREATEPROC

pattern Exit(_returnCode) is
	push a6;
	d1.l:=_returnCode;
	a6:=DOSBase; jsr [a6-144];
	pop a6;
endp;															# EXIT

pattern LoadSeg(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-150];
	pop a6;
endp;															# LOADSEG

pattern UnLoadSeg(_seglist) is
	push a6;
	d1.l:=_seglist;
	a6:=DOSBase; jsr [a6-156];
	pop a6;
endp;															# UNLOADSEG

pattern dosPrivate1 is
	push a6;
	a6:=DOSBase; jsr [a6-162];
	pop a6;
endp;															# DOSPRIVATE1

pattern dosPrivate2 is
	push a6;
	a6:=DOSBase; jsr [a6-168];
	pop a6;
endp;															# DOSPRIVATE2

pattern DeviceProc(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-174];
	pop a6;
endp;															# DEVICEPROC

pattern SetComment(_name,_comment) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_comment;;
	a6:=DOSBase; jsr [a6-180];
	pop d2\a6;
endp;															# SETCOMMENT

pattern SetProtection(_name,_protect) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_protect;;
	a6:=DOSBase; jsr [a6-186];
	pop d2\a6;
endp;															# SETPROTECTION

pattern dosDateStamp(_date) is
	push a6;
	d1.l:=_date;
	a6:=DOSBase; jsr [a6-192];
	pop a6;
endp;															# DOSDATESTAMP

pattern Delay(_timeout) is
	push a6;
	d1.l:=_timeout;
	a6:=DOSBase; jsr [a6-198];
	pop a6;
endp;															# DELAY

pattern WaitForChar(_file,_timeout) is
	push d2\a6;
	safe d1.l:=_file; d2.l:=_timeout;;
	a6:=DOSBase; jsr [a6-204];
	pop d2\a6;
endp;															# WAITFORCHAR

pattern ParentDir(_lock) is
	push a6;
	d1.l:=_lock;
	a6:=DOSBase; jsr [a6-210];
	pop a6;
endp;															# PARENTDIR

pattern IsInteractive(_file) is
	push a6;
	d1.l:=_file;
	a6:=DOSBase; jsr [a6-216];
	pop a6;
endp;															# ISINTERACTIVE

pattern Execute(_string,_file,_file2) is
	push d2\d3\a6;
	safe d1.l:=_string; d2.l:=_file; d3.l:=_file2;;
	a6:=DOSBase; jsr [a6-222];
	pop d2\d3\a6;
endp;															# EXECUTE

pattern AllocDosObject(_type,_tags) is
	push d2\a6;
	safe d1.l:=_type; d2.l:=_tags;;
	a6:=DOSBase; jsr [a6-228];
	pop d2\a6;
endp;															# ALLOCDOSOBJECT

pattern FreeDosObject(_type,_ptr) is
	push d2\a6;
	safe d1.l:=_type; d2.l:=_ptr;;
	a6:=DOSBase; jsr [a6-234];
	pop d2\a6;
endp;															# FREEDOSOBJECT

pattern DoPkt(_port,_action,_arg1,_arg2,_arg3,_arg4,_arg5) is
	push d2\d3\d4\d5\d6\d7\a6;
	safe d1.l:=_port; d2.l:=_action; d3.l:=_arg1; d4.l:=_arg2; d5.l:=_arg3; d6.l:=_arg4; d7.l:=_arg5;;
	a6:=DOSBase; jsr [a6-240];
	pop d2\d3\d4\d5\d6\d7\a6;
endp;															# DOPKT

pattern SendPkt(_dp,_port,_replyport) is
	push d2\d3\a6;
	safe d1.l:=_dp; d2.l:=_port; d3.l:=_replyport;;
	a6:=DOSBase; jsr [a6-246];
	pop d2\d3\a6;
endp;															# SENDPKT

pattern WaitPkt is
	push a6;
	a6:=DOSBase; jsr [a6-252];
	pop a6;
endp;															# WAITPKT

pattern ReplyPkt(_dp,_res1,_res2) is
	push d2\d3\a6;
	safe d1.l:=_dp; d2.l:=_res1; d3.l:=_res2;;
	a6:=DOSBase; jsr [a6-258];
	pop d2\d3\a6;
endp;															# REPLYPKT

pattern AbortPkt(_port,_pkt) is
	push d2\a6;
	safe d1.l:=_port; d2.l:=_pkt;;
	a6:=DOSBase; jsr [a6-264];
	pop d2\a6;
endp;															# ABORTPKT

pattern LockRecord(_fh,_offset,_length,_mode,_timeout) is
	push d2\d3\d4\d5\a6;
	safe d1.l:=_fh; d2.l:=_offset; d3.l:=_length; d4.l:=_mode; d5.l:=_timeout;;
	a6:=DOSBase; jsr [a6-270];
	pop d2\d3\d4\d5\a6;
endp;															# LOCKRECORD

pattern LockRecords(_recArray,_timeout) is
	push d2\a6;
	safe d1.l:=_recArray; d2.l:=_timeout;;
	a6:=DOSBase; jsr [a6-276];
	pop d2\a6;
endp;															# LOCKRECORDS

pattern UnLockRecord(_fh,_offset,_length) is
	push d2\d3\a6;
	safe d1.l:=_fh; d2.l:=_offset; d3.l:=_length;;
	a6:=DOSBase; jsr [a6-282];
	pop d2\d3\a6;
endp;															# UNLOCKRECORD

pattern UnLockRecords(_recArray) is
	push a6;
	d1.l:=_recArray;
	a6:=DOSBase; jsr [a6-288];
	pop a6;
endp;															# UNLOCKRECORDS

pattern SelectInput(_fh) is
	push a6;
	d1.l:=_fh;
	a6:=DOSBase; jsr [a6-294];
	pop a6;
endp;															# SELECTINPUT

pattern SelectOutput(_fh) is
	push a6;
	d1.l:=_fh;
	a6:=DOSBase; jsr [a6-300];
	pop a6;
endp;															# SELECTOUTPUT

pattern FGetC(_fh) is
	push a6;
	d1.l:=_fh;
	a6:=DOSBase; jsr [a6-306];
	pop a6;
endp;															# FGETC

pattern FPutC(_fh,_ch) is
	push d2\a6;
	safe d1.l:=_fh; d2.l:=_ch;;
	a6:=DOSBase; jsr [a6-312];
	pop d2\a6;
endp;															# FPUTC

pattern UnGetC(_fh,_character) is
	push d2\a6;
	safe d1.l:=_fh; d2.l:=_character;;
	a6:=DOSBase; jsr [a6-318];
	pop d2\a6;
endp;															# UNGETC

pattern FRead(_fh,_block,_blocklen,_number) is
	push d2\d3\d4\a6;
	safe d1.l:=_fh; d2.l:=_block; d3.l:=_blocklen; d4.l:=_number;;
	a6:=DOSBase; jsr [a6-324];
	pop d2\d3\d4\a6;
endp;															# FREAD

pattern FWrite(_fh,_block,_blocklen,_number) is
	push d2\d3\d4\a6;
	safe d1.l:=_fh; d2.l:=_block; d3.l:=_blocklen; d4.l:=_number;;
	a6:=DOSBase; jsr [a6-330];
	pop d2\d3\d4\a6;
endp;															# FWRITE

pattern FGets(_fh,_buf,_buflen) is
	push d2\d3\a6;
	safe d1.l:=_fh; d2.l:=_buf; d3.l:=_buflen;;
	a6:=DOSBase; jsr [a6-336];
	pop d2\d3\a6;
endp;															# FGETS

pattern FPuts(_fh,_str) is
	push d2\a6;
	safe d1.l:=_fh; d2.l:=_str;;
	a6:=DOSBase; jsr [a6-342];
	pop d2\a6;
endp;															# FPUTS

pattern VFWritef(_fh,_format,_argarray) is
	push d2\d3\a6;
	safe d1.l:=_fh; d2.l:=_format; d3.l:=_argarray;;
	a6:=DOSBase; jsr [a6-348];
	pop d2\d3\a6;
endp;															# VFWRITEF

pattern VFPrintf(_fh,_format,_argarray) is
	push d2\d3\a6;
	safe d1.l:=_fh; d2.l:=_format; d3.l:=_argarray;;
	a6:=DOSBase; jsr [a6-354];
	pop d2\d3\a6;
endp;															# VFPRINTF

pattern Flush(_fh) is
	push a6;
	d1.l:=_fh;
	a6:=DOSBase; jsr [a6-360];
	pop a6;
endp;															# FLUSH

pattern SetVBuf(_fh,_buff,_type,_size) is
	push d2\d3\d4\a6;
	safe d1.l:=_fh; d2.l:=_buff; d3.l:=_type; d4.l:=_size;;
	a6:=DOSBase; jsr [a6-366];
	pop d2\d3\d4\a6;
endp;															# SETVBUF

pattern DupLockFromFH(_fh) is
	push a6;
	d1.l:=_fh;
	a6:=DOSBase; jsr [a6-372];
	pop a6;
endp;															# DUPLOCKFROMFH

pattern OpenFromLock(_lock) is
	push a6;
	d1.l:=_lock;
	a6:=DOSBase; jsr [a6-378];
	pop a6;
endp;															# OPENFROMLOCK

pattern ParentOfFH(_fh) is
	push a6;
	d1.l:=_fh;
	a6:=DOSBase; jsr [a6-384];
	pop a6;
endp;															# PARENTOFFH

pattern ExamineFH(_fh,_fib) is
	push d2\a6;
	safe d1.l:=_fh; d2.l:=_fib;;
	a6:=DOSBase; jsr [a6-390];
	pop d2\a6;
endp;															# EXAMINEFH

pattern SetFileDate(_name,_date) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_date;;
	a6:=DOSBase; jsr [a6-396];
	pop d2\a6;
endp;															# SETFILEDATE

pattern NameFromLock(_lock,_buffer,_len) is
	push d2\d3\a6;
	safe d1.l:=_lock; d2.l:=_buffer; d3.l:=_len;;
	a6:=DOSBase; jsr [a6-402];
	pop d2\d3\a6;
endp;															# NAMEFROMLOCK

pattern NameFromFH(_fh,_buffer,_len) is
	push d2\d3\a6;
	safe d1.l:=_fh; d2.l:=_buffer; d3.l:=_len;;
	a6:=DOSBase; jsr [a6-408];
	pop d2\d3\a6;
endp;															# NAMEFROMFH

pattern SplitName(_name,_seperator,_buf,_oldpos,_size) is
	push d2\d3\d4\d5\a6;
	safe d1.l:=_name; d2.l:=_seperator; d3.l:=_buf; d4.l:=_oldpos; d5.l:=_size;;
	a6:=DOSBase; jsr [a6-414];
	pop d2\d3\d4\d5\a6;
endp;															# SPLITNAME

pattern SameLock(_lock1,_lock2) is
	push d2\a6;
	safe d1.l:=_lock1; d2.l:=_lock2;;
	a6:=DOSBase; jsr [a6-420];
	pop d2\a6;
endp;															# SAMELOCK

pattern SetMode(_fh,_mode) is
	push d2\a6;
	safe d1.l:=_fh; d2.l:=_mode;;
	a6:=DOSBase; jsr [a6-426];
	pop d2\a6;
endp;															# SETMODE

pattern ExAll(_lock,_buffer,_size,_data,_control) is
	push d2\d3\d4\d5\a6;
	safe d1.l:=_lock; d2.l:=_buffer; d3.l:=_size; d4.l:=_data; d5.l:=_control;;
	a6:=DOSBase; jsr [a6-432];
	pop d2\d3\d4\d5\a6;
endp;															# EXALL

pattern ReadLink(_port,_lock,_path,_buffer,_size) is
	push d2\d3\d4\d5\a6;
	safe d1.l:=_port; d2.l:=_lock; d3.l:=_path; d4.l:=_buffer; d5.l:=_size;;
	a6:=DOSBase; jsr [a6-438];
	pop d2\d3\d4\d5\a6;
endp;															# READLINK

pattern MakeLink(_name,_dest,_soft) is
	push d2\d3\a6;
	safe d1.l:=_name; d2.l:=_dest; d3.l:=_soft;;
	a6:=DOSBase; jsr [a6-444];
	pop d2\d3\a6;
endp;															# MAKELINK

pattern ChangeMode(_type,_fh,_newmode) is
	push d2\d3\a6;
	safe d1.l:=_type; d2.l:=_fh; d3.l:=_newmode;;
	a6:=DOSBase; jsr [a6-450];
	pop d2\d3\a6;
endp;															# CHANGEMODE

pattern SetFileSize(_fh,_pos,_mode) is
	push d2\d3\a6;
	safe d1.l:=_fh; d2.l:=_pos; d3.l:=_mode;;
	a6:=DOSBase; jsr [a6-456];
	pop d2\d3\a6;
endp;															# SETFILESIZE

pattern SetIoErr(_result) is
	push a6;
	d1.l:=_result;
	a6:=DOSBase; jsr [a6-462];
	pop a6;
endp;															# SETIOERR

pattern Fault(_code,_header,_buffer,_len) is
	push d2\d3\d4\a6;
	safe d1.l:=_code; d2.l:=_header; d3.l:=_buffer; d4.l:=_len;;
	a6:=DOSBase; jsr [a6-468];
	pop d2\d3\d4\a6;
endp;															# FAULT

pattern PrintFault(_code,_header) is
	push d2\a6;
	safe d1.l:=_code; d2.l:=_header;;
	a6:=DOSBase; jsr [a6-474];
	pop d2\a6;
endp;															# PRINTFAULT

pattern ErrorReport(_code,_type,_arg1,_device) is
	push d2\d3\d4\a6;
	safe d1.l:=_code; d2.l:=_type; d3.l:=_arg1; d4.l:=_device;;
	a6:=DOSBase; jsr [a6-480];
	pop d2\d3\d4\a6;
endp;															# ERRORREPORT

pattern Cli is
	push a6;
	a6:=DOSBase; jsr [a6-492];
	pop a6;
endp;															# CLI

pattern CreateNewProc(_tags) is
	push a6;
	d1.l:=_tags;
	a6:=DOSBase; jsr [a6-498];
	pop a6;
endp;															# CREATENEWPROC

pattern RunCommand(_seg,_stack,_paramptr,_paramlen) is
	push d2\d3\d4\a6;
	safe d1.l:=_seg; d2.l:=_stack; d3.l:=_paramptr; d4.l:=_paramlen;;
	a6:=DOSBase; jsr [a6-504];
	pop d2\d3\d4\a6;
endp;															# RUNCOMMAND

pattern GetConsoleTask is
	push a6;
	a6:=DOSBase; jsr [a6-510];
	pop a6;
endp;															# GETCONSOLETASK

pattern SetConsoleTask(_task) is
	push a6;
	d1.l:=_task;
	a6:=DOSBase; jsr [a6-516];
	pop a6;
endp;															# SETCONSOLETASK

pattern GetFileSysTask is
	push a6;
	a6:=DOSBase; jsr [a6-522];
	pop a6;
endp;															# GETFILESYSTASK

pattern SetFileSysTask(_task) is
	push a6;
	d1.l:=_task;
	a6:=DOSBase; jsr [a6-528];
	pop a6;
endp;															# SETFILESYSTASK

pattern GetArgStr is
	push a6;
	a6:=DOSBase; jsr [a6-534];
	pop a6;
endp;															# GETARGSTR

pattern SetArgStr(_string) is
	push a6;
	d1.l:=_string;
	a6:=DOSBase; jsr [a6-540];
	pop a6;
endp;															# SETARGSTR

pattern FindCliProc(_num) is
	push a6;
	d1.l:=_num;
	a6:=DOSBase; jsr [a6-546];
	pop a6;
endp;															# FINDCLIPROC

pattern MaxCli is
	push a6;
	a6:=DOSBase; jsr [a6-552];
	pop a6;
endp;															# MAXCLI

pattern SetCurrentDirName(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-558];
	pop a6;
endp;															# SETCURRENTDIRNAME

pattern GetCurrentDirName(_buf,_len) is
	push d2\a6;
	safe d1.l:=_buf; d2.l:=_len;;
	a6:=DOSBase; jsr [a6-564];
	pop d2\a6;
endp;															# GETCURRENTDIRNAME

pattern SetProgramName(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-570];
	pop a6;
endp;															# SETPROGRAMNAME

pattern GetProgramName(_buf,_len) is
	push d2\a6;
	safe d1.l:=_buf; d2.l:=_len;;
	a6:=DOSBase; jsr [a6-576];
	pop d2\a6;
endp;															# GETPROGRAMNAME

pattern SetPrompt(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-582];
	pop a6;
endp;															# SETPROMPT

pattern GetPrompt(_buf,_len) is
	push d2\a6;
	safe d1.l:=_buf; d2.l:=_len;;
	a6:=DOSBase; jsr [a6-588];
	pop d2\a6;
endp;															# GETPROMPT

pattern SetProgramDir(_lock) is
	push a6;
	d1.l:=_lock;
	a6:=DOSBase; jsr [a6-594];
	pop a6;
endp;															# SETPROGRAMDIR

pattern GetProgramDir is
	push a6;
	a6:=DOSBase; jsr [a6-600];
	pop a6;
endp;															# GETPROGRAMDIR

pattern SystemTagList(_command,_tags) is
	push d2\a6;
	safe d1.l:=_command; d2.l:=_tags;;
	a6:=DOSBase; jsr [a6-606];
	pop d2\a6;
endp;															# SYSTEMTAGLIST

pattern AssignLock(_name,_lock) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_lock;;
	a6:=DOSBase; jsr [a6-612];
	pop d2\a6;
endp;															# ASSIGNLOCK

pattern AssignLate(_name,_path) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_path;;
	a6:=DOSBase; jsr [a6-618];
	pop d2\a6;
endp;															# ASSIGNLATE

pattern AssignPath(_name,_path) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_path;;
	a6:=DOSBase; jsr [a6-624];
	pop d2\a6;
endp;															# ASSIGNPATH

pattern AssignAdd(_name,_lock) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_lock;;
	a6:=DOSBase; jsr [a6-630];
	pop d2\a6;
endp;															# ASSIGNADD

pattern RemAssignList(_name,_lock) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_lock;;
	a6:=DOSBase; jsr [a6-636];
	pop d2\a6;
endp;															# REMASSIGNLIST

pattern GetDeviceProc(_name,_dp) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_dp;;
	a6:=DOSBase; jsr [a6-642];
	pop d2\a6;
endp;															# GETDEVICEPROC

pattern FreeDeviceProc(_dp) is
	push a6;
	d1.l:=_dp;
	a6:=DOSBase; jsr [a6-648];
	pop a6;
endp;															# FREEDEVICEPROC

pattern LockDosList(_flags) is
	push a6;
	d1.l:=_flags;
	a6:=DOSBase; jsr [a6-654];
	pop a6;
endp;															# LOCKDOSLIST

pattern UnLockDosList(_flags) is
	push a6;
	d1.l:=_flags;
	a6:=DOSBase; jsr [a6-660];
	pop a6;
endp;															# UNLOCKDOSLIST

pattern AttemptLockDosList(_flags) is
	push a6;
	d1.l:=_flags;
	a6:=DOSBase; jsr [a6-666];
	pop a6;
endp;															# ATTEMPTLOCKDOSLIST

pattern RemDosEntry(_dlist) is
	push a6;
	d1.l:=_dlist;
	a6:=DOSBase; jsr [a6-672];
	pop a6;
endp;															# REMDOSENTRY

pattern AddDosEntry(_dlist) is
	push a6;
	d1.l:=_dlist;
	a6:=DOSBase; jsr [a6-678];
	pop a6;
endp;															# ADDDOSENTRY

pattern FindDosEntry(_dlist,_name,_flags) is
	push d2\d3\a6;
	safe d1.l:=_dlist; d2.l:=_name; d3.l:=_flags;;
	a6:=DOSBase; jsr [a6-684];
	pop d2\d3\a6;
endp;															# FINDDOSENTRY

pattern NextDosEntry(_dlist,_flags) is
	push d2\a6;
	safe d1.l:=_dlist; d2.l:=_flags;;
	a6:=DOSBase; jsr [a6-690];
	pop d2\a6;
endp;															# NEXTDOSENTRY

pattern MakeDosEntry(_name,_type) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_type;;
	a6:=DOSBase; jsr [a6-696];
	pop d2\a6;
endp;															# MAKEDOSENTRY

pattern FreeDosEntry(_dlist) is
	push a6;
	d1.l:=_dlist;
	a6:=DOSBase; jsr [a6-702];
	pop a6;
endp;															# FREEDOSENTRY

pattern IsFileSystem(_name) is
	push a6;
	d1.l:=_name;
	a6:=DOSBase; jsr [a6-708];
	pop a6;
endp;															# ISFILESYSTEM

pattern Format(_filesystem,_volumename,_dostype) is
	push d2\d3\a6;
	safe d1.l:=_filesystem; d2.l:=_volumename; d3.l:=_dostype;;
	a6:=DOSBase; jsr [a6-714];
	pop d2\d3\a6;
endp;															# FORMAT

pattern Relabel(_drive,_newname) is
	push d2\a6;
	safe d1.l:=_drive; d2.l:=_newname;;
	a6:=DOSBase; jsr [a6-720];
	pop d2\a6;
endp;															# RELABEL

pattern Inhibit(_name,_onoff) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_onoff;;
	a6:=DOSBase; jsr [a6-726];
	pop d2\a6;
endp;															# INHIBIT

pattern AddBuffers(_name,_number) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_number;;
	a6:=DOSBase; jsr [a6-732];
	pop d2\a6;
endp;															# ADDBUFFERS

pattern CompareDates(_date1,_date2) is
	push d2\a6;
	safe d1.l:=_date1; d2.l:=_date2;;
	a6:=DOSBase; jsr [a6-738];
	pop d2\a6;
endp;															# COMPAREDATES

pattern DateToStr(_datetime) is
	push a6;
	d1.l:=_datetime;
	a6:=DOSBase; jsr [a6-744];
	pop a6;
endp;															# DATETOSTR

pattern StrToDate(_datetime) is
	push a6;
	d1.l:=_datetime;
	a6:=DOSBase; jsr [a6-750];
	pop a6;
endp;															# STRTODATE

pattern InternalLoadSeg(_fh,_table,_funcarray,_stack) is
	push a2\a6;
	safe d0.l:=_fh; a0:=_table; a1:=_funcarray; a2:=_stack;;
	a6:=DOSBase; jsr [a6-756];
	pop a2\a6;
endp;															# INTERNALLOADSEG

pattern InternalUnLoadSeg(_seglist,_freefunc) is
	push a6;
	safe d1.l:=_seglist; a1:=_freefunc;;
	a6:=DOSBase; jsr [a6-762];
	pop a6;
endp;															# INTERNALUNLOADSEG

pattern NewLoadSeg(_file,_tags) is
	push d2\a6;
	safe d1.l:=_file; d2.l:=_tags;;
	a6:=DOSBase; jsr [a6-768];
	pop d2\a6;
endp;															# NEWLOADSEG

pattern AddSegment(_name,_seg,_system) is
	push d2\d3\a6;
	safe d1.l:=_name; d2.l:=_seg; d3.l:=_system;;
	a6:=DOSBase; jsr [a6-774];
	pop d2\d3\a6;
endp;															# ADDSEGMENT

pattern FindSegment(_name,_seg,_system) is
	push d2\d3\a6;
	safe d1.l:=_name; d2.l:=_seg; d3.l:=_system;;
	a6:=DOSBase; jsr [a6-780];
	pop d2\d3\a6;
endp;															# FINDSEGMENT

pattern RemSegment(_seg) is
	push a6;
	d1.l:=_seg;
	a6:=DOSBase; jsr [a6-786];
	pop a6;
endp;															# REMSEGMENT

pattern CheckSignal(_mask) is
	push a6;
	d1.l:=_mask;
	a6:=DOSBase; jsr [a6-792];
	pop a6;
endp;															# CHECKSIGNAL

pattern ReadArgs(_arg_template,_array,_args) is
	push d2\d3\a6;
	safe d1.l:=_arg_template; d2.l:=_array; d3.l:=_args;;
	a6:=DOSBase; jsr [a6-798];
	pop d2\d3\a6;
endp;															# READARGS

pattern FindArg(_keyword,_arg_template) is
	push d2\a6;
	safe d1.l:=_keyword; d2.l:=_arg_template;;
	a6:=DOSBase; jsr [a6-804];
	pop d2\a6;
endp;															# FINDARG

pattern ReadItem(_name,_maxchars,_cSource) is
	push d2\d3\a6;
	safe d1.l:=_name; d2.l:=_maxchars; d3.l:=_cSource;;
	a6:=DOSBase; jsr [a6-810];
	pop d2\d3\a6;
endp;															# READITEM

pattern StrToLong(_string,_value) is
	push d2\a6;
	safe d1.l:=_string; d2.l:=_value;;
	a6:=DOSBase; jsr [a6-816];
	pop d2\a6;
endp;															# STRTOLONG

pattern MatchFirst(_pat,_anchor) is
	push d2\a6;
	safe d1.l:=_pat; d2.l:=_anchor;;
	a6:=DOSBase; jsr [a6-822];
	pop d2\a6;
endp;															# MATCHFIRST

pattern MatchNext(_anchor) is
	push a6;
	d1.l:=_anchor;
	a6:=DOSBase; jsr [a6-828];
	pop a6;
endp;															# MATCHNEXT

pattern MatchEnd(_anchor) is
	push a6;
	d1.l:=_anchor;
	a6:=DOSBase; jsr [a6-834];
	pop a6;
endp;															# MATCHEND

pattern ParsePattern(_pat,_buf,_buflen) is
	push d2\d3\a6;
	safe d1.l:=_pat; d2.l:=_buf; d3.l:=_buflen;;
	a6:=DOSBase; jsr [a6-840];
	pop d2\d3\a6;
endp;															# PARSEPATTERN

pattern MatchPattern(_pat,_str) is
	push d2\a6;
	safe d1.l:=_pat; d2.l:=_str;;
	a6:=DOSBase; jsr [a6-846];
	pop d2\a6;
endp;															# MATCHPATTERN

pattern dosPrivate3 is
	push a6;
	a6:=DOSBase; jsr [a6-852];
	pop a6;
endp;															# DOSPRIVATE3

pattern FreeArgs(_args) is
	push a6;
	d1.l:=_args;
	a6:=DOSBase; jsr [a6-858];
	pop a6;
endp;															# FREEARGS

pattern FilePart(_path) is
	push a6;
	d1.l:=_path;
	a6:=DOSBase; jsr [a6-870];
	pop a6;
endp;															# FILEPART

pattern PathPart(_path) is
	push a6;
	d1.l:=_path;
	a6:=DOSBase; jsr [a6-876];
	pop a6;
endp;															# PATHPART

pattern AddPart(_dirname,_filename,_size) is
	push d2\d3\a6;
	safe d1.l:=_dirname; d2.l:=_filename; d3.l:=_size;;
	a6:=DOSBase; jsr [a6-882];
	pop d2\d3\a6;
endp;															# ADDPART

pattern StartNotify(_notify) is
	push a6;
	d1.l:=_notify;
	a6:=DOSBase; jsr [a6-888];
	pop a6;
endp;															# STARTNOTIFY

pattern EndNotify(_notify) is
	push a6;
	d1.l:=_notify;
	a6:=DOSBase; jsr [a6-894];
	pop a6;
endp;															# ENDNOTIFY

pattern SetVar(_name,_buffer,_size,_flags) is
	push d2\d3\d4\a6;
	safe d1.l:=_name; d2.l:=_buffer; d3.l:=_size; d4.l:=_flags;;
	a6:=DOSBase; jsr [a6-900];
	pop d2\d3\d4\a6;
endp;															# SETVAR

pattern GetVar(_name,_buffer,_size,_flags) is
	push d2\d3\d4\a6;
	safe d1.l:=_name; d2.l:=_buffer; d3.l:=_size; d4.l:=_flags;;
	a6:=DOSBase; jsr [a6-906];
	pop d2\d3\d4\a6;
endp;															# GETVAR

pattern DeleteVar(_name,_flags) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_flags;;
	a6:=DOSBase; jsr [a6-912];
	pop d2\a6;
endp;															# DELETEVAR

pattern FindVar(_name,_type) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_type;;
	a6:=DOSBase; jsr [a6-918];
	pop d2\a6;
endp;															# FINDVAR

pattern dosPrivate4 is
	push a6;
	a6:=DOSBase; jsr [a6-924];
	pop a6;
endp;															# DOSPRIVATE4

pattern CliInitNewcli(_dp) is
	push a6;
	a0:=_dp;
	a6:=DOSBase; jsr [a6-930];
	pop a6;
endp;															# CLIINITNEWCLI

pattern CliInitRun(_dp) is
	push a6;
	a0:=_dp;
	a6:=DOSBase; jsr [a6-936];
	pop a6;
endp;															# CLIINITRUN

pattern WriteChars(_buf,_buflen) is
	push d2\a6;
	safe d1.l:=_buf; d2.l:=_buflen;;
	a6:=DOSBase; jsr [a6-942];
	pop d2\a6;
endp;															# WRITECHARS

pattern PutStr(_str) is
	push a6;
	d1.l:=_str;
	a6:=DOSBase; jsr [a6-948];
	pop a6;
endp;															# PUTSTR

pattern VPrintf(_format,_argarray) is
	push d2\a6;
	safe d1.l:=_format; d2.l:=_argarray;;
	a6:=DOSBase; jsr [a6-954];
	pop d2\a6;
endp;															# VPRINTF

pattern ParsePatternNoCase(_pat,_buf,_buflen) is
	push d2\d3\a6;
	safe d1.l:=_pat; d2.l:=_buf; d3.l:=_buflen;;
	a6:=DOSBase; jsr [a6-966];
	pop d2\d3\a6;
endp;															# PARSEPATTERNNOCASE

pattern MatchPatternNoCase(_pat,_str) is
	push d2\a6;
	safe d1.l:=_pat; d2.l:=_str;;
	a6:=DOSBase; jsr [a6-972];
	pop d2\a6;
endp;															# MATCHPATTERNNOCASE

pattern dosPrivate5 is
	push a6;
	a6:=DOSBase; jsr [a6-978];
	pop a6;
endp;															# DOSPRIVATE5

pattern SameDevice(_lock1,_lock2) is
	push d2\a6;
	safe d1.l:=_lock1; d2.l:=_lock2;;
	a6:=DOSBase; jsr [a6-984];
	pop d2\a6;
endp;															# SAMEDEVICE

pattern ExAllEnd(_lock,_buffer,_size,_data,_control) is
	push d2\d3\d4\d5\a6;
	safe d1.l:=_lock; d2.l:=_buffer; d3.l:=_size; d4.l:=_data; d5.l:=_control;;
	a6:=DOSBase; jsr [a6-990];
	pop d2\d3\d4\d5\a6;
endp;															# EXALLEND

pattern SetOwner(_name,_owner_info) is
	push d2\a6;
	safe d1.l:=_name; d2.l:=_owner_info;;
	a6:=DOSBase; jsr [a6-996];
	pop d2\a6;
endp;															# SETOWNER

