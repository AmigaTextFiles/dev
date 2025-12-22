
MODULE Test2o;

IMPORT
  arb := test2ARB,
  d := Dos,
  e := Exec,
  rx := Rxtest2,
  rxh := ARBRexxHost;

VAR
  myhost: rx.RexxHost;
  portname: e.STRPTR;

(*
void argArrayDone( void )
{
  if( program_icon )
    FreeDiskObject( program_icon );
}

char **argArrayInit( LONG argc, char **argv )
{
  if( argc )
    return argv;

  else
  {
    struct WBStartup *wbs = (struct WBStartup * ) argv;

    if( program_icon = GetDiskObject((char * ) wbs->sm_ArgList->wa_Name) )
      return( (char ** ) program_icon->do_ToolTypes );
  }

  return NULL;
}


void init( int argc, char *argv[] )
{
  if( ttypes = argArrayInit( argc, (char ** ) argv ) )
  {
    portname = FindToolType( (UBYTE ** ) ttypes, "PORTNAME" );
  }
}
*)

(* Hauptprogramm *)

VAR
  fh: d.FileHandlePtr;
  s: LONGSET;

BEGIN
  (* Initialisieren *)
  (* Init( argc, argv ); *)

  myhost := rx.SetupARexxHost(portname);
  IF myhost = NIL THEN
    d.PrintF( "No Host\n" );
    HALT(20);
  END;

  (* Erst eine CommandShell... *)

  fh := d.Open( "CON:////CommandShell/AUTO", d.newFile );
  IF fh # NIL THEN
    myhost.CommandShell( fh, fh, "test> " );
    d.OldClose( fh );
  ELSE
    d.PrintF( "No Console\n" );
  END;

  (* ...und dann 'richtiger' ARexx-Betrieb *)

  d.PrintF("Address me on Port ");
  d.PrintF(myhost.name);
  d.PrintF("!\nCancel me with CTRL-C\n");

  LOOP;
    s := e.Wait(LONGSET{d.ctrlC,myhost.port.sigBit});
    IF d.ctrlC IN s THEN
      IF rxh.cmdShell IN myhost.flags THEN
        d.PrintF( "can't quit, commandshell still open!\n" );
      ELSE
        EXIT;
      END;
    ELSE
      myhost.Handle();
    END;
  END;

CLOSE
  (* argArrayDone(); *)
  IF myhost # NIL THEN rx.CloseDownARexxHost(myhost); END;

END Test2o.

