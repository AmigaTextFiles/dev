OPT MODULE
OPT REG=5,
    PREPROCESS

MODULE  'oomodules/object'

-> #define NO_SAFE_STACK 1  -> Uncomment if you don't want to watch the stack.
#define PIVOT(l,u) ((l)+(Div(((u)-(l)),(2))))

/*
 * Exceptions.
 *
 * ASAR_EXCEPTION identifies this module as the origin of the exception.  The
 * remaining constants identify the reason for an exception raised by this
 * module, eg:
 *
 *   Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
 */
EXPORT CONST ASAR_EXCEPTION="AsAr"
EXPORT CONST ASAR_KEYNOTFOUND="key",
             ASAR_STACKOVERFLOW="stak"

CONST DEFAULT_LENGTH=64

EXPORT OBJECT associativeArray OF object
/****** object/associativeArray ******************************

    NAME
        associativeArray of object -- Dynamic, one-dimensional, ordered
            array

    PURPOSE
        Dynamic, one-dimensional, ordered array for storing things whose
        indices fit any of these criteria:  1) are non-numeric (most
        popular index type is a string), 2) are not consecutive and/or
        have big gaps between values (commonly known as sparse arrays),
        3) order cannot be simply determined by builtin E arithmetic
        operators (=<>).  Basically any index type that is not the typical
        positive integer from 0 to MAXLONG.

    ATTRIBUTES
        len:LONG -- current max length of the array

        tail:LONG -- first empty place after the last element

        key:PTR TO LONG -- array stores the keys in ordered sequence

        val:PTR TO LONG -- array stores the values associated with each key
            in array key

    EXCEPTIONS
        ASAR_EXCEPTION identifies this module as the origin of the exception.
        The remaining constants identify the reason for an exception raised
        by this module. These are:

            ASAR_KEYNOTFOUND -- there is no such key in the array

            ASAR_STACKOVERFLOW -- stack overflow. Should not be raised if the
                stack watch is enabled.

    NOTES
        disposeKey(key)
        disposeVal(val)

        These are the default actions for disposal of keys and vals of type
        LONG, which is "do nothing", since they require no special cleanup.
        Override them if key and/or val requires cleanup, (ie, dynamically
        allocated, else your storage WILL NOT be freed when you set() or end()!!!)

        EXAMPLE:

        PROC disposeVal(val) OF myAsAr IS DisposeLink(val)

        Storage for new elements is automatically allocated, increased by 32
        each time the array's limits are exceeded.

        No duplicate keys will ever exist, values are simply overwritten.

        Inserting and removing from the front of the array is SLOW with large
        arrays.  This can't be helped, however it's often worth the sacrifice
        for the efficient lookup of binary searches and the handiness of
        sparse, non-numeric indexed arrays.

        The binary search function uses recursion and has a FreeStack() check.
        4096 should be plenty for most applications since the algorithm is
        amazingly efficient.

        Changing any of the PUBLIC (READ-ONLY) values in the object isn't
        recommended, but hey, who's to stop ya besides the guru? :)

    SEE ALSO
        object

********/
  len:  LONG
  tail: LONG
  key:  PTR TO LONG
  val:  PTR TO LONG
ENDOBJECT


/* Local. */
CONST LT=-1,
      EQ=0,
      GT=1

/*===========================================================================*/
/*=== Con/Destructors =======================================================*/
/*===========================================================================*/

/*
 * original new() contents:
 *    self.end()
 *    self.key:=NewR(Mul(length, 4))
 *    self.val:=NewR(Mul(length, 4))
 *    self.len:=length
 *    self.tail:=0
 *
 * length is the initial number of empty elements in the array
 */

PROC init() OF associativeArray
/****** associativeArray/init ******************************

    NAME
        init() of associativeArray -- Initialization of the object.

    SYNOPSIS
        associativeArray.init()

    FUNCTION
        Initializes the object. The list will initially contain
        DEFAULT_LENGTH elements.

    EXCEPTION
        May raise "MEM".

    SEE ALSO
        associativeArray

********/

  self.key:=NewR(Mul(DEFAULT_LENGTH, 4))
  self.val:=NewR(Mul(DEFAULT_LENGTH, 4))
  self.len:=DEFAULT_LENGTH
  self.tail:=0

