SAS/C V6.5x note:
-----------------
[Andreas Kleinert <Andreas_Kleinert@t-online.de>]


Of course you should now how to handle SAS/C before trying to build
such a thing like a datatype shared library with it, but basically you
just need to type "smake" in the "source/lib_source" directory.

Note, that you have to adjust the INCLUDE settings within SCOPTIONS
when building a V43 datatype (pointing to CyberGraphX and pic-dt V43
developer stuff). When not supporting V43, simply remoe the line

 #define V43_DT

from the beginning of libfuncs.c and the corresponding INCLUDE
entries from SCOPTIONS.

Relevant settings are in:  - smakefile      (SAS/C makefile)
                           - smakefile.wth  (to be processed by SLink)
                           - SCOPTIONS      (SAS/C compiler settings)

