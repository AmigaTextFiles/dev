/*==========================================================================+
| filter_average.e                                                          |
| simple moving average filter                                              |
| y(0) = y(-1) + x(0)/m - x(1-m)/m
+--------------------------------------------------------------------------*/

OPT MODULE

MODULE '*filter_design'

/*-------------------------------------------------------------------------*/

EXPORT OBJECT average OF filterdesign
	length
ENDOBJECT

PROC average(length) OF average
	self.filterdesign()
	self.length := length
ENDPROC

PROC m()  OF average IS self.length - 1
PROC n()  OF average IS 1
PROC a(i) OF average
	IF i = 0                 THEN RETURN !  1.0 / (self.length !)
	IF i = (self.length - 1) THEN RETURN ! -1.0 / (self.length !)
ENDPROC 0.0
PROC b(i) OF average IS IF i = 1 THEN 1.0 ELSE 0.0

/*--------------------------------------------------------------------------+
| END: filter_average.e                                                     |
+==========================================================================*/
