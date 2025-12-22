# AMOS Professional BSD Socket Extension

Want to get online with your AMOS Professional program? Now you can in style!

This extension provides a wrapper around the BSD Socket library
provided by your Internet stack for use with AMOS Professional. There's some
attempt to roll up some of the low-level functionality into something more
usable by AMOS.

## Installation

* Copy `AMOSPro_BSDSocket.Lib` to `AMOSPro_System:APSystem/`
* Within AMOS Professional:
  * Config -> Set Interpreter
  * Load Default Configuration
  * Set Loaded Extensions
  * Extension Slot 18 -- `AMOSPro_BSDSocket.Lib`
  * Exit
  * Save Configuration
  * Restart AMOS Professional
  * Type in the following and Run:

    ```
    Print Socket Library Open
    ```

    The line should tokenize, and running it should print -1 if you have no
    Internet stack running, or a large number if you do.

## Examples

### Communicating with an HTTP server

``` basic
LIB=Socket Library Open

If LIB<=0
   End
End If

SOCKET=Socket Create Inet Socket
_=Socket Set Nonblocking(SOCKET,True)

' connect to aminet.net
IP$=Dns Get Address By Name$("aminet.net")
ALREADY_CONNECTED=Socket Connect(SOCKET To IP$,80)

Reserve As Work 30,1024

For I=1 To 100
   If ALREADY_CONNECTED=-1
      RESULT=Socket Wait Async Writing(SOCKET,100)
      If RESULT=-3
         Print "Socket connect failure!"
         Exit
      End If

      If RESULT>0
         ALREADY_CONNECTED=0
      End If
   End If

   If ALREADY_CONNECTED=0
      HTTPGET$="GET / HTTP/1.0"+Chr$(10)+"Host: amiga"+Chr$(10)+Chr$(10)
      Print "Making HTTP request to aminet.net"
      _=Socket Send(SOCKET,Varptr(HTTPGET$),Len(HTTPGET$))

      For J=1 To 100
         RESULT=Socket Wait Async Reading(SOCKET,5000)
         If RESULT>0
            OUT=Socket Recv(SOCKET To Start(30),1024)
            _DATA$=""
            For K=0 To OUT-1
               _DATA$=_DATA$+Chr$(Peek(Start(30)+K))
            Next K
            Print _DATA$
            If OUT<1024
               Exit 2
            End If
         End If
      Next J
      Exit
   End If
Next I

Socket Library Close
```

### Starting a server

``` basic
If Socket Library Open<=0
   End
End If

SOCKET=Socket Create Inet Socket

_=Socket Set Nonblocking(SOCKET,True)
_=Socket Reuse Addr(SOCKET)

RESULT=Socket Bind(SOCKET To "INADDR_ANY",8000)

_=Socket Listen(SOCKET)
Print "listening on port 8000"

For I=1 To 100
   RESULT=Socket Wait Async Reading(SOCKET,500)

   If RESULT>0
      _REMOTE_SOCKET=Socket Accept(SOCKET)

      Print Socket Inet Ntoa$(Socket Get Host(_REMOTE_SOCKET))
      Print Socket Get Port(_REMOTE_SOCKET)

      Print Socket Recv$(_REMOTE_SOCKET,1024)

      Exit
   End If
   Wait Vbl
Next I

Socket Library Close
```

## Who's using the extension?

