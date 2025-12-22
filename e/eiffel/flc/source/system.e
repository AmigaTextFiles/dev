
-> Copyright © 1995, Guichard Damien.

-> The entire Eiffel system, including kernel classes

-> TO DO :
->   ARRAY[G], BIT n, REAL, DOUBLE, POINTER kernel classes

OPT MODULE

MODULE '*errors','*eiffel_lex'
MODULE '*parser','*prime_server'
MODULE '*entity','*entity_tree','*kernel_class','*current'
MODULE '*class','*feature','*function','*procedure','*variable','*constant'
MODULE '*argument'
MODULE '*code','*ame','*ame_code','*label_server'

-> The Eiffel system (set of classes)
EXPORT DEF system:PTR TO entity_tree

-> Kernel classes
EXPORT DEF any_class:PTR TO class
EXPORT DEF none_class:PTR TO kernel_class
EXPORT DEF integer_class:PTR TO kernel_class
EXPORT DEF boolean_class:PTR TO kernel_class
EXPORT DEF character_class:PTR TO kernel_class
EXPORT DEF real_class:PTR TO kernel_class
EXPORT DEF double_class:PTR TO kernel_class
EXPORT DEF pointer_class:PTR TO kernel_class
EXPORT DEF string_class:PTR TO class
EXPORT DEF array_class:PTR TO class

EXPORT DEF class:PTR TO class       -> class beeing parsed (passes 1 and 2)
EXPORT DEF current:PTR TO current   -> 'Current' class (passes 1 and 2)

EXPORT DEF lex:PTR TO eiffel_lex     -> lexical analyser (passes 1 and 2)
EXPORT DEF prime:PTR TO prime_server -> Prime stream (pass 1)
EXPORT DEF ll:PTR TO label_server    -> local label server (pass 2)
EXPORT DEF gl:PTR TO label_server    -> global label server (pass 1)
EXPORT DEF code:PTR TO ame_code      -> executable code generated (pass 2)

-> Vectors for routines from ANY
ENUM IS_EQUAL=1,STANDARD_IS_EQUAL,COPY,STANDARD_COPY,LASTCHAR,LASTINT,
     LASTSTRING,NEW_LINE,PUTCHAR,PUTINT,PUTSTRING,READCHAR,READINT,
     READSTRING,BIT_SIZE,LAST_VECTOR

-> Vectors for routines from STRING
ENUM MAKE=LAST_VECTOR,APPEND,CLEAR,IS_EMPTY,EXTEND,FILL_BLANK,
     HASH_CODE,HEAD,INDEX_OF,ITEM,ITEM_CODE,LEFT_ADJUST,
     PRECEDE, PREPEND,PUT,REMOVE,REMOVE_ALL_OCCURRENCES ,RIGHT_ADJUST,SHRINK,
     SUBSTRING,TAIL,TO_INTEGER,TO_LOWER,TO_UPPER

-> Declare the root of the Eiffel system
EXPORT PROC root(class_name,creator,file_name) HANDLE
  DEF file=NIL
  DEF errors:PTR TO LONG
  errors := ['',
    'Could not read source file',
    'Could not create executable file',
    'Feature not yet implemented',
    'Not a creation feature',
    'Syntax error',
    'VAOL','VAPE','VAVE','VBAR','VBGV','VCCH(1)','VCCH(2)',
    'VCFG(1)','VCFG(2)','VCRN','VDCN','VDJR','VDOC','VDRD(1)',
    'VDRD(2)','VDRD(3)','VDRD(4)','VDRD(5)','VDRD(6)','VDRD(7)','VDRD(8)',
    'VDRS(1)','VDRS(2)','VDRS(3)','VDRS(4)','VDUC','VDUS(1)','VDUS(2)',
    'VDUS(3)','VDUS(4)','VEEN','VFFD(1)','VFFD(2)','VFFD(3)','VFFD(4)',
    'VFFD(5)','VFFD(6)','VFFD(7)','VGCC(1)','VGCC(2)','VGCC(3)','VGCC(4)',
    'VGCC(5)','VGCC(6)','VGCI','VGCP(1)','VGCP(2)','VGCP(3)','VGCP(4)',
    'VGCP(5)','VGCS','VHAY','VHPR(1)','VHPR(2)','VHRC(1)','VHRC(2)',
    'VIEX','VIRW','VJAR','VJRV','VKCN','VLCP','VLEC',
    'VLEL(1)','VLEL(2)','VLEL(3)','VMCN','VMFN','VMRC','VMSS',
    'VNCB','VNCC','VNCE','VNCF','VNCG','VNCH','VNCN',
    'VNCS','VNCX','VOMB(1)','VOMB(2)','VOMB(3)','VOMB(4)','VOMB(5)',
    'VOMB(6)','VQMC','VQUI','VREG','VRFA','VRLE(1)','VRLE(2)',
    'VRRR(1)','VRRR(2)','VSCN','VSRC(1)','VSRC(2)','VTAT(1)','VTAT(2)',
    'VTAT(3)','VTBT','VTCG','VTCT','VTEC','VTUG','VUAR(1)',
    'VUAR(2)','VUCS','VUEX(1)','VUEX(2)','VUGV','VWBE','VWEQ',
    'VWCA','VWID','VWMA','VWMS(1)','VWMS(2)','VWOE','VWST','VXRC','VXRT',
    '']

  NEW code.buffer(16000)
  code.global_labels(200,400)
  code.local_labels(80,160)
  code.putbinary({startup}+32,{end_startup}-4)

  NEW system
  NEW current
  NEW gl
  NEW ll
  NEW prime.create()

  class_graph(class_name)
  explode(creator)
  code.resolve_globals()
  IF (file:=Open(file_name,NEWFILE))=NIL THEN Raise(ER_EXEFILE)
  code.flush(file)
