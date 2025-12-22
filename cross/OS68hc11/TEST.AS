*TEST.AS
*
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
*    MESSAGE EQUATES                                                          *
*******************************************************************************

MLINK    equ   0                   Message link pointer
MTASK    equ   2                   Message's sending task
MSEMA    equ   3                   Message semaphore
MBODY    equ   4                   Start of message body

*******************************************************************************
*    TEST equates                                                             *
*******************************************************************************

* REMEMBER task 1 is the CLOCK DRIVER *

T2     equ    2
T3     equ    3
T4     equ    4
T5     equ    5

SEMA_a equ    2          Semaphore that T2 waits on
SEMA_b equ    3          Semaphore that T3 waits on
SEMA_C equ    4          Semaphore that is reset by T4
SEMA_D equ    5          Semaphore that is signalled by T4 & waited by T3

TESTQ_1 equ    1         Test queue 1, used by T5 & T2
TESTQ_2 equ    2         Test queue 2, used by T4 & T3

tstmsg  equ   $0001      Message to be sent to task 4
savptr  equ   $0008
qdestn  equ   $0010      Address of dequeued test text string

ENDOFQ  equ   '$         End of queue message is dollar sign ($)
*******************************************************************************

        ORG $E800

******************************************************************************
*  Out of reset task 1 and 2 (and of course the null task) are the only tasks
*  that are runnable. This is setup in the SYSTEM.AS file on task
*  initialization. The other 3 tasks are in the idle state.
******************************************************************************
*task 2 todo's: 
* 1. Delays 5 seconds.                               
*    During this delay we will spend most of our time in the null task.
*    Except for when tick timer expires.
* 2. Make task 3 runnable.
*    This will not cause a task switch due to task 3 is a lower priority.
* 3. Waits on named semaphore (SEMA_a). Upon a signal from task 5.  
* 4. It deques a message sent from task 5. Since task 5 is enqueing to Queue 1
*    (1 x 8) queue and is a lower priority task, we will bounce back in forth
*    between task 2 and 5 until complete message is sent. If Queue 1 would have
*    been configured as a 4 x 2 queue, then task 2 would not have been awaken
*    on the dequeue ESR until all 4 bytes were enqueued by task 5.
* 5. Signal named semaphore (SEMA_b).
* 6. Terminate self.
*****************************************************************************
tsk2    clra
        clrb
        ldx    #5000/49
        swi
         FCB   .delay.    Delay start of task for 5 seconds. Except for
*                          the first time through this code, there should now
*                          be 2 timers in the thread. (see task 5)
    
        ldaa   #T3        set up task 3 for execution
        swi
         FCB   .execute.

        ldab   #SEMA_a    wait on semaphore A
        swi
         FCB    .wait.

dqloop  ldaa   #TESTQ_1   dequeue from queue 1
        swi
        FCB    .deque.
        cmpa   #ENDOFQ    compare dequeued byte with end-of queue character
        bne    dqloop     loop until a match is found

        ldab   #SEMA_b    signal semaphore B
        swi
        FCB    .signal.

        clra
        swi               terminate self
        FCB    .terminate.

*******************************************************************************
*task 3 todo's:
* 1.  Cause task 5 to become runnable.
*     Task 5 is a lower priority task therefore no task switch.
* 2.  Send a message to task 4 and wait upon the named semaphore (MSEMA).
*     Once MSEMA is signalled.
* 3.  Dequeue from Queue 2 (5 x 1) and put message at location $0010.
*     Compare message to expected message, then wait on named semaphore (SEMA_b)
*     Once SEMA_b is signalled.
* 4.  Resume task 4 from the suspended state.
*     Task 4 is a lower priority therefore no task switch.
* 5.  Suspend task 5 and self.
*     Once allowed to run due to resume ESR from task 4.
* 6.  Pend the named semaphore (SEMA_c) and wait for named semaphore (SEMA_d).
*     Once semaphore SEMA_d is signalled.
* 7.  Terminate task 5 and self.
*******************************************************************************
tsk3    ldaa   #T5        execute task 5
        swi
        FCB    .execute.

        ldd    #msgT3
        std    tstmsg+4   set up address of char string on msg body
        ldaa   #T4        send message to task 4
        clrb              use task semaphore
        ldx    #tstmsg
        swi
        FCB    .sendw.

        ldaa   #TESTQ_2
        ldx    #qdestn   set up destination address
        swi
        FCB    .deque.

        ldaa   #msglen
        ldx    #msgT3
        ldy    #qdestn   set up source & destination addresses
