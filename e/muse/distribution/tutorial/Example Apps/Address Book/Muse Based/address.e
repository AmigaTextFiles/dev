
-> The address book demo program with a Muse interface!

MODULE 'muse/muse', '*address_gui','*person','*people'

/*{------------------- The startup and processing stubs -------------------}*/
PROC main() IS easy_muse(address_book())
PROC address_book() IS [
   [WINDOW, address_book_window()],
   [EVENTS, processing()]
]
PROC processing() IS [
                      [STARTUP,   {display_greetings}],
                      [FINDNEXT,  {show_next}],
                      [CLEARVIEW, {clear_display}],
                      [INSERT,    {append_person}],
                      [DELETE,    {remove_person}],
                      [SETSEARCH, {get_search_pattern}],
                      [RESHOW,    {redisplay}],
                      [START,     {restart}]
]
/*{------------------ End of the startup/processing stubs -----------------}*/

/*{---------------- The event handling processor procedures ---------------}*/
PROC display_greetings()
DEF p:PTR TO person
   init_gads()
   initialise_database()
   NEW p.mk('Welcome To The Amazing','Address',
            'Book Program!!!', 'By Michael Sparks', 'Brought to you via Aminet',
            '...','..','.')
   display_person(p)  ->
   END p
ENDPROC

PROC append_person()    -> Simple huh?
DEF p
   p:=get_person()
   add_person(p)
ENDPROC

PROC remove_person()
   IF no_records()>0
      redisplay()
      IF request('Are you sure you wish to\n  delete this person?',
                 'Yes!|No, don''t!')
         delete_person()
         clear_display()
         request('Deleted!')
      ELSE
         request('Close shave there for you...')
      ENDIF
   ELSE
      request('No one stored!!!')
   ENDIF
ENDPROC

PROC show_next()
DEF q:PTR TO person, found
   q,found:=find_next()
   IF found
      display_person(q)
   ELSE
      request('No (more) people!')
   ENDIF
ENDPROC

PROC redisplay()
DEF p
   p:=current_record()
   IF p THEN display_person(p) ELSE 0
ENDPROC

PROC restart()
DEF p
   p:=first_person()
   IF p THEN display_person(p) ELSE 0
ENDPROC

PROC get_search_pattern()
DEF p
   p:=get_person()
   set_searchperson(p)
ENDPROC
