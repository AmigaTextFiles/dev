MODULE '*quip','other/stayrandom','other/stderr','dos/dosasl'

-> NOTE: The 'stayrandom' module should be in aminet:dev/e if you don't have it.
-> Otherwise, replace 'stayrandom()' below with something else, or leave it out,
-> but understand that randomized quips won't be truly random without the
-> 'stayrandom()' call (or something similiar).  Yes.. I made stayrandom(), too.

-> You already need 'stderr' for the quip module.  It's for handling standard
-> error output (with automated Fault() handling).

PROC main() HANDLE
 DEF quip=0:PTR TO fquip,tquip=0:PTR TO tquip,out,mid

 stayrandom()

 mid := StrAdd(String(41),'<><><><><><><><><><><><><><><><><><><>\n',ALL)

 -> NOTE: The above safely generates a new string that may be deallocated.

 NEW quip.new(["rnd",
 	       "num",5,
	       "file",'blonde.txt'])

 NEW tquip.new(["file",'blonde.txt',
 		"ser",
                "mid",mid,
		"num",5])

 -> Testing the 'fquip' object.

 WriteF('Testing the ''fquip'' object:\n')
 quip.pre('presuf.txt')			-> I could have specified these two in the
 quip.suf('presuf.txt')			-> .new() but I didn't.
 quip.grab()
 WHILE quip.isMore()
  out,mid:=quip.get()			-> 2 return values.. but 'mid' won't have
  WriteF(out)				-> anything in it.
  IF quip.isMore()<>0 THEN IF mid THEN WriteF(mid)
 ENDWHILE
 END quip; quip:=0

 -> Testing the 'tquip' object.

 WriteF('Testing the ''tquip'' object:\n')
 tquip.grab()
 tquip.pre('presuf.txt')
 tquip.suf('presuf.txt')
 WHILE tquip.isMore()
  out,mid:=tquip.get()			-> 'mid' will have something now.
  WriteF(out)
  IF tquip.isMore()<>0 THEN IF mid THEN WriteF(mid)	-> Make sure it's in the
 ENDWHILE						-> middle of printing quips.
 END tquip;tquip:=0
EXCEPT
 IF exception = "^C" THEN SetIoErr(ERROR_BREAK)
 IF tquip THEN END tquip			-> Generally a good idea.  Files
 IF quip THEN END quip				-> could be open or something.
 err_WriteF('Error.\n')
ENDPROC