EXCEPT DO
  IF file THEN Close(file)
  IF exception<>ER_NONE
    IF exception="MEM"
      WriteF('Not enough memory\n')
      RETURN
    ELSEIF exception<=ER_SYNTAX
      WriteF('\s in \s, line \d\n',
        errors[exception],class.name,lex.line)
    ELSE
      WriteF('Validity violation \s in \s, line \d\n',
        errors[exception],UpperStr(class.name),lex.line)
    ENDIF
  ENDIF
ENDPROC

-> construct a graph of classes
PROC class_graph(class_name)
  DEF skip
  code.ame(I_LINK,M_LABEL,skip:=gl.next(),R_NONE)
  kernel_none()
  kernel_boolean()
  kernel_numeric()
  kernel_any()
  kernel_character()
  kernel_string()
  kernel_array()
  kernel_pointer()
  NEW class.set_name(class_name,prime.next(),gl.next())
  system.add(class)
  class_declaration1()
  class_declaration2()
  code.ame(I_TABLE,M_LABEL,skip,R_NONE)
ENDPROC

-> create the root object
PROC explode(creator)
  DEF f:PTR TO feature
  DEF r:PTR TO procedure
  code.ame(I_CREATE,class.access(),class.index(),R_NONE)
  code.putF4(L,0,DREG,0,0,ARDIR,0)
  f:=class.find_feature(creator)
  IF f=NIL THEN Raise(ER_NOT_A_CREATION_FEATURE)
  IF f.is_procedure()=FALSE THEN Raise(ER_NOT_A_CREATION_FEATURE)
  r:=f
  IF r.is_creator(class,none_class)=FALSE THEN
    Raise(ER_NOT_A_CREATION_FEATURE)
  IF r.arguments THEN Raise(ER_VSRC2)
  code.ame(I_CALL,M_ROUTINE,r.vector(),R_NONE)
  code.putword(IRTS)
ENDPROC

-> NONE class
PROC kernel_none()
  NEW none_class.set_name('none',0,gl.next())
ENDPROC

-> BOOLEAN class
PROC kernel_boolean()
  NEW boolean_class.set_name('boolean',prime.next(),0)
ENDPROC

-> INTEGER, REAL, DOUBLE kernel classes
PROC kernel_numeric()
  NEW integer_class.set_name('integer',prime.next(),0)
  NEW real_class.set_name('real',prime.next(),0)
  NEW double_class.set_name('double',prime.next(),0)
ENDPROC

-> ANY class
-> ANY includes STANDARD_FILES and so provides IO facilities
PROC kernel_any()
  DEF r:PTR TO procedure
  DEF f:PTR TO function
  DEF arguments:PTR TO argument
  DEF lab:LONG
  DEF table:PTR TO LONG
  NEW any_class.set_name('any',1,gl.next())
  NEW string_class.set_name('string',prime.next(),gl.next())

-> is_equal (other:like Current):BOOLEAN
  NEW arguments.create('other')
  arguments.set_type(current)
  NEW f.create('is_equal',any_class,boolean_class)
  f.add_arguments(arguments)
  any_class.add_feature(f)

-> frozen standard_is_equal (other:like Current):BOOLEAN
  NEW arguments.create('other')
  arguments.set_type(current)
  NEW f.create('standard_is_equal',any_class,boolean_class)
  f.add_arguments(arguments)
  f.freeze()
  any_class.add_feature(f)

