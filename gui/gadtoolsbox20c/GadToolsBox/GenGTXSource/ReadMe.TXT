
 GenGTXSource v1.0 - (C) Copyright 1992-1993 Jaba Development. All rights reserved.

 This is an example source generator for GadToolsBox GUI files. It is distributed as
 an example for the people that wish to build their own source generator. Please note
 that it is not a complete source generator because it does miss some things. This is
 because I mainly written it to generate the source for the GadToolsBox main program.
 Also note that the generated source is using GTXLibrary calls, it shares strings
 between the different windows in a GUI (never the same string twice...) and it
 generates localized source.

    Usage:

        GenGTXSource NAME/A,TO/A,BUILTIN/K,CATALOG/K/A,PREPEND/K,VERSION/K/N,QUIET/S

    With:

        NAME                - The name of the GadToolsBox GUI file to generate.
        TO                  - The base name of the generated source files. When
                              you supply "test" here  the  following  files are
                              generated:

                                    test.c              main source
                                    test.h              main header
                                    test_protos.h       prototypes
                                    test_locale.h       CatComp generated header
                                    test.cd             catalog description file
        BUILTIN             - With this argument you specify the builtin language
                              of the GUI. When for example you have designed your
                              GUI with dutch strings you specify "nederlands"
                              here. Defaults to "english".
        CATALOG             - With this argument you specify the name of the catalog
                              that the generated source must open.
        PREPEND             - Here you can specify the name of your own catalog
                              descrition file which will be added to the generated
                              one before CatComp is called.
        VERSION             - With this argument you specify the version of the
                              catalog that the generated source must open. Defaults
                              to 0.
        QUIET               - This switch tells GenGTXSource to surpress progress
                              information.

    Catalogs:

    Nederlands              - Jan van den Baard
    Deutsch                 - Kai Bolay
    Italiano                - Maurizio Ciccione
    Français                - Reza Elghazi
    Norsk                   - Christopher Naas

 NOTE: GenGTXSource *requires* CatComp V38 to be in the system path.
