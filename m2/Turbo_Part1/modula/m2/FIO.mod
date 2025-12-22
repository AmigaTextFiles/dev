IMPLEMENTATION MODULE FIO ;

FROM SYSTEM IMPORT ADDRESS, ADR ;
IMPORT StdIO, Storage ;

MODULE CISupport ;

  IMPORT StdIO, ADDRESS, ADR ;

  EXPORT
    fseek, ftell, fopen, fclose, fread, fwrite, setvbuf,
    getc, ungetc, putc, fwriteinteger, freadreal,fflush,
    fwritereal, freadlongreal,fwritelongreal, freadstr,
    formatreal, formatlongreal ;

  CONST
    tableSize = StdIO.FOPEN_MAX ;

  VAR
    stdFiles : ARRAY [0..tableSize-1] OF StdIO.FILEPtr ;

  PROCEDURE fopen( VAR name, mode : ARRAY OF CHAR ) : LONGINT ;

    PROCEDURE firstnull( ) : LONGINT ;
      VAR i : LONGINT ;
    BEGIN
      i := 3 ;
      WHILE i < tableSize DO
        IF stdFiles[i] = NIL THEN RETURN i END ;
        INC( i )
      END ;
      HALT
    END firstnull ;

  VAR
    f : StdIO.FILEPtr ;
    i : LONGINT ;

  BEGIN
    f := StdIO.fopen( name, mode );
    IF f # NIL THEN i := firstnull( ) ; stdFiles[i] := f ELSE i := -1 END ;
    RETURN i
  END fopen ;

  PROCEDURE setvbuf(  file  : LONGINT ;
  		       buf  : ADDRESS ;
  		       mode : LONGINT ;
  		       size : LONGINT ) : BOOLEAN ;
  BEGIN RETURN StdIO.setvbuf( stdFiles[file], buf, mode, size ) = 0
  END setvbuf ;

  PROCEDURE fclose( file : LONGINT ) ;
  BEGIN StdIO.fclose( stdFiles[file] ) ; stdFiles[file] := NIL
  END fclose ;

  PROCEDURE fflush( file : LONGINT ) ;
  BEGIN StdIO.fflush( stdFiles[file] )
  END fflush ;

  PROCEDURE fseek( file, offset, pos : LONGINT ) : BOOLEAN ;
  BEGIN RETURN StdIO.fseek( stdFiles[file], pos, offset ) = 0
  END fseek ;

  PROCEDURE ftell( file : LONGINT ) : LONGINT ;
  BEGIN RETURN StdIO.ftell( stdFiles[file] )
  END ftell ;

  PROCEDURE fread( file , n : LONGINT ; buf : ADDRESS ) : LONGINT ;
  BEGIN RETURN StdIO.fread( buf, 1, n, stdFiles[file] )
  END fread ;

  PROCEDURE fwrite( file , n : LONGINT ; buf : ADDRESS ) : LONGINT ;
  BEGIN RETURN StdIO.fwrite( buf, 1, n, stdFiles[file] )
  END fwrite ;

  PROCEDURE getc( file : LONGINT ) : LONGINT ;
  BEGIN RETURN StdIO.fgetc( stdFiles[file] )
  END getc ;

  PROCEDURE ungetc( file : LONGINT ; c : LONGINT ) ;
  BEGIN StdIO.ungetc( c, stdFiles[file] )
  END ungetc ;

  PROCEDURE putc( file : LONGINT ; c : LONGINT ) : BOOLEAN ;
  BEGIN RETURN StdIO.fputc( c, stdFiles[file] ) # StdIO.EOF
  END putc ;

  PROCEDURE freadinteger( file : LONGINT ; VAR i : LONGINT ) : BOOLEAN ;
  BEGIN RETURN StdIO.fscanf( stdFiles[file], "%d", i ) = 1
  END freadinteger ;

  PROCEDURE fwriteinteger( file : LONGINT ; i : LONGINT ) : BOOLEAN ;
  BEGIN RETURN StdIO.fprintf( stdFiles[file], "%d", i ) # 0
  END fwriteinteger ;

  PROCEDURE freadreal( file : LONGINT ; VAR r : REAL ) : BOOLEAN ;
  BEGIN RETURN StdIO.fscanf( stdFiles[file], "%f", ADR( r ) ) = 1
  END freadreal ;

  PROCEDURE freadlongreal( file : LONGINT ; VAR r : LONGREAL ) : BOOLEAN ;
  BEGIN RETURN StdIO.fscanf( stdFiles[file], "%lf", ADR( r ) ) = 1
  END freadlongreal ;

  PROCEDURE fwritereal( file : LONGINT ; r : REAL ) : BOOLEAN ;
  BEGIN RETURN StdIO.fprintf( stdFiles[file], "%g", r ) # 0
  END fwritereal ;

  PROCEDURE fwritelongreal( file : LONGINT ; r : LONGREAL ) : BOOLEAN ;
  BEGIN RETURN StdIO.fprintf( stdFiles[file], "%g", r ) # 0
  END fwritelongreal ;

  PROCEDURE formatreal( file: LONGINT ; r: REAL ; w,d : LONGINT ) : BOOLEAN ;
    VAR format : ARRAY [0..29] OF CHAR ;
  BEGIN
    StdIO.sprintf( format, "%%%d.%df", w, d ) ;
    RETURN StdIO.fprintf( stdFiles[file], format, r ) # 0
  END formatreal ;

  PROCEDURE formatlongreal( file : LONGINT ;
  			         r : LONGREAL ;
  			      w, d : LONGINT ) : BOOLEAN ;
    VAR format : ARRAY [0..29] OF CHAR ;
  BEGIN
    StdIO.sprintf( format, "%%%d.%dlf", w, d );
    RETURN StdIO.fprintf( stdFiles[file], format, r ) # 0
  END formatlongreal ;

  PROCEDURE freadstr( file : LONGINT ;
  		     VAR s : ARRAY OF CHAR ;
  		         m : LONGINT ) : BOOLEAN ;
    VAR i , c : LONGINT ; ch : CHAR ;
  BEGIN
    FOR i := 0 TO m DO s[i] := 0C END ;
    i := 0 ;
    LOOP
      c := StdIO.fgetc( stdFiles[file] ) ;
      IF c = StdIO.EOF THEN RETURN FALSE END ;
      ch := CHR( c ) ;
      IF (ch = ' ') OR ( ch = '\t') OR (ch = '\n') THEN EXIT END ;
      s[i] := ch ;
      INC( i ) ;
      IF i>m THEN RETURN TRUE END
    END ;
    StdIO.ungetc( c, stdFiles[file] ) ;
    RETURN TRUE
  END freadstr ;

