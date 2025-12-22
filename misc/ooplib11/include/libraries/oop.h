#ifndef OOP_H
#define OOP_H

// method call return codes
#define   OOPMCR_METHOD_ACCEPTED         0
#define   OOPMCR_METHOD_PROPAGATE       -1
#define   OOPMCR_METHOD_REJECTED        -2
#define   OOPMCR_RUNTIME_ERROR          -3

// OOP_DeleteObject return codes
#define   OOPDOR_OK                      0
#define   OOPDOR_NO_SEMAPHORE           -1
#define   OOPDOR_NO_OBJECT              -2
#define   OOPDOR_GOT_OBJECTS            -3
#define   OOPDOR_IN_CLASSLIST           -4

// OOP_AddClass return codes
#define   OOPACR_OK                      0
#define   OOPACR_NO_SEMAPHORE           -1
#define   OOPACR_CLASS_EXISTS           -2
#define   OOPACR_OUT_OF_MEMORY          -3

// OOP_RemClass return codes
#define   OOPRCR_OK                      0
#define   OOPRCR_NO_SEMAPHORE           -1
#define   OOPRCR_CLASS_NOT_FOUND        -2

// OOP_AddSuperClass return codes
#define   OOPASCR_OK                     0
#define   OOPASCR_NO_SEMAPHORE          -1
#define   OOPASCR_NO_CLASS              -2
#define   OOPASCR_NO_SUPER_CLASS        -3
#define   OOPASCR_NO_MEMORY             -4

// OOP_RemSuperClass return codes
#define   OOPRSCR_OK                     0
#define   OOPRSCR_NO_SEMAPHORE          -1
#define   OOPRSCR_NO_CLASS              -2
#define   OOPRSCR_NO_SUPER_CLASS        -3
#define   OOPRSCR_SUPER_CLASS_NOT_FOUND -4

// OOP_AddMethod return codes
#define   OOPAMR_OK                      0
#define   OOPAMR_NO_SEMAPHORE           -1
#define   OOPAMR_NO_CLASS               -2
#define   OOPAMR_NO_HOOK                -3
#define   OOPAMR_NO_MEMORY              -4

// OOP_RemMethod return codes
#define   OOPRMR_OK                      0
#define   OOPRMR_NO_SEMAPHORE           -1
#define   OOPRMR_NO_CLASS               -2
#define   OOPRMR_METHOD_NOT_FOUND       -3


#define   OOP_ROOTCLASS_NAME            "RootClass"

// RootClass methods
#define   OOPRCM_NEW_OBJECT             0x00000000
#define   OOPRCM_DELETE_OBJECT          0x00000001
#define   OOPRCM_GET_ATTRIBUTES         0x00000002
#define   OOPRCM_SET_ATTRIBUTES         0x00000003

// RootClass attributes                               // Init Set Get
#define   OOPRCA_VERSION                0x80000000    //   +   -   +
#define   OOPRCA_REVISION               0x80000001    //   +   -   +
#define   OOPRCA_INFO                   0x80000002    //   +   -   +
#define   OOPRCA_AUTHOR                 0x80000003    //   +   -   +

#endif /* OOP_H */
