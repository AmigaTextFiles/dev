OPT MODULE

ENUM B_SET, B_CLR, B_TST, B_MAX

/****** simplebitfield.m/--overview-- **************************************
*
*   PURPOSE
*	To provide a simple bitfield.
*
*   OVERVIEW
*	Implements  the  same  concepts  as  bitfield.m,  but a great many
*	services  are  removed  or simplified, for applications where only
*	the simple get/set/clear functionality of a bitfield is needed.
*
*   SEE ALSO
*	bitfield.m
*
****************************************************************************
*
*
*/

EXPORT OBJECT simplebitfield PRIVATE
  data	-> PTR to data storing the bitfield
  size	-> size (in bytes) of this data
ENDOBJECT


/****** simplebitfield.m/new *******************************************
*
*   NAME
*	simplebitfield.new() -- Constructor.
*
*   SYNOPSIS
*	new(max)
*
*   FUNCTION
*	Initialises  an  instance  of the bitfield class. Raises exception
*	"MEM"  if it cannot allocate enough memory for the required number
*	of bits. All bits are initially cleared.
*
*   INPUT
*	max   - the  maximum integer value that will be represented in the
*	        field. Must be positive. The minimum will be 0.
*
*   SEE ALSO
*	end(), clearfield()
*
****************************************************************************
*
*
*/

EXPORT PROC new(max) OF simplebitfield 
  self.size := Shr(max + 7, 3)
  self.data := NewR(self.size)
ENDPROC

/****** simplebitfield.m/end *******************************************
*
*   NAME
*	simplebitfield.end() -- Destructor.
*
*   SYNOPSIS
*	end()
*
*   FUNCTION
*	Frees resources used by an instance of the bitfield class.
*
*   SEE ALSO
*	new()
*
****************************************************************************
*
*
*/

EXPORT PROC end() OF simplebitfield IS Dispose(self.data)


/****** simplebitfield.m/clearfield *******************************************
*
*   NAME
*	simplebitfield.clearfield() -- clear all bits.
*
*   SYNOPSIS
*	clear()
*
*   FUNCTION
*	Clears all bits in the bitfield to boolean FALSE.
*
****************************************************************************
*
*
*/

EXPORT PROC clearfield() OF simplebitfield
  DEF mem, end
  mem := self.data
  end := mem + self.size
  WHILE mem < end DO mem[]++ := 0
ENDPROC


/****** simplebitfield.m/bit_operations *******************************************
*
*   NAME
*	simplebitfield.set() -- set an individual bit.
*	simplebitfield.clear() -- clear an individual bit.
*	simplebitfield.test() -- test an individual bit.
*
*   SYNOPSIS
*	state := set(bit)
*	state := clear(bit)
*	state := test(bit)
*
*   FUNCTION
*	Will  test,  then perform an operation on an individual bit in the
*	bitfield:
*
*	set()    will set the bit to boolean TRUE.
*	clear()  will clear the bit to boolean FALSE.
*	test()   will perform no altering operation on the bit.
*
*	The  bit  specified  must  not lie outwith the range stored by the
*	bitfield, otherwise innocent data _will_ be corrupted.
*
*   INPUTS
*	bit   - the bit to perform an operation on.
*
*   RESULT
*	state - the  previous  state  of  the bit before the operation was
*	        performed on it, either TRUE or FALSE.
*
****************************************************************************
*
*
*/

EXPORT PROC set(bit)   OF simplebitfield IS bitop(B_SET, self, bit)
EXPORT PROC clear(bit) OF simplebitfield IS bitop(B_CLR, self, bit)
EXPORT PROC test(bit)  OF simplebitfield IS bitop(B_TST, self, bit)

PROC bitop(op, self:PTR TO simplebitfield, bit)
  DEF offset:REG, realbit:REG, data

  data := self.data

  offset := Shr(bit AND -32, 3)
  realbit := bit AND 31

	MOVE.L	data, A0
	ADDA.L	offset, A0
	MOVEQ	#0,D0

  SELECT B_MAX OF op
  CASE B_SET;	BSET.L realbit,(A0)
  CASE B_CLR;	BCLR.L realbit,(A0)
  CASE B_TST;	BTST.L realbit,(A0)
  ENDSELECT

	BEQ.S notset

  RETURN TRUE
notset:
ENDPROC FALSE
