OPT MODULE

MODULE  'amigalib/ports',
        'dos/dos',
        'exec/memory',
        'exec/nodes',
        'exec/ports',

        'oomodules/object'

EXPORT ENUM RCMD_ADD, RCMD_REMOVE, RCMD_INFO,
            RCMD_END, RCMD_GETRESOURCE

EXPORT OBJECT resourceMessage
/****** /resourceMessage ******************************

    NAME
        resourceMessage

    ATTRIBUTES
        msg:mn -- normal exec message node

        command:LONG -- the command sent to the master

        resource:LONG -- the resource that sends this message

        data:LONG -- any data that is required for the execution of that
            command. Leave NIL if unused.

    CREATION
        October 16 1995 Gregor Goldbach

    HISTORY
        November 1 1995 Gregor Goldbach
          Removed the remove-and-end stuff from resource.end() and put it in
          the command evaluation of the master program. end() does now only
          END the object of this resource.

        December 10 1995 Gregor Goldbach
          Added parent attribute. This could make the handling of the
          resources a bit easier. The Resource master should be able to sort
          the resources by this parent entry. It's the object that allocated
          the owner object. For example, take the eSource object. There are
          a number of eVar and eObjects allocated as well as some other
          stuff. The Resource Master can display/calculate the memory
          devoured by an eSource object by looking at the parent. It should
          be same value for every eVar etc.

          The bad thing about this is that the parent attribute has to be set
          when NEWing an object. This *has* to be done explicitly. Maybe a
          default entry for the option list passed to new() could be "prnt".


          Added getLastxxx() methods. These get an attribute from the last
          message that was sent to the Resource Master or the message itself.
          The new() and end() methods of Object could now be extended by some
          calls to resource methods:

            in new()

            NEW resource.new([self,FindTask(NIL),0]) ->add to Resource List


            in end()

            NEW dummyResource.new()

           /*
            * Get resource of myself. That way I don't have to store it
            */

            dummyResource.sendMessageToMaster(RCMD_GETRESOURCE, self)
            resourceOfMyself := dummyResource.getLastData()

           /*
            * END my resource. CAUTION: do *not* do this by now.
            * end() of resource calls end() of object, so this would result
            * in a deadlock. Simply remove the END self.owner from end() of
            * resource.
            */

            dummyResource.sendMessageToMaster(RCMD_END, resourceOfMyself)

           /*
            * end the dummy resource
            */

            dummyResource.sendMessageToMaster(RCMD_END, resourceOfMyself)


          NOTE: The behaviour outlined above is not aware of the parent. That
          one should get a not on the death of it's child, don't you think?
********/
  msg:mn
  command
  resource
  data
ENDOBJECT

EXPORT OBJECT resource
/****** resource/--resource-- ******************************************

    NAME 
        resource

    ATTRIBUTES
        owner -- What this resource represents. This should be the pointer to
            an object.

        task -- The task that created this resource/object.

        flags -- Special flags.

        parent:PTR TO object -- The parent object of owner. Used for
            grouping. It's the object that NEWs the owner object.

    CREATION
        October 16 1995 Gregor Goldbach

    HISTORY
        October 19 1995 Gregor Goldbach
          Added RMCD_END -- Performs an END on the resource. Use carefully!

    NOTES
        The first attempt to implement this resource tracking system failed.
        It used a queuestack of which the address was put to an ENV var.
        The client read it and called addLast() and so on.

        This version uses the Amiga's message port system. That means that
        this basic element of the object library is NOT portable. However,
        the user does not know that this system is there, so without
        changing a single line of code this system can be removed from the
        library without any problems.

        IMPORTANT: Each resource definitely HAS to be ended via END. Because
        of the internal handling of objects in Amiga E one can't simply wait
        till Amiga E ends them automatically.

        Implemented commands:
            RCMD_ADD -- Add resource to tracking list.

            RCMD_REMOVE -- Remove resource from tracking list.

            RMCD_INFO -- Get number of resources being tracked. This command
                may disappear in the future.

            RCMD_END -- Perform an END on the object represented by the
                resource after removing it from the list. Use carefully!

*************/

  owner:PTR TO object -> to whom I belong
  task
  flags
  parent:PTR TO object
ENDOBJECT




