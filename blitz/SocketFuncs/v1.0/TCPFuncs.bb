; This code has been modified so that bsdsocket.library now
; no longer needs to be set up in Blitz.
;
; Modifications v1.0
;
; Modifications made:
;
; All bsdsocket.library function calls replaced with their ASM
; equivalent.
; TCPFuncs must now open and close the bsdsocket.library itself.
; This is done in ConnectTCP{} and CloseTCP{}.
;
; Modifications by Roger Light <rogerlight@mindless.com> all other
; work done as stated below.
;
; If you have any problems with this code, I advised that you
; try the original TCPFuncs code to see if it is these modifications
; that are the problem. It may well be that these mods are at fault.
; Please don't contact me for support because I don't know much
; really and I will also have no access to an Amiga from the
; 11/10/99.
; If however you don't know what advantages this code gives you
; over the original TCPFuncs, but think you might need it, please
; feel free to contact me.

XINCLUDE TCPSocketIncs.bb2

;-----------------------------------------------------------
; Standard Blitz TCP Functions V1.8 by Paul Burkey (c)1997-1998
; Compiled with help from Ercole Spiteri and Anton Reinauer
; Contact me at burkey@bigfoot.com
;-----------------------------------------------------------
;History
;-------
;<16.2.97> Version 1.8
;Added NLPrintTCP{} for easy send string with carrage return and newline.
;Removed need for 3rd Party libs (only bsdsocket.library needed)
;
;<24.12.97> Version 1.7
;ReadTCP{} Updated with extra safety and Speed
;
;<18.9.97> Version 1.6
;Added PrintTCP{}  for an easy "send string" command.
;Added NPrintTCP{} for easy send string with carrage return
;CheckTCP{} merged into the ConnectTCP{} function.
;
;---------------
; Function List
;---------------
;
;ReadTCP{}                       ; Similar to Edit$() - recives data via TCP connection
;ReadMemTCP{ReadAdd.l,MaxSize.l} ; Similar to ReamMem - recives data via TCP connection
;WriteTCP{ad.l,size.w}           ; Similar to WriteMem - sends data via TCP connection
;ConnectTCP{host$,port.w}        ; Connect to a remote machine (Full error checking)
;PrintTCP{text$}                 ; Similar to Print - sends data via TCP connection
;NPrintTCP{text$}                ; Similar to NPrint - sends data via TCP connection
;NLPrintTCP{text$}               ; Similar to Print+CR+LF - sends data via TCP connection
;CloseTCP{}                      ; Closes TCP Connection

;---------------------------------
; TCP library Variables/Constants
;---------------------------------