* [AQUABYSS](https://agedcode.com/agedcode/en/games/aquabyss)
  * As of April 2023, the extension's been in heavy use for over a month
    on the client side of the game.
* [Hop to the Top: Bunny's Revenge](https://rabbit.robsmithdev.co.uk/)
  * The game uses this extension to send and receive high score information.
    I also did some of the art for the game!
* [Gopherized](https://allanon71.itch.io/gopherized)

Doing something cool with the extension?
[Contact me](https://theindustriousrabbit.com/about) and I'll add it to the list!

## General Notes

* The BSD Socket library, and all sockets, will close automatically when the program
  runs again. Sockets will stay open after stopping you code so you can
  debug issues from the AMOS console.
* Since AMOS takes over Ctrl-C handling, you have to continually
  poll for socket statuses on nonblocking sockets. Trying to use
  a blocking socket will likely cause AMOS to hang indefinitely!
  * Using the Wait Async functions with small timeouts are the
    most system-friendly way of doing this.
* MiamiDX can be fiddly, at least it is on my MiSTer set up.
  If Internet connectivity is not working, try re-connecting to the network.
* If using Roadshow, `bsdsocket.library` will always be available, so
  you can't use its presence or lack thereof to test if Internet is available.
  You'll have to use a combination of DNS lookups and/or connection
  timeouts using `Socket Async Wait Writing` to determine if the Internet
  is available.

## Versioning

This project uses semantic versioning.

* If the major number increases, API has changed.
* Otherwise, the extension's API should be backwards compatible.

## License

Copyright 2023-2024 John Bintz. Licensed under the MIT License.

If you use this in your project, and you really want to,
throw a link to theindustriousrabbit.com somewhere! You can
also find a donate link on
[the About section on The Industrious Rabbit](https://theindustriousrabbit.com/about).

## Feedback? Bug reports? Patches?

First, run `test/TestSuite` to generate a `report.txt` file.

Then, go to the [About section on The Industrious Rabbit](https://theindustriousrabbit.com/about)
to contact me, send the `report.txt` along with the details on your issue.

## Changelog

### 1.0.0 (2023-04-01)

* First public release

### 1.0.1 (2023-04-04)

* Fix bug in Socket Wait Async Writing where result of getsockopt was
  incorrectly used.

### 1.1.0 (2024-02-23)

* Fix bug in `Dns Get Host Address By Name$` where it assumed AMOS strings are
  null-terminated. They are not.
* Add `Socket Herrno` to aid in debugging resolver errors.

### 1.1.1 (2024-03-17)

* Fix bug in `Socket Inet Ntoa$` where the null terminator on the result of
  calling `Inet_NtoA` was being included in the AMOS string.
* Fix crash bug in `Socket Inet Ntoa$` if called with the BSD Socket library
  was not open.

### 1.1.2 (2024-03-18)

* Fix all functions that return strings so that strings work properly
  in AMOS. While you could kind of use the immediate return value of the
  string, any future manipulation of that string would fail. This fixes
  the following functions:
  * `Socket Inet Ntoa$`
  * `Dns Get Address By Name$`
  * `Socket Recv$`

### 1.1.3

Internal release.

### 1.1.4 (2024-05-02)

* Fix bug in fdset macro where using D3 for a parameter could cause corruption.
* Copy a null-terminated copy of IP address for `SocketIPAddressPortToSockaddr`.
* Add test suite to exercise extension functionality.
* Fix several crash bugs found due to the test suite.
* Retructure API docs for easier reading.
* Improve build and release tooling.

## Development

### Environment

#### Native Amiga

* Clone the [AMOS Professional source code](https://github.com/AOZ-Studio/AMOS-Professional-Official)
  * Copy `AMOSPro Sources/+lequ.s` to `+LEqu.s`
* Generate the socket LVO file in the `src` directory
  * Install [`fd2pragma`](https://aminet.net/package/dev/misc/fd2pragma) in your path
  * Download `https://raw.githubusercontent.com/cnvogelg/amitools/master/amitools/data/fd/bsdsocket_lib.fd` to `src`
  * In a Shell:

    ```
    cd src
    fd2pragma bsdsocket_lib.fd to "" special 20
    ```

* Fix up `src/absdsocket` to match your system's setup
* In a Shell:

```
cd src
execute absdsocket
```

#### Emulated setup (WinUAE, FS-UAE, Amiberry)

Run `bin/setup` to do most of the setups above.

### Debugging

#### Cross-platform

Modify data in the `DebugArea` and read it by `Peek`/`Deek`/`Leek`ing from
the base address provided by `Socket Get Debug Area`.

#### WinUAE/FS-UAE

In the debugger, set a memory breakpoint at `$100` for two written bytes:

```
w 0 100 2
```

Then, in your code, clear those two bytes to stop execution at that point:

```asm
  CLR.W $100
```

### Releasing

#### Ubuntu/Debian

* Install `jlha-utils` and a modern enough Java to run it
* Install Ruby
* Run `bin/release`
