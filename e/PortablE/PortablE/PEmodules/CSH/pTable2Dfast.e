/* pTable2Dfast.e 27-09-2012
	This is the fastest possible implementation of a 2D table, but it is a bit uglier to use & less safe than cTable2D.e .
*/
/* Public procedures:
	table2D_new(self:PTR TO oTable2Dfast, xsize, ysize)		->you don't normally need this
	table2D_end(self:PTR TO oTable2Dfast)					->you don't normally need this
	
	table2D_create(xsize, ysize) RETURNS self:PTR TO oTable2Dfast
	table2D_destroy(self:PTR TO oTable2Dfast) RETURNS nil:PTR TO oTable2Dfast
	
	table2D_get(self:PTR TO oTable2Dfast, x, y) RETURNS value
	table2D_set(self:PTR TO oTable2Dfast, x, y, value)
	table2D_copyTo(self:PTR TO oTable2Dfast, target:PTR TO oTable2Dfast)
	table2D_infoXsize(self:PTR TO oTable2Dfast) RETURNS xsize
	table2D_infoYsize(self:PTR TO oTable2Dfast) RETURNS ysize
*/
OPT INLINE
OPT POINTER	->needed for optimised copyTo()

PROC main()
	DEF mytable:PTR TO oTable2Dfast, copy:PTR TO oTable2Dfast
	
	->first table
	mytable := table2D_create(10, 15)	->table 10 wide, 15 high
	
	table2D_set(mytable, 9, 14, 999)
	Print('mytable get=\d \n', table2D_get(mytable, 9, 14))
	
	->second table
	copy := table2D_create(10, 15)
	
	table2D_copyTo(mytable, copy)
	Print('copy get=\d \n', table2D_get(copy, 9, 14))
FINALLY
	PrintException()
	
	mytable := table2D_destroy(mytable)
	copy    := table2D_destroy(copy)
ENDPROC

/*****************************/

OBJECT oTable2Dfast
	table:ARRAY OF VALUE
	xsize
	ysize
ENDOBJECT

PROC table2D_new(self:PTR TO oTable2Dfast, xsize, ysize)
	NEW self.table[xsize * ysize]
	self.xsize := xsize
	self.ysize := ysize
ENDPROC

PROC table2D_end(self:PTR TO oTable2Dfast)
	IF self
		END self.table
	ENDIF
ENDPROC


PROC table2D_create(xsize, ysize) RETURNS self:PTR TO oTable2Dfast
	NEW self
	table2D_new(self, xsize, ysize)
ENDPROC

PROC table2D_destroy(self:PTR TO oTable2Dfast) ->RETURNS nil:PTR TO oTable2Dfast
	table2D_end(self)
	END self
ENDPROC NIL


PROC table2D_get(self:PTR TO oTable2Dfast, x, y) RETURNS value IS self.table[y*self.xsize + x]

PROC table2D_set(self:PTR TO oTable2Dfast, x, y, value) IS (self.table[y*self.xsize + x] := value) BUT EMPTY

PROC table2D_copyTo(self:PTR TO oTable2Dfast, target:PTR TO oTable2Dfast) IS ArrayCopy(target.table !!ARRAY, self.table, self.xsize * self.ysize, SIZEOF VALUE) BUT EMPTY

/* ->unoptimised implementation
PROC table2D_copyTo(self:PTR TO oTable2Dfast, target:PTR TO oTable2Dfast)
	DEF i, max, srcTable:ARRAY OF VALUE, dstTable:ARRAY OF VALUE
	
	srcTable :=   self.table
	dstTable := target.table
	max := self.xsize * self.ysize - 1
	
	FOR i := 0 TO max DO dstTable[i] := srcTable[i]
ENDPROC
*/

PROC table2D_infoXsize(self:PTR TO oTable2Dfast) RETURNS xsize IS self.xsize

PROC table2D_infoYsize(self:PTR TO oTable2Dfast) RETURNS ysize IS self.ysize
