-> hashing module

OPT MODULE


->*****
->** WARNING : EXCEPTION HANDLING ADDED
->*****
RAISE	"^C"	IF	CtrlC()		=	TRUE	,
		"OUT"	IF	Fwrite()	=	0


EXPORT CONST HASH_NORMAL   = 211,
             HASH_MEDIUM   = 941,
             HASH_HEAVY    = 3911,
             HASH_HEAVIER  = 16267

EXPORT OBJECT hashtable PRIVATE
  size,entries:PTR TO LONG
ENDOBJECT


->*****
->** WARNING : MODIFIED TO MAKE PUBLIC THE HASHED DATA
->*****
EXPORT OBJECT hashlink
	PRIVATE
		next
	PUBLIC
		data
		len
ENDOBJECT

PROC hashtable(tablesize) OF hashtable		-> constructor
  DEF table:REG PTR TO LONG
  self.entries:=NEW table[tablesize]
  self.size:=tablesize
ENDPROC

/* hashes data, then tries to find entry.
   returns hashlink, hashvalue */

PROC find(data,len) OF hashtable
  DEF e,s:REG
  e:=self.entries
  s:=self.size
  MOVEM.L D3-D7,-(A7)
  MOVE.L data,D6        -> D6=data
  MOVE.L e,A1           -> A1=table
  MOVE.L s,D3           -> D3=tablesize
  MOVEQ  #0,D1          -> D1=hashvalue
  MOVEQ  #0,D0          -> D0=hashlink
  MOVE.L len,D4         -> D4=len
  BEQ.S  done
  MOVE.L D4,D5
  MOVE.L D6,A2
  SUBQ.L #1,D5
loop:
  LSL.W  #4,D1
  ADD.B  (A2)+,D1
  DBRA   D5,loop
  DIVU   D3,D1
  SWAP   D1
  EXT.L  D1
  MOVE.L A1,A2          -> now find entry
  MOVE.L D1,D5
  LSL.L  #2,D5
  ADD.L  D5,A2          -> A2 points to spot in table
findd:
  MOVE.L (A2),D5        -> pick next
  BEQ.S  done
  MOVE.L D5,A2
  CMP.L  8(A2),D4       -> if lengths are unequal, don't bother
  BNE.S  findd
  MOVE.L 4(A2),A0       -> get pointers to both areas
  MOVE.L D6,A3
  MOVE.L D4,D5
  SUBQ.L #1,D5
compare:                -> bytewise compare
  CMPM.B (A0)+,(A3)+
  BNE.S  findd
  DBRA   D5,compare
  MOVE.L A2,D0          -> found entry
done:
  MOVEM.L (A7)+,D3-D7
ENDPROC D0

-> add a new hashlink

PROC add(link:PTR TO hashlink,hashvalue,data,len) OF hashtable
  link.next:=self.entries[hashvalue]
  link.data:=data
  link.len:=len
  self.entries[hashvalue]:=link
ENDPROC


->*****
->** WARNING : USELESS VARIABLES WERE REMOVED TO SPEED UP THINGS
->** WARNING : MODIFICATIONS TO ALLOW EXTRA PARAMETERS TO BE GIVEN !
->*****
PROC iterate( do_proc , extra_parameters = NIL ) OF hashtable
							-> extra_parameters must be a list like [ param1 , param2 , param3 ] or a single parameter

	DEF a : REG , n : REG , p : REG PTR TO hashlink , table : REG PTR TO LONG

	n := self.size
	table := self.entries

	FOR a := 1 TO n

		p := table[]++

		CtrlC()

		WHILE p

			do_proc( p , extra_parameters )
			p := p.next

		ENDWHILE

	ENDFOR

ENDPROC


->*****
->** WARNING : NEW FUNCTIONS TO SAVE THE HASH TABLE
->*****
PROC save( file , save_data ) OF hashtable

	DEF table : PTR TO LONG , p : REG PTR TO hashlink
	DEF i : REG , n : REG
	DEF int_to_write[ 1 ] : REG ARRAY OF INT , int_parts : REG PTR TO CHAR

	n := self.size
	table := self.entries
	int_parts := int_to_write

	FOR i := 1 TO n

		CtrlC()

		IF p := table[]++

			int_to_write[] := i
			FputC( file , int_parts[ 0 ] )
			FputC( file , int_parts[ 1 ] )

			WHILE p

				int_to_write[] := p.len
				FputC( file , int_parts[ 0 ] )
				FputC( file , int_parts[ 1 ] )
				Fwrite( file , p.data , p.len , 1 )
				save_data( p , file )

				p := p.next

			ENDWHILE

			FputC( file , 0 )
			FputC( file , 0 )

		ENDIF

	ENDFOR

	FputC( file , 0 )
	FputC( file , 0 )

ENDPROC


->*****
->** WARNING : NEW FUNCTION TO READ FROM THE MEMORY A SAVED HASH TABLE
->*****
PROC read( hash_table_ptr , read_data ) OF hashtable

	DEF data_ptr : REG PTR TO CHAR
	DEF hash_value : REG , data : REG , data_length : REG
	DEF extra_data : REG PTR TO hashlink

	MOVE.L	hash_table_ptr , data_ptr
	CLR.L	hash_value
	CLR.L	data_length
while1:
	MOVE.L	data_ptr , A0
	MOVE.B	(A0)+ , hash_value
	LSL.W	#8 , hash_value
	MOVE.B	(A0)+ , hash_value
	MOVE.L	A0 , data_ptr
	TST.W	hash_value
	BEQ.B	end_while1
	SUBQ.W	#1 , hash_value
while2:
	MOVE.L	data_ptr , A0
	MOVE.B	(A0)+ , data_length
	LSL.W	#8 , data_length
	MOVE.B	(A0)+ , data_length
	MOVE.L	A0 , data_ptr
	TST.W	data_length
	BEQ.B	end_while2
	MOVE.L	data_ptr , data
	ADD.L	data_length , data_ptr
	data_ptr , extra_data := read_data( data_ptr )
	self.add( extra_data , hash_value , data , data_length )
	BRA.B	while2
end_while2:
	CtrlC()
	BRA.B	while1
end_while1:
	MOVE.L	A0 , D0

ENDPROC D0


->*****
->** WARNING : FOLLOWING FUNCTIONS ARE USELESS SO WERE PUT IN COMMENTS
->*****
/*PROC end() OF hashtable				-> destructor
  DEF p:REG PTR TO LONG
  p:=self.entries
  END p[self.size]
ENDPROC

PROC calc_hash_spread() OF hashtable
  DEF idepth,num
  idepth,num:=self.iterate({calcspread})
ENDPROC IF num THEN !idepth/num ELSE 0.0

PROC calcspread(h,depth) IS depth*/
