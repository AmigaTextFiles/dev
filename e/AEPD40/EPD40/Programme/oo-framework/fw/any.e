
-> ANY is the upper class of the framework as it has no parent.
-> This general object has no field to minimize memory usage.
-> The aim of this framework is to have as much abstract classes
-> as possible, doing so we provide more power and flexibility to
-> concrete classes. So don't expect these classes to be useful, but
-> inherit from them to get all OO benefits. There is only one class per
-> file as this improves readability and flexibility. This framework
-> is only for OS V36+ users, but some classes could be only for V37+,
-> V39+, or AGA only, if required (or just justified by my lazyness).
-> Source is also highly documented so separate documentation is useless.
-> For each class method the required preconditions are given before the
-> header, read them to prevent bad usage. Note that preconditions also
-> apply to redefined methods but are not repeated, there is no additionnal
-> precondition for redefined methods, this doesn't mean there is no
-> precondition at all.
-> I hope you will find this class set as powerful as you wish.
-> Most of all I hope it is an example of ONE good programming style, though
-> quite different of whatever I previously seen in E. This doesn't mean
-> other E programmers (including Wouter itself) have bad style, they just
-> prefer lower level of abstraction and have already provide large amount
-> of excellent examples for that.
-> The signs of my departure are: (to be interpreted either as goods or bads)
-> * smallTalk naming convention
-> * heavy comment
-> * high level of inheritance
-> * many abstract classes, most classes of this framework can be considered
->   as abstract and you will probably inherit of them again!
-> * no PRIVATE fields! as it would prevent me to use them in heirs, due
->   to class-level abstraction. So usage of this framework require special
->   attention to prevent data-hiding violation. But this is quite easy,
->   use only stuff that is usefull to the consumer point of view.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

OBJECT any
ENDOBJECT

-> Return a copy of this object.
-> Any E object can be cloned using this function.
PROC clone() OF any
  DEF copy:PTR TO any
  copy:=FastNew(Long(^self))
  CopyMem(self+SIZEOF LONG,copy,Long(^self)-SIZEOF LONG)
ENDPROC copy

-> Copy 'other' object to this object.
-> Any E object can be copied using this function.
-> 'other' class MUST be the same as this object class (or a parent).
PROC copy(other:PTR TO any) OF any
  CopyMem(other+4,self+4,Long(^other)-SIZEOF LONG)
ENDPROC

-> Print a readeable form of the object to standard output.
-> As a default print the address of the object in hexadecimal.
-> As an example of required precondition, I use buffered IO, so
-> console MUST be opened, so here (and whenever I perform console IO
-> from now) a previous WriteF('') call is REQUIRED.
PROC out() OF any
  VfPrintf(stdout,'$\h ',[self])
ENDPROC

-> Size of this object.
PROC size() OF any IS Long(^self)

