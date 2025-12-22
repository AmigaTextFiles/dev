/*

Object Localization Definitions (OLD). This file contains the numbers of
all messages in the global oomodules catalog.

You'll find the numbers of all messages and the name of the catalog it is
defined in.

The symbolic names are built this way:

OLDC_<short object name>        OLDN = object localization definition catalog

  name of catalog where the following strings are in

OLDM_<message name>             OLDN =                                message

  name of the message

OLDL_<language>                 OLDL =                                language

  language. usually passed as 'builtin language' argument

*/

OPT MODULE

OPT PREPROCESS,EXPORT

#define OLDL_ENGLISH 'english'
#define OLDL_DEUTSCH 'deutsch'

#define OLDC_OBJECT 'oomodules/object.catalog'
#define OLDM_OBJECT_DERIVED_RESPONSE 1
#define OLDM_OBJECT_SELECT_WRONG_LEN 2

#define OLDC_LIBRARY 'oomodules/library.catalog'
#define OLDM_LIBRARY_OPEN_FAILURE 1

#define OLDC_FILE 'oomodules/file.catalog'
#define OLDM_FILE_OPEN_FAILURE 1
#define OLDM_FILE_WRITE_FAILURE 2
#define OLDM_FILE_EOF 3
#define OLDM_FILE_UNEXPECTED_EOF 4

