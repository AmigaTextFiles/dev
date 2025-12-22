## BSD Socket Extension API

Most functions will return -2 if the bsdsocket.library is
not open.

---

## Setup

#### ADDR=Socket Library Open

Try to open bsdsocket.library version 4.

##### Returns

* 0 if opening failed
* Memory address of library on success
  * If needed, you'll be able to directly access library functions
    using this address.

---

#### Socket Library Close

Close bsdsocket.library. This is safe to call if the library
is not open

---

#### RESULT=Socket Set Nonblocking(Socket, IsNonblocking BOOL)

Make a socket blocking (False, default), or nonblocking (True).

##### Returns

* Result of IoctlSocket call.

---

#### RESULT=Socket Reuse Addr(Socket)

Make a listening socket reuse the address it's trying to bind to.
You probably want to call this right before Socket Listen.

##### Returns

* Result of setsockopt call.

---

## Connections

#### SOCKET=Socket Create Inet Socket

Create a new Internet socket for reading or writing.

##### Returns

* Socket number on success
* -1 on failure

---

#### RESULT=Socket Connect(Socket to IPAddress$, Port)

Attempt to connect to a remote IP address.

##### Emulation vs. Physical/FPGA Amiga note

On emulated Amigas (FS-UAE) with emulated `bsdsocket.library`, a failure in
`Socket Connect` due to giving the function a bad IP address allows you to reuse
the socket. On real or FPGA-based Amiga running real TCP/IP stacks (MiamiDX,
Roadshow), the socket will be made unusable and you'll need to
`Socket Close Socket` and reopen the socket with whatever parameters necessary.
Closing and opening `bsdsocket.library` has the same effect.

Always close and re-open a socket if you have any `Socket Connect` failure and
any non-blocking polling loops time out!

##### Returns

* 0 on connected
* -1 on error
  * If your socket is non-blocking, you have to check
    the socket with Socket Select and Socket Getsockopt Int
    to see if the connection succeeded
* -11 port out of range
* -13 IP address has zero length

---

#### RESULT=Socket Reuse Addr(Socket)

Set a server socket to reuse an interface and port that had
been used recently. You likely want this if you're building
something that listens on a port for connections. This calls
`setsockopt()` for you.

##### Returns

The result of calling setsockopt() while setting your socket
to reuse addresses.

---

#### RESULT=Socket Bind(Socket to IPAddress, Port)

Attempt to bind a socket to a network interface. Use
the string "IPADDR_ANY" for IPAddress to bind to all
interfaces.

##### Returns

* 0 on success
* -1 on other error
* -11 port out of range

---

#### RESULT=Socket Listen(Socket)

Start listening for connections.

##### Returns

* 0 on success
* -1 on failure

---

#### NEW_SOCKET=Socket Accept(Socket)

Get the socket that connected to this one. Wait for a connect
if this socket is blocking.

##### Warning

If this socket is blocking (the default), you will likely
get AMOS stuck in a state you can't recover from, due to
how AMOS takes over system signals! Be sure to make your
socket non-blocking and use Fdsets and Select!

##### Returns

* The remote socket number on success
* -1 on failure

---

#### RESULT=Socket Wait Async Reading(Socket, Wait_ms)

Wait the given number of milliseconds for the nonblocking socket to be ready for reading.
Use on a listen socket to await new connections, or on a connected socket to await
incoming data packets.

##### Returns

* 0 on timeout.
* -1 on error. Use `Socket Errno` for more detail.
* 1 on success.

---

#### RESULT=Socket Wait Async Writing(Socket, Wait_ms)

Wait the given number of milliseconds for the nonblocking socket to be ready for writing.
Use this when you're connecting to a remote server and want to know if the connection
has been completed.

##### Returns

* 0 on timeout.
* -1 on error. Use `Socket Errno` for more detail.
* -3 on the socket having an error.
  * If you're using this function to test for a successful connection and
    receive a -3, close and reopen the socket, otherwise subsequent
    checks will return 1.
* 1 on success.

---

#### RESULT=Socket Set Timeout(Socket, Wait_ms)

Set a socket to timeout after Wait_ms milliseconds if reading or writing doesn't complete.

##### Returns

