OPT MODULE
OPT EXPORT
OPT PREPROCESS
OPT OSVERSION=37

#define OOPNAME 'oop.library'
CONST   OOPVERSION = 1

-> method call return codes
CONST OOPMCR_METHOD_ACCEPTED     =    0,
      OOPMCR_METHOD_PROPAGATE    =   -1,
      OOPMCR_METHOD_REJECTED     =   -2,
      OOPMCR_RUNTIME_ERROR       =   -3

-> OOP_DeleteObject return codes
CONST OOPDOR_OK                  =    0,
      OOPDOR_NO_SEMAPHORE        =   -1,
      OOPDOR_NO_OBJECT           =   -2,
      OOPDOR_GOT_OBJECTS         =   -3,
      OOPDOR_IN_CLASSLIST        =   -4

-> OOP_AddClass return codes
CONST OOPACR_OK                  =    0,
      OOPACR_NO_SEMAPHORE        =   -1,
      OOPACR_CLASS_EXISTS        =   -2,
      OOPACR_OUT_OF_MEMORY       =   -3

-> OOP_RemClass return codes
CONST OOPRCR_OK                  =    0,
      OOPRCR_NO_SEMAPHORE        =   -1,
      OOPRCR_CLASS_NOT_FOUND     =   -2

-> OOP_AddSuperClass return codes
CONST OOPASCR_OK                 =    0,
      OOPASCR_NO_SEMAPHORE       =   -1,
      OOPASCR_NO_CLASS           =   -2,
      OOPASCR_NO_SUPER_CLASS     =   -3,
      OOPASCR_NO_MEMORY          =   -4

-> OOP_RemSuperClass return codes
CONST OOPRSCR_OK                 =    0,
      OOPRSCR_NO_SEMAPHORE       =   -1,
      OOPRSCR_NO_CLASS           =   -2,
      OOPRSCR_NO_SUPER_CLASS     =   -3,
      OOPRSCR_SUPER_CLASS_NOT_FOUND= -4

-> OOP_AddMethod return codes
CONST OOPAMR_OK                  =    0,
      OOPAMR_NO_SEMAPHORE        =   -1,
      OOPAMR_NO_CLASS            =   -2,
      OOPAMR_NO_HOOK             =   -3,
      OOPAMR_NO_MEMORY           =   -4

-> OOP_RemMethod return codes
CONST OOPRMR_OK                  =    0,
      OOPRMR_NO_SEMAPHORE        =   -1,
      OOPRMR_NO_CLASS            =   -2,
      OOPRMR_METHOD_NOT_FOUND    =   -3


#define OOP_ROOTCLASS_NAME 'RootClass'

-> RootClass methods
CONST OOPRCM_NEW_OBJECT          =   $00000000,
      OOPRCM_DELETE_OBJECT       =   $00000001,
      OOPRCM_GET_ATTRIBUTES      =   $00000002,
      OOPRCM_SET_ATTRIBUTES      =   $00000003

-> RootClass attributes                           -> Init Set Get
CONST OOPRCA_VERSION             =   $80000000,   ->   +   -   +
      OOPRCA_REVISION            =   $80000001,   ->   +   -   +
      OOPRCA_INFO                =   $80000002,   ->   +   -   +
      OOPRCA_AUTHOR              =   $80000003    ->   +   -   +

