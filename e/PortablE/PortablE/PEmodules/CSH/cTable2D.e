/* cTable2D.e 27-09-2012
	This is a safe & easy-to-use implementation of a 2D table, but it is not *quite* as fast as pTable2Dfast.e .
*/
/* Public methods of *cTable2D*:
	new(xsize, ysize)
	get(x, y) OF cTable2D RETURNS value
	set(x, y, value)
	copyTo(target:PTR TO cTable2D)
	infoXsize() RETURNS xsize
	infoYsize() RETURNS ysize
*/
MODULE 'CSH/pTable2Dfast'

PROC main()
	DEF mytable:PTR TO cTable2D, copy:PTR TO cTable2D
	
	->first table
	NEW mytable.new(10, 15)	->table 10 wide, 15 high
	
	mytable.set(9, 14, 999)
	Print('mytable get=\d \n', mytable.get(9, 14))
	
	->second table
	NEW copy.new(10, 15)
	
	mytable.copyTo(copy)
	Print('copy get=\d \n', copy.get(9, 14))
FINALLY
	PrintException()
	
	END mytable, copy
ENDPROC

/*****************************/

CLASS cTable2D PUBLIC
	fast:oTable2Dfast	->this is user-accessible, should they want slightly faster (but less safe) access to the table
ENDCLASS

PROC new(xsize, ysize) OF cTable2D
	table2D_new(self.fast, xsize, ysize)
ENDPROC

PROC end() OF cTable2D
	table2D_end(self.fast)
	
	SUPER self.end()
ENDPROC


PROC get(x, y) OF cTable2D RETURNS value
	IF (x < 0) OR (x >= table2D_infoXsize(self.fast)) THEN Throw("EMU", 'cTable2D.get(); x is outside of the table')
	IF (y < 0) OR (y >= table2D_infoYsize(self.fast)) THEN Throw("EMU", 'cTable2D.get(); y is outside of the table')
	
	value := table2D_get(self.fast, x, y)
ENDPROC

PROC set(x, y, value) OF cTable2D
	IF (x < 0) OR (x >= table2D_infoXsize(self.fast)) THEN Throw("EMU", 'cTable2D.set(); x is outside of the table')
	IF (y < 0) OR (y >= table2D_infoYsize(self.fast)) THEN Throw("EMU", 'cTable2D.set(); y is outside of the table')
	
	table2D_set(self.fast, x, y, value)
ENDPROC

PROC copyTo(target:PTR TO cTable2D) OF cTable2D
	IF table2D_infoXsize(target.fast) <> table2D_infoXsize(self.fast) THEN Throw("EMU", 'cTable2D.copyTo(); target is a different size to this table')
	IF table2D_infoYsize(target.fast) <> table2D_infoYsize(self.fast) THEN Throw("EMU", 'cTable2D.copyTo(); target is a different size to this table')
	
	table2D_copyTo(self.fast, target.fast)
ENDPROC

PROC infoXsize() OF cTable2D RETURNS xsize IS table2D_infoXsize(self.fast)

PROC infoYsize() OF cTable2D RETURNS ysize IS table2D_infoYsize(self.fast)
