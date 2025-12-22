/*
 * ar.e - yer very basic test suite to make sure numbers go in the right place
 * when inserted/removed in various orders.
 *
 * December 24 1995 Gregor Goldbach
 *   This is the original test program by Barry with these exceptions: I removed
 *   the initial size argument from new() and added NEW end END to each test.
 *
 */

OPT REG=5,
    PREPROCESS

MODULE 'oomodules/list/associativeArray'

#define TEST1
#define TEST2
#define TEST3
#define TEST4
#define TEST5
#define TEST6
#define TEST7
#define TEST8

OBJECT aa OF associativeArray
ENDOBJECT

PROC printAll() OF aa
  DEF i, last
  last:=self.tail-1
  FOR i:=0 TO last DO self.print(i)
  WriteF('\n')
ENDPROC
  /* printAll */

PROC print(i) OF aa
  WriteF('key\d=\d val\d=$\h\n', i, self.key[i], i, self.val[i])
ENDPROC
  /* print */

PROC main() HANDLE
  DEF ar:PTR TO aa, i
  NEW ar.new()
/*---------------------------------------------------------------------------*/
/*--- test order of insert --------------------------------------------------*/
/*---------------------------------------------------------------------------*/
#ifdef TEST1
  WriteF('/*** TEST 1 ***/\n')
  ar.set(1, $1111); ar.printAll()
  ar.set(2, $2222); ar.printAll()
  ar.set(3, $3333); ar.printAll()
  ar.set(4, $4444); ar.printAll()
  ar.set(5, $5555); ar.printAll()
  END ar
#endif
#ifdef TEST2
  NEW ar.new()
  WriteF('/*** TEST 2 ***/\n')
  ar.set(5, $5555); ar.printAll()
  ar.set(4, $4444); ar.printAll()
  ar.set(3, $3333); ar.printAll()
  ar.set(2, $2222); ar.printAll()
  ar.set(1, $1111); ar.printAll()
  END ar
#endif
#ifdef TEST3
  NEW ar.new()
  WriteF('/*** TEST 3 ***/\n')
  ar.set(5, $5555); ar.printAll()
  ar.set(1, $1111); ar.printAll()
  ar.set(4, $4444); ar.printAll()
  ar.set(2, $2222); ar.printAll()
  ar.set(3, $3333); ar.printAll()
  END ar

#endif
#ifdef TEST4
  NEW ar.new()
  WriteF('/*** TEST 4 ***/\n')
  ar.set(3, $3333); ar.printAll()
  ar.set(4, $4444); ar.printAll()
  ar.set(2, $2222); ar.printAll()
  ar.set(5, $5555); ar.printAll()
  ar.set(1, $1111); ar.printAll()
  END ar
#endif
#ifdef TEST5
  NEW ar.new()
  WriteF('/*** TEST 5 ***/\n')
  ar.set(1, $1111); ar.printAll()
  ar.set(5, $5555); ar.printAll()
  ar.set(3, $3333); ar.printAll()
  ar.set(2, $2222); ar.printAll()
  ar.set(4, $4444); ar.printAll()
  END ar
#endif

/*---------------------------------------------------------------------------*/
/*--- test overwrite --------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
#ifdef TEST6
  NEW ar.new()
  WriteF('/*** TEST 6 ***/\n')
  ar.set(1, $1111); ar.printAll()
  ar.set(5, $5555); ar.printAll()
  ar.set(3, $3333); ar.printAll()
  ar.set(4, $4444); ar.printAll()
  ar.set(2, $2222); ar.printAll()

  ar.set(1, $5555); ar.printAll()
  ar.set(2, $4444); ar.printAll()
  ar.set(3, $3333); ar.printAll()
  ar.set(4, $2222); ar.printAll()
  ar.set(5, $1111); ar.printAll()
  END ar
#endif
/*---------------------------------------------------------------------------*/
/*--- test get() and remove() -----------------------------------------------*/
/*---------------------------------------------------------------------------*/
#ifdef TEST7
  NEW ar.new()
  WriteF('/*** TEST 7 ***/\n')
  ar.set(3, $3333); ar.printAll()
  ar.set(2, $2222); ar.printAll()
  ar.set(4, $4444); ar.printAll()
  ar.set(1, $1111); ar.printAll()
  ar.set(5, $5555); ar.printAll()

  FOR i:=1 TO 5 DO WriteF('get(\d)=$\h\n', i, ar.get(i))
  WriteF('\n')

  ar.remove(3); ar.printAll()
  ar.remove(1); ar.printAll()
  ar.remove(5); ar.printAll()
  ar.remove(4); ar.printAll()
  ar.remove(2); ar.printAll()
  END ar
#endif
#ifdef TEST8
  NEW ar.new()
  WriteF('/*** TEST 8 (should raise exception) ***/\n')
  ar.remove("blah") ->should raise exception
#endif
EXCEPT DO
  IF exception THEN WriteF('BOOM!\n')
  CleanUp()
ENDPROC
