
/*
       Address Book Program - Text Based Version 0 - Michael Sparks 1996
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          This is a toy application to allow you to compare a text
          based version of a `proper' application with a Muse based
          version. I make no guarantees as to its decency concerning
          its program style, but it should be `followable'.

         (Adding a save/load/modify option could even make this _useful_
          as well as improving the flexibility of the search - its
          currently case sensitive...)

              · Share and enjoy, no warranties. Public Domain! ·
*/

MODULE '*person', '*texty', '*people'

/*{----------- Constants used through out this part of the program ------------}*/
ENUM INSERT=1, REMOVE, SEARCH, QUIT 
CONST MAX_PEOPLE=100

/*{-------------------- Variables that are used throughout --------------------}*/
DEF str[1024]:STRING

/* Where we start off, and finish up...   */
/* Hopefully this procedure is _readable_ */
PROC main()
DEF choice, quit_flag
   initialise_database()
   REPEAT
      choice:=get_choice()
      quit_flag:=do(choice)
   UNTIL quit_flag=QUIT
   shutdown_database()
ENDPROC

/* Get a decision from the user... */
PROC get_choice()
DEF choice, format_ok
   REPEAT
      show_menu()                                      -> draw prompt
      ReadStr(stdout,str)                              -> get the choice
      choice,format_ok:=Val(str)                       -> convert to integer
      choice:=validate_choice(choice, format_ok)       -> check it!
      IF choice=0                                      -> bad value entered !
         complain('You must make a selection between 1 and 4, OK?!')
      ENDIF
   UNTIL choice<>0
ENDPROC choice ->!

/* Check an entry the user's made... */
PROC validate_choice(choice, format_ok)
   IF format_ok=0 THEN RETURN 0 ELSE 0                 -> Wasn't a number...
   IF (choice>QUIT) OR (choice<1) THEN RETURN 0 ELSE 0 -> outside range...
ENDPROC choice                                         -> hunkey dory!!!

/* Do what the user wants... */
PROC do(action)
DEF q
   SELECT action
      CASE INSERT; insert()
      CASE REMOVE; remove()
      CASE SEARCH; search()
      CASE QUIT; q:=IF really(
                    'Are you absolutely certain you really want to do that?'
                             ) THEN QUIT ELSE 0
   ENDSELECT
ENDPROC q


/* Double check they really do want to quit the program
PROC really_quit()
DEF r=FALSE
   WriteF('\nAre you absolutely certain you really want to do that?\n»» ')
   IF ReadStr(stdout, str)=-1 THEN RETURN TRUE ELSE 0
   r:=(InStr(str,'Y')<>-1) OR (InStr(str,'y')<>-1)
ENDPROC r*/


/* Tell the user what they can do */

/* Something's not quite right. Complain to the user, and then continue */
PROC complain(complainstring)
   WriteF('\n\s\nPress return to continue...',complainstring)
   ReadStr(stdout, str)
ENDPROC

-> We're adding a person to the database!
PROC insert() HANDLE
-> get person, store at end of list, makelist coherent
DEF p
   insert_display()                 -> Let user know what's gonna happen...
   p:=get_person()
   add_person(p)
EXCEPT
   IF exception="peop" THEN complain('Too many people!!!')
ENDPROC

/* They want to *remove* someone? How dare they...! */
PROC remove() HANDLE
   IF no_records()=0 THEN Raise("prat")
   remove_display()
   set_searchperson(get_person()) -> Find out which record(s) the user wishes
                                  -> to delete, by getting a search pattern
   do_search({query_delete})      -> Search for the items, deleting
                                  ->   them as we go as required.
   complain('Going back to main menu')
EXCEPT
   complain('You haven''t entered an records!\n'+
            'I can''t therefore remove any!')
ENDPROC

PROC query_delete(p)
   display_person(p)
   IF really('Do you wish to delete this person?')
      delete_person()
      IF Not(really('Continue searching for people to delete?'))
         RETURN TRUE
      ENDIF
   ENDIF
ENDPROC FALSE


-> Search for all people matching a pattern as demonstarted by the user...
PROC search()
   search_display()                    -> Tell user what's happening!
   set_searchperson(get_person())      -> Get/Set a search pattern
   results_display()                   -> Display search results
   do_search({display_it})             -> Do the actual search, display results
   complain('no (more) records')
ENDPROC

PROC display_it(p)
   display_person(p); complain('')
ENDPROC FALSE

PROC do_search(visit)
DEF p, found=FALSE, quit=FALSE
   REPEAT
         p,found:=find_next()                   -> find next record
         IF found                               -> If we found one,
            quit:=visit(p)                         -> Visit it!
         ENDIF
   UNTIL Not(found) OR quit                     -> repeat until no more.
ENDPROC

PROC really(comment)
DEF r=FALSE
   WriteF('\n\s\n»» ',comment)
   IF ReadStr(stdout, str)=-1 THEN RETURN TRUE ELSE 0
   r:=(InStr(str,'Y')<>-1) OR (InStr(str,'y')<>-1)
ENDPROC r