BEGIN stdFiles := [StdIO.stdin, StdIO.stdout, StdIO.stderr]
END CISupport ;

CONST
  Tab      = "\t" ;
  NewLine  = "\n" ;
  Space    = " "  ;

  HitEOF   =  -1 ;

TYPE
  (* File is the index into files array *)

  FileType = ( none, reading, writing, random ) ;
  FileSet  = SET OF FileType ;

  FCB      = RECORD
    type     : FileType ;
    ioresult : Status   ;
    name     : POINTER TO ARRAY [0..1024] OF CHAR ;  (* Alloced less *)
    nameSize : LONGINT  ; (* Number of bytes alloced to name *)
    filedes  : LONGINT  ; (* file descriptor		     *)
    pad      : INTEGER  ; (* Makes record size a power of 2  *)
  END ;

  FileArray = ARRAY [0..MaxFiles] OF FCB;

(* NOTE: element
 *   0 is for open's which fail
 *       1 is stdin
 *       2 is stdout
 *       3 is stderr
 *)

VAR
  files    : FileArray ;
  modename : ARRAY FileType OF ARRAY [0..30] OF CHAR ;

(* -------------------- Private procedures section ------------------- *)

PROCEDURE len( s : (*@N*) ARRAY OF CHAR ) : LONGINT ;
  VAR i : LONGINT ;
BEGIN
  FOR i := 0 TO HIGH( s ) DO
    IF s[i] = 0C THEN RETURN i END
  END ;
  RETURN 1+HIGH(s)
END len ;