* 0 on success
* -1 on error

---

#### RESULT=Socket Close Socket(Socket)

Close a socket.


##### Returns

* 0 on success
* -1 on error

---

## Data Transfers

#### SENT=Socket Send$(Socket, String$)

Send a string to a connected socket.

##### Bugs

For some reason, this command performs incorrectly when
used in a Procedure to send a passed-in variable,
and Varptr() is not called on the string variable to be sent
beforehand within the procedure itself. I believe this is
a bug in AMOS itself. You'll know you're having this issue if
the byte count returned is abnormally high.

If you're using this in a Procedure, call Varptr() first:

```
Procedure SEND_STRING[SOCKET, S$]
  ' _shrug_
  _=Varptr(S$)

  BYTES=Socket Send$(SOCKET,S$)
End Proc
```

##### Returns

* Number of characters sent
* -1 on other error

---

#### SENT=Socket Send(Socket, Data Pointer, Length)

Send a block of data to a connected socket.

##### Returns

* Number of characters sent
* -1 on other error

---

#### DATA$=Socket Recv$(Socket, MaxLength)

Retrieve at most MaxLength bytes from Socket, and put them into a string.
If Len(DATA$) < MaxLength, you've read the last bit of data from the socket.

##### Returns

* String of data, which is blank if there is no more data.

---

#### LENGTH=Socket Recv(Socket to Dataptr, MaxLength)

Retrieve at most MaxLength bytes from Socket, and put them into the memory
address at Dataptr.

#### Returns

* Count of bytes read
* -1 on error

---

## Informational

#### HOST=Socket Get Host(Socket)

Get the IPv4 (Long) host value the given socket is using.

##### Returns

* Host as a long value

---

#### PORT=Socket Get Port(Socket)

Get the 16-bit port (Word) value the given socket is using.

##### Returns

* Port as a word value

---

#### RESULT$=Socket Inet Ntoa$(Host)

Turn a long Host address into a string.

##### Returns

* IP address as string

---

#### RESULT=Socket Errno

Get the error from the last command. Note that this is
not cleared on a successful command!

##### Returns

Error number from last call. Look in <sys/error.h> for more
details.

---

#### RESULT=Socket Herrno

Get the error from the last DNS resolver command.

##### Returns

Resolver error number (`h_errno`) from last call.

---

#### RESULT$=Dns Get Address By Name$(Domain Name$)

Look up the first IP address associated with this hostname.

##### Warning

This is dependent on your stack's name resolution. If DNS lookups
aren't working correctly, you may have to wait for the lookup to time
out. There's no way to set this timeout, or cancel or override it via AMOS.

##### Returns

String with IP address, or blank string on error.


## Low Level

#### RESULT=Socket Setsockopt Int(Socket, Option, Value)

Set a socket option. You probably want SO_REUSEADDR,
which is Option=$4, and you want Value=True. Or, use
Socket Reuse Addr().

##### Returns

* Result of setsockopt call

---

#### RESULT=Socket Getsockopt Int(Socket, Option)

Get a socket option. You probably want SO_ERROR,
which is Option=$1007, and it's what you check when you
attempt a connection with a non-blocking socket.

##### Returns

* Result of getsockopt call

---

#### ADDR=Socket Fdset Zero(fd_set)

Clear out the specified fd_set.

##### Returns

* Address to that particular fd_set
* -1 if fd_set out of range. You get 16 of them.

---

#### ADDR=Socket Fdset Set(fd_set, Socket to Value BOOL)

Set or clear a socket bit in an fd_set.

##### Returns

* Address to that particular fd_set
* -1 if fd_set is out of range or socket is out of range.

#### RESULT=Socket Fdset Is Set(fd_set, Socket)

See if the particular socket remained after a Socket Select call.

##### Returns

* True or False if the socket is set or not

#### RESULT=Socket Select(Max Socket, Read fd_set, Write fd_set, Error fd_set, TimeoutMS)

Wait for the specified number of milliseconds. If any of the sockets
in any of the fd_sets become interesting during that time, stop
waiting, clear out the uninteresting sockets in the fd_sets, and return
how many sockets were left.

##### Returns

* 0 on timeout
* -1 on error
* # of interesting sockets on success