ENDPROC


PROC end() OF associativeArray
/****** associativeArray/end ******************************

    NAME
        end() of associativeArray -- Global destructor.

    SYNOPSIS
        associativeArray.end()

    FUNCTION
        Cleans up keys and values using methods disposeKey() and disposeVal(),
        so if your keys and values are dynamically allocated, you must
        override these if you want this method to free them.  NOTE: this
        method was written to be very safe!  It may be called directly at any
        time (even multiple times) to free resources.  'myobj.end()' doesn't
        free the object, only its contents.  Just don't be so silly as to
        call -any- methods after an 'END myobj'. :)

    SEE ALSO
        associativeArray

********/
  DEF i, last, ar:PTR TO LONG
  last:=self.tail-1
  IF ar:=self.key
    FOR i:=0 TO last DO self.disposeKey(ar[i])
    Dispose(ar)
    self.key:=NIL
  ENDIF
  IF ar:=self.val
    FOR i:=0 TO last DO self.disposeVal(ar[i])
    Dispose(ar)
    self.val:=NIL
  ENDIF
  self.tail:=0
ENDPROC

/*===========================================================================*/
/*=== Tell-me-about-myself Methods ==========================================*/
/*===========================================================================*/

PROC disposeKey(key) OF associativeArray IS EMPTY
/****** associativeArray/disposeKey ******************************

    NAME
        disposeKey() of associativeArray -- Call destructor of key.

    SYNOPSIS
        associativeArray.disposeKey(LONG)

        associativeArray.disposeKey(key)

    FUNCTION
        Empty method. Special action to take when calling the destructor for
        an array whose keys are dynamically allocated.  Default for type LONG
        is NO ACTION.

    INPUTS
        key:LONG -- Pointer to key.

    SEE ALSO
        associativeArray, disposeVal()

********/

PROC disposeVal(val) OF associativeArray IS EMPTY
/****** associativeArray/disposeVal ******************************

    NAME
        disposeVal() of associativeArray -- Call destructor of value.

    SYNOPSIS
        associativeArray.disposeVal(LONG)

        associativeArray.disposeVal(val)

    FUNCTION
        Empty method. Special action to take when calling the destructor,
        or overwriting a value for a key that already exists, for an array
        whose keys are dynamically allocated.  Default for type LONG is
        NO ACTION.

    INPUTS
        val:LONG -- Pointer to value.

    SEE ALSO
        associativeArray, disposeKey()

********/

PROC testKey(left, right) OF associativeArray IS IF (right>left) THEN 1 ELSE (right<left)
/****** associativeArray/testKey ******************************

    NAME
        testKey() of associativeArray --

    SYNOPSIS
        associativeArray.testKey(LONG, LONG)

        associativeArray.testKey(left, right)

    FUNCTION
        Ordered comparison of two keys.  Default behavior is for comparison
        of type LONG.  Override this method to change the behavior.

    INPUTS
        left:LONG -- the left operand of an infix expression (left = right)
        right:LONG -- the right operand of an infix expression (left = right)

    RESULT
       -1 if left is less than right
        0 if left equals right
        1 if left is greater than right

    EXAMPLE
       /*
        * simple adaption for strings
        */

        PROC testKey(left, right) OF myAsAr IS OstrCmp(left, right)

    SEE ALSO
        associativeArray

********/

/*===========================================================================*/
/*=== Interactive methods ===================================================*/
/*===========================================================================*/

