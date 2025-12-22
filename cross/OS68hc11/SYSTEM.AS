*SYSTEM.AS                                                                    *
*******************************************************************************
*                                                                             *
*                          SYSTEM CONFIGURATION                               *
*                                                                             *
* This information must be entered by the user to define the configuration of *
* the system. These equates are used to define the extents of the MCX11       *
* system tables. THIS FILE MUST BE THE FILE NAMED IN THE ASSEMBLY COMMAND     *
* LINE. It may be named anything the user wishes. Remember that AS11 names    *
* S-Record object file after the first file name encountered in the assembly  *
* command.                                                                    *
*                                                                             *
*******************************************************************************
*                                                                             *
*                             APPLICATION EQUATES                             *
*    (These VALUES should be changed for your application where indicated)    *
*                                                                             *
*    DO NOT CHANGE THE SYMBOL NAMES BECAUSE THEY ARE USED THROUGHOUT MCX11    *
*                                                                             *
*******************************************************************************

*******************************************************************************
*                      BASIC CONFIGURATION DATA EQUATES                       *
*                 These should change for your application                    *
*******************************************************************************

NTASKS  equ    5                   Number of tasks in system
NQUEUES equ    2                   Number of queues in system
NNAMSEM equ    8                   Number of named semaphores in system
NTIMERS equ    3                   Number of timers in system

*******************************************************************************
*                            SYSTEM MEMORY EQUATES                            *
*                 These should change for your application                    *
*******************************************************************************

MCXVAR  equ    $EF                 Base RAM address of MCX variables (17 bytes
*                                   are needed. For example, $ef - $ff)
MCX11   equ    $E000               Base ROM address for MCX11
MCXTABL equ    MCXVAR-1            Base RAM address of MCX system tables

*******************************************************************************
*                           CLOCK AND PRESET EQUATES                          *
*                 These should change for your application                    *
*******************************************************************************

TMSK2   equ    $1024
TFLG2   equ    TMSK2+1
PACTL   equ    TFLG2+1
RTII    equ    $40                 RTI Interrupt enabled, prescale = 00
RTR     equ    $02                 16.37 ms per TICK @ 8MHz
RTIF    equ    $40
TOCK    equ    3                   3 TICKs per TOCK (TOCK = 49.14 ms ~ 20 Hz)

*******************************************************************************
*                              MCX11  EQUATES                                 *
*                      (These should not be changed)                          *
*******************************************************************************

TCBLEN  equ    5                   Length of a Task Control Block
TIMRLEN equ    8                   Length of a Timer Block
QHDRLEN equ    3                   Length of a Queue Header

*******************************************************************************
*                            SYSTEM TABLE EQUATES                             *
*                      (These should not be changed)                          *
*******************************************************************************

NT      equ    NTIMERS*TIMRLEN
TIMERS  equ    MCXTABL-NT          Base address of timer blocks
NQ      equ    NQUEUES*QHDRLEN
QHDRTBL equ    TIMERS-NQ           Base address of queue headers
NQS     equ    NQUEUES*2 
FLGTBL  equ    QHDRTBL-NNAMSEM-NTASKS-NQS  Base address of semaphores
NTS     equ    NTASKS*TCBLEN
STATLS  equ    FLGTBL-NTS-TCBLEN   Base address of Task Control Blocks (TCB)
QBODBAS equ    STATLS-1            Last address of Queue Bodies

*******************************************************************************
*                   TCB INITIALIZATION DATA BLOCK EQUATES                     *
*                      (These should not be changed)                          *
*******************************************************************************

INITST  equ    0                   Task STATE at system initialization
STRTADR equ    1                   Task starting address
RSTSP   equ    3                   Base address of task's stack
TCBADDR equ    5                   Address of task's TCB
TCBDATL equ    7                   Length of a TCB initialization data block

*******************************************************************************
*                  QUEUE INITIALIZATION DATA BLOCK EQUATES                    *
*                      (These should not be changed)                          *
*******************************************************************************