-> copy (other:like Current)
  NEW arguments.create('other')
  arguments.set_type(current)
  NEW r.create('copy',any_class,NIL)
  r.add_arguments(arguments)
  any_class.add_feature(r)

-> frozen standard_copy (other:like Current)
  NEW arguments.create('other')
  arguments.set_type(current)
  NEW r.create('standard_copy',any_class,NIL)
  r.add_arguments(arguments)
  r.freeze()
  any_class.add_feature(r)

-> lastchar:CHARACTER
  NEW f.create('lastchar',any_class,character_class)
  any_class.add_feature(f)

-> lastint:INTEGER
  NEW f.create('lastint',any_class,integer_class)
  any_class.add_feature(f)

-> laststring:STRING
  NEW f.create('laststring',any_class,string_class)
  any_class.add_feature(f)

-> new_line
  NEW r.create('new_line',any_class,NIL)
  any_class.add_feature(r)

-> putchar (c:CHARACTER)
  NEW arguments.create('c')
  arguments.set_type(character_class)
  NEW r.create('putchar',any_class,NIL)
  r.add_arguments(arguments)
  any_class.add_feature(r)

-> putint (i:INTEGER)
  NEW arguments.create('i')
  arguments.set_type(integer_class)
  NEW r.create('putint',any_class,NIL)
  r.add_arguments(arguments)
  any_class.add_feature(r)

-> putstring (s:STRING)
  NEW arguments.create('s')
  arguments.set_type(string_class)
  NEW r.create('putstring',any_class,NIL)
  r.add_arguments(arguments)
  any_class.add_feature(r)

-> readchar
  NEW r.create('readchar',any_class,NIL)
  any_class.add_feature(r)

-> readint
  NEW r.create('readint',any_class,NIL)
  any_class.add_feature(r)

-> readstring
  NEW r.create('readstring',any_class,NIL)
  any_class.add_feature(r)

-> bit_size:INTEGER
  NEW f.create('bit_size',any_class,integer_class)
  any_class.add_feature(f)

  any_class.prepare_links()

  table:=[IS_EQUAL,{is_equal},{end_is_equal},
    STANDARD_IS_EQUAL,{standard_is_equal},{end_standard_is_equal},
    COPY,{copy},{end_copy},
    STANDARD_COPY,{standard_copy},{end_standard_copy},
    LASTCHAR,{lastchar},{end_lastchar},
    LASTINT,{lastint},{end_lastint},
    LASTSTRING,{laststring},{end_laststring},
    NEW_LINE,{new_line},{end_new_line},
    PUTCHAR,{putchar},{end_putchar},
    PUTINT,{putint},{end_putint},
    PUTSTRING,{putstring},{end_putstring},
    READCHAR,{readchar},{end_readchar},
    READINT,{readint},{end_readint},
    READSTRING,{readstring},{end_readstring},
    BIT_SIZE,{bit_size},{end_bit_size},
    NIL]
  WHILE table[]
    any_class.link_routine(table[]++,lab:=gl.next())
    code.define_global(lab)
    code.putbinary(32+table[]++,-4+table[]++)
  ENDWHILE
ENDPROC

-> CHARACTER class
PROC kernel_character()
  NEW character_class.set_name('character',prime.next(),0)
ENDPROC

-> STRING class
PROC kernel_string()
  DEF v:PTR TO variable
  DEF r:PTR TO procedure
  DEF f:PTR TO function
  DEF arguments:PTR TO argument
  DEF argm:PTR TO argument
  DEF lab:LONG
  DEF table:PTR TO LONG
  string_class.add_parent(any_class)
  string_class.creators_section()

-> creation make (n:INTEGER)
  NEW arguments.create('n')
  arguments.set_type(integer_class)
  NEW r.create('make',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)
  r.as_creator(string_class,any_class)

