/*
 * associativeArray.m
 *
 * DESCRIPTION:
 *   Dynamic, one-dimensional, ordered array for storing things whose indices
 *   fit any of these criteria:  1) are non-numeric (most popular index type is
 *   a string), 2) are not consecutive and/or have big gaps between values
 *   (commonly known as sparse arrays), 3) order cannot be simply determined by
 *   builtin E arithmetic operators (=<>).  Basically any index type that is not
 *   the typical positive integer from 0 to MAXLONG.
 *
 * METHODS:
 *   new(len)
 *     Constructor.
 *       NOTE: this method was written to be very safe!  It may be called to
 *       reinitialize the object at anytime since it calls method end() to free
 *       resources before initialization.
 *      Arguments:
 *       len, the number of elements to initially allocate
 *      Exceptions:
 *       Raise("MEM")
 *   end()
 *     Destructor.
 *       Cleans up keys and values using methods disposeKey() and disposeVal(),
 *       so if your keys and values are dynamically allocated, you must override
 *       these if you want this method to free them.  NOTE: this method was
 *       written to be very safe!  It may be called directly at any time (even
 *       multiple times) to free resources.  'myobj.end()' doesn't free the
 *       object, only its contents.  Just don't be so silly as to call -any-
 *       methods after an 'END myobj'. :)
 *   disposeKey(key)
 *     Empty method.
 *       Special action to take when calling the destructor for an array whose
 *       keys are dynamically allocated.  Default for type LONG is NO ACTION.
 *      Arguments:
 *       key, pointer to a key
 *   disposeVal(val)
 *     Empty method.
 *       Special action to take when calling the destructor, or overwriting a
 *       value for a key that already exists, for an array whose keys are
 *       dynamically allocated.  Default for type LONG is NO ACTION.
 *      Arguments:
 *       val, pointer to a value
 *   testKey(this, that)
 *     Method.
 *       Ordered comparison of two keys.  Default behavior is for comparison
 *       of type LONG.  Override this method to change the behavior.
 *      Arguments:
 *       this, the left operand of an infix expression (this = that)
 *       that, the right operand of an infix expression (this < that)
 *      Return:
 *       -1 if this is less than that
 *        0 if this equals that
 *        1 if this is greater than that
 *   set(key, val)
 *     Method.
 *       Overwrites the value associated with key if it already exists, else
 *       inserts it ordered on key.  Once you set() an element, you effectively
 *       give it to the array object to hold until you remove() it or end() the
 *       object.  When in doubt about what is legal, read this simple module's
 *       source!
 *       WARNING, key:  calling this method essentially makes the elements of
 *       array.key READ-ONLY.  DO NOT change them (peeking allowed, but no
 *       poking:), else risk corrupting the order and breaking binary search.
 *       WARNING, val:  It IS safe to change (okay to poke:) the elements of
 *       array.val, eg, change the numeric value or swap out a string, etc, just
 *       BE SMART ABOUT IT.  If val is dynamically allocated, it is the
 *       programmer's responsibility to free the swapped-out val.
 *      Arguments:
 *       key, the key used to index val
 *       val, the value associated with key
 *      Exceptions:
 *       Raise("MEM")
 *       Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
 *   get(searchKey)
 *     Method.
 *       Perform binary search for matching key and return its associated value.
 *      Arguments:
 *       searchKey, the associated key used to identify a value
 *      Return:
 *       val,pos
 *      Exceptions:
 *       Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
 *       Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
 *   remove(searchKey)
 *     Method.
 *       Remove the key and value from the array and return them.
 *      Arguments:
 *       searchKey, the key of the element to be removed
 *      Return:
 *       key,val
 *      Exceptions:
 *       Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
 *       Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
 *
 *  PUBLIC DATA:
 *   len  - current max length of the array
 *   tail - first empty place after the last element
 *   key  - array stores the keys in ordered sequence
 *   val  - array stores the values associated with each key in array key
 *
 *  NOTES:
 *   - Storage for new elements is automatically allocated, increased by 32 each
 *     time the array's limits are exceeded.
 *   - No duplicate keys will ever exist, values are simply overwritten.
 *   - Inserting and removing from the front of the array is SLOW with large
 *     arrays.  This can't be helped, however it's often worth the sacrifice for
 *     the efficient lookup of binary searches and the handiness of sparse,
 *     non-numeric indexed arrays.
 *   - The binary search function uses recursion and has a FreeStack() check.
 *     4096 should be plenty for most applications since the algorithm is
 *     amazingly efficient.
 *   - Changing any of the PUBLIC (READ-ONLY) values in the object isn't
 *     recommended, but hey, who's to stop ya besides the guru? :)
 */