#TCPBuflen=$2048                ;Maximum data size to read at any time
TCPmem.l=AllocMem(#TCPBuflen,0) ;Allocate the temp buffer used for all TCP reads
#FIONREAD=$4004667f             ;FIONREAD request

;---------------------------------
; Standard TCP library structures
;---------------------------------

NEWTYPE.list
  *ItemA.b
  *ItemB.b
End NEWTYPE
NEWTYPE.inaddr
  s_addr.l
End NEWTYPE
NEWTYPE.sockaddrin
  sin_len.b
  sin_family.b
  sin_port.w
  sin_addr.inaddr
  sin_zero.b[8]
End NEWTYPE
NEWTYPE.hostent
  *h_name.b
  *h_aliases.list
  h_addrtype.l
  h_lenght.l
  *h_addr_list.list
End NEWTYPE

;---------------------------------
; Standard TCP Blitz Functions
;---------------------------------

.ReadTCP
Function .s ReadTCP{}
  SHARED sock.l,TCPmem.l
  ;
  ; This Function reads data from the server the result is passed back in a
  ; string. If there is no messages then it will return an empty string =""
  ;
  sockread.l=0                                ;Clear Readmask
  sockread.l BitSet sock.l                    ;Set Readmask on our socket
  e.l=IoctlSocket{sock.l,#FIONREAD,TCPmem.l}  ;How much data is there?
  f.l=Peek.l(TCPmem.l)                        ;Place value in f
  If f>0
    If f>#TCPBuflen Then f=#TCPBuflen         ;Don't read more than #TCPBuflen
    c=recv{sock.l,TCPmem.l,f,0}               ;Read all Data
    c$=String$(" ",f)                         ;Reserve String
    CopyMem_ TCPmem.l,&c$,f                   ;Copy Data to string
    Function Return c$
  Else
    Function Return ""
  EndIf
End Function


;----
;WARNING: This is a 'rough' experiment function.
;Function will probably change next update.
;----

.ReadMemTCP
Function .l ReadMemTCP{ReadAdd.l,MaxSize.l}
  SHARED sock.l,TCPmem.l
  ;
  ; Read into memory location 'ReadAdd.l' up to a maximum of 'MaxSize.l'
  ; Used for reading long binary files eg, WWW files or FTP files.
  ; Also returns the amount of bytes actually read.
  ;
  sockread.l=0                                ;Clear Readmask
  sockread.l BitSet sock.l                    ;Set Readmask on our socket
  e.l=IoctlSocket{sock.l,#FIONREAD,TCPmem.l}  ;How much data is there?
  f.l=Peek.l(TCPmem.l)                        ;Place value in f
  If f>0
    If f>#TCPBuflen Then f=#TCPBuflen         ;Don't read more than #TCPBuflen
    If f>MaxSize Then f=MaxSize               ;Don't read more than MaxSize
    c=recv{sock.l,ReadAdd.l,f,0}              ;Read Data to ReadAdd location
    Function Return f
  Else
    Function Return 0
  EndIf
  ;
End Function



.WriteMemTCP
Statement WriteMemTCP{ad.l,size.w}
  SHARED sock.l
  ;
  ; This routine writes data via TCP.
  ;
  sockwrite.l=0                           ;Clear Writemask
  sockwrite.l BitSet sock.l               ;set Writemask on our socket
  g.l=WaitSelect{2,0,&sockwrite.l,0,0,0}  ;Wait until server is ready to read our data
  c.l=send{sock.l,ad,size,0}              ;Send data to server
End Statement



.ConnectTCP
Function .b ConnectTCP{host$,port.w}
  SHARED sock.l
  ;
  ; Check if Miami/AmiTCP stack is available
  ; Connect to host at specified port
  ; Return true or False if Connection is made

  SocketBase.l=OpenLibrary_("bsdsocket.library",0)
  If SocketBase=0
    Function Return False
  Else
;;    CloseLibrary_(SocketBase)
    sock.l=socket{2,1,0}
    *a.hostent=gethostbyname{host$}
    If *a=0
      Function Return False   ; host not found (or internal TCP error)
    Else
      ;
      ; Copy Details to our Sockaddrin structure
      ;
      CopyMem_ *a\h_addr_list\ItemA,&host.sockaddrin\sin_addr,*a\h_lenght
      host.sockaddrin\sin_port=port       ;Set port number
      host.sockaddrin\sin_family=2        ;Set type to AT_INET
      StructLength.l=SizeOf .sockaddrin   ;Get lenght of structure sockaddrin
      If connect{sock.l,host.sockaddrin,StructLength}=-1
        CloseSocket{sock.l}
        Function Return False
      Else
        Function Return True
      EndIf
    EndIf
  EndIf
End Function



.PrintTCP
Statement PrintTCP{text$}
  ;
  ; Send String via TCP
  ;
  WriteMemTCP{&text$,Len(text$)}
End Statement



.NPrintTCP
Statement NPrintTCP{text$}
  ;
  ; Send String via TCP + Carrage Return
  ;
  text$=text$+Chr$(13)
  WriteMemTCP{&text$,Len(text$)}
End Statement



.NLPrintTCP
Statement NLPrintTCP{text$}
  ;
  ; Send String via TCP + Carrage Return + Line Feed
  ;
  text$=text$+Chr$(13)+Chr$(10)
  WriteMemTCP{&text$,Len(text$)}
End Statement



.CloseTCP
Statement CloseTCP{}
  SHARED sock.l
  SHARED SocketBase.l
  ;
  ; This is a simple close socket command
  ; Provided for the shear hell of it :)
  ; Now also closes bsdsocket.library.
  ;
  CloseSocket{sock.l}
  CloseLibrary_(SocketBase)
End Statement




