OPT MODULE

MODULE 'oomodules/object'

EXPORT OBJECT requester OF object
ENDOBJECT


EXPORT PROC message(text:PTR TO CHAR) OF requester IS EMPTY

EXPORT PROC choice(text:PTR TO CHAR) OF requester IS EMPTY

EXPORT PROC query(text:PTR TO CHAR, choices:PTR TO CHAR)  OF requester IS EMPTY

EXPORT PROC getFile(currentDirectory=NIL:PTR TO CHAR,pattern=NIL:PTR TO CHAR) OF requester IS EMPTY

EXPORT PROC getFont() OF requester IS EMPTY

EXPORT PROC getScreen() OF requester IS EMPTY

EXPORT PROC getNumber()  OF requester IS EMPTY

EXPORT PROC getString() OF requester IS EMPTY