WIDTH   equ    0                   Width of the queue entry
DEPTH   equ    1                   Depth of queue (# of entries)
QHADR   equ    2                   Queue Header address
QADDR   equ    4                   Address of the Queue Body
QUEDATL equ    6                   Length of a Queue initialization data block

*******************************************************************************
*    MCX ESR equates                                                          *
*******************************************************************************

.wait.   equ   1                   Wait for an event to occur
.signal. equ   2                   Signal the occurence of an event
.pend.   equ   3                   Set a semaphore to PENDing state
.send.   equ   4                   Send a message to a task
.sendw.  equ   5                   Send a message and wait for response
.receive. equ   6                  Receive a message 
.deque.  equ   7                   Dequeue an entery from a FIFO queue
.enque.  equ   8                   Enqueue an entry into a FIFO queue
.resume. equ   9                   Resume a suspended task
.suspend. equ   10                 Suspend a task
.terminate. equ   11               Terminate a task
.execute. equ   12                 Execute a task
.delay.  equ   13                  Delay a task for a period of time
.timer.  equ   14                  Set up a timer
.purge.  equ   15                  Purge active timer(s)

*******************************************************************************
*                                                                             *
*                 TASK AND QUEUE INITIALIZATION DATA BLOCKS                   *
*                 These should change for your application                    *
*                                                                             *
* The next section contains the initialization data blocks for the TCB's and  *
* the queues. The user should construct these tables as they define such data *
* as queue sizes, task starting addresses, and stack sizes.                   *
*                                                                             *
*******************************************************************************
*******************************************************************************
*                      QUEUE INITIALIZATION DATA BLOCKS                       *
*                            These must be in ROM                             *
*              (Do Queue definitions before Task definitions)                 *
*******************************************************************************

        ORG MCX11

QUEDATA equ    *                   Queue data (This must come first)

*******************************************************************************
*                 THESE ARE LOCAL SYMBOLS AND CAN BE CHANGED                  *
*******************************************************************************


Q1W     equ    1                   Queue 1 width
Q1D     equ    8                   Queue 1 depth
Q1SIZ   equ    Q1W*Q1D             Queue 1 size
Q1BODY  equ    QBODBAS-Q1SIZ+1     Address of Queue 1 body
Q1HDR   equ    QHDRTBL             Address of Queue 1 Header
        FCB    Q1W,Q1D             WIDTH,DEPTH
        FDB    Q1HDR,Q1BODY        QHADR,QADDR

Q2W     equ    5                   Queue 2 width
Q2D     equ    1                   Queue 2 depth
Q2SIZ   equ    Q2W*Q2D             Queue 2 size
Q2BODY  equ    Q1BODY-Q2SIZ        Address of Queue 2 body
Q2HDR   equ    Q1HDR+QHDRLEN       Address of Queue 1 Header
        FCB    Q2W,Q2D             WIDTH,DEPTH
        FDB    Q2HDR,Q2BODY        QHADR,QADDR

*******************************************************************************
STKBASE equ    Q2BODY-1            Base address of all stacks. This is defined
*                                    as the address of the last queue body - 1.
*******************************************************************************

*******************************************************************************
*                       TASK INITIALIZATION DATA BLOCKS                       *
*                                                                             *
*                (Do Task Definitions after Queue definitions)                *
*******************************************************************************

TCBDATA equ    *                   Task data

*******************************************************************************
*                 THESE ARE LOCAL SYMBOLS AND CAN BE CHANGED                  *
*******************************************************************************
* You must define certain information about the tasks in your application.    *
* The information MUST be supplied in the following sequence:                 *
*                                                                             *
*      1. Initial status of the task at Power-up                              *
*      2. The starting address of the task                                    *
*      3. The base address of the stack for the task                          *
*      4. The TCB address of the task (This is redundant but it saves time)   *
*                                                                             *
* The TCB address, the base address of the stack, and the stack size can be   *
* defined through equates and used in the definitions. REMEMBER, If you are   *
* using an HC11 EVB, you must make the stack size for each task AT LEAST 18   *
* bytes to accomodate the breakpoint mechanism.                               *
*                                                                             *
*                           --- N O T E ---                                   *
*                                                                             *
* In normal usage, MCX will have the clock driver as task number 1. That      *
* it the highest priority task in the system and assures the best timing. You *
* may change it to another if you wish, but it may not provide accurate time  *
* measurement if it can be preempted by another task. It is strongly urged    *
* that you always make task 1 the clock driver if your application is to use  *
* a time base.                                                                *
*******************************************************************************

TASK1   equ    STATLS              Task1 TCB address (Task 1 = CLOCK DRIVER)
STAK1   equ    STKBASE             Base address of task 1 stack
STK1SIZ equ    18                  Size of stack for task 1
        FCB    0                   INITST is RUN
        FDB    clkdrv,STAK1,TASK1  STRTADR,RSTSP,TCBADDR

TASK2   equ    TASK1+TCBLEN        Task 2 TCB address
STAK2   equ    STAK1-STK1SIZ       Base address of task 2 stack
STK2SIZ equ    23                  Size of stack for task 2
        FCB    0                   INITST is RUN
        FDB    $0002,STAK2,TASK2   STRTADR,RSTSP,TCBADDR

TASK3   equ    TASK2+TCBLEN        Task 3 TCB address
STAK3   equ    STAK2-STK2SIZ       Base address of task 3 stack
STK3SIZ equ    21                  Stack size for task 3
        FCB    _IDLE               INITST
        FDB    $0003,STAK3,TASK3   STRTADR,RSTSP,TCBADDR

TASK4   equ    TASK3+TCBLEN        Task 4 TCB address
STAK4   equ    STAK3-STK3SIZ       Base address of task 4 stack
STK4SIZ equ    18                  Stack size for task 4
        FCB    _IDLE               INITST
        FDB    $0004,STAK4,TASK4   STRTADR,RSTSP,TCBADDR

TASK5   equ    TASK4+TCBLEN        Task 5 TCB address
STAK5   equ    STAK4-STK4SIZ       Base address of task 5 stack
STK5SIZ equ    18                  Stack size for task 5
        FCB    _IDLE               INITST
        FDB    $0005,STAK5,TASK5   STRTADR,RSTSP,TCBADDR

*******************************************************************************
* Now that the tasks are all defined, all that is left is the definition of   *
* the base address of the system stack. It should be located 18 bytes below   *
* the top of the stack area for the last task defined above. The 18 bytes are *
* there for the stack for the null task.                                      *
*******************************************************************************

SYSTACK equ    STAK5-STK5SIZ-18    Base address of system stack.

*******************************************************************************
*******************************************************************************
*******************************************************************************

nulltsk bra    *                   This is the null task. It is always runnable
*                                    and always interruptable. It does nothing
*                                    except provide an active task for the
*                                    Dispatcher when all other tasks are busy.
*                                  You may change this any way you wish as long
*                                    it is never put into a non-ready state.

*******************************************************************************
*******************************************************************************
*******************************************************************************
*                                                                             *
*                            MCX11 INITIALIZATION                             *
*                                                                             *
* This is the MCX11 Initialization routine in which all of the 68HC11 RAM and *
* internal registers get initialized. This routine is entered upon a Power On *
* RESET; therefore the first 64 cycles must be spent initializing those areas *
* of the 68HC11 control register space which must be set up during that brief *
* period. Then all of the system tables must be set to their initial content. *
* The user should also include any initialization operatons unique to his own *
* application. Upon completion, the routine should jump to the start of the   *
* MCX11 Dispatcher at lable "dispch".                                         *
*                                                                             *
*******************************************************************************

*******************************************************************************
*     Put the special startup code here which must be done within the first   *
*     64 cycles after Power-on/Reset & set up the internal registers with     *
*     respect to the application requirements.                                *
*******************************************************************************

mcxinit equ    *                   This is MCX11 entry point
        lds    #SYSTACK
        ldaa   #RTII
        staa   TMSK2               Enable RTI Interrupt
        ldaa   #RTR
        staa   PACTL               Set up RTI clock rate

*******************************************************************************
*                                                                             *
* The following instruction is included for use with an EVM board. If you are *
* going to want to initialize the EVM in such a manner that the MPU will use  *
* the first 64 cycles to initialize the control registers, leave this one     *
* instruction in place and perform the following startup procedure:           *
*                                                                             *
*            1. Press the USER RESET button on EVM board.
*            2. Press ABORT SWITCH on EVM board.
*            3. Ignore any ERROR MESSAGE from the EVM and press ENTER on your *
*               debug console's keyboard. This should show the Register set.  *
*            4. Change the content of Stack Pointer Register to legal value   *
*            5. Start the program with a G command at the address of 'mcxgo'. *
*                                                                             *
* If this is not used on an EVM board, and a normal RESET sequence is desired *
* simply remove the following instruction.
*                                                                             *
*******************************************************************************

        bra     *                  Just wait for the ABORT.

*******************************************************************************
* The second job in the initialization process is to link all of the system   *
* timer blocks. The address of the first timer block is stored in the word    *
* in RAM labled "FREE". The word labled "ACTIVE" is set to a 0.               *
*******************************************************************************

mcxgo   ldaa   #TOCK
        staa   tickcnt             Set up Tick counter
        ldy    #NTIMERS            Set up counter for the number of timers
        ldd    #TIMERS             Get address of Timer Blocks
        std    FREE                Store it in the pointer to 1st free block
        ldx    #TIMERS             Set up pointer to 1st Timer Block
tmlp    dey                        Decrement timer counter and see if done.
        beq    tmdone
        addd   #TIMRLEN            If not done, calculate address of next block
        std    0,x                 Store it in link word of current block.
        ldx    0,x                 Then set up pointer to the next block.
        bra    tmlp
tmdone  clrb
        clra                      When done linking the timer blocks, set
        std    0,x                   the link word of the last timer to 0.
        std    ACTIVE              Set up 0 entry for no active timers.

*******************************************************************************
* The third thing to do during initialization is to set up the queues. The    *
* queues have a Header and a Body and they are not contiguous. The Queue      *
* Headers are found immediately below the Timer Blocks in RAM. The Bodies are *
* found immediately above the Task Control Blocks.                            *
*******************************************************************************

        ldx    #QHDRTBL            Set up pointer to the 1st queue header
qlp     clr    0,x                 Clear next byte in the queue header area.
        inx
        cpx    #TIMERS             See if all queue headers are cleared.
        bne    qlp                 keep looping until done

*******************************************************************************
* The fourth function during initialization is to set all of the semaphores   *
* to a PENDing state. The number of semaphores is equal to the number of the  *
* named semaphores + the number of tasks + twice the number of queues.        *
*******************************************************************************

        ldaa   #NQUEUES            Get the number of queues in system.
        asla                       Multiply it by 2.
        adda   #NNAMSEM            Add the number of named semaphores
        adda   #NTASKS             Then add the number of tasks.
        ldx    #FLGTBL             Set up pointer to base of the semaphores.
        ldab   #_PEND
smlp    stab   0,x                 Store the PENDing value in the semaphore.
        inx
        deca                       Decrement the counter
        bne    smlp                Keep looping until all are set to PENDing.


*******************************************************************************
* The fifth thing to do in the initialization is to set up the RAM resident   *
* portions of the Task Control Blocks (TCB). The TCBs are found immediately   *
* above the semaphores.                                                       *
*******************************************************************************

        ldy    #TCBDATA            Set up pointer to User Defined list of
*                                    TCB initialization data block.
        ldaa   #NTASKS             Set up task counter too.
        staa   notmt
tcblp   ldx    TCBADDR,y           Set up a pointer to the TCB.
        clr    MSGTHRD,x           Clear the message thread.
        clr    MSGTHRD+1,x
        ldab   INITST,y            Get the initial status of the task.
        stab   STATE,x             Store it as the status byte of the TCB.
        bne    nostart             Branch if task state show it is not ready.
        ldd    RSTSP,y
        subd   #9
        std    ACTSP,x             Set up pointer to the stack context.
        xgdx                       Put stacked context address into IX.
        ldd    STRTADR,y
        std    PC+1,x              Put task's starting address into PC word
        clra                        of the context. Then clear ACCB, ACCA,
        clrb                        and CCR.
        staa   CCR+1,x
        std    ACCB+1,x
nostart ldab   #TCBDATL
        aby                        Bump pointer to next TCB initialization
        dec    notmt                data block.
        bne    tcblp               Loop until done.

* Now set up the null task

        ldx    #SYSTACK+9
        ldd    #nulltsk            Get the starting address of the null task.
        std    PC+1,x              Put task's starting address into PC word
        clr    CCR+1,x               of the context. Then clear ACCB, ACCA,
        clr    ACCB+1,x              and CCR.
        clr    ACCA+1,x
        ldd    #NTASKS*TCBLEN+STATLS Get TCB address of the null task
        xgdx
        std    ACTSP,x             Save address of null task's context
        clr    STATE,x             Make sure null task is READY.
        clr    intlvl              Clear interrupt level.  ** (V1.1 #5) **
  
*       jmp    dispch              Start the MCX Dispatcher

*******************************************************************************
*  The next location should contain the entry point to the Dispatcher.        *
*  The file "MCX.AS" should follow this file. If not, then you should remove  *
*  the asterisk on the line above which causes a direct jump to the label of  *
*  the Dispatcher, "dispch".                                                  *
*******************************************************************************
