*ESREQU.AS
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

