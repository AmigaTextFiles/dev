
-> Copyright © 1995, Guichard Damien.

-> AME (Abstract Machine for Eiffel)
-> It has been designed to:
->  _ be machine and architecture (RISC/CISC) independant for portability
->  _ allow use of all addressing modes and registers of its target
->    processor for efficiency
->  _ not be affected by adding or removing or changing the technique of
->    garbage collection
-> This  goal  is achieved in AME firstly by making no other assumption about
-> the  target  processor  than the fact that it owns several registers and a
-> stack,  secondly  all  addressing  modes  used in AME are much Eiffel-like
-> (ATTRIBUT,   LOCAL,ROUTINE,ARGUMENT,CURRENT   object)   and  can  ever  be
-> translated  to  the  best  available  addressing  modes  by  the  back-end
-> generator.
-> see documentation for more information about AME

OPT MODULE
OPT EXPORT

-> AME addressing modes reflect Eiffel language entities

ENUM M_TRUE,        -> true value
     M_FALSE,       -> false value
     M_VOID,        -> Void value
     M_STRING,      -> an Eiffel string
     M_CURRENT,     -> access to current object
     M_IMMEDIATE,   -> a LONG immediate value
     M_REGISTER,    -> a p-code register
     M_ATTRIBUT,    -> access to current object attribut
     M_ARG,         -> access to current routine argument
     M_LOCAL,       -> access to a local variable
     M_ROUTINE,     -> access to a current object routine
     M_LABEL,       -> a label number from to
     M_NONE         -> no access mode

CONST R_NONE=-1

-> AME mnemonics definition
ENUM I_ADD,         -> performs destination + source
     I_AND,         -> performs destination AND source
     I_ASSIGN,      -> copy the destination to the source
     I_CALL,        -> procedure call,mode is M_LABEL,dest is R_NONE
     I_CLASSFIELDS, -> number of class fields
     I_CREATE,      -> object creation, mode is M_CLASS
     I_CURRENT,     -> set current object
     I_DIV,         -> performs destination / source
     I_ENDROUTINE,  -> restore old SP and frame register, and returns
     I_EQUAL,       -> performs destination = source
     I_GREATERTHAN, -> performs destination > source
     I_JALWAYS,     -> unconditionnal JUMP, mode is M_LABEL
     I_JFALSE,      -> JUMP if last result is FALSE, mode is M_LABEL
     I_JTRUE,       -> JUMP if last result is TRUE,  mode is M_LABEL
     I_LABEL,       -> LABEL declaration, mode is M_LABEL
     I_LESSTHAN,    -> performs destination < source
     I_LINK,        -> dynamic binding table vector
     I_LOCALS,      -> define local entities
     I_MOD,         -> performs destination MODULO source
     I_MUL,         -> performs destination * source
     I_NEG,         -> performs -destination
     I_NOT,         -> performs ~destination
     I_NOTEQUAL,    -> performs destination <> source
     I_NOTGREATER,  -> performs destination <= source
     I_NOTLESS,     -> performs destination >= source
     I_OR,          -> performs destination OR source
     I_POPREGS,     -> pop i regs from stack
     I_PUSH,        -> push source to stack
     I_PUSHREGS,    -> push i regs to stack
     I_ROUTINE,     -> push frame register and set it to SP value
     I_SUB,         -> performs destination - source
     I_TABLE,       -> jump table
     I_XOR,         -> performs destination XOR source
     I_NONE         -> no instruction

