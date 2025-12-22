/* this is a diff program for smalltalk 1.2 */ 

files = "mstsave.c IdentityDictionary.st mstsave.h initialize.st
 mststr.c Integer.st mststr.h Interval.st mstsym.c IOCtl.st mstsym.h
 alloc.c Link.st mstsysdep.c alloca.c LinkedList.st mstsysdep.h
 alloca.s LookupKey.st msttree.c Array.st Magnitude.st msttree.h
 ArrayedCollection.st Makefile Number.st Association.st
 MappedCollection.st Object.st Autoload.st Memory.st
 OrderedCollection.st Bag.st Message.st Point.st Behavior.st
 Metaclass.st PositionableStream.st bison.el MethodContext.st
 BlockContext.st MethodInfo.st Process.st Boolean.st
 ProcessorScheduler.st browse.el mst.h Random.st
 Browser.st mst.tab.c builtins.st mst.tab.h ByteArray.st mst.texinfo
 ReadStream.st ByteMemory.st mst.y ReadWriteStream.st CFuncs.st
 mstbyte.c Rectangle.st mstbyte.h Semaphore.st changes.st mstcallin.c
 SequenceableCollection.st Character.st mstcallin.h Set.st Class.st
 mstcint.c SharedQueue.st ClassDescription.st mstcint.h
 SortedCollection.st CObject.st mstcomp.c st-changelog.el Collection.st
 mstcomp.h st.el CompiledMethod.st mstdict.c Stream.st config.mst
 mstdict.h String.st mstfiles Symbol.st CStruct.st mstid.c
 SymLink.st CType.st mstid.h SystemDictionary.st Date.st mstinterp.c
 t.st Debugger.st mstinterp.h Delay.st mstlex.c Time.st
 Dictionary.st mstlex.h TokenStream.st DLD.st mstlib.c True.st False.st
 mstlib.h UndefinedObject.st fileout-ps.st mstmain.c UnixStream.st 
 FileSegment.st mstoop.c WordMemory.st FileStream.st mstoop.h
 WriteStream.st Float.st mstpaths.h-dist ymakefile Fraction.st
 mstpub.h"

numfiles = words(files)

call open out,"t:diff_temp",write

do i=1 to numfiles
        say 'diff' "-c" word(files,i) "smalltalk-1.2/"word(files,i)" >>t:smtk_diff"
        call writeln out,'diff' "-c" word(files,i) "smalltalk-1.2/"word(files,i)" >>t:smtk_diff"

end

call close out

