"-------------------------------------------------------------------"
" An instance of me is a simple record of a pointer to another Link."
" I am an abstract Class; my concrete subclasses, for example,      "
" Process, can be stored in a LinkedList structure.                 "
"-------------------------------------------------------------------"

Class Link :Collection ! nextLink !
[
  nextLink
    ^ nextLink
|
  nextLink: aLink
    ^ nextLink <- aLink
|
  new: aLink
    ^ self new nextLink: aLink
]