DEF replyport:PTR TO mp,
    msg:PTR TO resourceMessage,
    reply:PTR TO resourceMessage

EXPORT PROC initializeResourceTracking()
/****** /initializeResourceTracking ******************************

    NAME
        initializeResourceTracking() -- Initialization

    SYNOPSIS
        initializeResourceTracking()

    FUNCTION
        Initializes the resource tracking system. On the Amiga this means that
        the reply port for the messages is created and the message itself is
        created.

    SEE ALSO
        removeResourceTracking()

********/
  -> Using createPort() with no name because this port need not be public.

  IF NIL=(replyport:=createPort(NIL, 0)) THEN Raise(0)

  msg:=NewM(SIZEOF resourceMessage, MEMF_PUBLIC OR MEMF_CLEAR)
  msg.msg.ln.type:=NT_MESSAGE       -> Make up a message, including the
  msg.msg.length:=SIZEOF resourceMessage  -> reply port.
  msg.msg.replyport:=replyport

ENDPROC

PROC new(list=NIL) OF resource
/****** resource/new ******************************

    NAME
        new() of resource -- Create new instance of resource.

    SYNOPSIS
        resource.new(LONG=NIL)

        resource.new(list)

    FUNCTION
        Sends a message to the master about being added to the global
        resource list. If the tracking system hasn't been set up it does
        this first.

    INPUTS
        list:LONG -- used for compatibility with Object. An elist of three
            or four items: object, task, flags and parent.

    NOTES
        The list parameter is used for compatibility with Object's new().
        Makes everything look more homogeneous. May vanish in the future
        or be modified.

    SEE ALSO
        resource, initializeResourceTracking()
******************************************************************************

History


*/

  IF replyport=NIL THEN initializeResourceTracking()
  IF replyport=NIL THEN Throw("ReTr", {rtCouldNotBeInstalled})

  IF list
    self.owner := ListItem(list,0)
    self.task := ListItem(list,1)
    self.flags := ListItem(list,2)
    IF ListLen(list=4) THEN self.parent := ListItem(list,3)
  ENDIF

  self.sendMessageToMaster(RCMD_ADD)

ENDPROC

PROC end() OF resource
/****** resource/end ******************************

    NAME
        end() of resource -- Destructor

    SYNOPSIS
        resource.end()

    FUNCTION
        Removes itself from the global resource list by sending a message
        to the master about this. If the list is empty after removing
        itself the tracking system is removed, too. The object that is
        represented by this resource is ENDed.

        There may be a notification of the task in the future so make sure
        the task and flags attributes are not changed.

    NOTES
        It is possible to initialize end remove the tracking system multiple
        times.

    SEE ALSO
        new(), initializeResourceTracking(), removeResourceTracking(),
        resource

********/
->  WriteF('About to remove.\n')
->  self.sendMessageToMaster(RCMD_REMOVE)
->  WriteF('About to get info.\n')

->  self.sendMessageToMaster(RCMD_INFO)

->  WriteF('About to .\n')

->  IF reply.data = 0 THEN removeResourceTracking()


  IF self.owner THEN END self.owner

ENDPROC

EXPORT PROC sendMessageToMaster(command,data=NIL) OF resource
/****** resource/sendMessageToMaster ******************************

    NAME
        sendMessageToMaster() of resource --

    SYNOPSIS
        resource.sendMessageToMaster(LONG, LONG=NIL)

        resource.sendMessageToMaster(command, data)

    FUNCTION
        A message is sent to the resource master. The command defines the
        kind of this message.

    INPUTS
        command:LONG -- The command to send
            RCMD_ADD -- Add resource to list
            RCMD_REMOVE -- Remove resource from list
            RCMD_INFO -- Get info about list. This means that the data
                entry of the reply contains the number of resource
                currently being tracked.

        data:LONG -- Any data that may be required for the execution of the
        command.

    NOTES
        Uses {resourcePortName} as the port's name.

    SEE ALSO
        new(), end()
******************************************************************************/


  msg.command := command
  msg.resource := self
  msg.data := data

->  IF FALSE=safePutToPort(xymsg, {resourcePortName}) THEN Raise(ERR_FINDPORT)

  safePutToPort(msg, {resourcePortName})

  WaitPort(replyport)
  IF reply:=GetMsg(replyport)
    -> We don't ReplyMsg since WE initiated the message.
  ENDIF

