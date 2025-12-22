# This is an example of a Shell script (for Csh) that can be used to generate
# index files automatically so I do not have to select each time which files
# I want scanned with what options.
#
# Furthermore this script demonstrates how an index generation can be split
# up in several (in this case two) files. The supplied ARexx scripts, however, 
# do not take notice of this (I use another script) and are designed for just
# one index file. Figure it out yourself!
#
# I run this script everytime something has changed in my manuals or include
# files drawers. Note that the calls take advantage of the recursivity feature
# of GenerateIndex. Also note that it first deletes the existing index files.
# GenerateIndex will add to them if they are not deleted.
#
# This script is quite specific to the organization of my harddisk, so you
# cannot use it for anything real; it merely serves as an example.
#
# Anders Melchiorsen, 19-Feb-96

# First make an index file with AutoDoc, struct and file name entries
echo "Indexing AutoDocs, struct's and file names..."
delete S:FetchRefs.index

GenerateIndex/GenerateIndex TO S:FetchRefs.index RECURSIVELY KEEPEMPTY\
  AUTODOC C C_STRUCT\
  FROM "DCC:Docs" "DINCLUDE:*.h" "DINCLUDE:Amiga30" "DINCLUDE:pd"

# Now make another index file, this one with all defines and typedef's
echo "Indexing #define's and typedef's..."
delete S:FetchRefs.index.defines

GenerateIndex/GenerateIndex TO S:FetchRefs.index.defines RECURSIVELY\
 C C_DEFINE C_TYPEDEF\
 FROM "DINCLUDE:*.h" "DINCLUDE:Amiga30" "DINCLUDE:pd"

