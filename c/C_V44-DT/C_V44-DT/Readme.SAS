SAS/C V6.5x note:
-----------------

Of course you should now how to handle SAS/C before trying to build
such a thing like a datatype shared library with it, but basically you
just need to type "smake" in the "source/lib_source" directory.

Note, that you may have to adjust the INCLUDE settings within SCOPTIONS.

Relevant settings are in:  - smakefile      (SAS/C makefile)
                           - smakefile.wth  (to be processed by SLink)
                           - SCOPTIONS      (SAS/C compiler settings)