PROC set(key, val) OF associativeArray
/****** associativeArray/set ******************************

    NAME
        set() of associativeArray --

    SYNOPSIS
        associativeArray.set(LONG, LONG)

        associativeArray.get(key, val)

    FUNCTION
        Overwrites the value associated with key if it already exists, else
        inserts it ordered on key.  Once you set() an element, you
        effectively give it to the array object to hold until you remove() it
        or end() the object.  When in doubt about what is legal, read this
        simple module's source!

        WARNING, key:  calling this method essentially makes the elements of
        array.key READ-ONLY.  DO NOT change them (peeking allowed, but no
        poking:), else risk corrupting the order and breaking binary search.

        WARNING, val:  It IS safe to change (okay to poke:) the elements of
        array.val, eg, change the numeric value or swap out a string, etc,
        just BE SMART ABOUT IT.  If val is dynamically allocated, it is the
        programmer's responsibility to free the swapped-out val.

    INPUTS
        key:LONG -- the key used to index val

        val:LONG -- the value associated with key

    EXCEPTIONS
        May raise "MEM" or throw ASAR_EXCEPTION, ASAR_STACKOVERFLOW.

    SEE ALSO
        associativeArray

********/
  DEF pos=0, rel=-1
  IF self.tail>0
    pos:=binarySearch(self, 0, self.tail-1, key, PIVOT(0,self.tail-1))
    rel:=self.testKey(self.key[pos], key)
  ENDIF
  IF rel=EQ
    self.disposeVal(self.val[pos])
  ELSE
    IF rel=GT THEN INC pos
    makeRoom(self, pos)
    self.tail:=self.tail+1
  ENDIF
  self.key[pos]:=key
  self.val[pos]:=val
ENDPROC

PROC get(searchKey) OF associativeArray
/****** associativeArray/get ******************************

    NAME
        get() of associativeArray --

    SYNOPSIS
        associativeArray.get(LONG)

        associativeArray.get(searchKey)

    FUNCTION
        Perform binary search for matching key and return its associated
        value.

    INPUTS
        searchKey:LONG -- the associated key used to identify a value

    RESULT
        val:LONG -- value associated with key

        pos:LONG -- the position of the element in the array.

    EXCEPTIONS
        Throws ASAR_EXCEPTION, ASAR_KEYNOTFOUND or
        ASAR_EXCEPTION, ASAR_STACKOVERFLOW

    SEE ALSO
        associativeArray

********/
  DEF pos
  pos:=binarySearch(self, 0, self.tail-1, searchKey, PIVOT(0,self.tail-1))
  IF self.testKey(self.key[pos], searchKey) THEN Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
ENDPROC self.val[pos],pos

PROC remove(searchKey) OF associativeArray
/****** associativeArray/remove ******************************

    NAME
        remove() of associativeArray --

    SYNOPSIS
        associativeArray.remove(LONG)

        associativeArray.remove(searchKey)

    FUNCTION
        Remove the key and value from the array and return them.

    INPUTS
        searchKey:LONG -- the key of the element to be removed

    RESULT
        key:LONG -- the key you passed

        val:LONG -- value associated with key

    EXCEPTIONS
        Throws ASAR_EXCEPTION, ASAR_KEYNOTFOUND or
        ASAR_EXCEPTION, ASAR_STACKOVERFLOW

    SEE ALSO
        associativeArray

********/
  DEF pos, last, i, k:PTR TO LONG, v:PTR TO LONG, key, val
  pos:=binarySearch(self, 0, self.tail-1, searchKey, PIVOT(0,self.tail-1))
  IF self.testKey(self.key[pos], searchKey) THEN Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
  last:=self.tail-1
  k:=self.key
  v:=self.val
  key:=k[pos]
  val:=v[pos]
  FOR i:=pos TO last
    k[i]:=k[i+1]
    v[i]:=v[i+1]
  ENDFOR
  k[i]:=0
  v[i]:=0
  self.tail:=self.tail-1
ENDPROC key,val

/*===========================================================================*/
/*=== Private Support Functions =============================================*/
/*===========================================================================*/