ENDPROC

EXPORT PROC removeResourceTracking()
/****** resource/removeResourceTracking ******************************************

    NAME
        removeResourceTracking() -- Remove the tracking system.

    SYNOPSIS
        removeResourceTracking()

    FUNCTION
        By the call to this proc the resorce tracking system is removed from
        memory.

    NOTES
        Is is possilbe to call initializeResourceTracking() and
        removeResourceTracking() a number of times in one program.
        You may, however, only call initializeResourceTracking() after
        removing the system.

    SEE ALSO
        initializeResourceTracking()
******************************************************************************

History


*/

  IF msg THEN Dispose(msg)  -> E-Note: not really necessary
  IF replyport THEN deletePort(replyport)

  replyport := msg := NIL

ENDPROC

PROC safePutToPort(message, portname)
/****** resource/safePutToPort ******************************************

    NAME 
        safePutToPort() -- Put message to port safely.

    SYNOPSIS
        safePutToPort(LONG, LONG)

        safePutToPort(message, portname)

    FUNCTION
        Puts a message to a port only if the port exists.

    INPUTS
        message -- normal exec message. Has to be initialized.

        portname:PTR TO CHAR -- Name of the port to put the message in.

    RESULT
        TRUE if the port did exist, FALSE otherwise.

******************************************************************************

History


*/
  DEF port:PTR TO mp
  Forbid()
  port:=FindPort(portname)
  IF port THEN PutMsg(port, message)
  Permit()
  -> Once we've done a Permit(), the port might go away and leave us with an
  -> invalid port address.  So we return just a boolean to indicate whether
  -> the message has been sent or not.
  -> E-Note: Be careful - if FindPort() automatically raised an exception
  ->         you might forget to Permit()!
ENDPROC port<>NIL  -> FALSE if the port was not found

EXPORT PROC getLastMessage() OF resource
/****** resource/getLastMessage ******************************

    NAME
        getLastMessage() of resource -- Get the last message worked with.

    SYNOPSIS
        resource.getLastMessage()

    FUNCTION
        Returns the last Resource Message the master worked on.

    RESULT
        PTR TO resourceMessage

    EXAMPLE

    CREATION
        December 10 1995 Gregor Goldbach

    NOTES

    SEE ALSO
        resource, getLastCommand(), getLastData()

********/
  RETURN msg
ENDPROC

EXPORT PROC getLastCommand() OF resource
/****** resource/getLastCommand ******************************

    NAME
        getLastCommand() of resource -- Get the last command sent to the
            master.

    SYNOPSIS
        resource.getLastCommand()

    FUNCTION
        Returns the last Resource Message's command.

    RESULT
        LONG -- last command

    CREATION
        December 10 1995 Gregor Goldbach

    SEE ALSO
        resource, getLastMessage(), getLastData()
********/
  RETURN msg.command
ENDPROC

EXPORT PROC getLastData() OF resource
/****** resource/getLastData ******************************
    NAME
        getLastData() of resource -- Get the last data sent to the master.

    SYNOPSIS
        resource.getLastData()

    FUNCTION
        Returns the last Resource Message's data the master worked on.

    RESULT
        LONG -- data attribute of the last messagesent to the Resource
            Master.

    CREATION
        December 10 1995 Gregor Goldbach

    SEE ALSO
        resource, getLastCommand(), getLastMessage()
********/
  RETURN msg.data
ENDPROC

EXPORT PROC getLastResource() OF resource
/****** resource/getLastResource ******************************
    NAME
        getLastMessage() of resource -- Get the last message worked with.

    SYNOPSIS
        resource.getLastMessage()

    FUNCTION
        Returns the last Resource Message the master worked on.

    RESULT
        PTR TO resourceMessage

    EXAMPLE

    CREATION
        December 10 1995 Gregor Goldbach

    NOTES

    SEE ALSO
        resource, getLastCommand(), getLastData()

********/
  RETURN msg.resource
ENDPROC


rtCouldNotBeInstalled: CHAR 'Resource tracking could not be installed.',0
EXPORT resourcePortName: CHAR 'E-ResourceMaster',0
/*EE folds
-1
437 22 
EE folds*/
