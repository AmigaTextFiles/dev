libSPS++
Release Version 1.0                                                      10.09.2006
-----------------------------------------------------------------------------------
The libSPS++ library provides a simply C++ intercace to make the live easier for 
programmers, who want to write multithreaded application under AmigaOS4 using C++.

Classes included are:

class SPS_Thread                       Basic thread class
class SPS_Message                    Base class for message objects
class SPS_SyncMessageT<>     A synchronous message
class SPS_AsyncMessageT<>   An asynchronous message
class SPS_ExecMessage<>       A exec compatible message wrapper
class SPS_Hook                          A Hook object
class SPS_Exception                  Simple exception handling

as well as some additional macros to simplify opening and closing of interfaces 
(usually without the need to open a library speparately).

Please see the included html document and the example code for more details.

Note:

The html documentation contains syntax highlited source code. In my experience it 
works fine with AWeb, SimpleHTML and the SimpleHTML Datatype. IBrowse, however 
seems to not colorize the code correctly.

If you have question or want to contribute or submit bugs or feature requests,
please email at:

juergen AT cox DOT net

--
js
