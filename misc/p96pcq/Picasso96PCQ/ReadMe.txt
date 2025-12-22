
            -------------------------------------------------

                           Picasso96 - PCQ

            -------------------------------------------------

    by Andreas Neumann <Neumanna@stud-mailer.uni-marburg.de>

    last changes: 17.07.1997

    In this directory you can find the implementation of the
    Picasso96API library by Tobias Abt <tabt@studbox.uni-stuttgart.de>
    and Alexander Kneer for the Freeware Pascal compiler "PCQ" by
    Patrick Quaid. Now it is possible to use "Picasso96", the modular
    and system friendly software environment for Amiga graphic cards,
    within "PCQ"-Pascal programs. Included are these files:

    Lib/p96.lib:

        These are the machinecode routines which take care of the
        addressing of the Picasso96API library. You have to link this
        file to the objectcode file produced by "PCQ". This should
        look like:

        blink Programm.o to Programm library PCQ.lib,p96.lib ND SC SD

        To run the programs you need the Picasso96API library which can
        be found in the distribution of "Picasso96" (available e.g. in the
        Aminet (/gfx/board/Picasso96.lha)
        or on the "Picasso96 WWW Home Page"
        (http://wwwcip.rus.uni-stuttgart.de/~etk10317/etc/Picasso96.html).

        Because of the restricitions which exists within "PCQ", only the
        "TagList" versions of some P96 routines could be realised.

    Include/p96/Picasso96.i:

        This is the include file, which has to be copied into a
        "p96" directory in your "PCQ" include directory.

    Examples/

        Here you find Pascal conversions of the examples, which were
        included in the "Picasso96" developer distribution. Because
        they were the first programs in which I had to deal with
        functions of Kickstart 2.x/3.x, there may be some
        solutions which might appear to be not that perfect. I hope
        you can forgive me that. Unfortunately "PCQ" doesn't offer
        routines for converting numbers from one format to another,
        so the output of screen mode ids is done in decimal numbers
        and not in hexadecimal numbers as in the original examples.

        The programming of the "ReadArgs" functions is based on an
        example by Andreas Tetzl. I thank him for this.

        The example sources are copyrighted by their authors,
        Alexander Kneer and Tobias Abt. All rights are reserved to them.

    If there are still questions, problems or propositions contact me
    via e-mail. And please don't bother Alexander Kneer or Tobias Abt
    with questions about this distribution !
