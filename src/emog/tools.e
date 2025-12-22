/* -- ----------------------------------------------------- -- *
 * -- Name........: tools.e                                 -- *
 * -- Description.: Simple collection of helpful functions. -- *
 * -- Author......: Daniel Kasmeroglu                       -- *
 * -- E-Mail......: raptor@cs.tu-berlin.de                  -- *
 * --               daniel.kasmeroglu@daimlerchrysler.com   -- *
 * -- Date........: 05-Mar-00                               -- *
 * -- Version.....: 0.1                                     -- *
 * -- ----------------------------------------------------- -- */

/* -- ----------------------------------------------------- -- *
 * --                         Options                       -- *
 * -- ----------------------------------------------------- -- */

OPT MODULE
OPT EXPORT


/* -- ----------------------------------------------------- -- *
 * --                       Declarations                    -- *
 * -- ----------------------------------------------------- -- */

DEF dec_state


/* -- ----------------------------------------------------- -- *
 * --                         Functions                     -- *
 * -- ----------------------------------------------------- -- */

->> PROC getTempFile
->
-> SPEC   getTempFile( buffer )
-> DESC   Fills the supplied buffer with a path
->        that may be used for temporarily access.
-> PRE    {buffer} : A valid path of something around 15 characters.
-> POST   true
->
PROC getTempFile( get_file )
DEF get_temp [ 20 ] : STRING
DEF get_num

  get_num := 1
  REPEAT
    StringF( get_temp, 't:tfile.\d', get_num )
    get_num := get_num + 1
  UNTIL FileLength( get_temp ) < 1

  AstrCopy( get_file, get_temp, 20 )

ENDPROC
-><

->> PROC writeFile
->
-> SPEC   writeFile( destpath, buffer, bufflen ) = noerr
-> DESC   Stores the contents of a buffer under a specified path.
-> PRE    {destpath} : Path where to store the contents. This function
->                     doesn't check if there is already a file present.
->        {buffer}   : Valid buffer containing our data.
->        {bufflen}  : Length of the buffer or length of the data to store.
-> POST   noerr <=> FileLength( {destpath} ) == {bufflen}
->
PROC writeFile( wri_dest, wri_mem, wri_len )
DEF wri_handle,wri_written

  wri_handle  := Open( wri_dest, NEWFILE )
  IF wri_handle = NIL THEN RETURN FALSE

  wri_written := Write( wri_handle, wri_mem, wri_len )
  Close( wri_handle )

ENDPROC wri_written = wri_len
-><

->> PROC displayGauge
->
-> SPEC   displayGauge()
-> DESC   Stupid function to realise a simple gauge. For bigger
->        files it lets the user know that the app is running and not dead.
-> PRE    true
-> POST   true
->
PROC displayGauge()

  WriteF( '\c', 13 )

  SELECT dec_state
  CASE  00 ; WriteF( '|'  )
  CASE  30 ; WriteF( '/'  )
  CASE  60 ; WriteF( '-'  )
  CASE  90 ; WriteF( '\\' )
  CASE 120 ; WriteF( '|'  )
  CASE 150 ; WriteF( '/'  )
  CASE 180 ; WriteF( '-'  )
  CASE 210 ; WriteF( '\\' )
  ENDSELECT

  dec_state := dec_state + 1

  IF dec_state = 240
    dec_state := 0
  ENDIF

ENDPROC
-><



