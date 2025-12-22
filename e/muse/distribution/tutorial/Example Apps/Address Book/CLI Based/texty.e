
OPT MODULE
OPT EXPORT
MODULE '*person'

/* text interface for the address book program */

-> This displays a person's attributes.
PROC display_person(p:PTR TO person)
DEF f, t:PTR TO LONG
   t:=p.flat()             -> retrieve a list of the fields from the person
   FOR f:= 0 TO 7          -> Cycle through the fields and
      IF StrLen(t[f])>0 THEN WriteF('\s\n',t[f]) ELSE 0  -> Display non-empty ones
   ENDFOR                                                -> ie Len(field)>0
ENDPROC

PROC get_string(prompt)       -> allocates storage for response
DEF result                    -> returns this pointer to it!
   WriteF('\s: ',prompt)      -> Display the prompt string
   result:=String(80)         -> Create storage for response - max line = 80 Chars
   ReadStr(stdout,result)     -> Read the user's input.
ENDPROC result

PROC get_person()
DEF joe_bloggs:PTR TO person,                -> Used as return field.
    t:PTR TO LONG, f,                        -> T is a local temporary array.
    address_line:PTR TO LONG                -> Labels to display for those lines.
   NEW t[8]                                  -> Initialise temporary input buffer
   address_line:=['streetline1','streetline2', -> Set the labels.
                  'streetline3', 'city',
                  'county','postcode']
   t[0]:=get_string('name')                  -> Retrieve the person's name
   t[7]:=get_string('telephone')             -> Retrieve their telephone number
   FOR f:= 0 TO 5                            -> Cycle through the address_field labels
      t[1+f]:=get_string(address_line[f])   -> and retrieve those lines
   ENDFOR
   NEW joe_bloggs.mk(t[0], t[1], t[2], t[3], -> Create and initialise
                     t[4], t[5], t[6], t[7]) -> the person
   END t[8]                                  -> Dispose of input buffer.
ENDPROC joe_bloggs


-> Displays what happens when you perform a search.
PROC search_display() IS  WriteF(
            '\ecThe Amazing Address Book Program\n'+
            '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'+
            'Search for item(s)\n'+
            '------------------\n'+
            'You will be asked for a pattern to search for on.\n'+
            'If you do not wish to search on any field, just\n'+
            'press return. I''ll then search for what you''ve asked,\n'+
            'displaying each item one at a time.\n\n'+
            'Let''s go!\n')


-> Displays what happens when you try to add a record.
PROC insert_display() IS WriteF(
            '\ecThe Amazing Address Book Program\n'+
            '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'+
            'Add to Data Base\n'+
            '----------------\n'+
            'You will be asked for:\n'+
            '   name, telephone no,\n'+
            '   3 streetlines, city, county and postcode\n'+
            'There is no going back after you''ve pressed enter...\n\n')

/* Tell the user what they can do */
PROC show_menu() IS WriteF(
            '\ecWelcome to The Amazing Address book Program\n' +
            '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n' +
            '                 Main Menu\n'+
            '                 ~~~~~~~~~\n'+
            'Please choose:\n\n' +
            '   1. Add to data base\n' +
            '   2. Remove from data base\n' +
            '   3. Search database\n' +
            '   4. Quit!\n\n»» ')

-> Let the user know what happens when they're deleting!
PROC remove_display() IS WriteF(
            '\ecThe Amazing Address Book Program\n' +
            '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n' +
            'Remove Record\n' +
            '-------------\n' +
            '     First of all, I will ask you to enter some details\n' +
            'which will enable me to search for a record.\n' +
            '     I will then display the results of that search one\n' +
            'record at a time, asking you if you wish to delete it.\n' +
            '     I will give you a chance to change your mind and\n' +
            'then ask you if you wish to search for more records.\n')
PROC results_display() IS (WriteF('\ecResults\n~~~~~~~\n')) BUT 0