PROC binarySearch(ar:PTR TO associativeArray, l, u, key, pivot)
/****** /binarySearch ******************************

    NAME
        binarySearch() --

    SYNOPSIS
        binarySearch(PTR TO associativeArray, LONG, LONG, LONG, LONG)

        binarySearch(ar, l, u, key, pivot)

    FUNCTION
        Recursive binary search of array ar.key.  Returns pos when
        ar.key[pos] equals key, or when l=u.

    INPUTS
        ar:PTR TO associativeArray -- array to work on

        l:LONG -- 

        u:LONG -- 

        key:LONG -- 

        pivot:LONG -- 

    RESULT
        LONG -- index

    EXCEPTION
        Throws ASAR_EXCEPTION, ASAR_STACKOVERFLOW

********/
  DEF rel
#ifndef NO_SAFE_STACK
  IF FreeStack()<1000 THEN Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
#endif
  IF l=u THEN RETURN pivot
  rel:=ar.testKey(ar.key[pivot], key)
  IF rel=GT
    IF l=pivot THEN RETURN pivot+1
    l:=pivot
  ELSEIF rel=LT
    u:=pivot
  ELSE
    RETURN pivot
  ENDIF
ENDPROC binarySearch(ar, l, u, key, PIVOT(l,u))

PROC makeRoom(ar:PTR TO associativeArray, pos) HANDLE
/****** /makeRoom ******************************

    NAME
        makeRoom() -- Make room for an element.

    SYNOPSIS
        makeRoom(PTR TO associativeArray, LONG)

        makeRoom(ar, pos)

    FUNCTION
        Make a blank element at position pos (for an insert operation).
        Expand the length of the array by 32 elements if necessary.

    INPUTS
        ar:PTR TO associativeArray -- array to work on

        pos:LONG -- position to insert an element

********/
  DEF toKey=NIL:PTR TO LONG, toVal=NIL:PTR TO LONG
  DEF fromKey:PTR TO LONG, fromVal:PTR TO LONG, i, last
  fromKey:=ar.key
  fromVal:=ar.val
  /* Expand array if necessary and copy elements BEFORE pos, setup so that
   * upper half of array is copied.  Else setup so that upper half of array
   * is shifted right. **/
  IF ar.tail=ar.len
    toKey:=NewR(ar.len+32*4)
    toVal:=NewR(ar.len+32*4)
    last:=pos-1
    FOR i:=0 TO last
      toKey[i]:=fromKey[i]
      toVal[i]:=fromVal[i]
    ENDFOR
  ELSE
    toKey:=fromKey
    toVal:=fromVal
  ENDIF
  /* Shift upper half of array one position to the right. */
  INC pos
  last:=ar.tail
  FOR i:=last TO pos STEP -1
    toKey[i]:=fromKey[i-1]
    toVal[i]:=fromVal[i-1]
  ENDFOR
  /* Cleanup if the array was expanded. */
  IF toKey<>fromKey
    Dispose(fromKey)
    Dispose(fromVal)
    ar.key:=toKey
    ar.val:=toVal
    ar.len:=ar.len+32
  ENDIF
EXCEPT
  /* The only recovery required is if toVal:=NewR(ar.len+32*4) raises "MEM". */
  IF toKey THEN Dispose(toKey)
  ReThrow()
ENDPROC

PROC asList() OF associativeArray
DEF valueList:PTR TO LONG,
    keyList:PTR TO LONG,
    index,
    numberOfItems

  numberOfItems := self.tail

  valueList := List(numberOfItems)
  keyList := List(numberOfItems)

  IF (valueList AND keyList)

    FOR index := 0 TO numberOfItems-1

      valueList[index] := self.val[index]
      keyList[index] := self.key[index]

->      WriteF('key: \d, value: $\h\n',self.key[index],self.val[index])
->      WriteF('key: \d, value: $\h\n\n',keyList[index],valueList[index])
    ENDFOR
->    WriteF('\n')

    SetList(keyList,numberOfItems)
    SetList(valueList,numberOfItems)
  ENDIF

  RETURN keyList,valueList

ENDPROC
/*EE folds
-1
151 34 247 52 250 33 253 44 260 46 263 58 266 28 
EE folds*/
