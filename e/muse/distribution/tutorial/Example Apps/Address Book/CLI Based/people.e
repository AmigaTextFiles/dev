
-> This is a 'people' database module. It's only interface is to do with
-> searching for specific people, adding people, and deleting. It does *not*
-> deal with their creation, destruction, comparison etc.

OPT MODULE
OPT EXPORT
MODULE '*person'

CONST DEFAULT_MAX_PEOPLE=100
DEF people:PTR TO LONG, max_people,
    current_person, search_person:PTR TO person,
    last_found

/*{-------------- Module initialisation and shutdown code --------------}*/
PROC initialise_database(no_of_people=DEFAULT_MAX_PEOPLE)
-> Possible improvement would be to load database!
   last_found:=-1          -> Since we haven't searched yet.
   current_person:=-1      -> Since we haven't got anyone yet.
   search_person:=NIL
   people:=List(no_of_people)
   max_people:=no_of_people
ENDPROC

PROC shutdown_database()
-> Possible improvement might be to save database!
   NOP
ENDPROC
/*{-------------- End of initialisation and shutdown code --------------}*/

PROC add_person(p:PTR TO person)
DEF l
   l:=ListLen(people)
   IF l<max_people
      people[l]:=p ; SetList(people, l+1)
      current_person:=last_found:=l
   ELSE
      Raise("peop")
   ENDIF
ENDPROC


PROC delete_person()   -> Deletes the person stored at index current_person.
DEF p:PTR TO person, l
   IF ListLen(people)>0 AND (current_person>-1)   -> If got anyone
      l:=ListLen(people)                          -> Find length of the List.
      p:=people[current_person]                   -> Get pointer to this person
      END p                         -> Dispose of memory used by person.
      l:=l-1                        -> One less person now.
      IF l>=0                       -> Still have elements stored, so we
         people[current_person]:=people[l]  -> swap old last element into
                                        -> position from where the
                                        -> deletion took place
         SetList(people,l)          -> Make sure list variable reflects this!
         current_person:=current_person-1
      ENDIF
   ENDIF
ENDPROC

PROC set_searchperson(p)
   search_person:=p
   last_found:=-1     -> Assume we haven't got a start position
ENDPROC               -> ensures find_next() finds first.

/*
PROC find_person(p:PTR TO person)
PROC find_previous()
*/

PROC find_next()
DEF remaining, found=FALSE, tp:PTR TO person, index, result=0
   IF search_person=NIL THEN RETURN 0,FALSE ELSE 0
   current_person:=last_found+1
   remaining:=ListLen(people)-current_person
   IF remaining>0
      index:=current_person
      WHILE (remaining>0) AND Not(found)
         tp:= people[index]
         IF tp.compare(search_person, ALL) THEN found:=TRUE
         remaining-- ; index++
      ENDWHILE
   ENDIF
   IF found
      result:=people[index-1]
      last_found:=current_person:=index-1
   ENDIF
ENDPROC result, found

PROC no_records() IS ListLen(people)
PROC current_record()
   IF ListLen(people)>0
      RETURN people[current_person]
   ELSE
      RETURN 0
   ENDIF
ENDPROC

PROC first_person()
   IF ListLen(people)>0
      last_found:=current_person:=0
      RETURN people[current_person]
   ELSE
      last_found:=current_person:=-1
      RETURN 0
   ENDIF
ENDPROC 
