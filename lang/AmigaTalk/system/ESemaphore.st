" ---------------------------------------------------------------------- "
" The ESemaphore class implements exec.library semaphore functions into  "
" AmigaTalk.  This Class is NOT the same as the Semaphore Class in       "
" AmigaTalk:General/Semaphore.st                                         "
" ---------------------------------------------------------------------- "

Class ESemaphore :Object ! private semMsgObj !
[
   create: semName priority: semaphorePriority
      ^ private <- <primitive 209 5 1 semName semaphorePriority>
|
   dispose
      <primitive 209 5 0 private>.
      private <- nil
|
   getESemaphore
      ^ private
|
   createSemaphoreMsg: signalSemaphoreObj
      ^ semMsgObj <- <primitive 209 5 2 signalSemaphoreObj>
|
   disposeSemaphoreMsg
      <primitive 209 5 0 semMsgObj>
|
   getSemaphoreMessage
      ^ semMsgObj
|
   obtainSharedSemaphore: signalSemaphoreObj
      " A lock on a signal semaphore may either be exclusive, or shared.
      * Exclusive locks are granted by the obtainSemaphore: and
      * attemptSemaphore: methods.  Shared locks are granted by
      * obtainSemaphoreShared:.  Calls may be nested.
      *
      * Any number of tasks may simultaneously hold a shared lock on a
      * semaphore.  Only one task may hold an exclusive lock.  A typical
      * application is a list that is often read, but only occasionally
      * written to.
      *
      * Any exlusive locker will be held off until all shared lockers
      * release the semaphore.  Likewise, if an exlusive lock is held,
      * all potential shared lockers will block until the exclusive lock
      * is released.  All shared lockers are restarted at the same time.
      "
      <primitive 209 4 80 signalSemaphoreObj>
|
   procure: signalSemaphoreObj msg: semaphoreMsgObj
      " This method is used to obtain a semaphore in an async manner.
      * Like obtainSemaphore:, it will obtain a SignalSemaphore for you
      * but unlike obtainSemaphore:, you will not block until you get
      * the semaphore.  procure:msg: will just post a request for the semaphore
      * and will return.  When the semaphore is available (which could
      * be at any time) the bidMessage will ReplyMsg() and you will own
      * the semaphore.  This lets you wait on multiple semaphores at once
      * and to continue processing while waiting for the semaphore.
      *
      * NOTE:  Pre-V39, Procure() and Vacate() did not work correctly.
      * They also did not operate on SignalSemaphore semaphores.
      * Old (and broken) MessageSemaphore use as of V39 will no longer work.
      "
      ^ <primitive 209 4 63 signalSemaphoreObj semaphoreMsgObj>
|
   vacate: signalSemaphoreObj msg: semaphoreMsgObj
      " This method can be used to release a semaphore obtained via
      * procure:msg:.  However, the main purpose for this call is to be
      * able to remove a bid for a semaphore that has not yet responded.
      * This is required when a Procure() was issued and the program
      * no longer needs to get the semaphore and wishes to cancel the
      * Procure() request.  The canceled request will be replied with
      * the ssm_Semaphore field set to NULL.  If you own the semaphore,
      * the message was already replied and only the ssm_Semaphore field
      * will be cleared.
      *
      * NOTE:  Pre-V39, Procure() and Vacate() did not work correctly.
      * They also did not operate on SignalSemaphore semaphores.
      * Old (and broken) MessageSemaphore use as of V39 will no longer work.
      "
      <primitive 209 4 64 signalSemaphoreObj semaphoreMsgObj>
|
   initSemaphore: signalSemaphoreObj
      " This method initializes a signal semaphore and prepares it for
      * use.  It does not allocate anything, but does initialize list
      * pointers and the semaphore counters.
      *
      * Semaphores are often used to protect critical data structures
      * or hardware that can only be accessed by one task at a time.
      * After initialization, the address of the SignalSemaphore may be
      * made available to any number of tasks.  Typically a task will
      * try to obtainSemaphore:, passing this address in.  If no other
      * task owns the semaphore, then the call will lock and return
      * quickly.  If more tasks try to obtainSemaphore:, they will
      * be put to sleep.  When the owner of the semaphore releases
      * it, the next waiter in turn will be woken up.
      *
      * Semaphores are often preferable to the old-style Forbid()/Permit()
      * type arbitration.  With Forbid()/Permit() *all* other tasks are
      * prevented from running.  With semaphores, only those tasks that
      * need access to whatever the semaphore protects are subject
      * to waiting.
      "
      <primitive 209 4 65 signalSemaphoreObj>
|
   obtainSemaphore: signalSemaphoreObj
      " Signal semaphores are used to gain exclusive access to an object.
      * obtainSemaphore: is the method used to gain this access.  If another
      * user currently has the semaphore locked the call will block until
      * the object is available.
      *
      * If the current task already has locked the semaphore and attempts to
      * lock it again the call will still succeed.  A "nesting count" is
      * incremented each time the current owning task of the semaphore calls
      * obtainSemaphore:.  This counter is decremented each time
      * releaseSemaphore: is called.  When the counter returns to zero the
      * semaphore is actually released, and the next waiting task is called.
      *
      * A queue of waiting tasks is maintained on the stacks of the waiting
      * tasks.	Each will be called in turn as soon as the current task
      * releases the semaphore.
      *
      * Signal Semaphores are different than Procure()/Vacate() semaphores.
      * The former requires less CPU time, especially if the semaphore is
      * not currently locked.  They require very little set up and user
      * thought.  The latter flavor of semaphore make no assumptions about
      * how they are used -- they are completely general.  Unfortunately
      * they are not as efficient as signal semaphores, and require the
      * locker to have done some setup before doing the call.
      "
      <primitive 209 4 66 signalSemaphoreObj>
|
   releaseSemaphore: signalSemaphoreObj
      " releaseSemaphore: is the inverse of obtainSemaphore:. It makes
      * the semaphore lockable to other users.	If tasks are waiting for
      * the semaphore and this this task is done with the semaphore then
      * the next waiting task is signalled.
      *
      * Each obtainSemaphore: call must be balanced by exactly one
      * releaseSemaphore: call.  This is because there is a nesting count
      * maintained in the semaphore of the number of times that the current
      * task has locked the semaphore. The semaphore is not released to
      * other tasks until the number of releases matches the number of
      * obtains.
      *
      * Needless to say, havoc breaks out if the task releases more times
      * than it has obtained.
      "
      <primitive 209 4 67 signalSemaphoreObj>
|
   attemptSemaphore: signalSemaphoreObj
      " This call is similar to obtainSemaphore:, except that 
      * it will not block if the semaphore could not be locked.
      *
      * Returns true if the semaphore was locked, false if some
      * other task already possessed the semaphore.
      "
      ^ <primitive 209 4 68 signalSemaphoreObj>
|
   obtainSemaphoreList: listObj
      " Signal semaphores may be linked together into a list. This function
      * takes a list of these semaphores and attempts to lock all of them at
      * once. This call is preferable to applying obtainSemaphore: to each
      * element in the list because it attempts to lock all the elements
      * simultaneously, and won't deadlock if someone is attempting to lock
      * in some other order.
      *
      * This function assumes that only one task at a time will attempt to
      * lock the entire list of semaphores.  In other words, there needs to
      * be a higher level lock (perhaps another signal semaphore...) that is
      * used before someone attempts to lock the semaphore list via
      * obtainSemaphoreList:.
      *
      * Note that deadlocks may result if this call is used AND someone
      * attempts to use obtainSemaphore: to lock more than one semaphore on
      * the list.  If you wish to lock more than semaphore (but not all of
      * them) then you should obtain the higher level lock (see above)
      " 
      <primitive 209 4 69 listObj>
|
   releaseSemaphoreList: listObj
      " releaseSemaphoreList: is the inverse of obtainSemaphoreList:. It
      * releases each element in the semaphore list.
      *
      * Needless to say, havoc breaks out if the task releases more times
      * than it has obtained.
      "
      <primitive 209 4 70 listObj>
|
   findSemaphore: semaphoreName
      " This function will search the system signal semaphore list for a
      * semaphore with the given name.	The first semaphore matching this
      * name will be returned.
      *
      * This function does not arbitrate for access to the semaphore list,
      * surround the call with a Forbid()/Permit() pair.
      "
      ^ <primitive 209 4 71 semaphoreName>
|
   addSemaphore: signalSemaphoreObj
      " This method attaches a signal semaphore structure to the system's
      * public signal semaphore list.  The name and priority fields of the
      * semaphore structure must be initialized prior to calling this
      * method.  If you do not want to let others rendezvous with this
      * semaphore, use initSemaphore: instead.
      *
      * If a semaphore has been added to the naming list, you must be
      * careful to remove the semaphore from the list (via removeSemaphore:)
      * before deallocating its memory.
      *
      * Semaphores that are linked together in an allocation list (which
      * obtainSemaphoreList: would use) may not be added to the system
      * naming list, because the facilities use the link field of the
      * signal semaphore in incompatible ways
      "
      <primitive 209 4 72 signalSemaphoreObj>
|
   removeSemaphore: signalSemaphoreObj
      " This method removes a signal semaphore structure from the
      * system's signal semaphore list.  Subsequent attempts to
      * rendezvous by name with this semaphore will fail.
      "
      <primitive 209 4 73 signalSemaphoreObj>
|
   attemptSemaphoreShared: signalSemaphoreObj
      " This method is similar to obtainSharedSemaphore:, except that it
      * will not block if the semaphore could not be locked.
      "
      ^ <primitive 209 4 74 signalSemaphoreObj>
]