PROCEDURE errstr( s : (*@N*) ARRAY OF CHAR ) ;
BEGIN StdIO.fprintf( StdIO.stderr, "%s", s )
END errstr ;

PROCEDURE errline;
BEGIN StdIO.fprintf( StdIO.stderr, "\n" )
END errline ;

PROCEDURE findfree() : File;
(* finds the first free position in the file array *)
  VAR i : File ;
BEGIN
  FOR i := StdErr+1 TO MaxFiles DO
    IF files[i].type = none THEN RETURN i END
  END;
  RETURN 0
END findfree ;

PROCEDURE openfile( fname , fmode : (*@N*) ARRAY OF CHAR ;
    		    ftype   : FileType ;
		    badstat : Status ) : File ;

(* open a file: called by all three OpenTo procedures *)

  VAR
    filepos : File ;
    i       : LONGINT ;
    c       : LONGINT ;

BEGIN
  filepos := findfree( ) ;

  i := len( fname ) ;
  files[filepos].nameSize := i+1 ; (* Allocate one extra char for 0C *)
  Storage.ALLOCATE( files[filepos].name , i+1 ) ;
  FOR c := 0 TO i-1 DO files[filepos].name^[c] := fname[c] END ;
  files[filepos].name^[i] := 0C ;

  IF filepos = 0 THEN
    files[filepos].ioresult := TooManyOpen
  ELSE
    i := fopen( files[filepos].name^ , fmode ) ;
    IF i = -1 THEN
      files[filepos].ioresult := badstat ;
      files[0] := files[filepos] ;
      filepos := 0
    ELSE
      files[filepos].type := ftype ;
      files[filepos].filedes := i ;
      files[filepos].ioresult := NoError
    END
  END ;
  RETURN filepos
END openfile ;

PROCEDURE checkopenfor( procname : (*@N*) ARRAY OF CHAR ;
		            file  : File ;
		            modes : FileSet ) ;
  VAR openmode : FileType ;
BEGIN
  (* check that the file is open, first *)
  IF ( file < 0 ) OR ( file > MaxFiles ) OR ( files[file].type = none ) THEN
    errstr( "FIO." ) ;
    errstr( procname ) ;
    errstr(" : File has not been opened !!") ;
    errline( ) ;
    HALT ;
  END ;
  openmode := files[file].type ;
  IF NOT ( openmode IN modes ) THEN
    errstr( "FIO." ) ;
    errstr( procname ) ;
    errstr(" : file '") ;
    errstr( files[file].name^ ) ;
    errstr("' ") ;
    errstr("was opened for ") ;
    errstr( modename[openmode] ) ;
    errline( ) ;
    HALT ;
  END
END checkopenfor ;

PROCEDURE prematureEOF( procname : (*@N*) ARRAY OF CHAR ; file : File ) ;
BEGIN
  errstr( "FIO." ) ;
  errstr( procname ) ;
  errstr(" : premature EOF occurred in file '") ;
  errstr( files[file].name^ ) ;
  errstr("' ") ;
  errline( ) ;
  HALT ;
END prematureEOF ;

(*----------------------------------------------------------------------------*)

PROCEDURE IOStatus( file : File ) : Status;
BEGIN
  IF ( file < 0 ) OR ( file > MaxFiles ) THEN file := 0 END ;
  RETURN files[file].ioresult
END IOStatus ;

PROCEDURE ReportError( file : File ) ;
BEGIN
  IF ( file < 0 ) OR ( file > MaxFiles ) THEN file := 0 END ;
  CASE files[file].ioresult OF
  |  NoError:
     RETURN        (* only way of returning *)
  | UnInitialized :
    errstr("FIO: File being used when not open - unitialized")
  | CantOpenFile :
    errstr("FIO: File '") ;
    errstr( files[file].name^ ) ;
    errstr("' does not exist, or cannot be opened")
  | CantCreateFile :
    errstr("FIO: File '") ;
    errstr( files[file].name^ ) ;
    errstr("' cannot be created")
  | TooManyOpen :
    errstr("FIO: Can't open file '") ;
    errstr( files[file].name^ ) ;
    errstr("' too many files open already")
  | OpFailed :
    errstr("FIO: Operation on file '") ;
    errstr( files[file].name^ ) ;
    errstr("' failed")
  END ;
  errline( ) ;
  HALT ;
