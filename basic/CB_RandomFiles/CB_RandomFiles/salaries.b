{******* Salaries.b *******

© 1996 by FR-SoftWorks
  Version: 2.00
  Revision: 16 Sep 1996

This is an example of how to use the functions provided with CB_RandomFiles.h.

A simple file containing the salaries of our employees is created.

In AIDE, use the command "Program/Run in Shell..." to test the program.

*** Include header file ***
}
#include <CB_RandomFiles.h>

{*** Set up record structure ***

We use a structure to hold the record contents. Notice that the string length
*must* be stated using the size option of the string command because every
record must be of the same length for random access.

Chip Memory is allocated for the structure, because the "dos.library" functions
the random access functions rely on require this.
}
STRUCT RR
  STRING Name$ SIZE 40
  SINGLE Salary
END STRUCT

DECLARE STRUCT RR *RRecord

RRecord = ALLOC(SIZEOF(RR),0)

{*** Open random access file ***

Remember that RRecord holds the address of the structure, so we do not have
to use varptr. We use sizeof() to get the length of our record.
}
OpenRandomFile(1,"Employees.SAL",RRecord,SIZEOF(RRecord))

{*** Create records ***

We create 3 sample records (0 .. 2). Notice that the records have to be created
in sequential order and that 0 (zero) is the first one.
}
FOR currentrecord& = 0 TO 2
  PRINT "*** Record";currentrecord&;"***"
  INPUT "Employee: ", a$
  INPUT "Salary:   ",b
  RRecord->Name$=LEFT$(a$,40)
  RRecord->Salary=b
  PutRandomRecord(1,currentrecord&)
NEXT currentrecord&
PRINT

{*** Read records in sequential order ***

We read all three records just to show that they really exist.
}
FOR currentrecord& = 2 TO 0 STEP -1
  PRINT "*** Record";currentrecord&;"***"
  GetRandomRecord(1,currentrecord&)
  PRINT "Employee: ";RRecord->Name$
  PRINT "Salary:   ";RRecord->Salary
NEXT currentrecord&
PRINT

{*** Read a single record ***

The second record (#1) is read using random access.
}
currentrecord& = 1
PRINT "*** Record";currentrecord&;"***"
GetRandomRecord(1,currentrecord&)
PRINT "Employee: ";RRecord->Name$
PRINT "Salary:   ";RRecord->Salary

{*** Close files and libraries ***}

CloseRandomFile(1)

LIBRARY CLOSE

{End of Salaries.b}