OPT MODULE
OPT REG=5,
    PREPROCESS

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

EXPORT OBJECT associativeArray
/* DON'T CHANGE THESE, THEY'RE READ-ONLY!!! */
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
 * new(len)
 *
 * len is the initial number of empty elements in the array.
 *
 * Raise("MEM")
 */
PROC new(len) OF associativeArray
  self.end()
  self.key:=NewR(Mul(len, 4))
  self.val:=NewR(Mul(len, 4))
  self.len:=len
  self.tail:=0
ENDPROC
  /* new */

/*
 * end()
 *
 * Cleanup elements and cleanup self.
 */
PROC end() OF associativeArray
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
  /* end */


/*===========================================================================*/
/*=== Tell-me-about-myself Methods ==========================================*/
/*===========================================================================*/

/*
 * disposeKey(key)
 * disposeVal(val)
 *
 * These are the default actions for disposal of keys and vals of type LONG,
 * which is "do nothing", since they require no special cleanup.  Override
 * them if key and/or val requires cleanup, (ie, dynamically allocated,
 * else your storage WILL NOT be freed when you set() or end()!!!)  eg:
 *
 *   PROC disposeVal(val) OF myAsAr IS DisposeLink(val)
 */
PROC disposeKey(key) OF associativeArray IS EMPTY
PROC disposeVal(val) OF associativeArray IS EMPTY

/*
 * testKey(left, right) ... RETURN order
 *
 * This is the default comparison method for keys of type LONG.  You should
 * override it if you need string comparison, or any other special kind you
 * might require.  Your method MUST return one of these ordered values
 *
 *   (right > left) yields  1
 *   (right = left) yields  0
 *   (right < left) yields -1
 *
 * for example:
 *
 *   PROC testKey(left, right) OF myAsAr IS OstrCmp(left, right)
 *
 */
PROC testKey(left, right) OF associativeArray IS IF (right>left) THEN 1 ELSE (right<left)


/*===========================================================================*/
/*=== Interactive methods ===================================================*/
/*===========================================================================*/

/*
 * set(key, val)
 *
 * Place val into the array, ordered on key.
 *
 * Raise("MEM")
 * Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
 */
PROC set(key, val) OF associativeArray
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
  /* set */


/*
 * get(searchKey) ... RETURN val
 *
 * Get the value (and index) associated with searchKey.
 *
 * Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
 * Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
 */
PROC get(searchKey) OF associativeArray
  DEF pos
  pos:=binarySearch(self, 0, self.tail-1, searchKey, PIVOT(0,self.tail-1))
  IF self.testKey(self.key[pos], searchKey) THEN Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
ENDPROC self.val[pos],pos
  /* get */

/*
 * remove(searchKey) ... RETURN key,val
 *
 * Remove the key and value associated with searchKey and return them.
 *
 * Throw(ASAR_EXCEPTION, ASAR_KEYNOTFOUND)
 * Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
 */
PROC remove(searchKey) OF associativeArray
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
  /* remove */


/*===========================================================================*/
/*=== Private Support Functions =============================================*/
/*===========================================================================*/

/*
 * binarySearch(ar:PTR TO associativeArray, l, u, key) ... RETURN pos
 *
 * Recursive binary search of array ar.key.  Returns pos when ar.key[pos]
 * equals key, or when l=u.
 *
 * Throw(ASAR_EXCEPTION, ASAR_STACKOVERFLOW)
 */
PROC binarySearch(ar:PTR TO associativeArray, l, u, key, pivot)
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
  /* binarySearch */

/*
 * makeRoom(ar:PTR TO associativeArray, pos)
 *
 * Make a blank element at position pos (for an insert operation).  Expand the
 * length of the array by 32 elements if necessary.
 * Raise("MEM")
 */
PROC makeRoom(ar:PTR TO associativeArray, pos) HANDLE
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
  /* makeRoom */