-> append (s:STRING)
  NEW arguments.create('s')
  arguments.set_type(string_class)
  NEW r.create('append',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> capacity:INTEGER
  NEW v.create('capacity',any_class,NIL)
  string_class.add_feature(v)

-> clear
  NEW r.create('clear',any_class,NIL)
  string_class.add_feature(r)

-> copy (other:STRING)
  NEW arguments.create('other')
  arguments.set_type(string_class)
  NEW r.create('copy',any_class,NIL)
  r.add_arguments(arguments)
  string_class.redeclare_feature(r)  -> redefine copy

-> count:INTEGER
  NEW v.create('count',any_class,NIL)
  string_class.add_feature(v)

-> empty:BOOLEAN
  NEW f.create('empty',any_class,boolean_class)
  string_class.add_feature(f)

-> extend (c:CHARACTER)
  NEW arguments.create('c')
  arguments.set_type(character_class)
  NEW r.create('extend',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> fill_blank
  NEW r.create('fill_blank',any_class,NIL)
  string_class.add_feature(r)

-> hash_code:INTEGER
  NEW f.create('hash_code',any_class,integer_class)
  string_class.add_feature(f)

-> head (n:INTEGER)
  NEW arguments.create('n')
  arguments.set_type(integer_class)
  NEW r.create('head',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> index_of (c:CHARACTER; i:INTEGER):INTEGER
  NEW arguments.create('c')
  arguments.set_type(character_class)
  NEW argm.create('i')
  argm.set_type(integer_class)
  arguments.add(argm)
  NEW f.create('index_of',any_class,integer_class)
  f.add_arguments(arguments)
  string_class.add_feature(f)

-> is_equal (other:STRING):BOOLEAN  (inherited from ANY)
  NEW arguments.create('other')
  arguments.set_type(string_class)
  NEW f.create('is_equal',any_class,boolean_class)
  f.add_arguments(arguments)
  string_class.redeclare_feature(f)  -> redefine is_equal

-> item (n:INTEGER):CHARACTER
  NEW arguments.create('n')
  arguments.set_type(integer_class)
  NEW f.create('item',any_class,character_class)
  f.add_arguments(arguments)
  string_class.add_feature(f)

-> item_code (n:INTEGER):INTEGER
  NEW arguments.create('n')
  arguments.set_type(integer_class)
  NEW f.create('item_code',any_class,integer_class)
  f.add_arguments(arguments)
  string_class.add_feature(f)

-> left_adjust
  NEW r.create('left_adjust',any_class,NIL)
  string_class.add_feature(r)

-> precede (c:CHARACTER)
  NEW arguments.create('c')
  arguments.set_type(character_class)
  NEW r.create('precede',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> prepend (s:STRING)
  NEW arguments.create('s')
  arguments.set_type(string_class)
  NEW r.create('prepend',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> put (c:CHARACTER; i:INTEGER)
  NEW arguments.create('c')
  arguments.set_type(character_class)
  NEW argm.create('i')
  argm.set_type(integer_class)
  arguments.add(argm)
  NEW r.create('put',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> remove (i:INTEGER)
  NEW arguments.create('i')
  arguments.set_type(integer_class)
  NEW r.create('remove',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> remove_all_occurrences (c:CHARACTER)
  NEW arguments.create('c')
  arguments.set_type(character_class)
  NEW r.create('remove_all_occurrences',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> right_adjust
  NEW r.create('right_adjust',any_class,NIL)
  string_class.add_feature(r)

-> shrink (s:STRING; n1:INTEGER; n2:INTEGER)
  NEW arguments.create('s')
  arguments.set_type(string_class)
  NEW argm.create('n1')
  argm.set_type(integer_class)
  arguments.add(argm)
  NEW argm.create('n2')
  argm.set_type(integer_class)
  arguments.add(argm)
  NEW r.create('shrink',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> substring (n1:INTEGER; n2:INTEGER):STRING
  NEW arguments.create('n1')
  arguments.set_type(integer_class)
  NEW argm.create('n2')
  argm.set_type(integer_class)
  arguments.add(argm)
  NEW f.create('substring',any_class,string_class)
  f.add_arguments(arguments)
  string_class.add_feature(f)

-> tail (n:INTEGER)
  NEW arguments.create('n')
  arguments.set_type(integer_class)
  NEW r.create('tail',any_class,NIL)
  r.add_arguments(arguments)
  string_class.add_feature(r)

-> to_integer:INTEGER
  NEW f.create('to_integer',any_class,integer_class)
  string_class.add_feature(f)

-> to_lower
  NEW r.create('to_lower',any_class,NIL)
  string_class.add_feature(r)

-> to_upper
  NEW r.create('to_upper',any_class,NIL)
  string_class.add_feature(r)

-> feature {NONE} ""
-> it is a secret feature of STRING
-> is embodies the array of characters
  NEW v.create('',none_class,NIL)
  string_class.add_feature(v)

  string_class.prepare_links()

  table:=[MAKE,{make},{end_make},
    APPEND,{append},{end_append},
    CLEAR,{clear},{end_clear},
    COPY,{string_copy},{end_string_copy},
    IS_EMPTY,{empty},{end_empty},
    EXTEND,{extend},{end_extend},
    FILL_BLANK,{fill_blank},{end_fill_blank},
    HASH_CODE,{hash_code},{end_hash_code},
    HEAD,{head},{end_head},
    INDEX_OF,{index_of},{end_index_of},
    IS_EQUAL,{string_is_equal},{end_string_is_equal},
    ITEM,{item},{end_item},
    ITEM_CODE,{item_code},{end_item_code},
    LEFT_ADJUST,{left_adjust},{end_left_adjust},
    PRECEDE,{precede},{end_precede},
    PREPEND,{prepend},{end_prepend},
    PUT,{put},{end_put},
    REMOVE,{remove},{end_remove},
    REMOVE_ALL_OCCURRENCES,{remove_all_occurrences},{end_remove_all_occurrences},
    RIGHT_ADJUST,{right_adjust},{end_right_adjust},
    SHRINK,{shrink},{end_shrink},
    SUBSTRING,{substring},{end_substring},
    TAIL,{tail},{end_tail},
    TO_INTEGER,{to_integer},{end_to_integer},
    TO_LOWER,{to_lower},{end_to_lower},
    TO_UPPER,{to_upper},{end_to_upper},
    NIL]

  WHILE table[]
    string_class.link_routine(table[]++,lab:=gl.next())
    code.define_global(lab)
    code.putbinary(32+table[]++,-4+table[]++)
  ENDWHILE

ENDPROC

-> ARRAY class
PROC kernel_array()
  NEW array_class.set_name('array',prime.next(),0)
ENDPROC

-> POINTER class
PROC kernel_pointer()
  NEW pointer_class.set_name('pointer',prime.next(),0)
ENDPROC


startup: INCBIN 'startup/startup'
end_startup:

is_equal: INCBIN 'ANY/is_equal'
end_is_equal:

standard_is_equal: INCBIN 'ANY/standard_is_equal'
end_standard_is_equal:

copy: INCBIN 'ANY/copy'
end_copy:

standard_copy: INCBIN 'ANY/standard_copy'
end_standard_copy:

lastchar: INCBIN 'ANY/lastchar'
end_lastchar:

lastint: INCBIN 'ANY/lastint'
end_lastint:

laststring: INCBIN 'ANY/laststring'
end_laststring:

new_line: INCBIN 'ANY/new_line'
end_new_line:

putchar: INCBIN 'ANY/putchar'
end_putchar:

putint: INCBIN 'ANY/putint'
end_putint:

putstring: INCBIN 'ANY/putstring'
end_putstring:

readchar: INCBIN 'ANY/readchar'
end_readchar:

readint: INCBIN 'ANY/readint'
end_readint:

readstring: INCBIN 'ANY/readstring'
end_readstring:

bit_size: INCBIN 'ANY/bit_size'
end_bit_size:


make: INCBIN 'STRING/make'
end_make:

append: INCBIN 'STRING/append'
end_append:

clear: INCBIN 'STRING/clear'
end_clear:

string_copy: INCBIN 'STRING/copy'
end_string_copy:

empty: INCBIN 'STRING/empty'
end_empty:

extend: INCBIN 'STRING/extend'
end_extend:

fill_blank: INCBIN 'STRING/fill_blank'
end_fill_blank:

hash_code: INCBIN 'STRING/hash_code'
end_hash_code:

head: INCBIN 'STRING/head'
end_head:

index_of: INCBIN 'STRING/index'
end_index_of:

string_is_equal: INCBIN 'STRING/is_equal'
end_string_is_equal:

item: INCBIN 'STRING/item'
end_item:

item_code: INCBIN 'STRING/item_code'
end_item_code:

left_adjust: INCBIN 'STRING/left_adjust'
end_left_adjust:

precede: INCBIN 'STRING/precede'
end_precede:

prepend: INCBIN 'STRING/prepend'
end_prepend:

put: INCBIN 'STRING/put'
end_put:

remove: INCBIN 'STRING/remove'
end_remove:

remove_all_occurrences: INCBIN 'STRING/remove_all_occurrences'
end_remove_all_occurrences:

right_adjust: INCBIN 'STRING/right_adjust'
end_right_adjust:

shrink: INCBIN 'STRING/shrink'
end_shrink:

substring: INCBIN 'STRING/substring'
end_substring:

tail: INCBIN 'STRING/tail'
end_tail:

to_integer: INCBIN 'STRING/to_integer'
end_to_integer:

to_lower: INCBIN 'STRING/to_lower'
end_to_lower:

to_upper: INCBIN 'STRING/to_upper'
end_to_upper:

