
-> Author: Ali Graham, <agraham@hal9000.net.au>
-> $VER: muisupport.m 0.1 (16.4.97)

OPT MODULE, PREPROCESS

MODULE 'libraries/mui'

/*

    PROC mui_true()

    Because MUI uses C's value for TRUE (i.e. 1), whenever a
    program written in E calls an MUI function with a boolean
    value, E's TRUE value (-1) must be intercepted and changed.

    example:

        set(app.listview, MUIA_Disabled,
            mui_true(active=MUIV_List_Active_Off))

    (whereas without this procedure you would need to write)

        set(app.listview, MUIA_Disabled,
            IF (active=MUIV_List_Active_Off) THEN MUI_TRUE ELSE FALSE)

    Remember: abstraction is a *good* thing :)

*/

EXPORT PROC mui_true(bool=TRUE) IS (IF bool THEN MUI_TRUE ELSE FALSE)

/*

    PROC mui_get()

    More abstraction, basically, to make my MUI programs more readable...

    example:

        active:=mui_get(app.listview, MUIA_List_Active)

    (whereas without this procedure you would need to write)

        get(app.listview, MUIA_List_Active, {active})

    The first is a clearer representation, at least for me...
    I like to avoid explicit pointer references unless they are
    absolutely necessary.

    Also, this gives you the advantage of being able to use the
    return value directly, perhaps in evaluation of a larger
    code sequence.

*/

EXPORT PROC mui_get(a, b)

    DEF c=NIL:PTR TO LONG

    get(a,b,{c})

ENDPROC c
 