END ReportError ;

PROCEDURE OpenToRead( fname : (*@N*) ARRAY OF CHAR ) : File ;
BEGIN RETURN openfile( fname, "r ", reading, CantOpenFile )
END OpenToRead ;

PROCEDURE OpenToWrite( fname : (*@N*) ARRAY OF CHAR ) : File ;
BEGIN RETURN openfile( fname, "w ", writing, CantCreateFile )
END OpenToWrite ;

PROCEDURE OpenForRandom( fname :(*@N*) ARRAY OF CHAR ; create: BOOLEAN ): File ;
BEGIN
  IF create THEN RETURN openfile( fname, "w+", random, CantCreateFile )
  ELSE RETURN openfile( fname, "r+", random, CantOpenFile )
  END
END OpenForRandom ;


PROCEDURE SetBuffer( file : File ;
		     mode : BufferingMode ;
		     size : LONGINT ;
		     buff : ADDRESS ) ;
  VAR
    stdMode : LONGINT ;
BEGIN
  checkopenfor("SetBuffer", file, FileSet{reading,writing,random} ) ;
  CASE mode OF
  | NoBuffer   : stdMode := StdIO._IONBF
  | LineBuffer : stdMode := StdIO._IOLBF
  | FullBuffer : stdMode := StdIO._IOFBF
  END ;
  IF setvbuf( files[file].filedes, buff, stdMode, size ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END SetBuffer ;

PROCEDURE Close( file : File ) ;
BEGIN
  (* check that the file is open, first *)
  IF ( file<0 ) OR ( file>MaxFiles ) OR ( files[file].type = none ) THEN
    ReportError( file )
  END ;
  (* now close it *)
  fclose( files[file].filedes ) ;
  files[file].type     := none ;
  files[file].ioresult := UnInitialized ;
  IF file > 2 THEN
    Storage.DEALLOCATE( files[file].name , files[file].nameSize )
  END
END Close ;

PROCEDURE FlushFile( f : File ) ;
BEGIN
  checkopenfor("FlushFile", f, FileSet{reading,writing,random} ) ;
  fflush( files[f].filedes )
END FlushFile ;

PROCEDURE EOF( file : File ) : BOOLEAN ;
  VAR
    i : LONGINT ;
    f : LONGINT ;
BEGIN
  checkopenfor("EOF", file, FileSet{reading,random} ) ;
  f := files[file].filedes ;
  i := getc( f ) ;
  ungetc( f, i ) ;
  files[file].ioresult := NoError ;
  RETURN i = HitEOF
END EOF ;

PROCEDURE EOLN( file : File ) : BOOLEAN ;
  VAR
    i : LONGINT ;
    f : LONGINT ;
BEGIN
  checkopenfor("EOLN", file, FileSet{reading,random} ) ;
  f := files[file].filedes ;
  i := getc( f ) ;
  ungetc( f, i ) ;
  files[file].ioresult := NoError ;
  RETURN i = ORD( NewLineCh ) ;
END EOLN ;

PROCEDURE SetPosition( file : File; pos : LONGINT ; end : EndType ) ;
  VAR
    val : LONGINT ;
BEGIN
  IF ( pos = 0 ) & ( end = FromStart ) THEN
    checkopenfor("SetPosition", file, FileSet{reading,random} )
  ELSE checkopenfor("SetPosition", file, FileSet{random} )
  END ;
  CASE end OF
  |  FromStart   : val := 0
  |  FromCurrent : val := 1
  |  AddToEnd    : val := 2
  END ;
  IF fseek( files[file].filedes, pos, val ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END SetPosition ;

PROCEDURE FindPosition( file : File ) : LONGINT ;
BEGIN
  checkopenfor("FindPosition", file, FileSet{random} ) ;
  files[file].ioresult := NoError ;
  RETURN ftell( files[file].filedes )
END FindPosition ;

PROCEDURE Rewind( file : File ) ;
BEGIN
  (* INLINE CALL: SetPosition( file, 0, FromStart ); *)
  IF fseek( files[file].filedes, 0, 0 ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END Rewind ;

PROCEDURE ReadNBytes( file : File ; n : LONGINT ; buffer : ADDRESS ) ;
  VAR k : LONGINT ;
BEGIN
  checkopenfor("ReadNBytes", file, FileSet{reading,random} ) ;
  k := fread( files[file].filedes, n, buffer ) ;
  IF k = n THEN files[file].ioresult := NoError
  ELSIF ( k > 0 ) OR (n = 0) THEN
    files[file].ioresult := OpFailed
  ELSE prematureEOF("ReadNBytes", file )
  END
END ReadNBytes ;

PROCEDURE WriteNBytes( file : File ; n : LONGINT ; buffer : ADDRESS ) ;
BEGIN
  checkopenfor("WriteNBytes", file, FileSet{writing,random} ) ;
  IF fwrite( files[file].filedes, n, buffer ) = n THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteNBytes ;

PROCEDURE SkipBlanks( f : File ) ;
(* Skip blanks: tabs and spaces. Not newlines *)
  VAR
    ch : CHAR ;
    i  : LONGINT ;
BEGIN
  checkopenfor("SkipBlanks", f, FileSet{reading,random} );
  LOOP
    i := getc( files[f].filedes );
    IF i = HitEOF THEN EXIT; END;
    ch := CHR(i);
    IF ( ch # Space ) & ( ch # Tab ) THEN
      ungetc( files[f].filedes, i ) ;
      EXIT
    END
  END
END SkipBlanks ;

PROCEDURE SkipWS( f : File ) ;
(* Skip all whitespace (spaces, tabs and newlines) *)
  VAR
    ch : CHAR ;
    i  : LONGINT ;
BEGIN
  checkopenfor("SkipWS", f, FileSet{reading,random} ) ;
  LOOP
    i := getc( files[f].filedes ) ;
    IF i = HitEOF THEN EXIT END ;
    ch := CHR(i) ;
    IF ( ch # Space ) & ( ch # Tab ) & ( ch # NewLine ) THEN
      ungetc( files[f].filedes, i ) ; EXIT
    END
  END
END SkipWS ;

PROCEDURE EOFAfterWS( f : File ) : BOOLEAN ;
(* After skipping whitespace; are we now at EOF? *)
  VAR
    ch : CHAR ;
    i  : LONGINT ;
BEGIN
  (* INLINE CALLS: SkipWS( f ); RETURN EOF( f ); *)
  checkopenfor("EOFAfterWS", f, FileSet{reading,random} );
  LOOP
    i := getc( files[f].filedes );
    IF i = HitEOF THEN RETURN TRUE; END;
    ch := CHR(i);
    IF ( ch # Space ) & ( ch # Tab ) & ( ch # NewLine ) THEN
      ungetc( files[f].filedes, i ) ; RETURN FALSE
    END
  END
END EOFAfterWS ;

PROCEDURE skipws( procname : (*@N*) ARRAY OF CHAR; f : File ) ;
(* internal utility procedure: check open for reading/random, *)
(* skips whitespace, and goes bang if it hits premature EOF.. *)
  VAR
    i  : LONGINT ;
    ch : CHAR ;
BEGIN
  checkopenfor( procname, f, FileSet{reading,random} ) ;
  REPEAT
    i := getc( files[f].filedes ) ;
    IF i = HitEOF THEN prematureEOF( procname, f ) END ;
    ch := CHR(i)
  UNTIL (ch # ' ') & (ch # TabCh) & (ch # NewLineCh) ;
  ungetc( files[f].filedes, i )
END skipws ;

PROCEDURE ReadInteger( file : File ) : LONGINT ;

  CONST
    minint = MIN(LONGINT) ;
    maxint = MAX(LONGINT) ;

    minintdiv = minint DIV 10 ;       (* eg. -3781 => -378 *)
    minintmod = ABS(minint MOD 10) ;  (* eg. -3781 =>    1 *)

    maxintdiv = maxint DIV 10 ;
    maxintmod = maxint MOD 10 ;

  VAR
    negative : BOOLEAN ;
    ch       : CHAR    ;
    i        : LONGINT ;
    digit    : LONGINT ;
    result   : LONGINT ;
    first    : BOOLEAN ;

BEGIN
  skipws("ReadInteger", file ) ;
  i := getc( files[file].filedes ) ;
  ch := CHR(i) ;
  negative := ch = '-' ;
  IF (ch # '+') & (ch # '-') THEN ungetc( files[file].filedes, i ) END ;

  (* Accumulate the integer in result, check for overflow at each digit *)

  first := TRUE ;
  result := 0 ;
  LOOP
    i := getc( files[file].filedes ) ;
    digit := i - ORD('0') ;
    IF (digit < 0) OR (digit > 9) THEN EXIT END ;
    first := FALSE ;
    IF negative THEN
      IF (result<minintdiv )OR((result = minintdiv ) & (digit > minintmod)) THEN
        files[file].ioresult := Overflow ;
        RETURN 0
      END ;
      result := result*10 - digit
    ELSE
      IF (result>maxintdiv) OR ((result = maxintdiv) & (digit > maxintmod)) THEN
        files[file].ioresult := Overflow ;
        RETURN 0
      END ;
      result := result*10 + digit
    END
  END ;
  ungetc( files[file].filedes, i ) ;
  IF first THEN files[file].ioresult := OpFailed
  ELSE files[file].ioresult := NoError
  END ;
  RETURN result
END ReadInteger ;

PROCEDURE WriteInteger( file : File ; object : LONGINT ) ;
BEGIN
  checkopenfor("WriteInteger", file, FileSet{random,writing} ) ;
  IF fwriteinteger( files[file].filedes, object ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteInteger ;

PROCEDURE ReadReal( file : File ) : REAL ;
  VAR k : REAL ;
BEGIN
  skipws("ReadReal", file ) ;
  IF freadreal( files[file].filedes, k ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END ;
  RETURN k
END ReadReal ;

PROCEDURE WriteReal( file : File ; object : REAL ) ;
BEGIN
  checkopenfor("WriteReal", file, FileSet{random,writing} ) ;
  IF fwritereal( files[file].filedes, object ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteReal ;

PROCEDURE WriteRealFmt( file : File ; r : REAL ; width, decplaces : LONGINT ) ;
BEGIN
  checkopenfor("WriteRealFmt", file, FileSet{random,writing} ) ;
  IF formatreal( files[file].filedes, r, width, decplaces ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteRealFmt ;

PROCEDURE ReadLongReal( file : File ) : LONGREAL ;
  VAR k : LONGREAL ;
BEGIN
  skipws("ReadLongReal", file ) ;
  IF freadlongreal( files[file].filedes, k ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END ;
  RETURN k
END ReadLongReal ;

PROCEDURE WriteLongReal( file : File ; object : LONGREAL ) ;
BEGIN
  checkopenfor("WriteLongReal", file, FileSet{random,writing} ) ;
  IF fwritelongreal( files[file].filedes, object ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteLongReal ;

PROCEDURE WriteLongRealFmt( file : File ;
			       r : LONGREAL ;
			    width, decplaces : LONGINT ) ;
BEGIN
  checkopenfor("WriteLongRealFmt", file, FileSet{random,writing} );
  IF formatlongreal( files[file].filedes, r, width, decplaces ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteLongRealFmt ;

PROCEDURE ReadChar( file : File ) : CHAR ;
  VAR i : LONGINT ;
BEGIN
  checkopenfor("ReadChar", file, FileSet{reading,random} ) ;
  i := getc( files[file].filedes ) ;
  IF i = HitEOF THEN prematureEOF("ReadChar", file ) END ;
  files[file].ioresult := NoError ;
  RETURN CHR(i)
END ReadChar ;

PROCEDURE WriteChar( file : File; object : CHAR ) ;
BEGIN
  checkopenfor("WriteChar", file, FileSet{random,writing} );
  IF putc( files[file].filedes, ORD(object) ) THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteChar ;

PROCEDURE ReadString( file : File ; VAR s : ARRAY OF CHAR ) ;
BEGIN
  skipws("ReadString", file ) ;
  IF freadstr( files[file].filedes, s, HIGH(s) ) THEN
    files[file].ioresult := NoError
  ELSE prematureEOF("ReadString", file )
  END
END ReadString ;

PROCEDURE WriteString( file : File ; object : (*@N*) ARRAY OF CHAR ) ;
  VAR l : LONGINT ;
BEGIN
  checkopenfor("WriteString", file, FileSet{random,writing} ) ;
  l := len( object ) ;
  IF fwrite( files[file].filedes, l, ADR(object) ) = l THEN
    files[file].ioresult := NoError
  ELSE files[file].ioresult := OpFailed
  END
END WriteString ;

PROCEDURE ReadLine( file : File ) ;
  VAR i : LONGINT ;
BEGIN
  checkopenfor("ReadLine", file, FileSet{reading,random} ) ;
  REPEAT
    i := getc(files[file].filedes) ;
    IF i = HitEOF THEN prematureEOF("ReadLine", file ) END
  UNTIL CHR(i) = NewLineCh ;
  files[file].ioresult := NoError
END ReadLine ;

PROCEDURE WriteLine( file : File ) ;
BEGIN WriteChar( file, NewLineCh )
END WriteLine ;

PROCEDURE UnReadChar( file : File ; c : CHAR ) ;
(* currently no check to avoid two successive unreadchar calls *)
(* probably worth having one....			       *)
BEGIN
  checkopenfor("UnReadChar", file, FileSet{reading,random} ) ;
  ungetc( files[file].filedes, ORD(c) ) ;
  files[file].ioresult := NoError
END UnReadChar ;

PROCEDURE ReadLn( f : File ; VAR s : ARRAY OF CHAR ) ;
  VAR
    pos   : LONGINT ;
    ch    : CHAR ;
    error : BOOLEAN ;
BEGIN
  error := FALSE ;
  pos   := 0 ;
  WHILE NOT EOLN( f ) DO
    ch := ReadChar( f ) ;
    IF pos <= HIGH(s) THEN s[pos] := ch ELSE error := TRUE END ;
    INC( pos )
  END ;
  ReadLine( f ) ;
  IF pos <= HIGH(s) THEN s[pos] := 0C END ;
  IF error THEN
    WriteString( StdErr, "FIO.ReadLn: warning - line too long, truncated") ;
    WriteLine( StdErr )
  END
END ReadLn ;

PROCEDURE WriteLn( f : File ; s : (*@N*) ARRAY OF CHAR ) ;
BEGIN WriteString( f, s ) ; WriteLine( f )
END WriteLn ;

(*----------------------------------------------------------------------------*)

PROCEDURE Delete( name : (* @N *) ARRAY OF CHAR ) : BOOLEAN ;
(* Returns TRUE on success, FALSE otherwise *)
BEGIN RETURN StdIO.remove( name ) = 0
END Delete ;

PROCEDURE Rename( old , new : (* @N *) ARRAY OF CHAR ) : BOOLEAN ;
(* Returns TRUE on success, FALSE otherwise *)
BEGIN RETURN StdIO.rename( old , new ) = 0
END Rename ;

(* -------------------------- initialization code -------------------------- *)

VAR
  i : LONGINT ;

BEGIN
  modename[none]    := "none...ahem.." ;
  modename[reading] := "reading" ;
  modename[writing] := "writing" ;
  modename[random]  := "random" ;

  FOR i := 0 TO MaxFiles DO
    files[i].type     := none ;
    files[i].filedes  := -1 ;
    files[i].ioresult := UnInitialized ;
    files[i].name     := ADR("no name") ;
  END ;

  StdIn  := 1 ;
  StdOut := 2 ;
  StdErr := 3 ;

  files[StdIn].type      := reading  ;
  files[StdIn].filedes   := 0        ;
  files[StdIn].ioresult  := NoError  ;
  files[StdIn].name      := ADR("stdin")  ;

  files[StdOut].type     := writing  ;
  files[StdOut].filedes  := 1        ;
  files[StdOut].ioresult := NoError  ;
  files[StdOut].name     := ADR("stdout") ;

  files[StdErr].type     := writing  ;
  files[StdErr].filedes  := 2        ;
  files[StdErr].ioresult := NoError  ;
  files[StdErr].name     := ADR("stderr") ;
END FIO.
