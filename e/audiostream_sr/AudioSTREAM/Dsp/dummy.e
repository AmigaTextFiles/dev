
/*

        AudioSTREAM Professional
        (c) 1997-98 Immortal SYSTEMS

        Source codes for version 1.0

        =================================================

        Source:         dummy.e
        Description:    AudioSTREAM DSP plugin system v1.0 example
        Contains:       dsp example
        Version:        1.0
 --------------------------------------------------------------------
*/



        /* dsp plugins are standart AMIGADOS shared libraries */


	MODULE '*adst:global'


        /* DSP LIBRARY HEADER */


-> -------------------------------------        CUT HERE

LIBRARY 'dummy.dsp',1,0,
        'dummy.dsp v1.0 (4.2.1998)' IS dsp_getinfo,
	dsp_allochandle,dsp_freehandle,dsp_init,dsp_done,
        dsp_getparamlist,dsp_status,dsp_shutdown,dsp_execute

OBJECT obj_dspinfo      -> returned by dsp_getinfo function
       info:PTR TO CHAR         -> points to an info text
       pnames:PTR TO LONG       -> points to an array of strings,0 terminated
       pformat:PTR TO LONG      ->        -II-        of fmt description
       pminvals:PTR TO INT      -> array of minvalues
       pmaxvals:PTR TO INT      -> array of maxvalues
ENDOBJECT

OBJECT obj_dspstatus    -> returned by dsp_status function
       handles       -> number of opened handles
       reserved1
       reserved2
       reserved3
ENDOBJECT



                DEF handles  -> number of used handles, 256 is max
                DEF htable[256]:ARRAY OF LONG  -> points to parameters

-> --------------------------------------------------------------


/* function definition follows */


PROC main()
DEF i

        /* will be run when opening the dsp (loading it to DSP MANAGER,
        so you can put pre-initialization here */

        handles:=0           -> standart pre-init, copy it
        FOR i:=0 TO 255 DO htable[i]:=0

ENDPROC


PROC close()

        /* will be run when flushing the dsp, you can put some post-
        deallocations here */

ENDPROC


PROC dsp_getinfo()
DEF temp

        /* this function will fill the pointer to info object, object itse-
        return the pointer. this function can't fail*/
        /* IN THE TEXT, YOU CAN USE THE SPECIAL MUI TEXT ENGINE CODES!!! */


temp:= '\e8dummy.dsp v1.0 (4.2.1998) by IMMORTAL Systems\n\n' +
       '\e0This is only a demonstration of AudioSTREAM''s DSP plugin;\n' +
       'This DSP actually does nothing.\n\n'+
       'IT HAS 4 PARAMETERS'

ENDPROC [temp,

        /* now the array of paramnames, THE ARRAY HAS TO BE ZERO TERMINATED*/

        ['Param1 ;-)','Param2 ;-)','blahblah','*shIT*',NIL],

        /* now the array of fmt-strings */

        ['1 Meter','1 ms','1 Potatoe','1 µs'],

        /* minimal values */
        [0,100,-500,50]:INT,

        /* guess ;-) */     -> ! these values are signed ints! -32768..32767
        [20000,300,200,100]:INT]:obj_dspinfo



PROC dsp_allochandle() 
DEF i
DEF temp:PTR TO INT

        /* this stuff is called each time the dsp is added to some dsp seque-
        nce. You can allocate some stuff here AND YOU MUST HANDLE HANDLE
        ALLOCATIONS.YOU CAN COPY YOUR ROUTINE FROM HERE IF YOU WANT

        Then ,return the correct handle or !-1! as a fail-flag
        */

	i:=-1

        IF handles<256 
        	IF (temp:=AllocMem(16,$10001)) -> MEMF_CLEAR + MEMF_PUBLIC
		        FOR i:=0 TO 255 DO EXIT htable[i]=0
    			htable[i]:=temp
       			INC handles
		ENDIF
	ENDIF
ENDPROC i




PROC dsp_freehandle(handle)
DEF temp:PTR TO INT

        /* this stuff is called each time the dsp is removed from some se-
        quence. You can deallocate some stuff here. YOU MUST HANDLE  THE
        REMOVING THE HANDLES */

        /* handle must be <256 , if the handle does not exist, routine
        does nothing */

        temp:=htable[handle]
        IF temp
           FreeMem(temp,16)
           htable[handle]:=0
           /* dealoc stuff */
           DEC handles
           ENDIF
ENDPROC  -> no returned value



PROC dsp_init()

        /* this stuff is called by player library, on the play request.
        PLACE YOUR MAJOR INIT STUFF HERE! DON'T FORGET TO DO THE INIT
        STUFF FOR EACH HANDLE, BECAUSE THIS STUFF IS CALLED ONLY ONCE! */

        /* return false on failure! */

        /* player CAN call this EVEN handles=0 and dsp_allochandle WAS
        NOT CALLED ! count with that ! */

-> in the demonstration , we'll try to fail everytime ;-)
ENDPROC 0


PROC dsp_done()

        /* this stuff is called on the STOP request. Place your MAJOR
        dealoc stuff here FOR EACH HANDLE */

        /* player CAN call this EVEN handles=0 and dsp_allochandle WAS
        NOT CALLED ! count with that ! */

        /* player will NOT call this if dsp_init failed */

ENDPROC -> void


PROC dsp_getparamlist(handle)

        /* This stuff is called when server requests a list of
	dsp parameters - ARRAY 0..7 OF INT*/

	/* just copy it, returns 0 on fail*/

	IF htable[handle] THEN RETURN htable[handle]
	
ENDPROC 0



PROC dsp_status() IS [handles,0,0,0]:obj_dspstatus   -> just copy it at this time


PROC dsp_shutdown()    

-> used for quit and emergency purposes
-> just free all your handles here
DEF temp:PTR TO INT
DEF i

	FOR i:=0 TO 255
		temp:=htable[i]
        	IF temp
			FreeMem(temp,16)
			htable[i]:=0
			/* dealoc stuff */
		ENDIF
	ENDFOR
	handles:=0
ENDPROC



PROC dsp_execute()
ENDPROC