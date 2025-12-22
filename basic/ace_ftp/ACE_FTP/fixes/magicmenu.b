 Short: MagicMenu bug workaround example code.
Author: Herbert Breuer, HERBY@CYBERSPACE.ORG

--------------------------
Hi ACE friends.

Because of the known problems between ACE and MagicMenu I like to come up
with a solution, which can be used, until the assignment of the menus is
changed in ACE. I'm using it already in all my ACE programs and had no
system crashes anymore. :)

Here is the example code with comments for you:

CONST MENUCNT = (the count of the menus)

ADDRESS _win, _menuptr, _menuptr_dummy

SUB setup_menus

SHARED  _win, _menuptr, _menuptr_dummy

    /* ..... after setting up the menus */

    /* ..... get the menu pointer from the first menu */

    _menuptr=PEEKL(_win+28)

    /* ..... now the other ones; we only need the pointer of the last
             application menu and the dummy menu behind! */

    FOR i=1 TO MENUCNT-1
        _menuptr=PEEKL(_menuptr)
    NEXT

    /* if you have only one menu no second PEEKL is necessary! */
    /* if you have only two menus, then you write:

        _menuptr=PEEKL(_menuptr)
    */

    /* ..... get the pointer from the dummy menu, _menuptr holds already
             the pointer to the last application menu! */

    _menuptr_dummy=PEEKL(_menuptr)

    /* ..... kill the pointer to the dummy menu */

    POKEL _menuptr,0&


/* at the end of the program, or when leaving because of an error */

    /* ..... write the pointer to the dummy_menu again into the stucture
             of the application menu, now all the memory can be freed, which
             was allocated to create the menus! */

    POKEL _menuptr,_menuptr_dummy
    MENU CLEAR

/* and now the other clean up operations */

Happy ACEing. :)

Herbert