cmploop ldab   0,x
        cmpb   0,y
        bne    failT3
        inx
        iny
        deca
        bne    cmploop

        ldab   #SEMA_b    wait for semaphore B
        swi
        FCB    .wait.

        ldaa   #T4       set up to resume task 4
        swi
        FCB    .resume.

        ldaa   #T5       set up to suspend task 5
        swi
        FCB    .suspend.

        clra             set up to suspend self
        swi
        FCB    .suspend.

       ldab    #SEMA_C   pend on semaphore C
       swi
       FCB    .pend.

       ldab    #SEMA_D   wait on semaphore D
       swi
       FCB    .wait.

       ldaa    #T5       terminate task 5
       swi
       FCB    .terminate.

       clra              terminate self
       swi
       FCB    .terminate.

failT3 stop              halt if matchup fails

msgT3  FCC     "ABCDE"
msglen equ     *-msgT3

*******************************************************************************
*task 4 todo's:
* 1.  Wait on message from task 3. Strip bytes from message.
* 2.  Enqueue stripped bytes into queue 2.
* 3.  Signal the named semaphore (MSEMA).
*     This will cause a task switch due to task 3 (waiting on MSEMA) is
*     a higher priority task.
* 4.  Purge the timer setup by task 5.
*     Once allowed to run again due to resume from task 3.    
* 6.  Signal named semaphores (SEMA_c) and (SEMA_d) and allow task 3 to run.
*     Since task 3 is a higher priority we will do a task switch.
* 7.  Setup a 10 second timer. Cause task 2 to execute from start.
*     Since task 2 is a higher priority we will do a task switch. 
*     Notice since we are executing task 2, which jumps to start of task 2
*     we are actually starting the whole test over. But item 8. below did not
*     run. However it will run as soon as the delay in task 2 is started.
*     Since no other task is in the run state except task 4. We will run
*     the terminate in item 8, once the delay of task 2 is started, and
*     then go to the null task.
* 8.  Terminate self.
*
******************************************************************************
tsk4    clra               set up to receive highest priority message
         swi
         FCB    .receive.  receive the message from task 3

         stx    savptr     save ptr to message
         ldx    MBODY,x        get address of test text string
         ldaa   #TESTQ_2   enqueue to queue 2
         swi
         FCB    .enque.

         ldx    savptr     restore message address
         ldab   MSEMA,x        get semaphore number to signal
         swi
         FCB    .signal.

         ldaa   #T5        Purge the 10 second timer set up by
         clrb               task 5 and using the task semaphore.
         ldx    #1
         swi
          FCB   .purge.

         clra
         swi
         FCB    .suspend.        suspend self

         ldab   #SEMA_C    signal semaphore C
         swi
         FCB    .signal.

         ldab   #SEMA_D    signal semaphore D
         swi
         FCB    .signal.

         ldaa   #T3        resume task 3
         swi
         FCB    .resume.

         clra
         clrb
         ldx    #10000/49  Set up a 10 second timer for self.
         swi               This timer should disappear when the
          FCB   .timer.      task is terminated.

         ldaa   #T2        execute task 2
         swi
         FCB    .execute.
 
         clra              terminate task 4 (self)
         swi
         FCB    .terminate.

******************************************************************************

*task 5 todo's:
* 1.  Setup a 10 second timer and cause task 4 to be runnable.
* 2.  Signal named semaphore (SEMA_a). Enqueue data to Queue 1.
******************************************************************************
tsk5     clra
         clrb
         ldx    #10000/49
         swi               Set up a 10 second timer for self. This timer
          FCB   .timer.     will be purged by task 4.

         ldaa   #T4        execute task 4
         swi
         FCB    .execute.

         ldab   #SEMA_a    signal semaphore a
         swi
         FCB    .signal.

         ldy    #lisT5     pointer to list of characters
enqloop  ldx    0,y        get next char from list
         iny
         ldaa   #TESTQ_1   enqueue to queue 1
         swi
         FCB    .enque.

         xgdx
****(V1.4 #1) ****
         cmpa   #ENDOFQ    look for end of queue                          |
         bne    enqloop
         
         stop              should never get here.

lisT5    FCC    "ZYX$"

*******************************************************************************
*   Now set up the starting addresses in the TCB                              *
*******************************************************************************
* Be sure to download SYSTEM.S19 into the EVM before loading the TEST.S19
* file. This will assure that the starting addresses will be overlayed into
* the task control blocks properly. These addresses are set up to the task 
* number in SYSTEM.AS file and therfore are not runnable.
******************************************************************************
         ORG  $E014
         FDB  tsk2

         ORG  $E01B
         FDB  tsk3

         ORG  $E022
         FDB  tsk4

         ORG  $E029
         FDB  tsk5

