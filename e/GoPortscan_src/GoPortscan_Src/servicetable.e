OPT MODULE
OPT LARGE

/*
    Description: Internal Service Table for Go Portscan!

    Quick Notes:

    1. This is probably a bad way of doing this, but it was simple and seems fast
       enough.
    2. The reason for multiple procedures is to help speed up searching. Ie if I
       want to know what runs on port 10000, I call the procedure has it in it's
       check range, rather than searching all 65535 ports.
*/


EXPORT DEF servicedesc:PTR TO CHAR

->#################################

EXPORT PROC service(portserv:LONG)

SELECT portserv
    CASE 0
        StrCopy(servicedesc, 'Reserved')
    CASE 1
        StrCopy(servicedesc, 'tcpmux : TCP Port Service Multiplexer')
    CASE 2
        StrCopy(servicedesc, 'compressnet : Management Utility')
    CASE 3
        StrCopy(servicedesc, 'compressnet : Compression Process')
    CASE 5
        StrCopy(servicedesc, 'rje : Remote Job Entry')
    CASE 7
        StrCopy(servicedesc, 'echo : Echo')
    CASE 9
        StrCopy(servicedesc, 'discard sink null : Discard')
    CASE 11
        StrCopy(servicedesc, 'systat users : Active Users')
    CASE 13
        StrCopy(servicedesc, 'daytime : Daytime')
    CASE 15
        StrCopy(servicedesc, 'netstat : NetStat')
    CASE 17
        StrCopy(servicedesc, 'qotd quote : Quote of The Day')
    CASE 18
        StrCopy(servicedesc, 'msp : Message Send Protocol')
    CASE 19
        StrCopy(servicedesc, 'chargen ttytst source : Character Generator')
    CASE 20
        StrCopy(servicedesc, 'ftp-data : File Transfer Protocol [Data Connection]')
    CASE 21
        StrCopy(servicedesc, 'ftp : File Transfer Protocol [Control Connection] ; \eb[TROJANS=Dolly, Blade Runner, Back Construction, Fore, Invisible FTP, Larva, WebEx, WinCrash]\en')
    CASE 22
        StrCopy(servicedesc, 'ssh : Secure Shell Login')
    CASE 23
        StrCopy(servicedesc, 'telnet : Telnet ; \eb[TROJANS=Tiny Telnet]\en')
    CASE 24
        StrCopy(servicedesc, 'priv-mail : Private Mail System')
    CASE 25
        StrCopy(servicedesc, 'smtp mail : Simple Mail Transfer Protocol ; \eb[TROJANS=AntiGen, Ajan, haebue Coceda, Happy 99, Kuang2, ProMail, Shtrilitz, Stealth, Tapiras, Terminator, WinPC, WinSpy]\en')
    CASE 27
        StrCopy(servicedesc, 'nsw-fe : NSW User System FE')
    CASE 29
        StrCopy(servicedesc, 'msg-icp : MSG ICP')
    CASE 31
        StrCopy(servicedesc, 'msg-auth : MSG Authentication ; \eb[TROJANS=Agent 31, Hackers Paradise, Master Paradise]\en')
    CASE 33
        StrCopy(servicedesc, 'dsp : Display Support Protocol')
    CASE 35
        StrCopy(servicedesc, 'priv-print : Private Print Server')
    CASE 37
        StrCopy(servicedesc, 'time timeserver : Time Server')
    CASE 38
        StrCopy(servicedesc, 'rap : Route Access Protocol')
    CASE 39
        StrCopy(servicedesc, 'rlp resource : Resource Location Protocol')
    CASE 41
        StrCopy(servicedesc, 'graphics : Graphics ; \eb[TROJANS=Deep Throat]\en')
    CASE 42
        StrCopy(servicedesc, 'name nameserver : Host Name Server')
    CASE 43
        StrCopy(servicedesc, 'whois nicname shois: Who Is')
    CASE 44
        StrCopy(servicedesc, 'mpm-flags : MPM FLAGS Protocol')
    CASE 45
        StrCopy(servicedesc, 'mpm : Message Processing Module [recv]')
    CASE 46
        StrCopy(servicedesc, 'mpm-snd : Message Processing Module [send]')
    CASE 47
        StrCopy(servicedesc, 'ni-ftp : NI FTP')
    CASE 48
        StrCopy(servicedesc, 'auditd : Digital Audit Daemon')
    CASE 49
        StrCopy(servicedesc, 'tacacs : Login Host Protocol')
    CASE 50
        StrCopy(servicedesc, 're-mail-ck : Remote Mail Checking')
    CASE 51
        StrCopy(servicedesc, 'la-maint : IMP Logical Address Maintainence')
    CASE 52
        StrCopy(servicedesc, 'xns-time : XNS Time Protocol')
    CASE 53
        StrCopy(servicedesc, 'domain nameserver : Domain Name Server')
    CASE 54
        StrCopy(servicedesc, 'xns-ch : XNS Clearinghouse')
    CASE 55
        StrCopy(servicedesc, 'isi-gl : ISI Graphics Language')
    CASE 56
        StrCopy(servicedesc, 'xns-auth : XNS Authentication')
    CASE 57
        StrCopy(servicedesc, 'mtp : Private Terminal Access')
    CASE 58
        StrCopy(servicedesc, 'xns-mail : XNS Mail ; \eb[TROJANS=DMSetup]\en')
    CASE 59
        StrCopy(servicedesc, 'priv-file : Any Private File Service')
    CASE 61
        StrCopy(servicedesc, 'n-mail : NI Mail')
    CASE 62
        StrCopy(servicedesc, 'acas : ACA Services')
    CASE 63
        StrCopy(servicedesc, 'whois++ : Who Is++')
    CASE 64
        StrCopy(servicedesc, 'covia : Communications Integrator (CI)')
    CASE 65
        StrCopy(servicedesc, 'tacacs-ds : TACACS Database Service')
    CASE 66
        StrCopy(servicedesc, 'sql*net : Oracle SQL*NET')
    CASE 67
        StrCopy(servicedesc, 'bootps bootp : Bootstrap Protocol Server')
    CASE 68
        StrCopy(servicedesc, 'bootpc : Bootstrap Protocol Client')
    CASE 69
        StrCopy(servicedesc, 'tftp : Trivial File Transfer Protocol')
    CASE 70
        StrCopy(servicedesc, 'gopher : Gopher')
    CASE 71
        StrCopy(servicedesc, 'netrjs-1 : Remote Job Service 1')
    CASE 72
        StrCopy(servicedesc, 'netrjs-2 : Remote Job Service 2')
    CASE 73
        StrCopy(servicedesc, 'netrjs-3 : Remote Job Service 3')
    CASE 74
        StrCopy(servicedesc, 'netrjs-4 : Remote Job Service 4')
    CASE 75
        StrCopy(servicedesc, 'priv-dial : Any Private Dial-Out Service')
    CASE 76
        StrCopy(servicedesc, 'deos : Distributed External Object Store')
    CASE 77
        StrCopy(servicedesc, 'priv-rje netrjs netjrs : Any Private RJE Service')
    CASE 78
        StrCopy(servicedesc, 'vettcp : vettcp')
    CASE 79
        StrCopy(servicedesc, 'finger : Finger ; \eb[TROJANS=FireHotcker]\en')
    CASE 80
        StrCopy(servicedesc, 'http www www-http : World Wide Web HTTP Server ; \eb[TROJANS=Executor, RingZero]\en')
    CASE 81
        StrCopy(servicedesc, 'hosts2-ns : HOSTS2 Name Server')
    CASE 82
        StrCopy(servicedesc, 'xfer : XFER Utility')
    CASE 83
        StrCopy(servicedesc, 'mit-ml-dev : MIT ML Device')
    CASE 84
        StrCopy(servicedesc, 'ctf : Common Trace Facility')
    CASE 85
        StrCopy(servicedesc, 'mit-ml-dev : MIT ML Device')
    CASE 86
        StrCopy(servicedesc, 'mfcobol : Micro Focus Cobol')
    CASE 87
        StrCopy(servicedesc, 'link : Private Terminal Link')
    CASE 88
        StrCopy(servicedesc, 'kerberos : Kerberos')
    CASE 89
        StrCopy(servicedesc, 'su-mit-tg : SU/MIT Telnet Gateway')
    CASE 90
        StrCopy(servicedesc, 'dnsix : DNSIX Securit Attribute Token Map ; \eb[TROJANS=Hidden Port 2.0]\en')
    CASE 91
        StrCopy(servicedesc, 'mit-dov : MIT Dover Spooler')
    CASE 92
        StrCopy(servicedesc, 'npp : Network Printing Protocol')
    CASE 93
        StrCopy(servicedesc, 'dcp : Device Control Protocol')
    CASE 94
        StrCopy(servicedesc, 'objcall : Tivoli Object Dispatcher')
    CASE 95
        StrCopy(servicedesc, 'supdup : SUPDUP')
    CASE 96
        StrCopy(servicedesc, 'dixie : DIXIE Protocol Specification')
    CASE 97
        StrCopy(servicedesc, 'swift-rvf : Swift Remote Virtual File Protocol')
    CASE 98
        StrCopy(servicedesc, 'linuxconf : Linuxconf Configuration System ; tacnews : TAC News')
    CASE 99
        StrCopy(servicedesc, 'metagram : Metagram Relay ; \eb[TROJANS=Hidden Port]\en')
    CASE 100
        StrCopy(servicedesc, 'newacct : New Account [unauthorised use]')
    CASE 101
        StrCopy(servicedesc, 'hostname hostnames : NIC Host Name Server')
    CASE 102
        StrCopy(servicedesc, 'iso-tsap : ISO-TSAP Class 0')
    CASE 103
        StrCopy(servicedesc, 'x400 : ISO Mail ; gppitnp : Genesis Point to Point Trans Net')
    CASE 104
        StrCopy(servicedesc, 'x400-snd : ISO Mail ; acr-nema : ACR-NEMA Digital Imag. & Comm. 300')
    CASE 105
        StrCopy(servicedesc, 'cso : CCSO Name Server Protocol ; csnet-ns : Mailbox Nameserver')
    CASE 106
        StrCopy(servicedesc, '3com-tsmux : 3COM-TSMUX ; poppassd : Eudora')
    CASE 107
        StrCopy(servicedesc, 'rtelnet : Remote Telnet Service')
    CASE 108
        StrCopy(servicedesc, 'snagas : SNA Gateway Access Server')
    CASE 109
        StrCopy(servicedesc, 'pop pop2 postoffice : Post Office Protocol - Version 2 (Mail Server)')
    CASE 110
        StrCopy(servicedesc, 'pop3 : Post Office Protocol - Ver 3 (Mail Server) ; \eb[TROJANS=ProMail]\en')
    CASE 111
        StrCopy(servicedesc, 'sunrpc portmapper : Sun Remote Procedure Call/Portmapper')
    CASE 112
        StrCopy(servicedesc, 'mcidas : McIDAS Data Transmission Protocol')
    CASE 113
        StrCopy(servicedesc, 'ident auth : Authentication Service ; \eb[TROJANS=Kazimas]\en')
    CASE 114
        StrCopy(servicedesc, 'audionews : Audio News Multicast')
    CASE 115
        StrCopy(servicedesc, 'sftp : Simple File Transfer Protocol')
    CASE 116
        StrCopy(servicedesc, 'ansanotify : ANSA REX Notify')
    CASE 117
        StrCopy(servicedesc, 'uucp-path : UNIX to UNIX Copy Path Service')
    CASE 118
        StrCopy(servicedesc, 'sqlserv : Structured Query Language Server')
    CASE 119
        StrCopy(servicedesc, 'nntp readnews untp : Network News Transfer Protocol (USENET) ; \eb[TROJANS=Happy 99]\en')
    CASE 120
        StrCopy(servicedesc, 'cfdptkt : CFDPTKT')
    CASE 121
        StrCopy(servicedesc, 'erpc : Encore Expedited Remote Procedure Call ; \eb[TROJANS=Jammer Killah]\en')
    CASE 122
        StrCopy(servicedesc, 'smakynet : SMAKYNET')
    CASE 123
        StrCopy(servicedesc, 'ntp : Network Time Protocol')
    CASE 124
        StrCopy(servicedesc, 'ansatrader : ANSA REX Trader')
    CASE 125
        StrCopy(servicedesc, 'locus-map : Locus PC-Interface Net Map Service')
    CASE 126
        StrCopy(servicedesc, 'nxedit : NXEdit ; unitary : Unisys Unitary Logn (OBSOLETE!!)')
    CASE 127
        StrCopy(servicedesc, 'locus-con : Locus PC-Interface Conn Server')
    CASE 128
        StrCopy(servicedesc, 'gss-xlicen : GSS X License Verification')
    CASE 129
        StrCopy(servicedesc, 'pwdgen : Password Generator Protocol')
    CASE 130
        StrCopy(servicedesc, 'cisco-fna : Cisco FNATIVE')
    CASE 131
        StrCopy(servicedesc, 'cisco-tna : Cisco TNATIVE')
    CASE 132
        StrCopy(servicedesc, 'cisco-sys : Cisco SYSMAINT')
    CASE 133
        StrCopy(servicedesc, 'statsrv : Statistics Service')
    CASE 134
        StrCopy(servicedesc, 'ingres-net : INGRES-NET Servce')
    CASE 135
        StrCopy(servicedesc, 'epmap : DCE Endpoint Resolution')
    CASE 136
        StrCopy(servicedesc, 'profile : Profile Naming System')
    CASE 137
        StrCopy(servicedesc, 'netbios-ns : NetBIOS Name Service (SAMBA/Windows Networking)')
    CASE 138
        StrCopy(servicedesc, 'netbios-dgm : NetBIOS Datagram Service (SAMBA/Windows Networking)')
    CASE 139
        StrCopy(servicedesc, 'netbios-ssn : NetBIOS Session Service (SAMBA/Windows Networking)')
    CASE 140
        StrCopy(servicedesc, 'emfis-data : EMFIS [Data Connection]')
    CASE 141
        StrCopy(servicedesc, 'emfis-cntl : EMFIS [Control Connection]')
    CASE 142
        StrCopy(servicedesc, 'bl-idm : Britton Lee IDM')
    CASE 143
        StrCopy(servicedesc, 'imap imap2: Interactive Mail Access Protocol (V2)')
    CASE 144
        StrCopy(servicedesc, 'news : Window System ; uma : Universal Management Architecure')
    CASE 145
        StrCopy(servicedesc, 'uaac : UAAC Protocol')
    CASE 146
        StrCopy(servicedesc, 'iso-tp0 : ISO-TP0 ; \eb[TROJANS=Infector 1.3]\en')
    CASE 147
        StrCopy(servicedesc, 'iso-ip : ISO-IP')
    CASE 148
        StrCopy(servicedesc, 'jargon : Jargon')
    CASE 149
        StrCopy(servicedesc, 'aed-512 : AED 512 Emulation Service')
    CASE 150
        StrCopy(servicedesc, 'sql-net : Structured Query Language Net')
    CASE 151
        StrCopy(servicedesc, 'hems : HEMS')
    CASE 152
        StrCopy(servicedesc, 'bftp : Background File Transfer Protocol')
    CASE 153
        StrCopy(servicedesc, 'sgmp : SGMP')
    CASE 154
        StrCopy(servicedesc, 'netsc-prod : NETSC-PROD')
    CASE 155
        StrCopy(servicedesc, 'netsc-dev : NETSC-DEV')
    CASE 156
        StrCopy(servicedesc, 'sqlsrv : Structured Query Language Service')
    CASE 157
        StrCopy(servicedesc, 'knet-cmp : KNET/VM Command/Message Protocol')
    CASE 158
        StrCopy(servicedesc, 'pcmail-srv : PCMail Server')
    CASE 159
        StrCopy(servicedesc, 'nss-routing : NSS Routing')
    CASE 160
        StrCopy(servicedesc, 'sgmp-traps : SGMP Traps')
    CASE 161
        StrCopy(servicedesc, 'snmp : Simple Network Management Protocol')
    CASE 162
        StrCopy(servicedesc, 'snmptrap : Simple Network Management Protocol Traps')
    CASE 163
        StrCopy(servicedesc, 'cmip-man : CMIP/TCP Manager')
    CASE 164
        StrCopy(servicedesc, 'cmip-agent : CMIP/TCP Agent')
    CASE 165
        StrCopy(servicedesc, 'xns-courier : Xerox NS Courier')
    CASE 166
        StrCopy(servicedesc, 's-net : Sirius Systems')
    CASE 167
        StrCopy(servicedesc, 'namp : NAMP')
    CASE 168
        StrCopy(servicedesc, 'rsvd : RSVD')
    CASE 169
        StrCopy(servicedesc, 'send : SEND')
    CASE 170
        StrCopy(servicedesc, 'print-srv : Network Postscript')
    CASE 171
        StrCopy(servicedesc, 'multiplex : Network Innovations Multiplex')
    CASE 172
        StrCopy(servicedesc, 'cl/1 : Network Innovations CL/1')
    CASE 173
        StrCopy(servicedesc, 'xyplex-mux : Xyplex Multiplex')
    CASE 174
        StrCopy(servicedesc, 'mailq : Mailer Transport Queue for ZMailer')
    CASE 175
        StrCopy(servicedesc, 'vmnet : VMNET')
    CASE 176
        StrCopy(servicedesc, 'genrad-mux : GENRAD Multiplex')
    CASE 177
        StrCopy(servicedesc, 'xdmcp : X Display Manager Control Protocol')
    CASE 178
        StrCopy(servicedesc, 'nextstep : NextStep Window Server')
    CASE 179
        StrCopy(servicedesc, 'bgp : Border Gateway Protocol')
    CASE 180
        StrCopy(servicedesc, 'ris : Intergraph')
    CASE 181
        StrCopy(servicedesc, 'unify : Unify')
    CASE 182
        StrCopy(servicedesc, 'audit : Unisys Audit SITP')
    CASE 183
        StrCopy(servicedesc, 'ocbinder : OCBinder')
    CASE 184
        StrCopy(servicedesc, 'ocserver : OCServer')
    CASE 185
        StrCopy(servicedesc, 'remote-kis : Remote KIS Protocol')
    CASE 186
        StrCopy(servicedesc, 'kis : KIS Protocol')
    CASE 187
        StrCopy(servicedesc, 'aci : Applications Communcation Interface')
    CASE 188
        StrCopy(servicedesc, 'mumps : Plus Fives MUMPS')
    CASE 189
        StrCopy(servicedesc, 'qft : Queued File Transport')
    CASE 190
        StrCopy(servicedesc, 'gacp : Gateway Access Control Protocol')
    CASE 191
        StrCopy(servicedesc, 'prospero : Prospero Directory Service')
    CASE 192
        StrCopy(servicedesc, 'osu-nms : OSU Network Montoring System')
    CASE 193
        StrCopy(servicedesc, 'srmp : Spider Remote Monitoring Protocol')
    CASE 194
        StrCopy(servicedesc, 'irc : Internet Relay Chat')
    CASE 195
        StrCopy(servicedesc, 'dn6-nlm-aud : DNSIX Network Level Module Audit')
    CASE 196
        StrCopy(servicedesc, 'dn6-smm-red : DNSIX Session Mgt Module Audit Redir')
    CASE 197
        StrCopy(servicedesc, 'dls : Directory Location Service')
    CASE 198
        StrCopy(servicedesc, 'dls-mon : Directory Location Service Monitor')
    CASE 199
        StrCopy(servicedesc, 'smux : Simple Network Management Protocol UNIX Multiplexer')
    CASE 200
        StrCopy(servicedesc, 'src : IBM System Resource Controller')
    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT

ENDPROC

->###################################################

EXPORT PROC service2(portserv:LONG)

SELECT portserv
    CASE 201
        StrCopy(servicedesc, 'at-rtmp : AppleTalk Routing Maintainence')
    CASE 202
        StrCopy(servicedesc, 'at-nbp : AppleTalk Name Binding')
    CASE 203
        StrCopy(servicedesc, 'at-3 : AppleTalk [unused]')
    CASE 204
        StrCopy(servicedesc, 'at-echo : AppleTalk Echo')
    CASE 205
        StrCopy(servicedesc, 'at-5 : AppleTalk [unused]')
    CASE 206
        StrCopy(servicedesc, 'at-zis : AppleTalk Zone Information Service')
    CASE 207
        StrCopy(servicedesc, 'at-7 : AppleTalk [unused]')
    CASE 208
        StrCopy(servicedesc, 'at-8 : AppleTalk [unused]')
    CASE 209
        StrCopy(servicedesc, 'qmtp tam : Quick Mail Transfer Protocol ; Trivial Authenticated Mail Protocol')
    CASE 210
        StrCopy(servicedesc, 'z3950 wais: NISO Z39.50 database')
    CASE 211
        StrCopy(servicedesc, '914c/g : Texas Instruments 914C/G Terminal')
    CASE 212
        StrCopy(servicedesc, 'anet : ATEXSSTR')
    CASE 213
        StrCopy(servicedesc, 'ipx : IPX (Netware)')
    CASE 214
        StrCopy(servicedesc, 'vmpwscs : VM PWSCS')
    CASE 215
        StrCopy(servicedesc, 'softpc : Insignia Solutions')
    CASE 216
        StrCopy(servicedesc, 'cailic atls: Computer Asscociates Internatonal License Server ; Access Technology License Server')
    CASE 217
        StrCopy(servicedesc, 'dbase : dBASE UNIX')
    CASE 218
        StrCopy(servicedesc, 'mpp : Netix Message Posting Protocol')
    CASE 219
        StrCopy(servicedesc, 'uarps : Unisys ARPs')
    CASE 220
        StrCopy(servicedesc, 'imap3 : Interactive Mail Access Protocol v3')
    CASE 221
        StrCopy(servicedesc, 'fln-spx : Berkeley rlogind with SPX auth')
    CASE 222
        StrCopy(servicedesc, 'rsh-spx : Berkeley rshd wth SPX auth ; masqdialer : Masqdialer')
    CASE 223
        StrCopy(servicedesc, 'cdc : Certificate Distribution Centre')
    CASE 224
        StrCopy(servicedesc, 'masqdialer : Masqdialer')
->    CASE 225 TO 241
->        StrCopy(servicedesc, ' : ')

    CASE 242
        StrCopy(servicedesc, 'direct : Direct')
    CASE 243
        StrCopy(servicedesc, 'sur-meas : Survey Measurement')
    CASE 244
        StrCopy(servicedesc, 'inbusiness dayna : InBusiness ; dayna')
    CASE 245
        StrCopy(servicedesc, 'link : LINK')
    CASE 246
        StrCopy(servicedesc, 'dsp3270 : Display Systems Protocol')
    CASE 247
        StrCopy(servicedesc, 'subntbcst_tftp : SUBNTBCST_TFTP')
    CASE 248
        StrCopy(servicedesc, 'bhfhs : bhfhs')
->    CASE 249 TO 255
->        StrCopy(servicedesc, ' : ')
    CASE 256
        StrCopy(servicedesc, 'rap : RAP')
    CASE 257
        StrCopy(servicedesc, 'set : Secure Electronic Transaction')
    CASE 258
        StrCopy(servicedesc, 'yak-chat : Yak Winsock Personal Chat')
    CASE 259
        StrCopy(servicedesc, 'esro-gen : Efficient Short Remote Operations')
    CASE 260
        StrCopy(servicedesc, 'openport : OpenPort')
    CASE 261
        StrCopy(servicedesc, 'nsiiops : IIOP Name Service over TLS/SSL')
    CASE 262
        StrCopy(servicedesc, 'arcisdms : Arcisdms')
    CASE 263
        StrCopy(servicedesc, 'hdap : HDAP')
    CASE 264
        StrCopy(servicedesc, 'bgmp : BGMP')
    CASE 265
        StrCopy(servicedesc, 'x-bone-ctl : X-Bone CTL')
    CASE 266
        StrCopy(servicedesc, 'sst : SCSI on ST')
    CASE 267
        StrCopy(servicedesc, 'td-service : Tobit David Service Layer')
    CASE 268
        StrCopy(servicedesc, 'td-replica : Tobt David Replica')
->    CASE 269 TO 279
->        StrCopy(servicedesc, ' : ')
    CASE 280
        StrCopy(servicedesc, 'http-mgmt : HTTP-MGMT')
    CASE 281
        StrCopy(servicedesc, 'personal-link : Personal Link')
    CASE 282
        StrCopy(servicedesc, 'cableport-ax : Cable Port A/X')
    CASE 283
        StrCopy(servicedesc, 'rescap : rescap')
    CASE 284
        StrCopy(servicedesc, 'corerjd : corerjd')
->    CASE 285
->        StrCopy(servicedesc, ' : ')
    CASE 286
        StrCopy(servicedesc, 'fxp-1 : FXP-1')
    CASE 287
        StrCopy(servicedesc, 'k-block : K-BLOCK')
->    CASE 288 TO 300
->        StrCopy(servicedesc, ' : ')


->    CASE 301 TO 307
->        StrCopy(servicedesc, ' : ')
    CASE 308
        StrCopy(servicedesc, 'novastorbackup : Novastor Backup')
    CASE 309
        StrCopy(servicedesc, 'entrusttime : EntrustTime')
    CASE 310
        StrCopy(servicedesc, 'bhmds : bhmds')
    CASE 311
        StrCopy(servicedesc, 'asip-webadmin : AppleShare IP WebAdmin')
    CASE 312
        StrCopy(servicedesc, 'vslmp : VSLMP')
    CASE 313
        StrCopy(servicedesc, 'magenta-logic : Magenta Logic')
    CASE 314
        StrCopy(servicedesc, 'opalis-robot : Opalis Robot')
    CASE 315
        StrCopy(servicedesc, 'dpsi : DPSI')
    CASE 316
        StrCopy(servicedesc, 'decauth : DEC Auth')
    CASE 317
        StrCopy(servicedesc, 'zannet : Zannet')
    CASE 318
        StrCopy(servicedesc, 'pkix-timestamp : PKIX TimeStamp')
    CASE 319
        StrCopy(servicedesc, 'ptp-event : PTP Event')
    CASE 320
        StrCopy(servicedesc, 'ptp-general : PTP General')
    CASE 321
        StrCopy(servicedesc, 'pip : PIP')
    CASE 322
        StrCopy(servicedesc, 'rtsps : RTSPS')
->    CASE 323 TO 332
->        StrCopy(servicedesc, ' : ')
    CASE 333
        StrCopy(servicedesc, 'texar : Texar Security Port')
->    CASE 334 TO 343
->        StrCopy(servicedesc, ' : ')
    CASE 344
        StrCopy(servicedesc, 'pdap : Prospero Data Access Protocol')
    CASE 345
        StrCopy(servicedesc, 'pawserv : Perf Analysis Workbench')
    CASE 346
        StrCopy(servicedesc, 'zserv : Zebra Server')
    CASE 347
        StrCopy(servicedesc, 'fatserv : Fatmen Server')
    CASE 348
        StrCopy(servicedesc, 'csi-sgwp : Cabletron Management Protocol')
    CASE 349
        StrCopy(servicedesc, 'mftp : MFTP')
    CASE 350
        StrCopy(servicedesc, 'matip-type-a : MATIP Type A')
    CASE 351
        StrCopy(servicedesc, 'matip-type-b : MATIP Type B ; bhoetty : bhoetty')
    CASE 352
        StrCopy(servicedesc, 'dtag-ste-sb : DTAG')
    CASE 353
        StrCopy(servicedesc, 'ndsauth : NDSAUTH')
    CASE 354
        StrCopy(servicedesc, 'bh611 : BH611')
    CASE 355
        StrCopy(servicedesc, 'datex-asn : DATEX-ASN')
    CASE 356
        StrCopy(servicedesc, 'cloanto-net-1 : Cloanto Net 1')
    CASE 357
        StrCopy(servicedesc, 'bhevent : bhevent')
    CASE 358
        StrCopy(servicedesc, 'shrinkwrap : Shrinkwrap')
    CASE 359
        StrCopy(servicedesc, 'tenebris_nts : Tenebris Network Trace Service')
    CASE 360
        StrCopy(servicedesc, 'scoi2odialog : SCOi2oDialog')
    CASE 361
        StrCopy(servicedesc, 'semantix : Semantix')
    CASE 362
        StrCopy(servicedesc, 'srssend : SRS Send')
    CASE 363
        StrCopy(servicedesc, 'rsvp_tunnel : RSVP Tunnel')
    CASE 364
        StrCopy(servicedesc, 'aurora-cmgr : Aurora CMGR')
    CASE 365
        StrCopy(servicedesc, 'dtk : Deception Tool Kit')
    CASE 366
        StrCopy(servicedesc, 'odmr : ODMR')
    CASE 367
        StrCopy(servicedesc, 'mortgageware : MortgageWare')
    CASE 368
        StrCopy(servicedesc, 'qbikgdp : QbikGDP')
    CASE 369
        StrCopy(servicedesc, 'rpc2portmap : Remote Procedure Call 2 Portmap (coda portmapper)')
    CASE 370
        StrCopy(servicedesc, 'codaauth2 : CODA Authentication Server')
    CASE 371
        StrCopy(servicedesc, 'clearcase : Clearcase ; albd : Location Broker')
    CASE 372
        StrCopy(servicedesc, 'ulistproc : ListProcessor ; ulistserv : UNIX Listserv')
    CASE 373
        StrCopy(servicedesc, 'legent-1 : Legent Corporation (now Computer Assosciates)')
    CASE 374
        StrCopy(servicedesc, 'legent-2 : Legent Corporation (now Computer Asccociates)')
    CASE 375
        StrCopy(servicedesc, 'hassle : Hassle')
    CASE 376
        StrCopy(servicedesc, 'nip : Amiga Envoy Network Inquiry Proto')
    CASE 377
        StrCopy(servicedesc, 'tnetos : NEC Corporation')
    CASE 378
        StrCopy(servicedesc, 'dsetos : NEC Corporation')
    CASE 379
        StrCopy(servicedesc, 'is99c : TIA/EIA/IS-99 modem client')
    CASE 380
        StrCopy(servicedesc, 'is99s : TIA/EIA/IS-99 modem server')
    CASE 381
        StrCopy(servicedesc, 'hp-collector : hp performance data collector')
    CASE 382
        StrCopy(servicedesc, 'hp-managed-node : hp performance data managed node')
    CASE 383
        StrCopy(servicedesc, 'hp-alarm-mgr : hp performance data alarm manager')
    CASE 384
        StrCopy(servicedesc, 'arns : A Remote Network Server System')
    CASE 385
        StrCopy(servicedesc, 'ibm-app : IBM Application')
    CASE 386
        StrCopy(servicedesc, 'asa : ASA Message Router Object')
    CASE 387
        StrCopy(servicedesc, 'aurp : AppleTalk Update Based Routing Protocol')
    CASE 388
        StrCopy(servicedesc, 'unidata-ldm : UniData LDM Version 4')
    CASE 389
        StrCopy(servicedesc, 'ldap : Lightweight Directory Access Protocol')
    CASE 390
        StrCopy(servicedesc, 'uis : UIS')
    CASE 391
        StrCopy(servicedesc, 'synotics-relay : SynOptics SNMP Relay Port')
    CASE 392
        StrCopy(servicedesc, 'synotics-broker : SynOptics Port Broker')
    CASE 393
        StrCopy(servicedesc, 'meta5 dis : Meta5 ; Data Interpretation System')
    CASE 394
        StrCopy(servicedesc, 'embl-ndt : EMBL Nucleic Data Transfer')
    CASE 395
        StrCopy(servicedesc, 'netcp : NETScout Control Protocol')
    CASE 396
        StrCopy(servicedesc, 'netware-ip : Novell Netware over IP')
    CASE 397
        StrCopy(servicedesc, 'mptn : Multi Protocol Trans Net')
    CASE 398
        StrCopy(servicedesc, 'kryptolan : Kryptolan')
    CASE 399
        StrCopy(servicedesc, 'iso-tsap-c2 : ISO Transport Class 2 Non-Control over TCP')
    CASE 400
        StrCopy(servicedesc, 'work-sol : Workstation Solutions')
    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')

ENDSELECT

ENDPROC


EXPORT PROC service3(portserv:LONG)

SELECT portserv
    CASE 401
        StrCopy(servicedesc, 'ups : Uninterruptible Power Supply')
    CASE 402
        StrCopy(servicedesc, 'genie : Genie Protocol')
    CASE 403
        StrCopy(servicedesc, 'decap : decap')
    CASE 404
        StrCopy(servicedesc, 'nced : nced')
    CASE 405
        StrCopy(servicedesc, 'ncld : ncld')
    CASE 406
        StrCopy(servicedesc, 'imsp : Interactive Mail Support Protocol')
    CASE 407
        StrCopy(servicedesc, 'timbuktu : Timbuktu Remote Desktop Viewer')
    CASE 408
        StrCopy(servicedesc, 'prm-sm : Prospero Resource Manager Sys. Man.')
    CASE 409
        StrCopy(servicedesc, 'prm-nm : Prospero Resource Manager Node Man.')
    CASE 410
        StrCopy(servicedesc, 'decladebug : DECLadebug Remote Debug Protocol')
    CASE 411
        StrCopy(servicedesc, 'rmt : Remote MT Protocol')
    CASE 412
        StrCopy(servicedesc, 'synoptics-trap : Trap Convention Port')
    CASE 413
        StrCopy(servicedesc, 'smsp : Storage Management Services Protocol')
    CASE 414
        StrCopy(servicedesc, 'infoseek : InfoSeek')
    CASE 415
        StrCopy(servicedesc, 'bnet : BNet')
    CASE 416
        StrCopy(servicedesc, 'silverplatter : Silverplatter')
    CASE 417
        StrCopy(servicedesc, 'onmux : Onmux')
    CASE 418
        StrCopy(servicedesc, 'hyper-g : Hyper-G')
    CASE 419
        StrCopy(servicedesc, 'ariel1 : Ariel')
    CASE 420
        StrCopy(servicedesc, 'smpte : SMPTE')
    CASE 421
        StrCopy(servicedesc, 'ariel2 : Ariel')
    CASE 422
        StrCopy(servicedesc, 'ariel3 : Ariel')
    CASE 423
        StrCopy(servicedesc, 'opc-job-start : IBM Operations Planning and Control Start')
    CASE 424
        StrCopy(servicedesc, 'opc-job-track : IBM Operations Planning and Control Track')
    CASE 425
        StrCopy(servicedesc, 'icad-el : ICAD')
    CASE 426
        StrCopy(servicedesc, 'smartsdp : smartsdp')
    CASE 427
        StrCopy(servicedesc, 'svrloc : Server Location')
    CASE 428
        StrCopy(servicedesc, 'ocs_cmu : OCS_CMU')
    CASE 429
        StrCopy(servicedesc, 'ocs_amu : OCS_AMU')
    CASE 430
        StrCopy(servicedesc, 'utmpsd : UTMPSD')
    CASE 431
        StrCopy(servicedesc, 'utmpcd : UTMPCD')
    CASE 432
        StrCopy(servicedesc, 'iasd : IASD')
    CASE 433
        StrCopy(servicedesc, 'nnsp : Network News Sending Protocol (usenet)')
    CASE 434
        StrCopy(servicedesc, 'mobileip-agent : MobileIP-Agent')
    CASE 435
        StrCopy(servicedesc, 'mobilip-mn : MobilIP-MN')
    CASE 436
        StrCopy(servicedesc, 'dna-cml : DNA-CML')
    CASE 437
        StrCopy(servicedesc, 'comscm : comscm')
    CASE 438
        StrCopy(servicedesc, 'dsfgw : dsfgw')
    CASE 439
        StrCopy(servicedesc, 'dasp : dasp')
    CASE 440
        StrCopy(servicedesc, 'sgcp : sgcp')
    CASE 441
        StrCopy(servicedesc, 'decvms-sysmgt : decvms-sysmgt')
    CASE 442
        StrCopy(servicedesc, 'cvc_hostd : Network Console')
    CASE 443
        StrCopy(servicedesc, 'https : http protocol over TLS/SSL')
    CASE 444
        StrCopy(servicedesc, 'snpp : Simple Network Paging Protocol')
    CASE 445
        StrCopy(servicedesc, 'microsoft-ds : Microsoft-DS')
    CASE 446
        StrCopy(servicedesc, 'ddm-rdb : DDM-RDB')
    CASE 447
        StrCopy(servicedesc, 'ddm-dfm : DDM-RFM')
    CASE 448
        StrCopy(servicedesc, 'ddm-ssl : DDM-SSL')
    CASE 449
        StrCopy(servicedesc, 'as-servermap : AS Server Mapper')
    CASE 450
        StrCopy(servicedesc, 'tserver : TServer')
    CASE 451
        StrCopy(servicedesc, 'sfs-smp-net : Cray Network Semaphore server')
    CASE 452
        StrCopy(servicedesc, 'sfs-config : Cray SFS config server')
    CASE 453
        StrCopy(servicedesc, 'creativeserver : CreativeServer')
    CASE 454
        StrCopy(servicedesc, 'contentserver : ContentServer')
    CASE 455
        StrCopy(servicedesc, 'creativepartnr : CreativePartnr')
    CASE 456
        StrCopy(servicedesc, 'macon-tcp : macon-tcp ; \eb[TROJANS=Hackers Paradise]\en')
    CASE 457
        StrCopy(servicedesc, 'scohelp : scohelp')
    CASE 458
        StrCopy(servicedesc, 'appleqtc : apple quick time')
    CASE 459
        StrCopy(servicedesc, 'ampr-rcmd : ampr-rcmd')
    CASE 460
        StrCopy(servicedesc, 'skronk : skronk')
    CASE 461
        StrCopy(servicedesc, 'datasurfsrv : DataRampSrv')
    CASE 462
        StrCopy(servicedesc, 'datasurfsrvsec : DataRampSrvSec')
    CASE 463
        StrCopy(servicedesc, 'alpes : alpes')
    CASE 464
        StrCopy(servicedesc, 'kpasswd kpasswd5 : Passwd using Kerberos ; Passwd using Kerberos V5')
    CASE 465
        StrCopy(servicedesc, 'ssmtp smtps: SMTP using SSL')
    CASE 466
        StrCopy(servicedesc, 'digital-vrc : digital-vrc')
    CASE 467
        StrCopy(servicedesc, 'mylex-mapd : mylex-mapd')
    CASE 468
        StrCopy(servicedesc, 'photuris : Photuris Key Management')
    CASE 469
        StrCopy(servicedesc, 'rcp : Radio Control Protocol')
    CASE 470
        StrCopy(servicedesc, 'scx-proxy : scx-proxy')
    CASE 471
        StrCopy(servicedesc, 'mondex : Mondex')
    CASE 472
        StrCopy(servicedesc, 'ljk-login : ljk-login')
    CASE 473
        StrCopy(servicedesc, 'hybrid-pop : hybrid-pop')
    CASE 474
        StrCopy(servicedesc, 'tn-tl-w1 : tn-tl-w1')
    CASE 475
        StrCopy(servicedesc, 'tcpnethaspsrv : tcpnethaspsrv')
    CASE 476
        StrCopy(servicedesc, 'tn-tl-fd1 : tn-tl-fd1')
    CASE 477
        StrCopy(servicedesc, 'ss7ns : ss7ns')
    CASE 478
        StrCopy(servicedesc, 'spsc : spsc')
    CASE 479
        StrCopy(servicedesc, 'iafserver : iafserver')
    CASE 480
        StrCopy(servicedesc, 'iafdbase loadsrv: iafdbase')
    CASE 481
        StrCopy(servicedesc, 'ph : Ph service')
    CASE 482
        StrCopy(servicedesc, 'bgs-nsi xlof : bgs-nsi')
    CASE 483
        StrCopy(servicedesc, 'ulpnet : ulpnet')
    CASE 484
        StrCopy(servicedesc, 'integra-sme : Integra Software Management Environment')
    CASE 485
        StrCopy(servicedesc, 'powerburst : Air Soft Power Burst')
    CASE 486
        StrCopy(servicedesc, 'avian sstats: avian')
    CASE 487
        StrCopy(servicedesc, 'saft : Simple Asynchronous File Transfer')
    CASE 488
        StrCopy(servicedesc, 'gss-http : gss-http')
    CASE 489
        StrCopy(servicedesc, 'nest-protocol : nest-protocol')
    CASE 490
        StrCopy(servicedesc, 'micom-pfs : micom-pfs')
    CASE 491
        StrCopy(servicedesc, 'go-login : go-login')
    CASE 492
        StrCopy(servicedesc, 'ticf-1 : Transport Independent Convergence for FNA')
    CASE 493
        StrCopy(servicedesc, 'ticf-2 : Transport Independent Convergence for FNA')
    CASE 494
        StrCopy(servicedesc, 'pov-ray : POV-Ray')
    CASE 495
        StrCopy(servicedesc, 'intecourier : intecourier')
    CASE 496
        StrCopy(servicedesc, 'pim-rp-disc : PIM-RP-DISC')
    CASE 497
        StrCopy(servicedesc, 'dantz : dantz')
    CASE 498
        StrCopy(servicedesc, 'siam : siam')
    CASE 499
        StrCopy(servicedesc, 'iso-ill : ISO ILL Protocol')
    CASE 500
        StrCopy(servicedesc, 'isakmp : isakmp')

    CASE 501
        StrCopy(servicedesc, 'stmf : STMF')
    CASE 502
        StrCopy(servicedesc, 'asa-appl-proto : asa-appl-proto')
    CASE 503
        StrCopy(servicedesc, 'intrinsa : Intrinsa')
    CASE 504
        StrCopy(servicedesc, 'citadel : citadel')
    CASE 505
        StrCopy(servicedesc, 'mailbox-lm : mailbox-lm')
    CASE 506
        StrCopy(servicedesc, 'ohimsrv : ohimsrv')
    CASE 507
        StrCopy(servicedesc, 'crs : crs')
    CASE 508
        StrCopy(servicedesc, 'xvttp : xvttp')
    CASE 509
        StrCopy(servicedesc, 'snare : snare')
    CASE 510
        StrCopy(servicedesc, 'fcp : FirstClass Protocol')
    CASE 511
        StrCopy(servicedesc, 'passgo : PassGo')
    CASE 512
        StrCopy(servicedesc, 'exec : remote process execution ; biff : Biff Mail Notification')
    CASE 513
        StrCopy(servicedesc, 'login who : Remote Login ; Who')
    CASE 514
        StrCopy(servicedesc, 'shell rsh: cmd (Remote Shell)')
    CASE 515
        StrCopy(servicedesc, 'printer spooler: Print Spooler')
    CASE 516
        StrCopy(servicedesc, 'videotex : videotex')
    CASE 517
        StrCopy(servicedesc, 'talk : like tenex link, but across')
    CASE 518
        StrCopy(servicedesc, 'ntalk : NTalk')
    CASE 519
        StrCopy(servicedesc, 'utime : unixtime')
    CASE 520
        StrCopy(servicedesc, 'efs route: extended file name server ; router routed RIP')
    CASE 521
        StrCopy(servicedesc, 'ripng : ripng')
    CASE 522
        StrCopy(servicedesc, 'ulp : ULP')
    CASE 523
        StrCopy(servicedesc, 'ibm-db2 : IBM-DB2')
    CASE 524
        StrCopy(servicedesc, 'ncp : NCP')
    CASE 525
        StrCopy(servicedesc, 'timed : timeserver')
    CASE 526
        StrCopy(servicedesc, 'tempo newdate: Tempo/Newdate')
    CASE 527
        StrCopy(servicedesc, 'stx : Stock IXChange')
    CASE 528
        StrCopy(servicedesc, 'custix : Customer IXChange')
    CASE 529
        StrCopy(servicedesc, 'irc-serv : IRC-SERV')
    CASE 530
        StrCopy(servicedesc, 'courier rpc : Courier Remote Procedure Call')
    CASE 531
        StrCopy(servicedesc, 'conference chat : Chat ; \eb[TROJANS=Rasmin]\en')
    CASE 532
        StrCopy(servicedesc, 'netnews readnews : Netnews ; readnews')
    CASE 533
        StrCopy(servicedesc, 'netwall : Emergency Message Broadcast')
    CASE 534
        StrCopy(servicedesc, 'mm-admin : MegaMedia Admin')
    CASE 535
        StrCopy(servicedesc, 'iiop : iiop')
    CASE 536
        StrCopy(servicedesc, 'opalis-rdv : opalis-rdv')
    CASE 537
        StrCopy(servicedesc, 'nmsp : Networked Media Streaming Protocol')
    CASE 538
        StrCopy(servicedesc, 'gdomap : GNUstep Distributed Objects')
    CASE 539
        StrCopy(servicedesc, 'apertus-ldp : Apertus Technologies Load Determination')
    CASE 540
        StrCopy(servicedesc, 'uucp uucpd : UNIX to UNIX Copy {Daemon}')
    CASE 541
        StrCopy(servicedesc, 'uucp-rlogin : UNIX to UNIX Copy Remote Login')
    CASE 542
        StrCopy(servicedesc, 'commerce : commerce')
    CASE 543
        StrCopy(servicedesc, 'klogin : Login using Kerberos (V4/5)')
    CASE 544
        StrCopy(servicedesc, 'kshell krcmd : Remote shell using Kerberos (V4/5)')
    CASE 545
        StrCopy(servicedesc, 'appleqtcsrvr ekshell : appleqtcsrvr (QuickTime) ; Kerberos Encrypted Remote Shell')
    CASE 546
        StrCopy(servicedesc, 'dhcpv6-client : DHCPv6 Client')
    CASE 547
        StrCopy(servicedesc, 'dhcpv6-server : DHCPv6 Server')
    CASE 548
        StrCopy(servicedesc, 'afpovertcp : AFP over TCP')
    CASE 549
        StrCopy(servicedesc, 'idfp : IDFP')
    CASE 550
        StrCopy(servicedesc, 'new-rwho new-who : new-who')
    CASE 551
        StrCopy(servicedesc, 'cybercash : cybercash')
    CASE 552
        StrCopy(servicedesc, 'deviceshare : deviceshare')
    CASE 553
        StrCopy(servicedesc, 'pirp : pirp')
    CASE 554
        StrCopy(servicedesc, 'rtsp : Real Time Stream Control Protocol')
    CASE 555
        StrCopy(servicedesc, 'dsf : dsf ; \eb[TROJANS=Stealth Spy, Phaze, Ini Killer, NetAdmin, ]\en')
    CASE 556
        StrCopy(servicedesc, 'remotefs rfs rfs_server : Brunhoff Remote Filesystem')
    CASE 557
        StrCopy(servicedesc, 'openvms-sysipc : openvms-sysipc')
    CASE 558
        StrCopy(servicedesc, 'sdnskmp : SDNSKMP')
    CASE 559
        StrCopy(servicedesc, 'teedtap : TEEDTAP')
    CASE 560
        StrCopy(servicedesc, 'rmonitor rmonitord : rmonitord')
    CASE 561
        StrCopy(servicedesc, 'monitor : monitor')
    CASE 562
        StrCopy(servicedesc, 'chshell : chcmd')
    CASE 563
        StrCopy(servicedesc, 'nntps snews : NNTP protocol over TLS/SSL (was snntp)')
    CASE 564
        StrCopy(servicedesc, '9pfs : plan 9 file service')
    CASE 565
        StrCopy(servicedesc, 'whoami : whoami')
    CASE 566
        StrCopy(servicedesc, 'streettalk : streettalk')
    CASE 567
        StrCopy(servicedesc, 'banyan-rpc : banyan-rpc')
    CASE 568
        StrCopy(servicedesc, 'ms-shuttle : microsoft shuttle')
    CASE 569
        StrCopy(servicedesc, 'ms-rome : microsoft rome')
    CASE 570
        StrCopy(servicedesc, 'meter : demon')
    CASE 571
        StrCopy(servicedesc, 'meter : udemon')
    CASE 572
        StrCopy(servicedesc, 'sonar : sonar')
    CASE 573
        StrCopy(servicedesc, 'banyan-vip : banyan-vip')
    CASE 574
        StrCopy(servicedesc, 'ftp-agent : FTP Software Agent System')
    CASE 575
        StrCopy(servicedesc, 'vemmi : VEMMI')
    CASE 576
        StrCopy(servicedesc, 'ipcd : ipcd')
    CASE 577
        StrCopy(servicedesc, 'vnas : vnas')
    CASE 578
        StrCopy(servicedesc, 'ipdd : ipdd')
    CASE 579
        StrCopy(servicedesc, 'decbsrv : decbsrv')
    CASE 580
        StrCopy(servicedesc, 'sntp-heartbeat : SNTP HEARTBEAT')
    CASE 581
        StrCopy(servicedesc, 'bdp : Bundle Discovery Protocol')
    CASE 582
        StrCopy(servicedesc, 'scc-security : SCC Security')
    CASE 583
        StrCopy(servicedesc, 'philips-vc : Philips Video-Conferencing')
    CASE 584
        StrCopy(servicedesc, 'keyserver : Key Server')
    CASE 585
        StrCopy(servicedesc, 'imap4-ssl : IMAP4+SSL (use 993 instead)')
    CASE 586
        StrCopy(servicedesc, 'password-chg : Password Change')
    CASE 587
        StrCopy(servicedesc, 'submission : Submission')
    CASE 588
        StrCopy(servicedesc, 'cal : CAL')
    CASE 589
        StrCopy(servicedesc, 'eyelink : EyeLink')
    CASE 590
        StrCopy(servicedesc, 'tns-cml : TNS CML')
    CASE 591
        StrCopy(servicedesc, 'http-alt : FileMaker, Inc. - HTTP Alternate (see Port 80)')
    CASE 592
        StrCopy(servicedesc, 'eudora-set : Eudora Set')
    CASE 593
        StrCopy(servicedesc, 'http-rpc-epmap : HTTP RPC Ep Map')
    CASE 594
        StrCopy(servicedesc, 'tpip : TPIP')
    CASE 595
        StrCopy(servicedesc, 'cab-protocol : CAB Protocol')
    CASE 596
        StrCopy(servicedesc, 'smsd : SMSD')
    CASE 597
        StrCopy(servicedesc, 'ptcnameservice : PTC Name Service')
    CASE 598
        StrCopy(servicedesc, 'sco-websrvrmg3 : SCO Web Server Manager 3')
    CASE 599
        StrCopy(servicedesc, 'acp : Aeolon Core Protocol')
    CASE 600
        StrCopy(servicedesc, 'pcserver ipcserver : Sun ECD Integrated PC board server')
    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')

ENDSELECT
ENDPROC


EXPORT PROC service4(portserv:LONG)

SELECT portserv
    CASE 601
        StrCopy(servicedesc, 'ta-rauth : Andrews File System Remote Authentication')
    CASE 606
        StrCopy(servicedesc, 'urm : Cray Unified Resource Manager')
    CASE 607
        StrCopy(servicedesc, 'nqs : nqs')
    CASE 608
        StrCopy(servicedesc, 'sift-uft : Sender-Initiated/Unsolicited File Transfer')
    CASE 609
        StrCopy(servicedesc, 'npmp-trap : npmp-trap')
    CASE 610
        StrCopy(servicedesc, 'npmp-local : npmp-local')
    CASE 611
        StrCopy(servicedesc, 'npmp-gui : npmp-gui')
    CASE 612
        StrCopy(servicedesc, 'hmmp-ind : HMMP Indication')
    CASE 613
        StrCopy(servicedesc, 'hmmp-op : HMMP Operation')
    CASE 614
        StrCopy(servicedesc, 'sshell : SSLshell')
    CASE 615
        StrCopy(servicedesc, 'sco-inetmgr : Internet Configuration Manager')
    CASE 616
        StrCopy(servicedesc, 'sco-sysmgr : SCO System Administration Server')
    CASE 617
        StrCopy(servicedesc, 'sco-dtmgr : SCO Desktop Administration Server')
    CASE 618
        StrCopy(servicedesc, 'dei-icda : DEI-ICDA')
    CASE 619
        StrCopy(servicedesc, 'digital-evm : Digital EVM')
    CASE 620
        StrCopy(servicedesc, 'sco-websrvrmgr : SCO WebServer Manager')
    CASE 621
        StrCopy(servicedesc, 'escp-ip : ESCP')
    CASE 622
        StrCopy(servicedesc, 'collaborator : Collaborator')
    CASE 623
        StrCopy(servicedesc, 'aux_bus_shunt : Aux Bus Shunt')
    CASE 624
        StrCopy(servicedesc, 'cryptoadmin : Crypto Admin')
    CASE 625
        StrCopy(servicedesc, 'dec_dlm : DEC DLM')
    CASE 626
        StrCopy(servicedesc, 'asia : ASIA')
    CASE 627
        StrCopy(servicedesc, 'passgo-tivoli : PassGo Tivoli')
    CASE 628
        StrCopy(servicedesc, 'qmqp : Qmail Quick Mail Queuing')
    CASE 629
        StrCopy(servicedesc, '3com-amp3 : 3Com AMP3')
    CASE 630
        StrCopy(servicedesc, 'rda : RDA')
    CASE 631
        StrCopy(servicedesc, 'ipp cups : IPP (Internet Printing Protocol) ; Common UNIX Printing System')
    CASE 632
        StrCopy(servicedesc, 'bmpp : bmpp')
    CASE 633
        StrCopy(servicedesc, 'servstat : Service Status update (Sterling Software)')
    CASE 634
        StrCopy(servicedesc, 'ginad : ginad')
    CASE 635
        StrCopy(servicedesc, 'rlzdbase mount : RLZ DBase ; MFS Mount Service')
    CASE 636
        StrCopy(servicedesc, 'ldaps ssl-ldap : LDAP protocol over TLS/SSL (was sldap)')
    CASE 637
        StrCopy(servicedesc, 'lanserver : lanserver')
    CASE 638
        StrCopy(servicedesc, 'mcns-sec : mcns-sec')
    CASE 639
        StrCopy(servicedesc, 'msdp : MSDP')
    CASE 640
        StrCopy(servicedesc, 'entrust-sps pcnfs : entrust-sps ; PC-NFS DOS Authentication')
    CASE 641
        StrCopy(servicedesc, 'repcmd : repcmd')
    CASE 642
        StrCopy(servicedesc, 'esro-emsdp : ESRO-EMSDP V1.3')
    CASE 643
        StrCopy(servicedesc, 'sanity : SANity')
    CASE 644
        StrCopy(servicedesc, 'dwr : dwr')
    CASE 645
        StrCopy(servicedesc, 'pssc : PSSC')
    CASE 646
        StrCopy(servicedesc, 'ldp : LDP')
    CASE 647
        StrCopy(servicedesc, 'dhcp-failover : DHCP Failover')
    CASE 648
        StrCopy(servicedesc, 'rrp : Registry Registrar Protocol (RRP)')
    CASE 649
        StrCopy(servicedesc, 'aminet : Aminet')
    CASE 650
        StrCopy(servicedesc, 'obex bwnfs : OBEX ; BW-NFS DOS Authentication')
    CASE 651
        StrCopy(servicedesc, 'ieee-mms : IEEE MMS')
    CASE 652
        StrCopy(servicedesc, 'udlr-dtcp : UDLR_DTCP')
    CASE 653
        StrCopy(servicedesc, 'repscmd : RepCmd')
    CASE 654
        StrCopy(servicedesc, 'aodv : AODV')
    CASE 655
        StrCopy(servicedesc, 'tinc : TINC')
    CASE 656
        StrCopy(servicedesc, 'spmp : SPMP')
    CASE 657
        StrCopy(servicedesc, 'rmc : RMC')
    CASE 658
        StrCopy(servicedesc, 'tenfold : TenFold')
    CASE 659
        StrCopy(servicedesc, 'url-rendezvous : URL Rendezvous')
    CASE 660
        StrCopy(servicedesc, 'mac-srvr-admin : MacOS Server Admin')
    CASE 661
        StrCopy(servicedesc, 'hap : HAP')
    CASE 662
        StrCopy(servicedesc, 'pftp : PFTP')
    CASE 663
        StrCopy(servicedesc, 'purenoise : PureNoise')
    CASE 664
        StrCopy(servicedesc, 'secure-aux-bus : Secure Aux Bus')
    CASE 665
        StrCopy(servicedesc, 'sun-dr : Sun DR')
    CASE 666
        StrCopy(servicedesc, 'mdqs : Sun DR ; doom : Doom Game Server ; \eb[TROJANS=Attack FTP, Cain & Abel, Back Contruction, Satanz Backdoor, ServeU, Shadow Phyre]\en')
    CASE 667
        StrCopy(servicedesc, 'disclose : campaign contribution disclosures - SDR Technologies')
    CASE 668
        StrCopy(servicedesc, 'mecomm : MeComm')
    CASE 669
        StrCopy(servicedesc, 'meregister : MeRegister')
    CASE 670
        StrCopy(servicedesc, 'vacdsm-sws : VACDSM-SWS')
    CASE 671
        StrCopy(servicedesc, 'vacdsm-app : VACDSM-APP')
    CASE 672
        StrCopy(servicedesc, 'vpps-qua : VPPS-QUA')
    CASE 673
        StrCopy(servicedesc, 'cimplex : CIMPLEX')
    CASE 674
        StrCopy(servicedesc, 'acap : ACAP')
    CASE 675
        StrCopy(servicedesc, 'dctp : DCTP')
    CASE 676
        StrCopy(servicedesc, 'vpps-via : VPPS Via')
    CASE 677
        StrCopy(servicedesc, 'vpp : Virtual Presence Protocol')
    CASE 678
        StrCopy(servicedesc, 'ggf-ncp : GNU Gereration Foundation NCP')
    CASE 679
        StrCopy(servicedesc, 'mrm : MRM')
    CASE 680
        StrCopy(servicedesc, 'entrust-aaas : entrust-aaas')
    CASE 681
        StrCopy(servicedesc, 'entrust-aams : entrust-aams')
    CASE 682
        StrCopy(servicedesc, 'xfr : XFR')
    CASE 683
        StrCopy(servicedesc, 'corba-iiop : CORBA IIOP')
    CASE 684
        StrCopy(servicedesc, 'corba-iiop-ssl : CORBA IIOP SSL')
    CASE 685
        StrCopy(servicedesc, 'mdc-portmapper : MDC Port Mapper')
    CASE 686
        StrCopy(servicedesc, 'hcp-wismar : Hardware Control Protocol Wismar')
    CASE 687
        StrCopy(servicedesc, 'asipregistry : asipregistry')
    CASE 688
        StrCopy(servicedesc, 'realm-rusd : REALM-RUSD')
    CASE 689
        StrCopy(servicedesc, 'nmap : NMAP')
    CASE 690
        StrCopy(servicedesc, 'vatp : VATP')
    CASE 691
        StrCopy(servicedesc, 'msexch-routing : MicroSoft Exchange Routing (mail)')
    CASE 692
        StrCopy(servicedesc, 'hyperwave-isp : Hyperwave-ISP')
    CASE 693
        StrCopy(servicedesc, 'connendp : connendp')
    CASE 694
        StrCopy(servicedesc, 'ha-cluster : ha-cluster')
    CASE 695
        StrCopy(servicedesc, 'ieee-mms-ssl : IEEE-MMS-SSL')
    CASE 696
        StrCopy(servicedesc, 'rushd : RUSHD')
    CASE 697
        StrCopy(servicedesc, 'uuidgen : UUIDGEN')
    CASE 698
        StrCopy(servicedesc, 'olsr : OLSR')
    CASE 699
        StrCopy(servicedesc, 'accessnetwork : Access Network')
    CASE 704
        StrCopy(servicedesc, 'elcsd : errlog copy/server daemon')
    CASE 705
        StrCopy(servicedesc, 'agentx : AgentX')
    CASE 706
        StrCopy(servicedesc, 'silc : SILC')
    CASE 707
        StrCopy(servicedesc, 'borland-dsj : Borland DSJ')
    CASE 709
        StrCopy(servicedesc, 'entrust-kmsh : Entrust Key Management Service Handler (Nortel DES)')
    CASE 710
        StrCopy(servicedesc, 'entrust-ash : Entrust Administration Service Handler')
    CASE 711
        StrCopy(servicedesc, 'cisco-tdp : Cisco TDP')
    CASE 729
        StrCopy(servicedesc, 'netviewdm1 : IBM NetView DM/6000 Server/Client')
    CASE 730
        StrCopy(servicedesc, 'netviewdm2 : IBM NetView DM/6000 send/tcp')
    CASE 731
        StrCopy(servicedesc, 'netviewdm3 : IBM NetView DM/6000 receive/tcp')
    CASE 741
        StrCopy(servicedesc, 'netgw : netGW')
    CASE 742
        StrCopy(servicedesc, 'netrcs : Network based Rev. Cont. Sys.')
    CASE 744
        StrCopy(servicedesc, 'flexlm : Flexible License Manager')
    CASE 747
        StrCopy(servicedesc, 'fujitsu-dev : Fujitsu Device Control')
    CASE 748
        StrCopy(servicedesc, 'ris-cm : Russell Info Sci Calendar Manager')
    CASE 749
        StrCopy(servicedesc, 'kerberos-adm :Kerberos Administration Tool (kadmin)')
    CASE 750
        StrCopy(servicedesc, 'rfile : rfile ; kerberos4 kerberos-iv kdc kerberos : Kerberos Server')
    CASE 751
        StrCopy(servicedesc, 'pump : pump ; kerberos_master : Kerberos Authentication')
    CASE 752
        StrCopy(servicedesc, 'qrh : qrh')
    CASE 753
        StrCopy(servicedesc, 'rrh : rrh')
    CASE 754
        StrCopy(servicedesc, 'tell : send ; krb_prop : Kerberos Slave Propagation')
    CASE 758
        StrCopy(servicedesc, 'nlogin : nlogin')
    CASE 759
        StrCopy(servicedesc, 'con : con')
    CASE 760
        StrCopy(servicedesc, 'ns : ns ; krbupdate kreg : Kerberos (v4) Registration')
    CASE 761
        StrCopy(servicedesc, 'rxe : rxe ; kpasswd : Kerberos (v4) Passwd')
    CASE 762
        StrCopy(servicedesc, 'quotad : quotad')
    CASE 763
        StrCopy(servicedesc, 'cycleserv : cycleserv')
    CASE 764
        StrCopy(servicedesc, 'omserv : omserv')
    CASE 765
        StrCopy(servicedesc, 'webster : Webster Network Dictionary')
    CASE 767
        StrCopy(servicedesc, 'phonebook : phone')
    CASE 769
        StrCopy(servicedesc, 'vid : vid')
    CASE 770
        StrCopy(servicedesc, 'cadlock : cadlock')
    CASE 771
        StrCopy(servicedesc, 'rtip : rtip')
    CASE 772
        StrCopy(servicedesc, 'cycleserv2 : cycleserv2')
    CASE 773
        StrCopy(servicedesc, 'submit notify : submit notify')
    CASE 774
        StrCopy(servicedesc, 'rpasswd acmaint_dbd : rpasswd ; acmaint_dbd')
    CASE 775
        StrCopy(servicedesc, 'entomb acmaint_transd : entomb ; acmain_transd')
    CASE 776
        StrCopy(servicedesc, 'wpages : wpages')
    CASE 777
        StrCopy(servicedesc, 'multiling-http : Multiling HTTP ; \eb[TROJANS=AIM Spy App]\en')
    CASE 780
        StrCopy(servicedesc, 'wpgs : wpgs')
    CASE 781
        StrCopy(servicedesc, 'hp-collector : hp performance data collector')
    CASE 782
        StrCopy(servicedesc, 'hp-managed-node : hp performance data managed node')
    CASE 783
        StrCopy(servicedesc, 'hp-alarm-mgr : hp performance data alarm manager')
    CASE 786
        StrCopy(servicedesc, 'concert : Concert')
    CASE 787
        StrCopy(servicedesc, 'qsc : QSC')
    CASE 799
        StrCopy(servicedesc, 'controlit : controlit')
    CASE 800
        StrCopy(servicedesc, 'mdbs_daemon amiganetfs : QSC')


    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC

EXPORT PROC service5(portserv:LONG)

SELECT portserv
    CASE 801
        StrCopy(servicedesc, 'device : device')
    CASE 808
        StrCopy(servicedesc, 'omirr omirrd : Online Mirror')
    CASE 810
        StrCopy(servicedesc, 'fcp-udp : FCP')
    CASE 828
        StrCopy(servicedesc, 'itm-mcell-s : itm-mcell-s')
    CASE 829
        StrCopy(servicedesc, 'pkix-3-ca-ra : PKIX-3 CA/RA')
    CASE 847
        StrCopy(servicedesc, 'dhcp-failover2 : dhcp-failover 2')
    CASE 871
        StrCopy(servicedesc, 'supfilesrv : SUP Filer Server')
    CASE 873
        StrCopy(servicedesc, 'rsync : rsync')
    CASE 886
        StrCopy(servicedesc, 'iclcnet-locate : ICL coNETion locate server')
    CASE 887
        StrCopy(servicedesc, 'iclcnet_svinfo : ICL coNETion server info')
    CASE 888
        StrCopy(servicedesc, 'accessbuilder : AccessBuilder or Audio CD Database')
    CASE 888
        StrCopy(servicedesc, 'cddbp : CD Database Protocol')
    CASE 900
        StrCopy(servicedesc, 'omginitialrefs : OMG Initial Refs')
    CASE 901
        StrCopy(servicedesc, 'smpnameres samba-swat : SMPNAMERES ; WWW Swat Samba Configuration ; ISS RealSecure')
    CASE 902
        StrCopy(servicedesc, 'ideafarm-chat : IDEAFARM-CHAT')
    CASE 903
        StrCopy(servicedesc, 'ideafarm-catch : IDEAFARM-CATCH')
    CASE 911
        StrCopy(servicedesc, 'xact-backup : xact-backup ; \eb[TROJANS=Dark Shadow]\en')
    CASE 950
        StrCopy(servicedesc, 'oftep-rpc : RPC.statd on RedHat Linux')
    CASE 953
        StrCopy(servicedesc, 'rndc : RNDC is used by Bind 9')
    CASE 975
        StrCopy(servicedesc, 'securenetpro-sensor : securenetpro-sensor')
    CASE 989
        StrCopy(servicedesc, 'ftps-data : ftp protocol, data, over TLS/SSL')
    CASE 990
        StrCopy(servicedesc, 'ftps : ftp protocol, control, over TLS/SSL')
    CASE 991
        StrCopy(servicedesc, 'nas : Netnews Administration System')
    CASE 992
        StrCopy(servicedesc, 'telnets : telnet protocol over TLS/SSL')
    CASE 993
        StrCopy(servicedesc, 'imaps simap : imap4 protocol over TLS/SSL')
    CASE 994
        StrCopy(servicedesc, 'ircs : irc protocol over TLS/SSL')
    CASE 995
        StrCopy(servicedesc, 'pop3s spop3 : pop3 protocol over TLS/SSL')
    CASE 996
        StrCopy(servicedesc, 'vsinet : vsinet')
    CASE 997
        StrCopy(servicedesc, 'maitrd : maitrd')
    CASE 998
        StrCopy(servicedesc, 'busboy : busboy')
    CASE 999
        StrCopy(servicedesc, 'garcon applix puprouter: garcon ; applix-ac ; puprouter ; \eb[TROJANS=Deep Throat, WinSatan]\en')
    CASE 1000
        StrCopy(servicedesc, 'cadlock2 cadlock : cadlock V2 ; cadlock ; \eb[TROJANS=Der Spaecher]\en')
    CASE 1001
        StrCopy(servicedesc, '\eb[TROJANS=Silencer, WebEx]\en')
    CASE 1008
        StrCopy(servicedesc, 'ufsd : UFS Aware Server')
    CASE 1010
        StrCopy(servicedesc, 'surf : surf ; \eb[TROJANS=Dolly]\en')
    CASE 1011
        StrCopy(servicedesc, '\eb[TROJANS=Dolly]\en')
    CASE 1012
        StrCopy(servicedesc, 'sometimes-rpc1 : Rstatd (on OpenBSD) ; \eb[TROJANS=Dolly]\en')
    CASE 1015
        StrCopy(servicedesc, '\eb[TROJANS=Dolly]\en')
    CASE 1024
        StrCopy(servicedesc, 'kdm : K Display Manager (K version of XDM) ; \eb[TROJANS=NetSpy]\en')
    CASE 1025
        StrCopy(servicedesc, 'blackjack listen : network blackjack ; Listen Remote File Sharing ; \eb[TROJANS=Mavericks Matrix]\en')
    CASE 1026
        StrCopy(servicedesc, 'nterm : Remote Login Network Terminal')
    CASE 1027
        StrCopy(servicedesc, 'icq : ICQ')
    CASE 1028
        StrCopy(servicedesc, 'icq : ICQ')
    CASE 1029
        StrCopy(servicedesc, 'icq : ICQ')
    CASE 1030
        StrCopy(servicedesc, 'iad1 : BBN IAD')
    CASE 1031
        StrCopy(servicedesc, 'iad2 : BBN IAD')
    CASE 1032
        StrCopy(servicedesc, 'iad3 : BBN IAD')
    CASE 1033
        StrCopy(servicedesc, '\eb[TROJANS=NetSpy]\en')
    CASE 1042
        StrCopy(servicedesc, '\eb[TROJANS=Bla]\en')
    CASE 1045
        StrCopy(servicedesc, '\eb[TROJANS=Rasmin]\en')
    CASE 1047
        StrCopy(servicedesc, 'neod1 : Suns NEO Object Request Broker')
    CASE 1048
        StrCopy(servicedesc, 'neod2 : Suns NEO Object Request Broker')
    CASE 1049
        StrCopy(servicedesc, 'td-postman : Tobit David Postman VPMN')
    CASE 1050
        StrCopy(servicedesc, 'cma : CORBA Management Agent')
    CASE 1051
        StrCopy(servicedesc, 'optima-vnet : Optima VNET')
    CASE 1052
        StrCopy(servicedesc, 'ddt : Dynamic DNS Tools')
    CASE 1053
        StrCopy(servicedesc, 'remote-as : Remote Assistant (RA)')
    CASE 1054
        StrCopy(servicedesc, 'brvread : BRVREAD')
    CASE 1055
        StrCopy(servicedesc, 'ansyslmd : ANSYS - License Manager ')
    CASE 1056
        StrCopy(servicedesc, 'vfo : VFO')
    CASE 1057
        StrCopy(servicedesc, 'startron : STARTRON')
    CASE 1058
        StrCopy(servicedesc, 'nim : nim')
    CASE 1059
        StrCopy(servicedesc, 'nimreg : nimreg')
    CASE 1060
        StrCopy(servicedesc, 'polestar : POLESTAR')
    CASE 1061
        StrCopy(servicedesc, 'kiosk : KIOSK')
    CASE 1062
        StrCopy(servicedesc, 'veracity : Veracity')
    CASE 1063
        StrCopy(servicedesc, 'kyoceranetdev : KyoceraNetDev')
    CASE 1064
        StrCopy(servicedesc, 'jstel : JSTEL')
    CASE 1065
        StrCopy(servicedesc, 'syscomlan : SYSCOMLAN')
    CASE 1066
        StrCopy(servicedesc, 'fpo-fns : FPO-FNS')
    CASE 1067
        StrCopy(servicedesc, 'instl_boots : Installation Bootstrap Proto. Serv.')
    CASE 1068
        StrCopy(servicedesc, 'instl_bootc : Installation Bootstrap Proto. Cli.')
    CASE 1069
        StrCopy(servicedesc, 'cognex-insight : COGNEX-INSIGHT')
    CASE 1070
        StrCopy(servicedesc, 'gmrupdateserv : GMRUpdateSERV')
    CASE 1071
        StrCopy(servicedesc, 'bsquare-voip : BSQUARE-VOIP')
    CASE 1072
        StrCopy(servicedesc, 'cardax : CARDAX')
    CASE 1073
        StrCopy(servicedesc, 'bridgecontrol : BridgeControl')
    CASE 1074
        StrCopy(servicedesc, 'fastechnologlm : FASTechnologies License Manager')
    CASE 1075
        StrCopy(servicedesc, 'rdrmshc : RDRMSHC')
    CASE 1076
        StrCopy(servicedesc, 'dab-sti-c : DAB STI-C')
    CASE 1077
        StrCopy(servicedesc, 'imgames : IMGames')
    CASE 1078
        StrCopy(servicedesc, 'emanagecstp : eManageCstp')
    CASE 1079
        StrCopy(servicedesc, 'asprovatalk : ASPROVATalk')
    CASE 1080
        StrCopy(servicedesc, 'socks : Socks Proxy Server')
    CASE 1081
        StrCopy(servicedesc, 'pvuniwien : PVUNIWIEN')
    CASE 1082
        StrCopy(servicedesc, 'amt-esd-prot : AMT-ESD-PROT')
    CASE 1083
        StrCopy(servicedesc, 'ansoft-lm-1 : Anasoft License Manager')
    CASE 1084
        StrCopy(servicedesc, 'ansoft-lm-2 : Anasoft License Manager')
    CASE 1085
        StrCopy(servicedesc, 'webobjects : Web Objects')
    CASE 1086
        StrCopy(servicedesc, 'cplscrambler-lg : CPL Scrambler Logging')
    CASE 1087
        StrCopy(servicedesc, 'cplscrambler-in : CPL Scrambler Internal')
    CASE 1088
        StrCopy(servicedesc, 'cplscrambler-al : CPL Scrambler Alarm Log')
    CASE 1089
        StrCopy(servicedesc, 'ff-annunc : FF Annunciation')
    CASE 1090
        StrCopy(servicedesc, 'ff-fms : FF Fieldbus Message Specification ; \eb[TROJANS=XTreme]\en')
    CASE 1091
        StrCopy(servicedesc, 'ff-sm : FF System Management')
    CASE 1092
        StrCopy(servicedesc, 'obrpd : OBRPD')
    CASE 1093
        StrCopy(servicedesc, 'proofd : PROOFD')
    CASE 1094
        StrCopy(servicedesc, 'rootd : ROOTD')
    CASE 1095
        StrCopy(servicedesc, 'nicelink : NICELink ; \eb[TROJANS=Rat]\en')
    CASE 1096
        StrCopy(servicedesc, 'cnrprotocol : Common Name Resolution Protocol')
    CASE 1097
        StrCopy(servicedesc, 'sunclustermgr : Sun Cluster Manager ; \eb[TROJANS=Rat]\en')
    CASE 1098
        StrCopy(servicedesc, 'rmiactivation : RMI Activation ; \eb[TROJANS=Rat]\en')
    CASE 1099
        StrCopy(servicedesc, 'rmiregistry : RMI Registry ; \eb[TROJANS=Rat]\en')
    CASE 1100
        StrCopy(servicedesc, 'mctp : MCTP')
    CASE 1101
        StrCopy(servicedesc, 'pt2-discover : PT2-DISCOVER')
    CASE 1102
        StrCopy(servicedesc, 'adobeserver-1 : ADOBE SERVER 1')
    CASE 1103
        StrCopy(servicedesc, 'adobeserver-2 xaudio : ADOBE SERVER 2 ; X Audio Server')
    CASE 1104
        StrCopy(servicedesc, 'xrl : XRL')
    CASE 1105
        StrCopy(servicedesc, 'ftranhc : FTRANHC')
    CASE 1106
        StrCopy(servicedesc, 'isoipsigport-1 : ISOIPSIGPORT-1')
    CASE 1107
        StrCopy(servicedesc, 'isoipsigport-2 : ISOIPSIGPORT-2')
    CASE 1108
        StrCopy(servicedesc, 'ratio-adp : ratio-adp')
    CASE 1109
        StrCopy(servicedesc, 'kpop : Post Office Protocol using Kerberos')
    CASE 1110
        StrCopy(servicedesc, 'nfsd-status : Cluster status info')
    CASE 1111
        StrCopy(servicedesc, 'lmsocialserver : LM Social Server')
    CASE 1112
        StrCopy(servicedesc, 'icp msql : Intelligent Communication Protocol ; Mini SQL Server')
    CASE 1114
        StrCopy(servicedesc, 'mini-sql : Mini SQL')
    CASE 1115
        StrCopy(servicedesc, 'ardus-trns : ARDUS Transfer')
    CASE 1116
        StrCopy(servicedesc, 'ardus-cntl : ARDUS Control')
    CASE 1117
        StrCopy(servicedesc, 'ardus-mtrns : ARDUS Multicast Transfer')
    CASE 1122
        StrCopy(servicedesc, 'availant-mgr : availant-mgr')
    CASE 1123
        StrCopy(servicedesc, 'murray : Murray')


    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC

EXPORT PROC service6(portserv:LONG)

SELECT portserv
    CASE 1127
        StrCopy(servicedesc, 'supfiledvg : SUP Debugging')
    CASE 1139
        StrCopy(servicedesc, 'cc3ex : ClearCommerce Engine 3.x')
    CASE 1155
        StrCopy(servicedesc, 'nfa : Network File Access')
    CASE 1161
        StrCopy(servicedesc, 'health-polling : Health Polling')
    CASE 1162
        StrCopy(servicedesc, 'health-trap : Health Trap')
    CASE 1167
        StrCopy(servicedesc, 'phone : Conference Calling')
    CASE 1169
        StrCopy(servicedesc, 'tripwire : TRIPWIRE')
    CASE 1170
        StrCopy(servicedesc, 'xxx : Voice Streaming Audio ; \eb[TROJANS=Psyber Streaming, Voice Trojan]\en')
    CASE 1178
        StrCopy(servicedesc, 'skkserv : SKK - Kanji (japanese) input')
    CASE 1180
        StrCopy(servicedesc, 'mc-client : Millicent Client Proxy')
    CASE 1188
        StrCopy(servicedesc, 'hp-webadmin : HP Web Admin')
    CASE 1200
        StrCopy(servicedesc, 'scol : SCOL')
    CASE 1201
        StrCopy(servicedesc, 'nucleus-sand : Nucleus Sand')
    CASE 1202
        StrCopy(servicedesc, 'caiccipc : caiccipc')
    CASE 1203
        StrCopy(servicedesc, 'ssslic-mgr : License Validation')
    CASE 1204
        StrCopy(servicedesc, 'ssslog-mgr : Log Request Listener')
    CASE 1205
        StrCopy(servicedesc, 'accord-mgc : Accord-MGC')
    CASE 1206
        StrCopy(servicedesc, 'anthony-data : Anthony Data')
    CASE 1207
        StrCopy(servicedesc, 'metasage : MetaSage ; \eb[TROJANS=Soft War]\en')
    CASE 1208
        StrCopy(servicedesc, 'seagull-ais : SEAGULL AIS')
    CASE 1209
        StrCopy(servicedesc, 'ipcd3 : IPCD3')
    CASE 1210
        StrCopy(servicedesc, 'eoss : EOSS')
    CASE 1211
        StrCopy(servicedesc, 'groove-dpp : Groove DPP')
    CASE 1212
        StrCopy(servicedesc, 'lupa : lupa')
    CASE 1213
        StrCopy(servicedesc, 'mpc-lifenet : MPC LIFENET')
    CASE 1214
        StrCopy(servicedesc, 'kazaa : KAZAA and Morpheus File Sharing')
    CASE 1215
        StrCopy(servicedesc, 'scanstat-1 : scanSTAT 1.0')
    CASE 1216
        StrCopy(servicedesc, 'etebac5 : ETEBAC 5')
    CASE 1217
        StrCopy(servicedesc, 'hpss-ndapi : HPSS-NDAPI')
    CASE 1218
        StrCopy(servicedesc, 'aeroflight-ads : AeroFlight-ADs')
    CASE 1219
        StrCopy(servicedesc, 'aeroflight-ret : AeroFlight-Ret')
    CASE 1220
        StrCopy(servicedesc, 'qt-serveradmin : QT SERVER ADMIN')
    CASE 1221
        StrCopy(servicedesc, 'sweetware-apps : SweetWARE Apps')
    CASE 1222
        StrCopy(servicedesc, 'nerv : SNI R&D network')
    CASE 1223
        StrCopy(servicedesc, 'tgp : TGP')
    CASE 1224
        StrCopy(servicedesc, 'vpnz : VPNz')
    CASE 1225
        StrCopy(servicedesc, 'slinkysearch : SLINKYSEARCH')
    CASE 1226
        StrCopy(servicedesc, 'stgxfws : STGXFWS')
    CASE 1227
        StrCopy(servicedesc, 'dns2go : DNS2Go')
    CASE 1228
        StrCopy(servicedesc, 'florence : FLORENCE')
    CASE 1229
        StrCopy(servicedesc, 'novell-zfs : Novell ZFS')
    CASE 1230
        StrCopy(servicedesc, 'periscope : Periscope')
    CASE 1231
        StrCopy(servicedesc, 'menandmice-lpm : menandmice-lpm')
    CASE 1232
        StrCopy(servicedesc, 'mtrgtrans : mtrgtrans')
    CASE 1233
        StrCopy(servicedesc, 'univ-appserver : Universal App Server')
    CASE 1234
        StrCopy(servicedesc, 'search-agent hotline: Infoseek Search Agent ; \eb[TROJANS=Ultors]\en')
    CASE 1235
        StrCopy(servicedesc, 'mosaicsyssvc1 : mosaicsyssvc1')
    CASE 1236
        StrCopy(servicedesc, 'bvcontrol : bvcontrol ; rmtcfg : Gracilis Packeten Remote Configuration')
    CASE 1237
        StrCopy(servicedesc, 'tsdos390 : tsdos390')
    CASE 1238
        StrCopy(servicedesc, 'hacl-qs : hacl-qs')
    CASE 1239
        StrCopy(servicedesc, 'nmsd : NMSD')
    CASE 1240
        StrCopy(servicedesc, 'instantia : Instantia')
    CASE 1241
        StrCopy(servicedesc, 'nessus msg : nessus ; remote message server')
    CASE 1242
        StrCopy(servicedesc, 'nmasoverip : NMAS over IP')
    CASE 1243
        StrCopy(servicedesc, 'serialgateway : SerialGateway ; \eb[TROJANS=SubSeven]\en')
    CASE 1244
        StrCopy(servicedesc, 'isbconference1 : isbconference1')
    CASE 1245
        StrCopy(servicedesc, 'isbconference2 : isbconference2 ; \eb[TROJANS=VooDoo Doll]\en')
    CASE 1246
        StrCopy(servicedesc, 'payrouter : payrouter')
    CASE 1247
        StrCopy(servicedesc, 'visionpyramid : VisionPyramid')
    CASE 1248
        StrCopy(servicedesc, 'hermes : hermes')
    CASE 1249
        StrCopy(servicedesc, 'mesavistaco : Mesa Vista Co')
    CASE 1250
        StrCopy(servicedesc, 'swldy-sias : swldy-sias')
    CASE 1251
        StrCopy(servicedesc, 'servergraph : servergraph')
    CASE 1252
        StrCopy(servicedesc, 'bspne-pcc : bspne-pcc')
    CASE 1253
        StrCopy(servicedesc, 'q55-pcc : q55-pcc')
    CASE 1254
        StrCopy(servicedesc, 'de-noc : de-noc')
    CASE 1255
        StrCopy(servicedesc, 'de-cache-query : de-cache-query')
    CASE 1256
        StrCopy(servicedesc, 'de-server : de-server')
    CASE 1257
        StrCopy(servicedesc, 'shockwave2 : Shockwave 2')
    CASE 1258
        StrCopy(servicedesc, 'opennl : Open Network Library')
    CASE 1259
        StrCopy(servicedesc, 'opennl-voice : Open Network Library Voice')
    CASE 1260
        StrCopy(servicedesc, 'ibm-ssd : ibm-ssd')
    CASE 1261
        StrCopy(servicedesc, 'mpshrsv : mpshrsv')
    CASE 1262
        StrCopy(servicedesc, 'qnts-orb : QNTS-ORB')
    CASE 1263
        StrCopy(servicedesc, 'dka : dka')
    CASE 1264
        StrCopy(servicedesc, 'prat : PRAT')
    CASE 1265
        StrCopy(servicedesc, 'dssiapi : DSSIAPI')
    CASE 1266
        StrCopy(servicedesc, 'dellpwrappks : DELLPWRAPPKS')
    CASE 1267
        StrCopy(servicedesc, 'pcmlinux : pcmlinux')
    CASE 1268
        StrCopy(servicedesc, 'propel-msgsys : PROPEL-MSGSYS')
    CASE 1269
        StrCopy(servicedesc, 'watilapp : WATiLaPP ; \eb[TROJANS=Mavericks Matrix]\en')
    CASE 1270
        StrCopy(servicedesc, 'opsman : opsman')
    CASE 1271
        StrCopy(servicedesc, 'dabew : Dabew')
    CASE 1272
        StrCopy(servicedesc, 'cspmlockmgr : CSPMLockMgr')
    CASE 1273
        StrCopy(servicedesc, 'emc-gateway : EMC-Gateway')
    CASE 1274
        StrCopy(servicedesc, 't1distproc : t1distproc')
    CASE 1275
        StrCopy(servicedesc, 'ivcollector : ivcollector')
    CASE 1276
        StrCopy(servicedesc, 'ivmanager : ivmanager')
    CASE 1277
        StrCopy(servicedesc, 'miva-mqs : mqs')
    CASE 1278
        StrCopy(servicedesc, 'dellwebadmin-1 : Dell Web Admin 1')
    CASE 1279
        StrCopy(servicedesc, 'dellwebadmin-2 : Dell Web Admin 2')
    CASE 1280
        StrCopy(servicedesc, 'pictrography : Pictrography')
    CASE 1281
        StrCopy(servicedesc, 'healthd : healthd')
    CASE 1282
        StrCopy(servicedesc, 'emperion : Emperion')
    CASE 1283
        StrCopy(servicedesc, 'productinfo : ProductInfo')
    CASE 1284
        StrCopy(servicedesc, 'iee-qfx : IEE-QFX')
    CASE 1285
        StrCopy(servicedesc, 'neoiface : neoiface')
    CASE 1286
        StrCopy(servicedesc, 'netuitive : netuitive')
    CASE 1288
        StrCopy(servicedesc, 'navbuddy : NavBuddy')
    CASE 1289
        StrCopy(servicedesc, 'jwalkserver : JWalkServer')
    CASE 1290
        StrCopy(servicedesc, 'winjaserver : WinJaServer')
    CASE 1291
        StrCopy(servicedesc, 'seagulllms : SEAGULLLMS')
    CASE 1292
        StrCopy(servicedesc, 'dsdn : dsdn')
    CASE 1293
        StrCopy(servicedesc, 'pkt-krb-ipsec : PKT-KRB-IPSec')
    CASE 1294
        StrCopy(servicedesc, 'cmmdriver : CMMdriver')
    CASE 1295
        StrCopy(servicedesc, 'eetp : EETP')
    CASE 1296
        StrCopy(servicedesc, 'dproxy : dproxy')
    CASE 1297
        StrCopy(servicedesc, 'sdproxy : sdproxy')
    CASE 1298
        StrCopy(servicedesc, 'lpcp : lpcp')
    CASE 1299
        StrCopy(servicedesc, 'hp-sci : hp-sci')
    CASE 1300
        StrCopy(servicedesc, 'h323hostcallsc : H323 Host Call Secure')
    CASE 1301
        StrCopy(servicedesc, 'ci3-software-1 : CI3-Software-1')
    CASE 1302
        StrCopy(servicedesc, 'ci3-software-2 : CI3-Software-2')
    CASE 1303
        StrCopy(servicedesc, 'sftsrv : sftsrv')
    CASE 1304
        StrCopy(servicedesc, 'boomerang : Boomerang')
    CASE 1305
        StrCopy(servicedesc, 'pe-mike : pe-mike')
    CASE 1306
        StrCopy(servicedesc, 're-conn-proto : RE-Conn-Proto')
    CASE 1307
        StrCopy(servicedesc, 'pacmand : Pacmand')
    CASE 1308
        StrCopy(servicedesc, 'odsi : Optical Domain Service Interconnect (ODSI)')
    CASE 1309
        StrCopy(servicedesc, 'jtag-server : JTAG server')
    CASE 1310
        StrCopy(servicedesc, 'husky : Husky')
    CASE 1311
        StrCopy(servicedesc, 'rxmon : RxMon')
    CASE 1312
        StrCopy(servicedesc, 'sti-envision : STI Envision')
    CASE 1313
        StrCopy(servicedesc, 'bmc_patroldb : BMC_PATROLDB')
    CASE 1314
        StrCopy(servicedesc, 'pdps : Photoscript Distributed Printing System')
    CASE 1315
        StrCopy(servicedesc, 'els : els')
    CASE 1316
        StrCopy(servicedesc, 'exbit-escp : Exbit-ESCP')
    CASE 1317
        StrCopy(servicedesc, 'vrts-ipcserver : vrts-ipcserver')
    CASE 1318
        StrCopy(servicedesc, 'krb5gatekeeper : krb5gatekeeper')
    CASE 1319
        StrCopy(servicedesc, 'panja-icsp : Panja-ICSP')
    CASE 1320
        StrCopy(servicedesc, 'panja-axbnet : Panja-AXBNET')
    CASE 1321
        StrCopy(servicedesc, 'pip : PIP')
    CASE 1322
        StrCopy(servicedesc, 'novation : Novation')
    CASE 1323
        StrCopy(servicedesc, 'brcd : brcd')
    CASE 1324
        StrCopy(servicedesc, 'delta-mcp : delta-mcp')
    CASE 1325
        StrCopy(servicedesc, 'dx-instrument : DX-Instrument')
    CASE 1326
        StrCopy(servicedesc, 'wimsic : WIMSIC')
    CASE 1327
        StrCopy(servicedesc, 'ultrex : Ultrex')
    CASE 1328
        StrCopy(servicedesc, 'ewall : EWALL')
    CASE 1329
        StrCopy(servicedesc, 'netdb-export : netdb-export')
    CASE 1330
        StrCopy(servicedesc, 'streetperfect : StreetPerfect')
    CASE 1331
        StrCopy(servicedesc, 'intersan : intersan')
    CASE 1332
        StrCopy(servicedesc, 'pcia-rxp-b : PCIA RXP-B')
    CASE 1333
        StrCopy(servicedesc, 'passwrd-policy : Password Policy')
    CASE 1334
        StrCopy(servicedesc, 'writesrv : writesrv')
    CASE 1335
        StrCopy(servicedesc, 'digital-notary : Digital Notary Protocol')
    CASE 1336
        StrCopy(servicedesc, 'ischat : Instant Service Chat')
    CASE 1337
        StrCopy(servicedesc, 'menandmice-dns : menandmice DNS')
    CASE 1338
        StrCopy(servicedesc, 'wmc-log-svc : WMC-log-svr')
    CASE 1339
        StrCopy(servicedesc, 'kjtsiteserver : kjtsiteserver')
    CASE 1340
        StrCopy(servicedesc, 'naap : NAAP')
    CASE 1341
        StrCopy(servicedesc, 'qubes : QuBES')
    CASE 1342
        StrCopy(servicedesc, 'esbroker : ESBroker')
    CASE 1343
        StrCopy(servicedesc, 're101 : re101')
    CASE 1344
        StrCopy(servicedesc, 'icap : ICAP')
    CASE 1345
        StrCopy(servicedesc, 'vpjp : VPJP')
    CASE 1346
        StrCopy(servicedesc, 'alta-ana-lm : Alta Analytics License Manager ')
    CASE 1347
        StrCopy(servicedesc, 'bbn-mmc : multi media conferencing')
    CASE 1348
        StrCopy(servicedesc, 'bbn-mmx : multi media conferencing')
    CASE 1349
        StrCopy(servicedesc, 'sbook : Registration Network Protocol ; \eb[TROJANS=Back Orifice DLL]\en')
    CASE 1350
        StrCopy(servicedesc, 'editbench : Registration Network Protocol')
    CASE 1351
        StrCopy(servicedesc, 'equationbuilder : Digital Tool Works (MIT)')
    CASE 1352
        StrCopy(servicedesc, 'lotusnote : Lotus Notes')
    CASE 1353
        StrCopy(servicedesc, 'relief : Relief Consulting')
    CASE 1354
        StrCopy(servicedesc, 'rightbrain : RightBrain Software')
    CASE 1355
        StrCopy(servicedesc, 'intuitive-edge : Intuitive Edge')
    CASE 1356
        StrCopy(servicedesc, 'cuillamartin : CuillaMartin Company')
    CASE 1357
        StrCopy(servicedesc, 'pegboard : Electronic PegBoard')
    CASE 1358
        StrCopy(servicedesc, 'connlcli : CONNLCLI')
    CASE 1359
        StrCopy(servicedesc, 'ftsrv : FTSRV')
    CASE 1360
        StrCopy(servicedesc, 'mimer : MIMER')
    CASE 1361
        StrCopy(servicedesc, 'linx : LinX')
    CASE 1362
        StrCopy(servicedesc, 'timeflies : TimeFlies')
    CASE 1363
        StrCopy(servicedesc, 'ndm-requester : Network DataMover Requester')
    CASE 1364
        StrCopy(servicedesc, 'ndm-server : Network DataMover Server')
    CASE 1365
        StrCopy(servicedesc, 'adapt-sna : Network Software Associates')
    CASE 1366
        StrCopy(servicedesc, 'netware-csp : Novell NetWare Comm Service Platform')
    CASE 1367
        StrCopy(servicedesc, 'dcs : DCS')
    CASE 1368
        StrCopy(servicedesc, 'screencast : ScreenCast')
    CASE 1369
        StrCopy(servicedesc, 'gv-us : GlobalView to Unix Shell')
    CASE 1370
        StrCopy(servicedesc, 'us-gv : Unix Shell to GlobalView')
    CASE 1371
        StrCopy(servicedesc, 'fc-cli : Fujitsu Config Protocol')
    CASE 1372
        StrCopy(servicedesc, 'fc-ser : Fujitsu Config Protocol')
    CASE 1373
        StrCopy(servicedesc, 'chromagrafx : Chromagrafx')
    CASE 1374
        StrCopy(servicedesc, 'molly : EPI Software Systems')
    CASE 1375
        StrCopy(servicedesc, 'bytex : Bytex')
    CASE 1376
        StrCopy(servicedesc, 'ibm-pps : IBM Person to Person Software')
    CASE 1377
        StrCopy(servicedesc, 'cichlid : Cichlid License Manager')
    CASE 1378
        StrCopy(servicedesc, 'elan : Elan License Manager')
    CASE 1379
        StrCopy(servicedesc, 'dbreporter : Integrity Solutions')
    CASE 1380
        StrCopy(servicedesc, 'telesis-licman : Telesis Network License Manager')
    CASE 1381
        StrCopy(servicedesc, 'apple-licman : Apple Network License Manager')
    CASE 1382
        StrCopy(servicedesc, 'udt_os : udt_os')
    CASE 1383
        StrCopy(servicedesc, 'gwha : GW Hannaway Network License Manager')
    CASE 1384
        StrCopy(servicedesc, 'os-licman : Objective Solutions License Manager')
    CASE 1385
        StrCopy(servicedesc, 'atex_elmd : Atex Publishing License Manager')
    CASE 1386
        StrCopy(servicedesc, 'checksum : CheckSum License Manager')
    CASE 1387
        StrCopy(servicedesc, 'cadsi-lm : Computer Aided Design Software Inc LM')
    CASE 1388
        StrCopy(servicedesc, 'objective-dbc : Objective Solutions DataBase Cache')
    CASE 1389
        StrCopy(servicedesc, 'iclpv-dm : Document Manager')
    CASE 1390
        StrCopy(servicedesc, 'iclpv-sc : Storage Controller')
    CASE 1391
        StrCopy(servicedesc, 'iclpv-sas : Storage Access Server')
    CASE 1392
        StrCopy(servicedesc, 'iclpv-pm : Print Manager')
    CASE 1393
        StrCopy(servicedesc, 'iclpv-nls : Network Log Server')
    CASE 1394
        StrCopy(servicedesc, 'iclpv-nlc : Network Log Client')
    CASE 1395
        StrCopy(servicedesc, 'iclpv-wsm : PC Workstation Manager software')
    CASE 1396
        StrCopy(servicedesc, 'dvl-activemail : DVL Active Mail')
    CASE 1397
        StrCopy(servicedesc, 'audio-activmail : Audio Active Mail')
    CASE 1398
        StrCopy(servicedesc, 'video-activmail : Video Active Mail')
    CASE 1399
        StrCopy(servicedesc, 'cadkey-licman : Cadkey License Manager')
    CASE 1400
        StrCopy(servicedesc, 'cadkey-tablet : Cadkey Tablet Daemon')


    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC

EXPORT PROC service7(portserv:LONG)

SELECT portserv
    CASE 1401
        StrCopy(servicedesc, 'goldleaf-licman : Goldleaf License Manager')
    CASE 1402
        StrCopy(servicedesc, 'prm-sm-np : Prospero Resource Manager')
    CASE 1403
        StrCopy(servicedesc, 'prm-nm-np : Prospero Resource Manager')
    CASE 1404
        StrCopy(servicedesc, 'igi-lm : Infinite Graphics License Manager')
    CASE 1405
        StrCopy(servicedesc, 'ibm-res : IBM Remote Execution Starter')
    CASE 1406
        StrCopy(servicedesc, 'netlabs-lm : NetLabs License Manager')
    CASE 1407
        StrCopy(servicedesc, 'dbsa-lm : DBSA License Manager')
    CASE 1408
        StrCopy(servicedesc, 'sophia-lm : Sophia License Manager')
    CASE 1409
        StrCopy(servicedesc, 'here-lm : Here License Manager')
    CASE 1410
        StrCopy(servicedesc, 'hiq : HiQ License Manager')
    CASE 1411
        StrCopy(servicedesc, 'af : AudioFile')
    CASE 1412
        StrCopy(servicedesc, 'innosys : InnoSys')
    CASE 1413
        StrCopy(servicedesc, 'innosys-acl : Innosys-ACL')
    CASE 1414
        StrCopy(servicedesc, 'ibm-mqseries : IBM MQSeries')
    CASE 1415
        StrCopy(servicedesc, 'dbstar : DBStar')
    CASE 1416
        StrCopy(servicedesc, 'novell-lu6.2 : Novell LU6.2')
    CASE 1417
        StrCopy(servicedesc, 'timbuktu-srv1 : Timbuktu Service (desktop viewer) 1 Port')
    CASE 1418
        StrCopy(servicedesc, 'timbuktu-srv2 : Timbuktu Service (desktop viewer) 2 Port')
    CASE 1419
        StrCopy(servicedesc, 'timbuktu-srv3 : Timbuktu Service (desktop viewer) 3 Port')
    CASE 1420
        StrCopy(servicedesc, 'timbuktu-srv4 : Timbuktu Service (desktop viewer) 4 Port')
    CASE 1421
        StrCopy(servicedesc, 'gandalf-lm : Gandalf License Manager')
    CASE 1422
        StrCopy(servicedesc, 'autodesk-lm : Autodesk License Manager')
    CASE 1423
        StrCopy(servicedesc, 'essbase : Essbase Arbor Software')
    CASE 1424
        StrCopy(servicedesc, 'hybrid : Hybrid Encryption Protocol')
    CASE 1425
        StrCopy(servicedesc, 'zion-lm : Zion Software License Manager')
    CASE 1426
        StrCopy(servicedesc, 'sais : Satellite-data Acquisition System 1')
    CASE 1427
        StrCopy(servicedesc, 'mloadd : mloadd monitoring tool')
    CASE 1428
        StrCopy(servicedesc, 'informatik-lm : Informatik License Manager')
    CASE 1429
        StrCopy(servicedesc, 'nms : Hypercom NMS')
    CASE 1430
        StrCopy(servicedesc, 'tpdu : Hypercom TPDU')
    CASE 1431
        StrCopy(servicedesc, 'rgtp : Reverse Gossip Transport')
    CASE 1432
        StrCopy(servicedesc, 'blueberry-lm : Blueberry Software License Manager')
    CASE 1433
        StrCopy(servicedesc, 'ms-sql-s : Microsoft-SQL-Server')
    CASE 1434
        StrCopy(servicedesc, 'ms-sql-m : Microsoft-SQL-Monitor')
    CASE 1435
        StrCopy(servicedesc, 'ibm-cics : IBM CICS')
    CASE 1436
        StrCopy(servicedesc, 'saism : Satellite-data Acquisition System 2')
    CASE 1437
        StrCopy(servicedesc, 'tabula : Tabula')
    CASE 1438
        StrCopy(servicedesc, 'eicon-server : Eicon Security Agent/Server')
    CASE 1439
        StrCopy(servicedesc, 'eicon-x25 : Eicon X25/SNA Gateway')
    CASE 1440
        StrCopy(servicedesc, 'eicon-slp : Eicon Service Location Protocol')
    CASE 1441
        StrCopy(servicedesc, 'cadis-1 : Cadis License Management')
    CASE 1442
        StrCopy(servicedesc, 'cadis-2 : Cadis License Management')
    CASE 1443
        StrCopy(servicedesc, 'ies-lm : Integrated Engineering Software')
    CASE 1444
        StrCopy(servicedesc, 'marcam-lm : Marcam  License Management')
    CASE 1445
        StrCopy(servicedesc, 'proxima-lm : Proxima License Manager')
    CASE 1446
        StrCopy(servicedesc, 'ora-lm : Optical Research Associates License Manager')
    CASE 1447
        StrCopy(servicedesc, 'apri-lm : Applied Parallel Research LM')
    CASE 1448
        StrCopy(servicedesc, 'oc-lm : OpenConnect License Manager')
    CASE 1449
        StrCopy(servicedesc, 'peport : PEport')
    CASE 1450
        StrCopy(servicedesc, 'dwf : Tandem Distributed Workbench Facility')
    CASE 1451
        StrCopy(servicedesc, 'infoman : IBM Information Management')
    CASE 1452
        StrCopy(servicedesc, 'gtegsc-lm : GTE Government Systems License Man ')
    CASE 1453
        StrCopy(servicedesc, 'genie-lm : Genie License Manager')
    CASE 1454
        StrCopy(servicedesc, 'interhdl_elmd : interHDL License Manager')
    CASE 1455
        StrCopy(servicedesc, 'esl-lm : ESL License Manager')
    CASE 1456
        StrCopy(servicedesc, 'dca : DCA')
    CASE 1457
        StrCopy(servicedesc, 'valisys-lm : Valisys License Manager')
    CASE 1458
        StrCopy(servicedesc, 'nrcabq-lm : Nichols Research Corp.')
    CASE 1459
        StrCopy(servicedesc, 'proshare1 : Proshare Notebook Application')
    CASE 1460
        StrCopy(servicedesc, 'proshare2 : Proshare Notebook Application')
    CASE 1461
        StrCopy(servicedesc, 'ibm_wrless_lan : IBM Wireless LAN')
    CASE 1462
        StrCopy(servicedesc, 'world-lm : World License Manager')
    CASE 1463
        StrCopy(servicedesc, 'nucleus : Nucleus')
    CASE 1464
        StrCopy(servicedesc, 'msl_lmd : MSL License Manager')
    CASE 1465
        StrCopy(servicedesc, 'pipes : Pipes Platform')
    CASE 1466
        StrCopy(servicedesc, 'oceansoft-lm : Ocean Software License Manager')
    CASE 1467
        StrCopy(servicedesc, 'csdmbase : CSDMBASE')
    CASE 1468
        StrCopy(servicedesc, 'csdm : CSDM')
    CASE 1469
        StrCopy(servicedesc, 'aal-lm : Active Analysis Limited License Manager')
    CASE 1470
        StrCopy(servicedesc, 'uaiact : Universal Analytics')
    CASE 1471
        StrCopy(servicedesc, 'csdmbase : csdmbase')
    CASE 1472
        StrCopy(servicedesc, 'csdm : csdm')
    CASE 1473
        StrCopy(servicedesc, 'openmath : OpenMath')
    CASE 1474
        StrCopy(servicedesc, 'telefinder : Telefinder')
    CASE 1475
        StrCopy(servicedesc, 'taligent-lm : Taligent License Manager')
    CASE 1476
        StrCopy(servicedesc, 'clvm-cfg : clvm-cfg')
    CASE 1477
        StrCopy(servicedesc, 'ms-sna-server : ms-sna-server')
    CASE 1478
        StrCopy(servicedesc, 'ms-sna-base : ms-sna-base')
    CASE 1479
        StrCopy(servicedesc, 'dberegister : dberegister')
    CASE 1480
        StrCopy(servicedesc, 'pacerforum : PacerForum')
    CASE 1481
        StrCopy(servicedesc, 'airs : AIRS')
    CASE 1482
        StrCopy(servicedesc, 'miteksys-lm : Miteksys License Manager')
    CASE 1483
        StrCopy(servicedesc, 'afs : AFS License Manager')
    CASE 1484
        StrCopy(servicedesc, 'confluent : Confluent License Manager')
    CASE 1485
        StrCopy(servicedesc, 'lansource : LANSource')
    CASE 1486
        StrCopy(servicedesc, 'nms_topo_serv : nms_topo_serv')
    CASE 1487
        StrCopy(servicedesc, 'localinfosrvr : LocalInfoSrvr')
    CASE 1488
        StrCopy(servicedesc, 'docstor : DocStor')
    CASE 1489
        StrCopy(servicedesc, 'dmdocbroker : dmdocbroker')
    CASE 1490
        StrCopy(servicedesc, 'insitu-conf : insitu-conf')
    CASE 1491
        StrCopy(servicedesc, 'anynetgateway : anynetgateway')
    CASE 1492
        StrCopy(servicedesc, 'stone-design-1 : stone-design-1 ; \eb[TROJANS=FTP99CMP]\en')
    CASE 1493
        StrCopy(servicedesc, 'netmap_lm : netmap_lm')
    CASE 1494
        StrCopy(servicedesc, 'ica citrix-ica : ica ; citrix-ica')
    CASE 1495
        StrCopy(servicedesc, 'cvc : Network Console')
    CASE 1496
        StrCopy(servicedesc, 'liberty-lm : liberty-lm')
    CASE 1497
        StrCopy(servicedesc, 'rfx-lm : rfx-lm')
    CASE 1498
        StrCopy(servicedesc, 'sybase-sqlany watcom-sql : Sybase SQL Any ; Watcom SQL')
    CASE 1499
        StrCopy(servicedesc, 'fhc : Federico Heinz Consultora')
    CASE 1500
        StrCopy(servicedesc, 'vlsi-lm : VLSI License Manager')
    CASE 1501
        StrCopy(servicedesc, 'saiscm sas-3 : Satellite-data Acquisition System 3')
    CASE 1502
        StrCopy(servicedesc, 'shivadiscovery : Shiva')
    CASE 1503
        StrCopy(servicedesc, 'imtc-mcs : Databeam')
    CASE 1504
        StrCopy(servicedesc, 'evb-elm : EVB Software Engineering License Manager')
    CASE 1505
        StrCopy(servicedesc, 'funkproxy : Funk Software, Inc.')
    CASE 1506
        StrCopy(servicedesc, 'utcd : Universal Time daemon (utcd)')
    CASE 1507
        StrCopy(servicedesc, 'symplex : symplex')
    CASE 1508
        StrCopy(servicedesc, 'diagmond : diagmond')
    CASE 1509
        StrCopy(servicedesc, 'robcad-lm : Robcad, Ltd. License Manager ; \eb[TROJANS=Psyber Streaming]\en')
    CASE 1510
        StrCopy(servicedesc, 'mvx-lm : Midland Valley Exploration Ltd. Lic. Man.')
    CASE 1511
        StrCopy(servicedesc, '3l-l1 : 3l-l1')
    CASE 1512
        StrCopy(servicedesc, 'wins : Microsofts Windows Internet Name Service')
    CASE 1513
        StrCopy(servicedesc, 'fujitsu-dtc : Fujitsu Systems Business of America, Inc')
    CASE 1514
        StrCopy(servicedesc, 'fujitsu-dtcns : Fujitsu Systems Business of America, Inc')
    CASE 1515
        StrCopy(servicedesc, 'ifor-protocol : ifor-protocol')
    CASE 1516
        StrCopy(servicedesc, 'vpad : Virtual Places Audio data')
    CASE 1517
        StrCopy(servicedesc, 'vpac : Virtual Places Audio control')
    CASE 1518
        StrCopy(servicedesc, 'vpvd : Virtual Places Video data')
    CASE 1519
        StrCopy(servicedesc, 'vpvc : Virtual Places Video control')
    CASE 1520
        StrCopy(servicedesc, 'atm-zip-office : atm zip office')
    CASE 1521
        StrCopy(servicedesc, 'ncube-lm : nCube License Manager')
    CASE 1522
        StrCopy(servicedesc, 'ricardo-lm rna-lm : Ricardo North America License Manager')
    CASE 1523
        StrCopy(servicedesc, 'cichild-lm : cichild')
    CASE 1524
        StrCopy(servicedesc, 'ingreslock : Ingres Database?!?')
    CASE 1525
        StrCopy(servicedesc, 'orasrv prospero-np : Oracle or Prospero Directory Service')
    CASE 1526
        StrCopy(servicedesc, 'pdap-np : Prospero Data Access Prot non-priv ')
    CASE 1527
        StrCopy(servicedesc, 'tlisrv : oracle')
    CASE 1528
        StrCopy(servicedesc, 'mciautoreg : micautoreg')
    CASE 1529
        StrCopy(servicedesc, 'coauthor : oracle')
    CASE 1530
        StrCopy(servicedesc, 'rap-service : rap-service')
    CASE 1531
        StrCopy(servicedesc, 'rap-listen : rap-listen')
    CASE 1532
        StrCopy(servicedesc, 'miroconnect : miroconnect')
    CASE 1533
        StrCopy(servicedesc, 'virtual-places : Virtual Places Software')
    CASE 1534
        StrCopy(servicedesc, 'micromuse-lm : micromuse-lm')
    CASE 1535
        StrCopy(servicedesc, 'ampr-info : ampr-info')
    CASE 1536
        StrCopy(servicedesc, 'ampr-inter : ampr-inter')
    CASE 1537
        StrCopy(servicedesc, 'sdsc-lm : isi-lm')
    CASE 1538
        StrCopy(servicedesc, '3ds-lm : 3ds-lm')
    CASE 1539
        StrCopy(servicedesc, 'intellistor-lm : Intellistor License Manager')
    CASE 1540
        StrCopy(servicedesc, 'rds : rds')
    CASE 1541
        StrCopy(servicedesc, 'rds2 : rds2')
    CASE 1542
        StrCopy(servicedesc, 'gridgen-elmd : gridgen-elmd')
    CASE 1543
        StrCopy(servicedesc, 'simba-cs : simba-cs')
    CASE 1544
        StrCopy(servicedesc, 'aspeclmd : aspeclmd')
    CASE 1545
        StrCopy(servicedesc, 'vistium-share : vistium-share')
    CASE 1546
        StrCopy(servicedesc, 'abbaccuray : abbaccuray')
    CASE 1547
        StrCopy(servicedesc, 'laplink : laplink')
    CASE 1548
        StrCopy(servicedesc, 'axon-lm : Axon License Manager')
    CASE 1549
        StrCopy(servicedesc, 'shivahose : Shiva Hose')
    CASE 1550
        StrCopy(servicedesc, '3m-image-lm : Image Storage license manager 3M Company')
    CASE 1551
        StrCopy(servicedesc, 'hecmtl-db : HECMTL-DB')
    CASE 1552
        StrCopy(servicedesc, 'pciarray : pciarray')
    CASE 1553
        StrCopy(servicedesc, 'sna-cs : sna-cs')
    CASE 1554
        StrCopy(servicedesc, 'caci-lm : CACI Products Company License Manager')
    CASE 1555
        StrCopy(servicedesc, 'livelan : livelan')
    CASE 1556
        StrCopy(servicedesc, 'ashwin : AshWin CI Tecnologies')
    CASE 1557
        StrCopy(servicedesc, 'arbortext-lm : ArborText License Manager')
    CASE 1558
        StrCopy(servicedesc, 'xingmpeg : xingmpeg')
    CASE 1559
        StrCopy(servicedesc, 'web2host : web2host')
    CASE 1560
        StrCopy(servicedesc, 'asci-val : asci-val')
    CASE 1561
        StrCopy(servicedesc, 'facilityview : facilityview')
    CASE 1562
        StrCopy(servicedesc, 'pconnectmgr : pconnectmgr')
    CASE 1563
        StrCopy(servicedesc, 'cadabra-lm : Cadabra License Manager')
    CASE 1564
        StrCopy(servicedesc, 'pay-per-view : Pay-Per-View')
    CASE 1565
        StrCopy(servicedesc, 'winddlb : WinDD')
    CASE 1566
        StrCopy(servicedesc, 'corelvideo : CORELVIDEO')
    CASE 1567
        StrCopy(servicedesc, 'jlicelmd : jlicelmd')
    CASE 1568
        StrCopy(servicedesc, 'tsspmap : tsspmap')
    CASE 1569
        StrCopy(servicedesc, 'ets : ets')
    CASE 1570
        StrCopy(servicedesc, 'orbixd : orbixd')
    CASE 1571
        StrCopy(servicedesc, 'rdb-dbs-disp : Oracle Remote Data Base')
    CASE 1572
        StrCopy(servicedesc, 'chip-lm : Chipcom License Manager')
    CASE 1573
        StrCopy(servicedesc, 'itscomm-ns : itscomm-ns')
    CASE 1574
        StrCopy(servicedesc, 'mvel-lm : mvel-lm')
    CASE 1575
        StrCopy(servicedesc, 'oraclenames : oraclenames')
    CASE 1576
        StrCopy(servicedesc, 'moldflow-lm : moldflow-lm')
    CASE 1577
        StrCopy(servicedesc, 'hypercube-lm : hypercube-lm')
    CASE 1578
        StrCopy(servicedesc, 'jacobus-lm : Jacobus License Manager')
    CASE 1579
        StrCopy(servicedesc, 'ioc-sea-lm : ioc-sea-lm')
    CASE 1580
        StrCopy(servicedesc, 'tn-tl-r1 : tn-tl-r1')
    CASE 1581
        StrCopy(servicedesc, 'mil-2045-47001 : MIL-2045-47001')
    CASE 1582
        StrCopy(servicedesc, 'msims : MSIMS')
    CASE 1583
        StrCopy(servicedesc, 'simbaexpress : simbaexpress')
    CASE 1584
        StrCopy(servicedesc, 'tn-tl-fd2 : tn-tl-fd2')
    CASE 1585
        StrCopy(servicedesc, 'intv : intv')
    CASE 1586
        StrCopy(servicedesc, 'ibm-abtact : ibm-abtact')
    CASE 1587
        StrCopy(servicedesc, 'pra_elmd : pra_elmd')
    CASE 1588
        StrCopy(servicedesc, 'triquest-lm : triquest-lm')
    CASE 1589
        StrCopy(servicedesc, 'vqp : VQP')
    CASE 1590
        StrCopy(servicedesc, 'gemini-lm : gemini-lm')
    CASE 1591
        StrCopy(servicedesc, 'ncpm-pm : ncpm-pm')
    CASE 1592
        StrCopy(servicedesc, 'commonspace : commonspace')
    CASE 1593
        StrCopy(servicedesc, 'mainsoft-lm : mainsoft-lm')
    CASE 1594
        StrCopy(servicedesc, 'sixtrak : sixtrak')
    CASE 1595
        StrCopy(servicedesc, 'radio : radio')
    CASE 1596
        StrCopy(servicedesc, 'radio-sm : radio-sm')
    CASE 1597
        StrCopy(servicedesc, 'orbplus-iiop : orbplus-iiop')
    CASE 1598
        StrCopy(servicedesc, 'picknfs : picknfs')
    CASE 1599
        StrCopy(servicedesc, 'simbaservices : simbaservices')
    CASE 1600
        StrCopy(servicedesc, 'issd : issd ; \eb[TROJANS=Shivka - Burka]\en')


    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC

EXPORT PROC service8(portserv:LONG)

SELECT portserv
    CASE 1601
        StrCopy(servicedesc, 'aas : aas')
    CASE 1602
        StrCopy(servicedesc, 'inspect : inspect')
    CASE 1603
        StrCopy(servicedesc, 'picodbc : pickodbc')
    CASE 1604
        StrCopy(servicedesc, 'icabrowser : icabrowser')
    CASE 1605
        StrCopy(servicedesc, 'slp : Salutation Manager (Salutation Protocol)')
    CASE 1606
        StrCopy(servicedesc, 'slm-api : Salutation Manager (SLM-API)')
    CASE 1607
        StrCopy(servicedesc, 'stt : stt')
    CASE 1608
        StrCopy(servicedesc, 'smart-lm : Smart Corp. License Manager')
    CASE 1609
        StrCopy(servicedesc, 'isysg-lm : isysg-lm')
    CASE 1610
        StrCopy(servicedesc, 'taurus-wh : taurus-wh')
    CASE 1611
        StrCopy(servicedesc, 'ill : Inter Library Loan')
    CASE 1612
        StrCopy(servicedesc, 'netbill-trans : NetBill Transaction Server')
    CASE 1613
        StrCopy(servicedesc, 'netbill-keyrep : NetBill Key Repository')
    CASE 1614
        StrCopy(servicedesc, 'netbill-cred : NetBill Credential Server')
    CASE 1615
        StrCopy(servicedesc, 'netbill-auth : NetBill Authorization Server')
    CASE 1616
        StrCopy(servicedesc, 'netbill-prod : NetBill Product Server')
    CASE 1617
        StrCopy(servicedesc, 'nimrod-agent : Nimrod Inter-Agent Communication')
    CASE 1618
        StrCopy(servicedesc, 'skytelnet : skytelnet')
    CASE 1619
        StrCopy(servicedesc, 'xs-openstorage : xs-openstorage')
    CASE 1620
        StrCopy(servicedesc, 'faxportwinport : faxportwinport')
    CASE 1621
        StrCopy(servicedesc, 'softdataphone : softdataphone')
    CASE 1622
        StrCopy(servicedesc, 'ontime : ontime')
    CASE 1623
        StrCopy(servicedesc, 'jaleosnd : jaleosnd')
    CASE 1624
        StrCopy(servicedesc, 'udp-sr-port : udp-sr-port')
    CASE 1625
        StrCopy(servicedesc, 'svs-omagent : svs-omagent')
    CASE 1626
        StrCopy(servicedesc, 'shockwave : Shockwave')
    CASE 1627
        StrCopy(servicedesc, 't128-gateway : T.128 Gateway')
    CASE 1628
        StrCopy(servicedesc, 'lontalk-norm : LonTalk normal')
    CASE 1629
        StrCopy(servicedesc, 'lontalk-urgnt : LonTalk urgent')
    CASE 1630
        StrCopy(servicedesc, 'oraclenet8cman : Oracle Net8 Cman')
    CASE 1631
        StrCopy(servicedesc, 'visitview : Visit view')
    CASE 1632
        StrCopy(servicedesc, 'pammratc : PAMMRATC')
    CASE 1633
        StrCopy(servicedesc, 'pammrpc : PAMMRPC')
    CASE 1634
        StrCopy(servicedesc, 'loaprobe : Log On America Probe')
    CASE 1635
        StrCopy(servicedesc, 'edb-server1 : EDB Server 1')
    CASE 1636
        StrCopy(servicedesc, 'cncp : CableNet Control Protocol')
    CASE 1637
        StrCopy(servicedesc, 'cnap : CableNet Admin Protocol')
    CASE 1638
        StrCopy(servicedesc, 'cnip : CableNet Info Protocol')
    CASE 1639
        StrCopy(servicedesc, 'cert-initiator : cert-initiator')
    CASE 1640
        StrCopy(servicedesc, 'cert-responder : cert-responder')
    CASE 1641
        StrCopy(servicedesc, 'invision : InVision')
    CASE 1642
        StrCopy(servicedesc, 'isis-am : isis-am')
    CASE 1643
        StrCopy(servicedesc, 'isis-ambc : isis-ambc')
    CASE 1644
        StrCopy(servicedesc, 'saiseh : Satellite-data Acquisition System 4')
    CASE 1645
        StrCopy(servicedesc, 'datametrics radius : datametrics ; Radius Authentication and Accounting')
    CASE 1646
        StrCopy(servicedesc, 'sa-msg-port old radacct : sa-msg-port')
    CASE 1647
        StrCopy(servicedesc, 'rsap : rsap')
    CASE 1648
        StrCopy(servicedesc, 'concurrent-lm : concurrent-lm')
    CASE 1649
        StrCopy(servicedesc, 'kermit : kermit')
    CASE 1650
        StrCopy(servicedesc, 'nkd : nkd')
    CASE 1651
        StrCopy(servicedesc, 'shiva_confsrvr : shiva_confsrvr')
    CASE 1652
        StrCopy(servicedesc, 'xnmp : xnmp')
    CASE 1653
        StrCopy(servicedesc, 'alphatech-lm : alphatech-lm')
    CASE 1654
        StrCopy(servicedesc, 'stargatealerts : stargatealerts')
    CASE 1655
        StrCopy(servicedesc, 'dec-mbadmin : dec-mbadmin')
    CASE 1656
        StrCopy(servicedesc, 'dec-mbadmin-h : dec-mbadmin-h')
    CASE 1657
        StrCopy(servicedesc, 'fujitsu-mmpdc : fujitsu-mmpdc')
    CASE 1658
        StrCopy(servicedesc, 'sixnetudr : sixnetudr')
    CASE 1659
        StrCopy(servicedesc, 'sg-lm : Silicon Grail License Manager')
    CASE 1660
        StrCopy(servicedesc, 'skip-mc-gikreq : skip-mc-gikreq')
    CASE 1661
        StrCopy(servicedesc, 'netview-aix-1 : netview-aix-1')
    CASE 1662
        StrCopy(servicedesc, 'netview-aix-2 : netview-aix-2')
    CASE 1663
        StrCopy(servicedesc, 'netview-aix-3 : netview-aix-3')
    CASE 1664
        StrCopy(servicedesc, 'netview-aix-4 : netview-aix-4')
    CASE 1665
        StrCopy(servicedesc, 'netview-aix-5 : netview-aix-5')
    CASE 1666
        StrCopy(servicedesc, 'netview-aix-6 : netview-aix-6')
    CASE 1667
        StrCopy(servicedesc, 'netview-aix-7 : netview-aix-7')
    CASE 1668
        StrCopy(servicedesc, 'netview-aix-8 : netview-aix-8')
    CASE 1669
        StrCopy(servicedesc, 'netview-aix-9 : netview-aix-9')
    CASE 1670
        StrCopy(servicedesc, 'netview-aix-10 : netview-aix-10')
    CASE 1671
        StrCopy(servicedesc, 'netview-aix-11 : netview-aix-11')
    CASE 1672
        StrCopy(servicedesc, 'netview-aix-12 : netview-aix-12')
    CASE 1673
        StrCopy(servicedesc, 'proshare-mc-1 : Intel Proshare Multicast')
    CASE 1674
        StrCopy(servicedesc, 'proshare-mc-2 : Intel Proshare Multicast')
    CASE 1675
        StrCopy(servicedesc, 'pdp : Pacific Data Products')
    CASE 1676
        StrCopy(servicedesc, 'netcomm1 : netcomm1')
    CASE 1677
        StrCopy(servicedesc, 'groupwise : groupwise')
    CASE 1678
        StrCopy(servicedesc, 'prolink : prolink')
    CASE 1679
        StrCopy(servicedesc, 'darcorp-lm : darcorp-lm')
    CASE 1680
        StrCopy(servicedesc, 'microcom-sbp : microcom-sbp')
    CASE 1681
        StrCopy(servicedesc, 'sd-elmd : sd-elmd')
    CASE 1682
        StrCopy(servicedesc, 'lanyon-lantern : lanyon-lantern')
    CASE 1683
        StrCopy(servicedesc, 'ncpm-hip : ncpm-hip')
    CASE 1684
        StrCopy(servicedesc, 'snaresecure : SnareSecure')
    CASE 1685
        StrCopy(servicedesc, 'n2nremote : n2nremote')
    CASE 1686
        StrCopy(servicedesc, 'cvmon : cvmon')
    CASE 1687
        StrCopy(servicedesc, 'nsjtp-ctrl : nsjtp-ctrl')
    CASE 1688
        StrCopy(servicedesc, 'nsjtp-data : nsjtp-data')
    CASE 1689
        StrCopy(servicedesc, 'firefox : firefox')
    CASE 1690
        StrCopy(servicedesc, 'ng-umds : ng-umds')
    CASE 1691
        StrCopy(servicedesc, 'empire-empuma : empire-empuma')
    CASE 1692
        StrCopy(servicedesc, 'sstsys-lm : sstsys-lm')
    CASE 1693
        StrCopy(servicedesc, 'rrirtr : rrirtr')
    CASE 1694
        StrCopy(servicedesc, 'rrimwm : rrimwm')
    CASE 1695
        StrCopy(servicedesc, 'rrilwm : rrilwm')
    CASE 1696
        StrCopy(servicedesc, 'rrifmm : rrifmm')
    CASE 1697
        StrCopy(servicedesc, 'rrisat : rrisat')
    CASE 1698
        StrCopy(servicedesc, 'rsvp-encap-1 : RSVP-ENCAPSULATION-1')
    CASE 1699
        StrCopy(servicedesc, 'rsvp-encap-2 : RSVP-ENCAPSULATION-2')
    CASE 1700
        StrCopy(servicedesc, 'mps-raft : mps-raft')
    CASE 1701
        StrCopy(servicedesc, 'l2f : l2f')
    CASE 1701
        StrCopy(servicedesc, 'l2tp : l2tp')
    CASE 1702
        StrCopy(servicedesc, 'deskshare : deskshare')
    CASE 1703
        StrCopy(servicedesc, 'hb-engine : hb-engine')
    CASE 1704
        StrCopy(servicedesc, 'bcs-broker : bcs-broker')
    CASE 1705
        StrCopy(servicedesc, 'slingshot : slingshot')
    CASE 1706
        StrCopy(servicedesc, 'jetform : jetform')
    CASE 1707
        StrCopy(servicedesc, 'vdmplay : vdmplay')
    CASE 1708
        StrCopy(servicedesc, 'gat-lmd : gat-lmd')
    CASE 1709
        StrCopy(servicedesc, 'centra : centra')
    CASE 1710
        StrCopy(servicedesc, 'impera : impera')
    CASE 1711
        StrCopy(servicedesc, 'pptconference : pptconference')
    CASE 1712
        StrCopy(servicedesc, 'registrar : resource monitoring service')
    CASE 1713
        StrCopy(servicedesc, 'conferencetalk : ConferenceTalk')
    CASE 1714
        StrCopy(servicedesc, 'sesi-lm : sesi-lm')
    CASE 1715
        StrCopy(servicedesc, 'houdini-lm : houdini-lm')
    CASE 1716
        StrCopy(servicedesc, 'xmsg : xmsg')
    CASE 1717
        StrCopy(servicedesc, 'fj-hdnet : fj-hdnet')
    CASE 1718
        StrCopy(servicedesc, 'h323gatedisc : h323gatedisc')
    CASE 1719
        StrCopy(servicedesc, 'h323gatestat : h323gatestat ')
    CASE 1720
        StrCopy(servicedesc, 'h323hostcall : h323hostcall')
    CASE 1721
        StrCopy(servicedesc, 'caicci : caicci')
    CASE 1722
        StrCopy(servicedesc, 'hks-lm : HKS License Manager')
    CASE 1723
        StrCopy(servicedesc, 'pptp : Point to Point Tunneling Protocol')
    CASE 1724
        StrCopy(servicedesc, 'csbphonemaster : csbphonemaster')
    CASE 1725
        StrCopy(servicedesc, 'iden-ralp : iden-ralp')
    CASE 1726
        StrCopy(servicedesc, 'iberiagames : IBERIAGAMES')
    CASE 1727
        StrCopy(servicedesc, 'winddx : winddx')
    CASE 1728
        StrCopy(servicedesc, 'telindus : TELINDUS')
    CASE 1729
        StrCopy(servicedesc, 'citynl : CityNL License Management')
    CASE 1730
        StrCopy(servicedesc, 'roketz : roketz')
    CASE 1731
        StrCopy(servicedesc, 'msiccp : MSICCP')
    CASE 1732
        StrCopy(servicedesc, 'proxim : proxim')
    CASE 1733
        StrCopy(servicedesc, 'siipat : SIMS - SIIPAT Protocol for Alarm Transmission')
    CASE 1734
        StrCopy(servicedesc, 'cambertx-lm : Camber Corporation License Management')
    CASE 1735
        StrCopy(servicedesc, 'privatechat : PrivateChat')
    CASE 1736
        StrCopy(servicedesc, 'street-stream : street-stream')
    CASE 1737
        StrCopy(servicedesc, 'ultimad : ultimad')
    CASE 1738
        StrCopy(servicedesc, 'gamegen1 : GameGen1')
    CASE 1739
        StrCopy(servicedesc, 'webaccess : webaccess')
    CASE 1740
        StrCopy(servicedesc, 'encore : encore')
    CASE 1741
        StrCopy(servicedesc, 'cisco-net-mgmt : cisco-net-mgmt')
    CASE 1742
        StrCopy(servicedesc, '3Com-nsd : 3Com-nsd')
    CASE 1743
        StrCopy(servicedesc, 'cinegrfx-lm : Cinema Graphics License Manager')
    CASE 1744
        StrCopy(servicedesc, 'ncpm-ft : ncpm-ft')
    CASE 1745
        StrCopy(servicedesc, 'remote-winsock : remote-winsock')
    CASE 1746
        StrCopy(servicedesc, 'ftrapid-1 : ftrapid-1')
    CASE 1747
        StrCopy(servicedesc, 'ftrapid-2 : ftrapid-2')
    CASE 1748
        StrCopy(servicedesc, 'oracle-em1 : oracle-em1')
    CASE 1749
        StrCopy(servicedesc, 'aspen-services : aspen-services')
    CASE 1750
        StrCopy(servicedesc, 'sslp : Simple Socket Librarys PortMaster')
    CASE 1751
        StrCopy(servicedesc, 'swiftnet : SwiftNet')
    CASE 1752
        StrCopy(servicedesc, 'lofr-lm : Leap of Faith Research License Manager ')
    CASE 1753
        StrCopy(servicedesc, 'translogic-lm : Translogic License Manager')
    CASE 1754
        StrCopy(servicedesc, 'oracle-em2 : oracle-em2')
    CASE 1755
        StrCopy(servicedesc, 'ms-streaming : ms-streaming')
    CASE 1756
        StrCopy(servicedesc, 'capfast-lmd : capfast-lmd')
    CASE 1757
        StrCopy(servicedesc, 'cnhrp : cnhrp')
    CASE 1758
        StrCopy(servicedesc, 'tftp-mcast : tftp-mcast')
    CASE 1759
        StrCopy(servicedesc, 'spss-lm : SPSS License Manager')
    CASE 1760
        StrCopy(servicedesc, 'www-ldap-gw : HTTP to LDAP gateway')
    CASE 1761
        StrCopy(servicedesc, 'cft-0 : cft-0')
    CASE 1762
        StrCopy(servicedesc, 'cft-1 : cft-1')
    CASE 1763
        StrCopy(servicedesc, 'cft-2 : cft-2')
    CASE 1764
        StrCopy(servicedesc, 'cft-3 : cft-3')
    CASE 1765
        StrCopy(servicedesc, 'cft-4 : cft-4')
    CASE 1766
        StrCopy(servicedesc, 'cft-5 : cft-5')
    CASE 1767
        StrCopy(servicedesc, 'cft-6 : cft-6')
    CASE 1768
        StrCopy(servicedesc, 'cft-7 : cft-7')
    CASE 1769
        StrCopy(servicedesc, 'bmc-net-adm : bmc-net-adm')
    CASE 1770
        StrCopy(servicedesc, 'bmc-net-svc : bmc-net-svc')
    CASE 1771
        StrCopy(servicedesc, 'vaultbase : vaultbase')
    CASE 1772
        StrCopy(servicedesc, 'essweb-gw : EssWeb Gateway')
    CASE 1773
        StrCopy(servicedesc, 'kmscontrol : KMSControl')
    CASE 1774
        StrCopy(servicedesc, 'global-dtserv : global-dtserv')
    CASE 1776
        StrCopy(servicedesc, 'femis : Federal Emergency Management Information System')
    CASE 1777
        StrCopy(servicedesc, 'powerguardian : powerguardian')
    CASE 1778
        StrCopy(servicedesc, 'prodigy-intrnet : prodigy-internet')
    CASE 1779
        StrCopy(servicedesc, 'pharmasoft : pharmasoft')
    CASE 1780
        StrCopy(servicedesc, 'dpkeyserv : dpkeyserv')
    CASE 1781
        StrCopy(servicedesc, 'answersoft-lm : answersoft-lm')
    CASE 1782
        StrCopy(servicedesc, 'hp-hcip : hp-hcip')
    CASE 1784
        StrCopy(servicedesc, 'finle-lm : Finle License Manager')
    CASE 1785
        StrCopy(servicedesc, 'windlm : Wind River Systems License Manager')
    CASE 1786
        StrCopy(servicedesc, 'funk-logger : funk-logger')
    CASE 1787
        StrCopy(servicedesc, 'funk-license : funk-license')
    CASE 1788
        StrCopy(servicedesc, 'psmond : psmond')
    CASE 1789
        StrCopy(servicedesc, 'hello : hello')
    CASE 1790
        StrCopy(servicedesc, 'nmsp : Narrative Media Streaming Protocol')
    CASE 1791
        StrCopy(servicedesc, 'ea1 : EA1')
    CASE 1792
        StrCopy(servicedesc, 'ibm-dt-2 : ibm-dt-2')
    CASE 1793
        StrCopy(servicedesc, 'rsc-robot : rsc-robot')
    CASE 1794
        StrCopy(servicedesc, 'cera-bcm : cera-bcm')
    CASE 1795
        StrCopy(servicedesc, 'dpi-proxy : dpi-proxy')
    CASE 1796
        StrCopy(servicedesc, 'vocaltec-admin : Vocaltec Server Administration')
    CASE 1797
        StrCopy(servicedesc, 'uma : UMA')
    CASE 1798
        StrCopy(servicedesc, 'etp : Event Transfer Protocol')
    CASE 1799
        StrCopy(servicedesc, 'netrisk : NETRISK')
    CASE 1800
        StrCopy(servicedesc, 'ansys-lm : ANSYS-License manager')
    CASE 1801
        StrCopy(servicedesc, 'msmq : Microsoft Message Que')
    CASE 1802
        StrCopy(servicedesc, 'concomp1 : ConComp1')
    CASE 1803
        StrCopy(servicedesc, 'hp-hcip-gwy : HP-HCIP-GWY')
    CASE 1804
        StrCopy(servicedesc, 'enl : ENL')
    CASE 1805
        StrCopy(servicedesc, 'enl-name : ENL-Name')
    CASE 1806
        StrCopy(servicedesc, 'musiconline : Musiconline')
    CASE 1807
        StrCopy(servicedesc, 'fhsp : Fujitsu Hot Standby Protocol ; \eb[TROJANS=Spy Sender]\en')
    CASE 1808
        StrCopy(servicedesc, 'oracle-vp2 : Oracle-VP2')
    CASE 1809
        StrCopy(servicedesc, 'oracle-vp1 : Oracle-VP1')
    CASE 1810
        StrCopy(servicedesc, 'jerand-lm : Jerand License Manager')
    CASE 1811
        StrCopy(servicedesc, 'scientia-sdb : Scientia-SDB')
    CASE 1812
        StrCopy(servicedesc, 'radius : RADIUS Authentication Protocol')
    CASE 1813
        StrCopy(servicedesc, 'radius-acct : RADIUS Accounting Protocol')
    CASE 1814
        StrCopy(servicedesc, 'tdp-suite : TDP Suite')
    CASE 1815
        StrCopy(servicedesc, 'mmpft : MMPFT')
    CASE 1816
        StrCopy(servicedesc, 'harp : HARP')
    CASE 1817
        StrCopy(servicedesc, 'rkb-oscs : RKB-OSCS')
    CASE 1818
        StrCopy(servicedesc, 'etftp : Enhanced Trivial File Transfer Protocol')
    CASE 1819
        StrCopy(servicedesc, 'plato-lm : Plato License Manager')
    CASE 1820
        StrCopy(servicedesc, 'mcagent : mcagent')
    CASE 1821
        StrCopy(servicedesc, 'donnyworld : donnyworld')
    CASE 1822
        StrCopy(servicedesc, 'es-elmd : es-elmd')
    CASE 1823
        StrCopy(servicedesc, 'unisys-lm : Unisys Natural Language License Manager')
    CASE 1824
        StrCopy(servicedesc, 'metrics-pas : metrics-pas')
    CASE 1825
        StrCopy(servicedesc, 'direcpc-video : DirecPC Video')
    CASE 1826
        StrCopy(servicedesc, 'ardt : ARDT')
    CASE 1827
        StrCopy(servicedesc, 'asi pcm : ASI ; PCM Agent (AutoSecure Policy Compliance Manager)')
    CASE 1828
        StrCopy(servicedesc, 'itm-mcell-u : itm-mcell-u')
    CASE 1829
        StrCopy(servicedesc, 'optika-emedia : Optika eMedia ')
    CASE 1830
        StrCopy(servicedesc, 'net8-cman : Oracle Net8 CMan Admin')
    CASE 1831
        StrCopy(servicedesc, 'myrtle : Myrtle')
    CASE 1832
        StrCopy(servicedesc, 'tht-treasure : ThoughtTreasure')
    CASE 1833
        StrCopy(servicedesc, 'udpradio : udpradio')
    CASE 1834
        StrCopy(servicedesc, 'ardusuni : ARDUS Unicast')
    CASE 1835
        StrCopy(servicedesc, 'ardusmul : ARDUS Multicast')
    CASE 1836
        StrCopy(servicedesc, 'ste-smsc : ste-smsc')
    CASE 1837
        StrCopy(servicedesc, 'csoft1 : csoft1')
    CASE 1838
        StrCopy(servicedesc, 'talnet : TALNET')
    CASE 1839
        StrCopy(servicedesc, 'netopia-vo1 : netopia-vo1')
    CASE 1840
        StrCopy(servicedesc, 'netopia-vo2 : netopia-vo2')
    CASE 1841
        StrCopy(servicedesc, 'netopia-vo3 : netopia-vo3')
    CASE 1842
        StrCopy(servicedesc, 'netopia-vo4 : netopia-vo4')
    CASE 1843
        StrCopy(servicedesc, 'netopia-vo5 : netopia-vo5')
    CASE 1844
        StrCopy(servicedesc, 'direcpc-dll : DirecPC-DLL')
    CASE 1845
        StrCopy(servicedesc, 'altalink : altalink')
    CASE 1846
        StrCopy(servicedesc, 'tunstall-pnc : Tunstall PNC')
    CASE 1847
        StrCopy(servicedesc, 'slp-notify : SLP Notification')
    CASE 1848
        StrCopy(servicedesc, 'fjdocdist : fjdocdist')
    CASE 1849
        StrCopy(servicedesc, 'alpha-sms : ALPHA-SMS')
    CASE 1850
        StrCopy(servicedesc, 'gsi : GSI')
    CASE 1851
        StrCopy(servicedesc, 'ctcd : ctcd')
    CASE 1852
        StrCopy(servicedesc, 'virtual-time : Virtual Time')
    CASE 1853
        StrCopy(servicedesc, 'vids-avtp : VIDS-AVTP')
    CASE 1854
        StrCopy(servicedesc, 'buddy-draw : Buddy Draw')
    CASE 1855
        StrCopy(servicedesc, 'fiorano-rtrsvc : Fiorano RtrSvc')
    CASE 1856
        StrCopy(servicedesc, 'fiorano-msgsvc : Fiorano MsgSvc')
    CASE 1857
        StrCopy(servicedesc, 'datacaptor : DataCaptor')
    CASE 1858
        StrCopy(servicedesc, 'privateark : PrivateArk')
    CASE 1859
        StrCopy(servicedesc, 'gammafetchsvr : Gamma Fetcher Server')
    CASE 1860
        StrCopy(servicedesc, 'sunscalar-svc : SunSCALAR Services')
    CASE 1861
        StrCopy(servicedesc, 'lecroy-vicp : LeCroy VICP')
    CASE 1862
        StrCopy(servicedesc, 'techra-server : techra-server')
    CASE 1863
        StrCopy(servicedesc, 'msnp : MSNP')
    CASE 1864
        StrCopy(servicedesc, 'paradym-31port : Paradym 31 Port')
    CASE 1865
        StrCopy(servicedesc, 'entp : ENTP')
    CASE 1866
        StrCopy(servicedesc, 'swrmi : swrmi')
    CASE 1867
        StrCopy(servicedesc, 'udrive : UDRIVE')
    CASE 1868
        StrCopy(servicedesc, 'viziblebrowser : VizibleBrowser')
    CASE 1869
        StrCopy(servicedesc, 'yestrader : YesTrader')
    CASE 1870
        StrCopy(servicedesc, 'sunscalar-dns : SunSCALAR DNS Service')
    CASE 1871
        StrCopy(servicedesc, 'canocentral0 : Cano Central 0')
    CASE 1872
        StrCopy(servicedesc, 'canocentral1 : Cano Central 1')
    CASE 1873
        StrCopy(servicedesc, 'fjmpjps : Fjmpjps')
    CASE 1874
        StrCopy(servicedesc, 'fjswapsnp : Fjswapsnp')
    CASE 1875
        StrCopy(servicedesc, 'westell-stats : westell stats')
    CASE 1876
        StrCopy(servicedesc, 'ewcappsrv : ewcappsrv')
    CASE 1877
        StrCopy(servicedesc, 'hp-webqosdb : hp-webqosdb')
    CASE 1881
        StrCopy(servicedesc, 'ibm-mqseries2 : IBM MQSeries')
    CASE 1895
        StrCopy(servicedesc, 'vista-4gl : Vista 4GL')
    CASE 1899
        StrCopy(servicedesc, 'mc2studios : MC2Studios')
    CASE 1900
        StrCopy(servicedesc, 'ssdp : SSDP')
    CASE 1901
        StrCopy(servicedesc, 'fjicl-tep-a : Fujitsu ICL Terminal Emulator Program A')
    CASE 1902
        StrCopy(servicedesc, 'fjicl-tep-b : Fujitsu ICL Terminal Emulator Program B')
    CASE 1903
        StrCopy(servicedesc, 'linkname : Local Link Name Resolution')
    CASE 1904
        StrCopy(servicedesc, 'fjicl-tep-c : Fujitsu ICL Terminal Emulator Program C')
    CASE 1905
        StrCopy(servicedesc, 'sugp : Secure UP.Link Gateway Protocol')
    CASE 1906
        StrCopy(servicedesc, 'tpmd : TPortMapperReq')
    CASE 1907
        StrCopy(servicedesc, 'intrastar : IntraSTAR')
    CASE 1908
        StrCopy(servicedesc, 'dawn : Dawn')
    CASE 1909
        StrCopy(servicedesc, 'global-wlink : Global World Link')
    CASE 1910
        StrCopy(servicedesc, 'ultrabac : ultrabac')
    CASE 1911
        StrCopy(servicedesc, 'mtp : Starlight Networks Multimedia Transport Protocol')
    CASE 1912
        StrCopy(servicedesc, 'rhp-iibp : rhp-iibp')
    CASE 1913
        StrCopy(servicedesc, 'armadp : armadp')
    CASE 1914
        StrCopy(servicedesc, 'elm-momentum : Elm-Momentum')
    CASE 1915
        StrCopy(servicedesc, 'facelink : FACELINK')
    CASE 1916
        StrCopy(servicedesc, 'persona : Persoft Persona')
    CASE 1917
        StrCopy(servicedesc, 'noagent : nOAgent')
    CASE 1918
        StrCopy(servicedesc, 'can-nds : Candle Directory Service - NDS')
    CASE 1919
        StrCopy(servicedesc, 'can-dch : Candle Directory Service - DCH')
    CASE 1920
        StrCopy(servicedesc, 'can-ferret : Candle Directory Service - FERRET')
    CASE 1921
        StrCopy(servicedesc, 'noadmin : NoAdmin')
    CASE 1922
        StrCopy(servicedesc, 'tapestry : Tapestry')
    CASE 1923
        StrCopy(servicedesc, 'spice : SPICE')
    CASE 1924
        StrCopy(servicedesc, 'xiip : XIIP')
    CASE 1930
        StrCopy(servicedesc, 'driveappserver : Drive AppServer')
    CASE 1931
        StrCopy(servicedesc, 'amdsched : AMD SCHED')
    CASE 1941
        StrCopy(servicedesc, 'dic-aida : DIC-Aida')
    CASE 1944
        StrCopy(servicedesc, 'close-combat : close-combat')
    CASE 1945
        StrCopy(servicedesc, 'dialogic-elmd : dialogic-elmd')
    CASE 1946
        StrCopy(servicedesc, 'tekpls : tekpls')
    CASE 1947
        StrCopy(servicedesc, 'hlserver : hlserver')
    CASE 1948
        StrCopy(servicedesc, 'eye2eye : eye2eye')
    CASE 1949
        StrCopy(servicedesc, 'ismaeasdaqlive : ISMA Easdaq Live')
    CASE 1950
        StrCopy(servicedesc, 'ismaeasdaqtest : ISMA Easdaq Test')
    CASE 1951
        StrCopy(servicedesc, 'bcs-lmserver : bcs-lmserver')
    CASE 1952
        StrCopy(servicedesc, 'mpnjsc : mpnjsc')
    CASE 1953
        StrCopy(servicedesc, 'rapidbase : Rapid Base')
    CASE 1957
        StrCopy(servicedesc, 'unix-status : unix-status')
    CASE 1961
        StrCopy(servicedesc, 'bts-appserver : BTS APPSERVER')
    CASE 1962
        StrCopy(servicedesc, 'biap-mp : BIAP-MP')
    CASE 1963
        StrCopy(servicedesc, 'webmachine : WebMachine')
    CASE 1964
        StrCopy(servicedesc, 'solid-e-engine : SOLID E ENGINE')
    CASE 1965
        StrCopy(servicedesc, 'tivoli-npm : Tivoli NPM')
    CASE 1966
        StrCopy(servicedesc, 'slush : Slush')
    CASE 1967
        StrCopy(servicedesc, 'sns-quote : SNS Quote')
    CASE 1972
        StrCopy(servicedesc, 'intersys-cache : Cache')
    CASE 1973
        StrCopy(servicedesc, 'dlsrap : Data Link Switching Remote Access Protocol')
    CASE 1974
        StrCopy(servicedesc, 'drp : DRP')
    CASE 1975
        StrCopy(servicedesc, 'tcoflashagent : TCO Flash Agent')
    CASE 1976
        StrCopy(servicedesc, 'tcoregagent : TCO Reg Agent ')
    CASE 1977
        StrCopy(servicedesc, 'tcoaddressbook : TCO Address Book')
    CASE 1978
        StrCopy(servicedesc, 'unisql : UniSQL')
    CASE 1979
        StrCopy(servicedesc, 'unisql-java : UniSQL Java')
    CASE 1981
        StrCopy(servicedesc, '\eb[TROJANS=ShockRave]\en')
    CASE 1984
        StrCopy(servicedesc, 'bb : BB')
    CASE 1985
        StrCopy(servicedesc, 'hsrp : Hot Standby Router Protocol')
    CASE 1986
        StrCopy(servicedesc, 'licensedaemon : cisco license management')
    CASE 1987
        StrCopy(servicedesc, 'tr-rsrb-p1 : cisco RSRB Priority 1 port')
    CASE 1988
        StrCopy(servicedesc, 'tr-rsrb-p2 : cisco RSRB Priority 2 port')
    CASE 1989
        StrCopy(servicedesc, 'tr-rsrb-p3 mshnet : cisco RSRB Priority 3 port ; MHSnet system')
    CASE 1990
        StrCopy(servicedesc, 'stun-p1 : cisco STUN Priority 1 port')
    CASE 1991
        StrCopy(servicedesc, 'stun-p2 : cisco STUN Priority 2 port')
    CASE 1992
        StrCopy(servicedesc, 'stun-p3 ipsendmsg : cisco STUN Priority 3 port ; IPsendmsg')
    CASE 1993
        StrCopy(servicedesc, 'snmp-tcp-port : cisco SNMP TCP port')
    CASE 1994
        StrCopy(servicedesc, 'stun-port : cisco serial tunnel port')
    CASE 1995
        StrCopy(servicedesc, 'perf-port : cisco perf port')
    CASE 1996
        StrCopy(servicedesc, 'tr-rsrb-port : cisco Remote SRB port')
    CASE 1997
        StrCopy(servicedesc, 'gdp-port : cisco Gateway Discovery Protocol')
    CASE 1998
        StrCopy(servicedesc, 'x25-svc-port : cisco X.25 service (XOT)')
    CASE 1999
        StrCopy(servicedesc, 'tcp-id-port : cisco identification port ; \eb[TROJANS=Backdoor, TransScout]\en')
    CASE 2000
        StrCopy(servicedesc, 'callbook : callbook ; \eb[TROJANS=TransScout]\en')
    CASE 2001
        StrCopy(servicedesc, 'dc : dc ; \eb[TROJANS=TransScout, Trojan Cow]\en')
    CASE 2002
        StrCopy(servicedesc, 'globe : globe ; \eb[TROJANS=TransScout]\en')
    CASE 2003
        StrCopy(servicedesc, 'cfinger : GNU Finger ; \eb[TROJANS=TransScout]\en')
    CASE 2004
        StrCopy(servicedesc, 'mailbox : mailbox ; \eb[TROJANS=TransScout]\en')
    CASE 2005
        StrCopy(servicedesc, 'berknet deslogin oracle : berknet ; encrypted symmetric login ; \eb[TROJANS=TransScout]\en')
    CASE 2006
        StrCopy(servicedesc, 'invokator raid-cc : invokator ; raid')
    CASE 2007
        StrCopy(servicedesc, 'dectalk raid-am : DEC Talk ; raid')
    CASE 2008
        StrCopy(servicedesc, 'conf terminaldb : conf')
    CASE 2009
        StrCopy(servicedesc, 'news whosockami : news')
    CASE 2010
        StrCopy(servicedesc, 'search pipe_server : search ; Also used by NFR')
    CASE 2011
        StrCopy(servicedesc, 'raid-cc : raid')
    CASE 2012
        StrCopy(servicedesc, 'ttyinfo : ttyinfo (Terminal Info)')
    CASE 2013
        StrCopy(servicedesc, 'raid-am : raid-am')
    CASE 2014
        StrCopy(servicedesc, 'troff : troff')
    CASE 2015
        StrCopy(servicedesc, 'cypress : cypress')
    CASE 2016
        StrCopy(servicedesc, 'bootserver : bootserver')
    CASE 2017
        StrCopy(servicedesc, 'cypress-stat bootclient : cypress-stat')
    CASE 2018
        StrCopy(servicedesc, 'terminaldb rellpack : terminaldb')
    CASE 2019
        StrCopy(servicedesc, 'whosockami about : whosockami')
    CASE 2020
        StrCopy(servicedesc, 'xinupageserver : xinupageserver')
    CASE 2021
        StrCopy(servicedesc, 'servexec : servexec')
    CASE 2022
        StrCopy(servicedesc, 'down : down')
    CASE 2023
        StrCopy(servicedesc, 'xinuexpansion3 : xinuexpansion3 ; \eb[TROJANS=Pass Ripper]\en')
    CASE 2024
        StrCopy(servicedesc, 'xinuexpansion4 : xinuexpansion4')
    CASE 2025
        StrCopy(servicedesc, 'ellpack xribs : ellpack')
    CASE 2026
        StrCopy(servicedesc, 'scrabble : Scrabble')
    CASE 2027
        StrCopy(servicedesc, 'shadowserver : shadowserver')
    CASE 2028
        StrCopy(servicedesc, 'submitserver : submtserver')
    CASE 2030
        StrCopy(servicedesc, 'device2 : device2')
    CASE 2032
        StrCopy(servicedesc, 'blackboard : blackboard (Backboard WWW forum???) ')
    CASE 2033
        StrCopy(servicedesc, 'glogger : glogger')
    CASE 2034
        StrCopy(servicedesc, 'scoremgr : scoremgr')
    CASE 2035
        StrCopy(servicedesc, 'imsldoc : imsldoc')
    CASE 2038
        StrCopy(servicedesc, 'objectmanager : objectmanager')
    CASE 2040
        StrCopy(servicedesc, 'lam : lam')
    CASE 2041
        StrCopy(servicedesc, 'interbase : interbase')
    CASE 2042
        StrCopy(servicedesc, 'isis : isis')
    CASE 2043
        StrCopy(servicedesc, 'isis-bcast : isis-bcast')
    CASE 2044
        StrCopy(servicedesc, 'rimsl : rimsl')
    CASE 2045
        StrCopy(servicedesc, 'cdfunc : cdfunc')
    CASE 2046
        StrCopy(servicedesc, 'sdfunc : sdfunc')
    CASE 2047
        StrCopy(servicedesc, 'dls : dls')
    CASE 2048
        StrCopy(servicedesc, 'dls-monitor : dls-monitor')
    CASE 2049
        StrCopy(servicedesc, 'nfsd nfs : Network File System Server Daemon (cots) ; shilp : shilp')
    CASE 2053
        StrCopy(servicedesc, 'knetd : Kerberos De-Multiplexer')
    CASE 2064
        StrCopy(servicedesc, 'xxx : Keyblock Proxy for RSA Cryptographic challenge')
    CASE 2065
        StrCopy(servicedesc, 'dlsrpn : Data Link Switch Read Port Number')
    CASE 2067
        StrCopy(servicedesc, 'dlswpn : Data Link Switch Write Port Number')
    CASE 2087
        StrCopy(servicedesc, 'eli : ELI - Event Logging Integration')
    CASE 2089
        StrCopy(servicedesc, 'sep : Security Encapsulation Protocol - SEP')
    CASE 2090
        StrCopy(servicedesc, 'lrp : Load Report Protocol')
    CASE 2091
        StrCopy(servicedesc, 'prp : PRP')
    CASE 2092
        StrCopy(servicedesc, 'descent3 : Descent 3')
    CASE 2093
        StrCopy(servicedesc, 'nbx-cc : NBX CC')
    CASE 2094
        StrCopy(servicedesc, 'nbx-au : NBX AU')
    CASE 2095
        StrCopy(servicedesc, 'nbx-ser : NBX SER')
    CASE 2096
        StrCopy(servicedesc, 'nbx-dir : NBX DIR')
    CASE 2097
        StrCopy(servicedesc, 'jetformpreview : Jet Form Preview')
    CASE 2098
        StrCopy(servicedesc, 'dialog-port : Dialog Port')
    CASE 2099
        StrCopy(servicedesc, 'h2250-annex-g : H.225.0 Annex G')
    CASE 2100
        StrCopy(servicedesc, 'amiganetfs : amiganetfs')


    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC




EXPORT PROC service9(portserv:LONG)

SELECT portserv
    CASE 2101
        StrCopy(servicedesc, 'rtcm-sc104 : rtcm-sc104')
    CASE 2102
        StrCopy(servicedesc, 'zephyr-srv : Zephyr server')
    CASE 2103
        StrCopy(servicedesc, 'zephyr-clt : Zephyr serv-hm connection')
    CASE 2104
        StrCopy(servicedesc, 'zephyr-hm : Zephyr hostmanager')
    CASE 2105
        StrCopy(servicedesc, 'minipay : MiniPay ; eklogin : Kerberos Encrypted Remote Login')
    CASE 2106
        StrCopy(servicedesc, 'mzap ekshell : MZAP ; Kerberos Encrypted Remote Shell')
    CASE 2107
        StrCopy(servicedesc, 'bintec-admin : BinTec Admin ')
    CASE 2108
        StrCopy(servicedesc, 'comcam rkinit : Comcam ; Kerberos Remote Initialisation')
    CASE 2109
        StrCopy(servicedesc, 'ergolight : Ergolight')
    CASE 2110
        StrCopy(servicedesc, 'umsp : UMSP')
    CASE 2111
        StrCopy(servicedesc, 'dsatp kx : DSATP ; X over Kerberos')
    CASE 2112
        StrCopy(servicedesc, 'idonix-metanet kip : Idonix MetaNet ; IP over Kerberos')
    CASE 2113
        StrCopy(servicedesc, 'hsl-storm : HSL StoRM')
    CASE 2114
        StrCopy(servicedesc, 'newheights : NEWHEIGHTS')
    CASE 2115
        StrCopy(servicedesc, 'kdm : KDM ; \eb[TROJANS=Bugs]\en')
    CASE 2116
        StrCopy(servicedesc, 'ccowcmr : CCOWCMR')
    CASE 2117
        StrCopy(servicedesc, 'mentaclient : MENTACLIENT')
    CASE 2118
        StrCopy(servicedesc, 'mentaserver : MENTASERVER')
    CASE 2119
        StrCopy(servicedesc, 'gsigatekeeper : GSIGATEKEEPER')
    CASE 2120
        StrCopy(servicedesc, 'qencp kauth : Quick Eagle Networks CP ; Remote Kauth')
    CASE 2121
        StrCopy(servicedesc, 'scientia-ssdb : SCIENTIA-SSDB')
    CASE 2122
        StrCopy(servicedesc, 'caupc-remote : CauPC Remote Control')
    CASE 2123
        StrCopy(servicedesc, 'gtp-control : GTP-Control Plane (3GPP)')
    CASE 2124
        StrCopy(servicedesc, 'elatelink : ELATELINK')
    CASE 2125
        StrCopy(servicedesc, 'lockstep : LOCKSTEP')
    CASE 2126
        StrCopy(servicedesc, 'pktcable-cops : PktCable-COPS')
    CASE 2127
        StrCopy(servicedesc, 'index-pc-wb : INDEX-PC-WB')
    CASE 2128
        StrCopy(servicedesc, 'net-steward : Net Steward Control')
    CASE 2129
        StrCopy(servicedesc, 'cs-live : cs-live.com')
    CASE 2130
        StrCopy(servicedesc, 'swc-xds : SWC-XDS')
    CASE 2131
        StrCopy(servicedesc, 'avantageb2b : Avantageb2b')
    CASE 2132
        StrCopy(servicedesc, 'avail-epmap : AVAIL-EPMAP')
    CASE 2133
        StrCopy(servicedesc, 'zymed-zpp : ZYMED-ZPP')
    CASE 2134
        StrCopy(servicedesc, 'avenue : AVENUE')
    CASE 2135
        StrCopy(servicedesc, 'gris : Grid Resource Information Server')
    CASE 2136
        StrCopy(servicedesc, 'appworxsrv : APPWORXSRV')
    CASE 2137
        StrCopy(servicedesc, 'connect : CONNECT')
    CASE 2138
        StrCopy(servicedesc, 'unbind-cluster : UNBIND-CLUSTER')
    CASE 2139
        StrCopy(servicedesc, 'ias-auth : IAS-AUTH')
    CASE 2140
        StrCopy(servicedesc, 'ias-reg : IAS-REG ; \eb[TROJANS=Deep Throat, The Invasor]\en')
    CASE 2141
        StrCopy(servicedesc, 'ias-admind : IAS-ADMIND')
    CASE 2142
        StrCopy(servicedesc, 'tdm-over-ip : TDM-OVER-IP')
    CASE 2143
        StrCopy(servicedesc, 'lv-jc : Live Vault Job Control')
    CASE 2144
        StrCopy(servicedesc, 'lv-ffx : Live Vault Fast Object Transfer')
    CASE 2145
        StrCopy(servicedesc, 'lv-pici : Live Vault Remote Diagnostic Console Support')
    CASE 2146
        StrCopy(servicedesc, 'lv-not : Live Vault Admin Event Notification')
    CASE 2147
        StrCopy(servicedesc, 'lv-auth : Live Vault Authentication')
    CASE 2148
        StrCopy(servicedesc, 'veritas-ucl : VERITAS UNIVERSAL COMMUNICATION LAYER')
    CASE 2149
        StrCopy(servicedesc, 'acptsys : ACPTSYS')
    CASE 2150
        StrCopy(servicedesc, 'dynamic3d : DYNAMIC3D ; ninstall : Ninstall Service')
    CASE 2151
        StrCopy(servicedesc, 'docent : DOCENT')
    CASE 2155
        StrCopy(servicedesc, '\eb[TROJANS=Illusion Mailer]\en')
    CASE 2152
        StrCopy(servicedesc, 'gtp-user : GTP-User Plane (3GPP)')
    CASE 2165
        StrCopy(servicedesc, 'x-bone-api : X-Bone API')
    CASE 2166
        StrCopy(servicedesc, 'iwserver : IWSERVER')
    CASE 2180
        StrCopy(servicedesc, 'mc-gt-srv : Millicent Vendor Gateway Server')
    CASE 2181
        StrCopy(servicedesc, 'eforward : eforward')
    CASE 2200
        StrCopy(servicedesc, 'ici : ICI')
    CASE 2201
        StrCopy(servicedesc, 'ats : Advanced Training System Program')
    CASE 2202
        StrCopy(servicedesc, 'imtc-map : Int. Multimedia Teleconferencing Cosortium')
    CASE 2213
        StrCopy(servicedesc, 'kali : Kali')
    CASE 2220
        StrCopy(servicedesc, 'netiq : NetIQ Pegasus')
    CASE 2221
        StrCopy(servicedesc, 'rockwell-csp1 : Rockwell CSP1')
    CASE 2222
        StrCopy(servicedesc, 'rockwell-csp2 : Rockwell CSP2')
    CASE 2223
        StrCopy(servicedesc, 'rockwell-csp3 : Rockwell CSP3')
    CASE 2232
        StrCopy(servicedesc, 'ivs-video : IVS Video default')
    CASE 2233
        StrCopy(servicedesc, 'infocrypt : INFOCRYPT')
    CASE 2234
        StrCopy(servicedesc, 'directplay : DirectPlay')
    CASE 2235
        StrCopy(servicedesc, 'sercomm-wlink : Sercomm-WLink')
    CASE 2236
        StrCopy(servicedesc, 'nani : Nani')
    CASE 2237
        StrCopy(servicedesc, 'optech-port1-lm : Optech Port1 License Manager')
    CASE 2238
        StrCopy(servicedesc, 'aviva-sna : AVIVA SNA SERVER')
    CASE 2239
        StrCopy(servicedesc, 'imagequery : Image Query')
    CASE 2240
        StrCopy(servicedesc, 'recipe : RECIPe')
    CASE 2241
        StrCopy(servicedesc, 'ivsd : IVS Daemon')
    CASE 2242
        StrCopy(servicedesc, 'foliocorp : Folio Remote Server')
    CASE 2243
        StrCopy(servicedesc, 'magicom : Magicom Protocol')
    CASE 2244
        StrCopy(servicedesc, 'nmsserver : NMS Server')
    CASE 2245
        StrCopy(servicedesc, 'hao : HaO')
    CASE 2250
        StrCopy(servicedesc, 'remote-collab : remote-collab')
    CASE 2255
        StrCopy(servicedesc, 'vrtp : VRTP - ViRtue Transfer Protocol')
    CASE 2279
        StrCopy(servicedesc, 'xmquery : xmquery')
    CASE 2280
        StrCopy(servicedesc, 'lnvpoller : LNVPOLLER')
    CASE 2281
        StrCopy(servicedesc, 'lnvconsole : LNVCONSOLE')
    CASE 2282
        StrCopy(servicedesc, 'lnvalarm : LNVALARM')
    CASE 2283
        StrCopy(servicedesc, 'lnvstatus : LNVSTATUS ; \eb[TROJANS=HVL Rat 5]\en')
    CASE 2284
        StrCopy(servicedesc, 'lnvmaps : LNVMAPS')
    CASE 2285
        StrCopy(servicedesc, 'lnvmailmon : LNVMAILMON')
    CASE 2286
        StrCopy(servicedesc, 'nas-metering : NAS-Metering')
    CASE 2287
        StrCopy(servicedesc, 'dna : DNA')
    CASE 2288
        StrCopy(servicedesc, 'netml : NETML')
    CASE 2294
        StrCopy(servicedesc, 'konshus-lm : Konshus License Manager (FLEX)')
    CASE 2295
        StrCopy(servicedesc, 'advant-lm : Advant License Manager')
    CASE 2296
        StrCopy(servicedesc, 'theta-lm : Theta License Manager (Rainbow)')
    CASE 2297
        StrCopy(servicedesc, 'd2k-datamover1 : D2K DataMover 1')
    CASE 2298
        StrCopy(servicedesc, 'd2k-datamover2 : D2K DataMover 2')
    CASE 2299
        StrCopy(servicedesc, 'pc-telecommute : PC Telecommute')
    CASE 2300
        StrCopy(servicedesc, 'cvmmon : CVMMON')
    CASE 2301
        StrCopy(servicedesc, 'cpq-wbem compaqdiag : Compaq HTTP ; Compaq Remote Diagnostic')
    CASE 2302
        StrCopy(servicedesc, 'binderysupport : Bindery Support')
    CASE 2303
        StrCopy(servicedesc, 'proxy-gateway : Proxy Gateway')
    CASE 2304
        StrCopy(servicedesc, 'attachmate-uts : Attachmate UTS')
    CASE 2305
        StrCopy(servicedesc, 'mt-scaleserver : MT ScaleServer')
    CASE 2306
        StrCopy(servicedesc, 'tappi-boxnet : TAPPI BoxNet')
    CASE 2307
        StrCopy(servicedesc, 'pehelp : pehelp')
    CASE 2308
        StrCopy(servicedesc, 'sdhelp : sdhelp')
    CASE 2309
        StrCopy(servicedesc, 'sdserver : SD Server')
    CASE 2310
        StrCopy(servicedesc, 'sdclient : SD Client')
    CASE 2311
        StrCopy(servicedesc, 'messageservice : Message Service')
    CASE 2313
        StrCopy(servicedesc, 'iapp : IAPP (Inter Access Point Protocol)')
    CASE 2314
        StrCopy(servicedesc, 'cr-websystems : CR WebSystems')
    CASE 2315
        StrCopy(servicedesc, 'precise-sft : Precise Sft.')
    CASE 2316
        StrCopy(servicedesc, 'sent-lm : SENT License Manager')
    CASE 2317
        StrCopy(servicedesc, 'attachmate-g32 : Attachmate G32')
    CASE 2318
        StrCopy(servicedesc, 'cadencecontrol : Cadence Control')
    CASE 2319
        StrCopy(servicedesc, 'infolibria : InfoLibria')
    CASE 2320
        StrCopy(servicedesc, 'siebel-ns : Siebel NS')
    CASE 2321
        StrCopy(servicedesc, 'rdlap : RDLAP over UDP')
    CASE 2322
        StrCopy(servicedesc, 'ofsd : ofsd')
    CASE 2323
        StrCopy(servicedesc, '3d-nfsd : 3d-nfsd')
    CASE 2324
        StrCopy(servicedesc, 'cosmocall : Cosmocall')
    CASE 2325
        StrCopy(servicedesc, 'designspace-lm : Design Space License Management')
    CASE 2326
        StrCopy(servicedesc, 'idcp : IDCP')
    CASE 2327
        StrCopy(servicedesc, 'xingcsm : xingcsm')
    CASE 2328
        StrCopy(servicedesc, 'netrix-sftm : Netrix SFTM')
    CASE 2329
        StrCopy(servicedesc, 'nvd : NVD')
    CASE 2330
        StrCopy(servicedesc, 'tscchat : TSCCHAT')
    CASE 2331
        StrCopy(servicedesc, 'agentview : AGENTVIEW')
    CASE 2332
        StrCopy(servicedesc, 'rcc-host : RCC Host')
    CASE 2333
        StrCopy(servicedesc, 'snapp : SNAPP')
    CASE 2334
        StrCopy(servicedesc, 'ace-client : ACE Client Auth')
    CASE 2335
        StrCopy(servicedesc, 'ace-proxy : ACE Proxy')
    CASE 2336
        StrCopy(servicedesc, 'appleugcontrol : Apple UG Control')
    CASE 2337
        StrCopy(servicedesc, 'ideesrv : ideesrv')
    CASE 2338
        StrCopy(servicedesc, 'norton-lambert : Norton Lambert')
    CASE 2339
        StrCopy(servicedesc, '3com-webview : 3Com WebView')
    CASE 2340
        StrCopy(servicedesc, 'wrs_registry : WRS Registry')
    CASE 2341
        StrCopy(servicedesc, 'xiostatus : XIO Status')
    CASE 2342
        StrCopy(servicedesc, 'manage-exec : Seagate Manage Exec')
    CASE 2343
        StrCopy(servicedesc, 'nati-logos : nati logos')
    CASE 2344
        StrCopy(servicedesc, 'fcmsys : fcmsys')
    CASE 2345
        StrCopy(servicedesc, 'dbm : dbm')
    CASE 2346
        StrCopy(servicedesc, 'redstorm_join : Game Connection Port')
    CASE 2347
        StrCopy(servicedesc, 'redstorm_find : Game Announcement and Location')
    CASE 2348
        StrCopy(servicedesc, 'redstorm_info : Information to query for game status')
    CASE 2349
        StrCopy(servicedesc, 'redstorm_diag : Diagnostics Port')
    CASE 2350
        StrCopy(servicedesc, 'psbserver : psbserver')
    CASE 2351
        StrCopy(servicedesc, 'psrserver : psrserver')
    CASE 2352
        StrCopy(servicedesc, 'pslserver : pslserver')
    CASE 2353
        StrCopy(servicedesc, 'pspserver : pspserver')
    CASE 2354
        StrCopy(servicedesc, 'psprserver : psprserver')
    CASE 2355
        StrCopy(servicedesc, 'psdbserver : psdbserver')
    CASE 2356
        StrCopy(servicedesc, 'gxtelmd : GXT License Managemant')
    CASE 2357
        StrCopy(servicedesc, 'unihub-server : UniHub Server')
    CASE 2358
        StrCopy(servicedesc, 'futrix : Futrix')
    CASE 2359
        StrCopy(servicedesc, 'flukeserver : FlukeServer')
    CASE 2360
        StrCopy(servicedesc, 'nexstorindltd : NexstorIndLtd')
    CASE 2361
        StrCopy(servicedesc, 'tl1 : TL1')
    CASE 2362
        StrCopy(servicedesc, 'digiman : digiman')
    CASE 2363
        StrCopy(servicedesc, 'mediacntrlnfsd : Media Central NFSD')
    CASE 2364
        StrCopy(servicedesc, 'oi-2000 : OI-2000')
    CASE 2365
        StrCopy(servicedesc, 'dbref : dbref')
    CASE 2366
        StrCopy(servicedesc, 'qip-login : qip-login')
    CASE 2367
        StrCopy(servicedesc, 'service-ctrl : Service Control')
    CASE 2368
        StrCopy(servicedesc, 'opentable : OpenTable')
    CASE 2369
        StrCopy(servicedesc, 'acs2000-dsp : ACS2000 DSP')
    CASE 2370
        StrCopy(servicedesc, 'l3-hbmon : L3-HBMon')
    CASE 2381
        StrCopy(servicedesc, 'compaq-https : Compaq HTTPS')
    CASE 2382
        StrCopy(servicedesc, 'ms-olap3 : Microsoft OLAP')
    CASE 2383
        StrCopy(servicedesc, 'ms-olap4 : Microsoft OLAP')
    CASE 2384
        StrCopy(servicedesc, 'sd-request : SD-REQUEST')
    CASE 2389
        StrCopy(servicedesc, 'ovsessionmgr : OpenView Session Mgr')
    CASE 2390
        StrCopy(servicedesc, 'rsmtp : RSMTP')
    CASE 2391
        StrCopy(servicedesc, '3com-net-mgmt : 3COM Net Management')
    CASE 2392
        StrCopy(servicedesc, 'tacticalauth : Tactical Auth')
    CASE 2393
        StrCopy(servicedesc, 'ms-olap1 : MS OLAP 1')
    CASE 2394
        StrCopy(servicedesc, 'ms-olap2 : MS OLAP 2')
    CASE 2395
        StrCopy(servicedesc, 'lan900_remote : LAN900 Remote')
    CASE 2396
        StrCopy(servicedesc, 'wusage : Wusage')
    CASE 2397
        StrCopy(servicedesc, 'ncl : NCL')
    CASE 2398
        StrCopy(servicedesc, 'orbiter : Orbiter')
    CASE 2399
        StrCopy(servicedesc, 'fmpro-fdal : FileMaker, Inc. - Data Access Layer')
    CASE 2400
        StrCopy(servicedesc, 'opequus-server : OpEquus Server')
    CASE 2401
        StrCopy(servicedesc, 'cvspserver : Control Version System Client/Server Operations')
    CASE 2402
        StrCopy(servicedesc, 'taskmaster2000 : TaskMaster 2000 Server')
    CASE 2403
        StrCopy(servicedesc, 'taskmaster2000 : TaskMaster 2000 Web')
    CASE 2404
        StrCopy(servicedesc, 'iec870-5-104 : IEC870-5-104')
    CASE 2405
        StrCopy(servicedesc, 'trc-netpoll : TRC Netpoll')
    CASE 2406
        StrCopy(servicedesc, 'jediserver : JediServer')
    CASE 2407
        StrCopy(servicedesc, 'orion : Orion')
    CASE 2408
        StrCopy(servicedesc, 'optimanet : OptimaNet')
    CASE 2409
        StrCopy(servicedesc, 'sns-protocol : SNS Protocol')
    CASE 2410
        StrCopy(servicedesc, 'vrts-registry : VRTS Registry')
    CASE 2411
        StrCopy(servicedesc, 'netwave-ap-mgmt : Netwave AP Management')
    CASE 2412
        StrCopy(servicedesc, 'cdn : CDN')
    CASE 2413
        StrCopy(servicedesc, 'orion-rmi-reg : orion-rmi-reg')
    CASE 2414
        StrCopy(servicedesc, 'beeyond : Beeyond')
    CASE 2415
        StrCopy(servicedesc, 'comtest : COMTEST')
    CASE 2416
        StrCopy(servicedesc, 'rmtserver : RMT Server')
    CASE 2417
        StrCopy(servicedesc, 'composit-server : Composit Server')
    CASE 2418
        StrCopy(servicedesc, 'cas : cas')
    CASE 2419
        StrCopy(servicedesc, 'attachmate-s2s : Attachmate S2S')
    CASE 2420
        StrCopy(servicedesc, 'dslremote-mgmt : DSL Remote Management')
    CASE 2421
        StrCopy(servicedesc, 'g-talk : G-Talk')
    CASE 2422
        StrCopy(servicedesc, 'crmsbits : CRMSBITS')
    CASE 2423
        StrCopy(servicedesc, 'rnrp : RNRP')
    CASE 2424
        StrCopy(servicedesc, 'kofax-svr : KOFAX-SVR')
    CASE 2425
        StrCopy(servicedesc, 'fjitsuappmgr : Fujitsu App Manager')
    CASE 2426
        StrCopy(servicedesc, 'applianttcp : Appliant TCP')
    CASE 2427
        StrCopy(servicedesc, 'mgcp-gateway : Media Gateway Control Protocol Gateway')
    CASE 2428
        StrCopy(servicedesc, 'ott : One Way Trip Time')
    CASE 2429
        StrCopy(servicedesc, 'ft-role : FT-ROLE')
    CASE 2430
        StrCopy(servicedesc, 'venus : Venus callback/wbc interface')
    CASE 2431
        StrCopy(servicedesc, 'venus-se : Vencus TCP Side Effects')
    CASE 2432
        StrCopy(servicedesc, 'codasrv : codasrv')
    CASE 2433
        StrCopy(servicedesc, 'codasrv-se : Codasrv TCP Side Effects')
    CASE 2434
        StrCopy(servicedesc, 'pxc-epmap : pxc-epmap')
    CASE 2435
        StrCopy(servicedesc, 'optilogic : OptiLogic')
    CASE 2436
        StrCopy(servicedesc, 'topx : TOP/X')
    CASE 2437
        StrCopy(servicedesc, 'unicontrol : UniControl')
    CASE 2438
        StrCopy(servicedesc, 'msp : MSP')
    CASE 2439
        StrCopy(servicedesc, 'sybasedbsynch : SybaseDBSynch')
    CASE 2440
        StrCopy(servicedesc, 'spearway : Spearway Lockers')
    CASE 2441
        StrCopy(servicedesc, 'pvsw-inet : pvsw-inet')
    CASE 2442
        StrCopy(servicedesc, 'netangel : Netangel')
    CASE 2443
        StrCopy(servicedesc, 'powerclientcsf : PowerClient Central Storage Facility')
    CASE 2444
        StrCopy(servicedesc, 'btpp2sectrans : BT PP2 Sectrans')
    CASE 2445
        StrCopy(servicedesc, 'dtn1 : DTN1')
    CASE 2446
        StrCopy(servicedesc, 'bues_service : bues_service')
    CASE 2447
        StrCopy(servicedesc, 'ovwdb : OpenView NNM daemon')
    CASE 2448
        StrCopy(servicedesc, 'hpppssvr : hpppsvr')
    CASE 2449
        StrCopy(servicedesc, 'ratl : RATL')
    CASE 2450
        StrCopy(servicedesc, 'netadmin : netadmin')
    CASE 2451
        StrCopy(servicedesc, 'netchat : netchat')
    CASE 2452
        StrCopy(servicedesc, 'snifferclient : SnifferClient')
    CASE 2453
        StrCopy(servicedesc, 'madge-om : madge-om')
    CASE 2454
        StrCopy(servicedesc, 'indx-dds : IndX-DDS')
    CASE 2455
        StrCopy(servicedesc, 'wago-io-system : WAGO-IO-SYSTEM')
    CASE 2456
        StrCopy(servicedesc, 'altav-remmgt : altav-remmgt')
    CASE 2457
        StrCopy(servicedesc, 'rapido-ip : Rapido_IP')
    CASE 2458
        StrCopy(servicedesc, 'griffin : griffin')
    CASE 2459
        StrCopy(servicedesc, 'community : Community')
    CASE 2460
        StrCopy(servicedesc, 'ms-theater : ms-theater')
    CASE 2461
        StrCopy(servicedesc, 'qadmifoper : qadmifoper')
    CASE 2462
        StrCopy(servicedesc, 'qadmifevent : qadmifevent')
    CASE 2463
        StrCopy(servicedesc, 'symbios-raid : Symbios Raid')
    CASE 2464
        StrCopy(servicedesc, 'direcpc-si : DirecPC SI')
    CASE 2465
        StrCopy(servicedesc, 'lbm : Load Balance Management')
    CASE 2466
        StrCopy(servicedesc, 'lbf : Load Balance Forwarding')
    CASE 2467
        StrCopy(servicedesc, 'high-criteria : High Criteria')
    CASE 2468
        StrCopy(servicedesc, 'qip-msgd : qip_msgd')
    CASE 2469
        StrCopy(servicedesc, 'mti-tcs-comm : MTI-TCS-COMM')
    CASE 2470
        StrCopy(servicedesc, 'taskman-port : taskman port')
    CASE 2471
        StrCopy(servicedesc, 'seaodbc : SeaODBC')
    CASE 2472
        StrCopy(servicedesc, 'c3 : C3')
    CASE 2473
        StrCopy(servicedesc, 'aker-cdp : Aker-cdp')
    CASE 2474
        StrCopy(servicedesc, 'vitalanalysis : Vital Analysis')
    CASE 2475
        StrCopy(servicedesc, 'ace-server : ACE Server')
    CASE 2476
        StrCopy(servicedesc, 'ace-svr-prop : ACE Server Propagation')
    CASE 2477
        StrCopy(servicedesc, 'ssm-cvs : SecurSight Certificate Valifation Service')
    CASE 2478
        StrCopy(servicedesc, 'ssm-cssps : SecurSight Authentication Server (SLL)')
    CASE 2479
        StrCopy(servicedesc, 'ssm-els : SecurSight Event Logging Server (SSL)')
    CASE 2480
        StrCopy(servicedesc, 'lingwood : Lingwoods Detail')
    CASE 2481
        StrCopy(servicedesc, 'giop : Oracle GIOP')
    CASE 2482
        StrCopy(servicedesc, 'giop-ssl : Oracle GIOP SSL')
    CASE 2483
        StrCopy(servicedesc, 'ttc : Oracle TTC')
    CASE 2484
        StrCopy(servicedesc, 'ttc-ssl : Oracle TTC SSL')
    CASE 2485
        StrCopy(servicedesc, 'netobjects1 : Net Objects1')
    CASE 2486
        StrCopy(servicedesc, 'netobjects2 : Net Objects2')
    CASE 2487
        StrCopy(servicedesc, 'pns : Policy Notice Service')
    CASE 2488
        StrCopy(servicedesc, 'moy-corp : Moy Corporation')
    CASE 2489
        StrCopy(servicedesc, 'tsilb : TSILB')
    CASE 2490
        StrCopy(servicedesc, 'qip-qdhcp : qip_qdhcp')
    CASE 2491
        StrCopy(servicedesc, 'conclave-cpp : Conclave CPP')
    CASE 2492
        StrCopy(servicedesc, 'groove : GROOVE')
    CASE 2493
        StrCopy(servicedesc, 'talarian-mqs : Talarian MQS')
    CASE 2494
        StrCopy(servicedesc, 'bmc-ar : BMC AR')
    CASE 2495
        StrCopy(servicedesc, 'fast-rem-serv : Fast Remote Services')
    CASE 2496
        StrCopy(servicedesc, 'dirgis : DIRGIS')
    CASE 2497
        StrCopy(servicedesc, 'quaddb : Quad DB')
    CASE 2498
        StrCopy(servicedesc, 'odn-castraq : ODN-CasTraq')
    CASE 2499
        StrCopy(servicedesc, 'unicontrol : UniControl')
    CASE 2500
        StrCopy(servicedesc, 'rtsserv : Resource Tracking system server ; Freeware Amiga Network Filesystem')
    CASE 2501
        StrCopy(servicedesc, 'rtsclient : Resource Tracking system client')
    CASE 2502
        StrCopy(servicedesc, 'kentrox-prot : Kentrox Protocol')
    CASE 2503
        StrCopy(servicedesc, 'nms-dpnss : NMS-DPNSS')
    CASE 2504
        StrCopy(servicedesc, 'wlbs : WLBS ')
    CASE 2505
        StrCopy(servicedesc, 'torque-traffic : torque-traffic')
    CASE 2506
        StrCopy(servicedesc, 'jbroker : jbroker')
    CASE 2507
        StrCopy(servicedesc, 'spock : spock')
    CASE 2508
        StrCopy(servicedesc, 'jdatastore : JDataStore')
    CASE 2509
        StrCopy(servicedesc, 'fjmpss : fjmpss')
    CASE 2510
        StrCopy(servicedesc, 'fjappmgrbulk : fjappmgrbulk')
    CASE 2511
        StrCopy(servicedesc, 'metastorm : Metastorm')
    CASE 2512
        StrCopy(servicedesc, 'citrixima : Citrix IMA')
    CASE 2513
        StrCopy(servicedesc, 'citrixadmin : Citrix ADMIN')
    CASE 2514
        StrCopy(servicedesc, 'facsys-ntp : Facsys NTP')
    CASE 2515
        StrCopy(servicedesc, 'facsys-router : Facsys Router')
    CASE 2516
        StrCopy(servicedesc, 'maincontrol : Main Control')
    CASE 2517
        StrCopy(servicedesc, 'call-sig-trans : H.323 Annex E call signaling transport')
    CASE 2518
        StrCopy(servicedesc, 'willy : Willy')
    CASE 2519
        StrCopy(servicedesc, 'globmsgsvc : globmsgsvc')
    CASE 2520
        StrCopy(servicedesc, 'pvsw : pvsw')
    CASE 2521
        StrCopy(servicedesc, 'adaptecmgr : Adaptec Manager')
    CASE 2522
        StrCopy(servicedesc, 'windb : WinDb')
    CASE 2523
        StrCopy(servicedesc, 'qke-llc-v3 : Qke LLC V.3')
    CASE 2524
        StrCopy(servicedesc, 'optiwave-lm : Optiwave License Management')
    CASE 2525
        StrCopy(servicedesc, 'ms-v-worlds : MS V-Worlds ')
    CASE 2526
        StrCopy(servicedesc, 'ema-sent-lm : EMA License Manager')
    CASE 2527
        StrCopy(servicedesc, 'iqserver : IQ Server')
    CASE 2528
        StrCopy(servicedesc, 'ncr_ccl : NCR CCL')
    CASE 2529
        StrCopy(servicedesc, 'utsftp : UTS FTP')
    CASE 2530
        StrCopy(servicedesc, 'vrcommerce : VR Commerce')
    CASE 2531
        StrCopy(servicedesc, 'ito-e-gui : ITO-E GUI')
    CASE 2532
        StrCopy(servicedesc, 'ovtopmd : OVTOPMD')
    CASE 2533
        StrCopy(servicedesc, 'snifferserver : SnifferServer')
    CASE 2534
        StrCopy(servicedesc, 'combox-web-acc : Combox Web Access')
    CASE 2535
        StrCopy(servicedesc, 'madcap : MADCAP')
    CASE 2536
        StrCopy(servicedesc, 'btpp2audctr1 : btpp2audctr1')
    CASE 2537
        StrCopy(servicedesc, 'upgrade : Upgrade Protocol')
    CASE 2538
        StrCopy(servicedesc, 'vnwk-prapi : vnwk-prapi')
    CASE 2539
        StrCopy(servicedesc, 'vsiadmin : VSI Admin')
    CASE 2540
        StrCopy(servicedesc, 'lonworks : LonWorks')
    CASE 2541
        StrCopy(servicedesc, 'lonworks2 : LonWorks2')
    CASE 2542
        StrCopy(servicedesc, 'davinci : daVinci')
    CASE 2543
        StrCopy(servicedesc, 'reftek : REFTEK')
    CASE 2544
        StrCopy(servicedesc, 'novell-zen : Novell ZEN')
    CASE 2544
        StrCopy(servicedesc, 'novell-zen : Novell ZEN')
    CASE 2545
        StrCopy(servicedesc, 'sis-emt : sis-emt')
    CASE 2546
        StrCopy(servicedesc, 'vytalvaultbrtp : vytalvaultbrtp')
    CASE 2547
        StrCopy(servicedesc, 'vytalvaultvsmp : vytalvaultvsmp')
    CASE 2548
        StrCopy(servicedesc, 'vytalvaultpipe : vytalvaultpipe')
    CASE 2549
        StrCopy(servicedesc, 'ipass : IPASS')
    CASE 2550
        StrCopy(servicedesc, 'ads : ADS')
    CASE 2551
        StrCopy(servicedesc, 'isg-uda-server : ISG UDA Server')
    CASE 2552
        StrCopy(servicedesc, 'call-logging : Call Logging')
    CASE 2553
        StrCopy(servicedesc, 'efidiningport : efidiningport')
    CASE 2554
        StrCopy(servicedesc, 'vcnet-link-v10 : VCnet-Link v10')
    CASE 2555
        StrCopy(servicedesc, 'compaq-wcp : Compaq WCP')
    CASE 2556
        StrCopy(servicedesc, 'nicetec-nmsvc : nicetec-nmsvc')
    CASE 2557
        StrCopy(servicedesc, 'nicetec-mgmt : nicetec-mgmt')
    CASE 2558
        StrCopy(servicedesc, 'pclemultimedia : PCLE Multi Media')
    CASE 2559
        StrCopy(servicedesc, 'lstp : LSTP')
    CASE 2560
        StrCopy(servicedesc, 'labrat : labrat')
    CASE 2561
        StrCopy(servicedesc, 'mosaixcc : MosaixCC')
    CASE 2562
        StrCopy(servicedesc, 'delibo : Delibo')
    CASE 2563
        StrCopy(servicedesc, 'cti-redwood : CTI Redwood')
    CASE 2564
        StrCopy(servicedesc, 'hp-3000-telnet : HP 3000 NS/VT block mode telnet')
    CASE 2565
        StrCopy(servicedesc, 'coord-svr : Coordinator Server ; \eb[TROJANS=Striker]\en')
    CASE 2566
        StrCopy(servicedesc, 'pcs-pcw : pcs-pcw')
    CASE 2567
        StrCopy(servicedesc, 'clp : Cisco Line Protocol')
    CASE 2568
        StrCopy(servicedesc, 'spamtrap : SPAM TRAP')
    CASE 2569
        StrCopy(servicedesc, 'sonuscallsig : Sonus Call Signal')
    CASE 2570
        StrCopy(servicedesc, 'hs-port : HS Port')
    CASE 2571
        StrCopy(servicedesc, 'cecsvc : CECSVC')
    CASE 2572
        StrCopy(servicedesc, 'ibp : IBP')
    CASE 2573
        StrCopy(servicedesc, 'trustestablish : Trust Establish')
    CASE 2574
        StrCopy(servicedesc, 'blockade-bpsp : Blockade BPSP')
    CASE 2575
        StrCopy(servicedesc, 'hl7 : HL7')
    CASE 2576
        StrCopy(servicedesc, 'tclprodebugger : TCL Pro Debugger')
    CASE 2577
        StrCopy(servicedesc, 'scipticslsrvr : Scriptics Lsrvr')
    CASE 2578
        StrCopy(servicedesc, 'rvs-isdn-dcp : RVS ISDN DCP')
    CASE 2579
        StrCopy(servicedesc, 'mpfoncl : mpfoncl')
    CASE 2580
        StrCopy(servicedesc, 'tributary : Tributary')
    CASE 2581
        StrCopy(servicedesc, 'argis-te : ARGIS TE')
    CASE 2582
        StrCopy(servicedesc, 'argis-ds : ARGIS DS')
    CASE 2583
        StrCopy(servicedesc, 'mon : MON ; \eb[TROJANS=Win Crash]\en')
    CASE 2584
        StrCopy(servicedesc, 'cyaserv : cyaserv')
    CASE 2585
        StrCopy(servicedesc, 'netx-server : NETX Server')
    CASE 2586
        StrCopy(servicedesc, 'netx-agent : NETX Agent')
    CASE 2587
        StrCopy(servicedesc, 'masc : MASC')
    CASE 2588
        StrCopy(servicedesc, 'privilege : Privilege')
    CASE 2589
        StrCopy(servicedesc, 'quartus-tcl : quartus tcl')
    CASE 2590
        StrCopy(servicedesc, 'idotdist : idotdist')
    CASE 2591
        StrCopy(servicedesc, 'maytagshuffle : Maytag Shuffle')
    CASE 2592
        StrCopy(servicedesc, 'netrek : netrek')
    CASE 2593
        StrCopy(servicedesc, 'mns-mail : MNS Mail Notice Service')
    CASE 2594
        StrCopy(servicedesc, 'dts : Data Base Server')
    CASE 2595
        StrCopy(servicedesc, 'worldfusion1 : World Fusion 1')
    CASE 2596
        StrCopy(servicedesc, 'worldfusion2 : World Fusion 2')
    CASE 2597
        StrCopy(servicedesc, 'homesteadglory : Homestead Glory')
    CASE 2598
        StrCopy(servicedesc, 'citriximaclient : Citrix MA Client')
    CASE 2599
        StrCopy(servicedesc, 'meridiandata : Meridian Data')
    CASE 2600
        StrCopy(servicedesc, 'hpstgmgr zebrasrv : HPSTGMGR ; Zebra Service ; \eb[TROJANS=Digital RootBeer]\en')


    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC




EXPORT PROC service10(portserv:LONG)

SELECT portserv
    CASE 2601
        StrCopy(servicedesc, 'discp-client zebra : discp client ; Zebra VTY')
    CASE 2602
        StrCopy(servicedesc, 'discp-server ripd : discp server ; RIPd VTY')
    CASE 2603
        StrCopy(servicedesc, 'servicemeter ripngd : Service Meter ; RIPngd VTY')
    CASE 2604
        StrCopy(servicedesc, 'nsc-ccs ospfd : NSC CCS ; OFPFd VTY')
    CASE 2605
        StrCopy(servicedesc, 'nsc-posa bgpd : NSC POSA ; BGPd VTY')
    CASE 2606
        StrCopy(servicedesc, 'netmon : Dell Netmon')
    CASE 2607
        StrCopy(servicedesc, 'connection : Dell Connection')
    CASE 2608
        StrCopy(servicedesc, 'wag-service : Wag Service')
    CASE 2609
        StrCopy(servicedesc, 'system-monitor : System Monitor')
    CASE 2610
        StrCopy(servicedesc, 'versa-tek : VersaTek')
    CASE 2611
        StrCopy(servicedesc, 'lionhead : LIONHEAD')
    CASE 2612
        StrCopy(servicedesc, 'qpasa-agent : Qpasa Agent')
    CASE 2613
        StrCopy(servicedesc, 'smntubootstrap : SMNTUBootstrap')
    CASE 2614
        StrCopy(servicedesc, 'neveroffline : Never Offline')
    CASE 2615
        StrCopy(servicedesc, 'firepower : firepower')
    CASE 2616
        StrCopy(servicedesc, 'appswitch-emp : appswitch-emp')
    CASE 2617
        StrCopy(servicedesc, 'cmadmin : Clinical Context Managers')
    CASE 2618
        StrCopy(servicedesc, 'priority-e-com : Priority E-Com')
    CASE 2619
        StrCopy(servicedesc, 'bruce : bruce')
    CASE 2620
        StrCopy(servicedesc, 'lpsrecommender : LPSRecommender')
    CASE 2621
        StrCopy(servicedesc, 'miles-apart : Miles Apart Jukebox Server')
    CASE 2622
        StrCopy(servicedesc, 'metricadbc : MetricaDBC')
    CASE 2623
        StrCopy(servicedesc, 'lmdp : LMDP')
    CASE 2624
        StrCopy(servicedesc, 'aria : Aria')
    CASE 2625
        StrCopy(servicedesc, 'blwnkl-port : Blwnkl Port')
    CASE 2626
        StrCopy(servicedesc, 'gbjd816 : gbjd816')
    CASE 2627
        StrCopy(servicedesc, 'moshebeeri webster : Moshe Beeri ; Webster Networked Dictionary')
    CASE 2628
        StrCopy(servicedesc, 'dict : DICT')
    CASE 2629
        StrCopy(servicedesc, 'sitaraserver : Sitara Server')
    CASE 2630
        StrCopy(servicedesc, 'sitaramgmt : Sitara Management')
    CASE 2631
        StrCopy(servicedesc, 'sitaradir : Sitara Dir')
    CASE 2632
        StrCopy(servicedesc, 'irdg-post : IRdg Post')
    CASE 2633
        StrCopy(servicedesc, 'interintelli : InterIntelli')
    CASE 2634
        StrCopy(servicedesc, 'pk-electronics : PK Electronics')
    CASE 2635
        StrCopy(servicedesc, 'backburner : Back Burner')
    CASE 2636
        StrCopy(servicedesc, 'solve : Solve')
    CASE 2637
        StrCopy(servicedesc, 'imdocsvc : Import Document Service')
    CASE 2638
        StrCopy(servicedesc, 'sybaseanywhere : Sybase Anywhere Database')
    CASE 2639
        StrCopy(servicedesc, 'aminet : AMInet')
    CASE 2640
        StrCopy(servicedesc, 'sai_sentlm : Sabbagh Associates Licence Manager')
    CASE 2641
        StrCopy(servicedesc, 'hdl-srv : HDL Server')
    CASE 2642
        StrCopy(servicedesc, 'tragic : Tragic')
    CASE 2643
        StrCopy(servicedesc, 'gte-samp : GTE-SAMP')
    CASE 2644
        StrCopy(servicedesc, 'travsoft-ipx-t : Travsoft IPX Tunnel')
    CASE 2645
        StrCopy(servicedesc, 'novell-ipx-cmd : Novell IPX CMD')
    CASE 2646
        StrCopy(servicedesc, 'and-lm : AND Licence Manager')
    CASE 2647
        StrCopy(servicedesc, 'syncserver : SyncServer')
    CASE 2648
        StrCopy(servicedesc, 'upsnotifyprot : Upsnotifyprot')
    CASE 2649
        StrCopy(servicedesc, 'vpsipport : VPSIPPORT')
    CASE 2650
        StrCopy(servicedesc, 'eristwoguns : eristwoguns')
    CASE 2651
        StrCopy(servicedesc, 'ebinsite : EBInSite')
    CASE 2652
        StrCopy(servicedesc, 'interpathpanel : InterPathPanel')
    CASE 2653
        StrCopy(servicedesc, 'sonus : Sonus')
    CASE 2654
        StrCopy(servicedesc, 'corel_vncadmin : Corel VNC Admin')
    CASE 2655
        StrCopy(servicedesc, 'unglue : UNIX Nt Glue')
    CASE 2656
        StrCopy(servicedesc, 'kana : Kana')
    CASE 2657
        StrCopy(servicedesc, 'sns-dispatcher : SNS Dispatcher')
    CASE 2658
        StrCopy(servicedesc, 'sns-admin : SNS Admin')
    CASE 2659
        StrCopy(servicedesc, 'sns-query : SNS Query')
    CASE 2660
        StrCopy(servicedesc, 'gcmonitor : GC Monitor')
    CASE 2661
        StrCopy(servicedesc, 'olhost : OLHOST')
    CASE 2662
        StrCopy(servicedesc, 'bintec-capi : BinTec-CAPI')
    CASE 2663
        StrCopy(servicedesc, 'bintec-tapi : BinTec-TAPI')
    CASE 2664
        StrCopy(servicedesc, 'command-mq-gm : Command MQ GM')
    CASE 2665
        StrCopy(servicedesc, 'command-mq-pm : Command MQ PM')
    CASE 2666
        StrCopy(servicedesc, 'extensis : extensis')
    CASE 2667
        StrCopy(servicedesc, 'alarm-clock-s : Alarm Clock Server')
    CASE 2668
        StrCopy(servicedesc, 'alarm-clock-c : Alarm Clock Client')
    CASE 2669
        StrCopy(servicedesc, 'toad : TOAD')
    CASE 2670
        StrCopy(servicedesc, 'tve-announce : TVE Announce')
    CASE 2671
        StrCopy(servicedesc, 'newlixreg : newlixreg')
    CASE 2672
        StrCopy(servicedesc, 'nhserver : nhserver')
    CASE 2673
        StrCopy(servicedesc, 'firstcall42 : First Call 42')
    CASE 2674
        StrCopy(servicedesc, 'ewnn : ewnn')
    CASE 2675
        StrCopy(servicedesc, 'ttc-etap : TTC ETAP')
    CASE 2676
        StrCopy(servicedesc, 'simslink : SIMSLink')
    CASE 2677
        StrCopy(servicedesc, 'gadgetgate1way : Gadget Gate 1 Way')
    CASE 2678
        StrCopy(servicedesc, 'gadgetgate2way : Gadget Gate 2 Way')
    CASE 2679
        StrCopy(servicedesc, 'syncserverssl : Sync Server SSL')
    CASE 2680
        StrCopy(servicedesc, 'pxc-sapxom : pxc-sapxom')
    CASE 2681
        StrCopy(servicedesc, 'mpnjsomb : mpnjsomb')
    CASE 2682
        StrCopy(servicedesc, 'srsp : SRSP')
    CASE 2683
        StrCopy(servicedesc, 'ncdloadbalance : NCDLoadBalance')
    CASE 2684
        StrCopy(servicedesc, 'mpnjsosv : mpnjsosv')
    CASE 2685
        StrCopy(servicedesc, 'mpnjsocl : mpnjsocl')
    CASE 2686
        StrCopy(servicedesc, 'mpnjsomg : mpnjsomg')
    CASE 2687
        StrCopy(servicedesc, 'pq-lic-mgmt : pq-lic-mgmt')
    CASE 2688
        StrCopy(servicedesc, 'md-cg-http : md-cf-http')
    CASE 2689
        StrCopy(servicedesc, 'fastlynx : FastLynx')
    CASE 2690
        StrCopy(servicedesc, 'hp-nnm-data : HP NNM Embedded Database')
    CASE 2691
        StrCopy(servicedesc, 'itinternet : IT Internet')
    CASE 2692
        StrCopy(servicedesc, 'admins-lms : Admins LMS')
    CASE 2693
        StrCopy(servicedesc, 'belarc-http : belarc-http')
    CASE 2694
        StrCopy(servicedesc, 'pwrsevent : pwrsevent')
    CASE 2695
        StrCopy(servicedesc, 'vspread : VSPREAD')
    CASE 2696
        StrCopy(servicedesc, 'unifyadmin : Unify Admin')
    CASE 2697
        StrCopy(servicedesc, 'oce-snmp-trap : Oce SNMP Trap Port')
    CASE 2698
        StrCopy(servicedesc, 'mck-ivpip : MCK-IVPIP')
    CASE 2699
        StrCopy(servicedesc, 'csoft-plusclnt : Csoft Plus Client')
    CASE 2700
        StrCopy(servicedesc, 'tqdata : tqdata')
    CASE 2701
        StrCopy(servicedesc, 'sms-rcinfo : SMS RCINFO')
    CASE 2702
        StrCopy(servicedesc, 'sms-xfer : SMS XFER')
    CASE 2703
        StrCopy(servicedesc, 'sms-chat : SMS CHAT')
    CASE 2704
        StrCopy(servicedesc, 'sms-remctrl : SMS REMCTRL')
    CASE 2705
        StrCopy(servicedesc, 'sds-admin : SDS Admin')
    CASE 2706
        StrCopy(servicedesc, 'ncdmirroring : NCD Mirroring')
    CASE 2707
        StrCopy(servicedesc, 'emcsymapiport : EMCSYMAPIPORT')
    CASE 2708
        StrCopy(servicedesc, 'banyan-net : Banyan-Net')
    CASE 2709
        StrCopy(servicedesc, 'supermon : Supermon')
    CASE 2710
        StrCopy(servicedesc, 'sso-service : SSO Service')
    CASE 2711
        StrCopy(servicedesc, 'sso-control : SSO Control')
    CASE 2712
        StrCopy(servicedesc, 'aocp : Axapta Object Communication Protocol')
    CASE 2713
        StrCopy(servicedesc, 'raven1 : Raven1')
    CASE 2714
        StrCopy(servicedesc, 'raven2 : Raven2')
    CASE 2714
        StrCopy(servicedesc, 'raven2 : Raven2')
    CASE 2715
        StrCopy(servicedesc, 'hpstgmgr2 : HPSTGMGR2')
    CASE 2716
        StrCopy(servicedesc, 'inova-ip-disco : Inova IP Disco')
    CASE 2717
        StrCopy(servicedesc, 'pn-requester : PN REQUESTER')
    CASE 2718
        StrCopy(servicedesc, 'pn-requester2 : PN REQUESTER 2')
    CASE 2719
        StrCopy(servicedesc, 'scan-change : Scan & Change')
    CASE 2720
        StrCopy(servicedesc, 'wkars : wkars')
    CASE 2721
        StrCopy(servicedesc, 'smart-diagnose : Smart Diagnose')
    CASE 2722
        StrCopy(servicedesc, 'proactivesrvr : Proactive Server')
    CASE 2723
        StrCopy(servicedesc, 'watchdognt : WatchDog NT')
    CASE 2724
        StrCopy(servicedesc, 'qotps : qotps')
    CASE 2725
        StrCopy(servicedesc, 'msolap-ptp2 : MSOLAP PTP2')
    CASE 2726
        StrCopy(servicedesc, 'tams : TAMS')
    CASE 2727
        StrCopy(servicedesc, 'mgcp-callagent : Media Gateway Control Protocol Call Agent')
    CASE 2728
        StrCopy(servicedesc, 'sqdr : SQDR')
    CASE 2729
        StrCopy(servicedesc, 'tcim-control : TCIM Control')
    CASE 2730
        StrCopy(servicedesc, 'nec-raidplus : NEC RaidPlus')
    CASE 2731
        StrCopy(servicedesc, 'netdragon-msngr : NetDragon Messanger')
    CASE 2732
        StrCopy(servicedesc, 'g5m : G5M')
    CASE 2733
        StrCopy(servicedesc, 'signet-ctf : Signet CTF')
    CASE 2734
        StrCopy(servicedesc, 'ccs-software : CCS Software')
    CASE 2735
        StrCopy(servicedesc, 'netiq-mc : NetIQ Monitor Console')
    CASE 2736
        StrCopy(servicedesc, 'radwiz-nms-srv : RADWIZ NMS SRV')
    CASE 2737
        StrCopy(servicedesc, 'srp-feedback : SRP Feedback')
    CASE 2738
        StrCopy(servicedesc, 'ndl-tcp-ois-gw : NDL TCP-OSI Gateway')
    CASE 2739
        StrCopy(servicedesc, 'tn-timing : TN Timing')
    CASE 2740
        StrCopy(servicedesc, 'alarm : Alarm')
    CASE 2741
        StrCopy(servicedesc, 'tsb : TSB')
    CASE 2742
        StrCopy(servicedesc, 'tsb2 : TSB2')
    CASE 2743
        StrCopy(servicedesc, 'murx : murx')
    CASE 2744
        StrCopy(servicedesc, 'honyaku : honyaku')
    CASE 2745
        StrCopy(servicedesc, 'urbisnet : URBISNET')
    CASE 2746
        StrCopy(servicedesc, 'cpudpencap : CPUDPENCAP')
    CASE 2747
        StrCopy(servicedesc, 'fjippol-swrly : fjippol-swrly')
    CASE 2748
        StrCopy(servicedesc, 'fjippol-polsvr : fjippol-polsvr')
    CASE 2749
        StrCopy(servicedesc, 'fjippol-cnsl : fjippol-cnsl ')
    CASE 2750
        StrCopy(servicedesc, 'fjippol-port1 : fjippol-port1 ')
    CASE 2751
        StrCopy(servicedesc, 'fjippol-port2 : fjippol-port2 ')
    CASE 2752
        StrCopy(servicedesc, 'rsisysaccess : RSISYS ACCESS')
    CASE 2753
        StrCopy(servicedesc, 'de-spot : de-spot')
    CASE 2754
        StrCopy(servicedesc, 'apollo-cc : APOLLO CC')
    CASE 2755
        StrCopy(servicedesc, 'expresspay : Express Pay')
    CASE 2756
        StrCopy(servicedesc, 'simplement-tie : simplement-tie')
    CASE 2757
        StrCopy(servicedesc, 'cnrp : CNRP')
    CASE 2758
        StrCopy(servicedesc, 'apollo-status : APOLLO Status')
    CASE 2759
        StrCopy(servicedesc, 'apollo-gms : APOLLO GMS')
    CASE 2760
        StrCopy(servicedesc, 'sabams : Saba MS')
    CASE 2761
        StrCopy(servicedesc, 'dicom-iscl : DICOM ISCL')
    CASE 2762
        StrCopy(servicedesc, 'dicom-tls : DICOM TLS')
    CASE 2763
        StrCopy(servicedesc, 'desktop-dna : Desktop DNA')
    CASE 2764
        StrCopy(servicedesc, 'data-insurance : Data Insurance')
    CASE 2765
        StrCopy(servicedesc, 'qip-audup : qip-audup')
    CASE 2766
        StrCopy(servicedesc, 'listen : System V Listener Port ; compaq-scp : Compaq SCP')
    CASE 2767
        StrCopy(servicedesc, 'uadtc : UADTC')
    CASE 2768
        StrCopy(servicedesc, 'uacs : UACS')
    CASE 2769
        StrCopy(servicedesc, 'singlept-mvs : Single Point MVS')
    CASE 2770
        StrCopy(servicedesc, 'veronica : Veronica')
    CASE 2771
        StrCopy(servicedesc, 'vergencecm : Vergence CM')
    CASE 2772
        StrCopy(servicedesc, 'auris : auris')
    CASE 2773
        StrCopy(servicedesc, 'pcbakcup1 : PC Backup')
    CASE 2774
        StrCopy(servicedesc, 'pcbakcup2 : PC Backup')
    CASE 2775
        StrCopy(servicedesc, 'smpp : SMMP')
    CASE 2776
        StrCopy(servicedesc, 'ridgeway1 : Ridgeway Systems & Software')
    CASE 2777
        StrCopy(servicedesc, 'ridgeway2 : Ridgeway Systems & Software')
    CASE 2778
        StrCopy(servicedesc, 'gwen-sonya : Gwen-Sonya')
    CASE 2779
        StrCopy(servicedesc, 'lbc-sync : LBC Sync')
    CASE 2780
        StrCopy(servicedesc, 'lbc-control : LBC Control')
    CASE 2781
        StrCopy(servicedesc, 'whosells : ResolveNet IOM whosells')
    CASE 2782
        StrCopy(servicedesc, 'everydayrc : everydayrc')
    CASE 2783
        StrCopy(servicedesc, 'aises : AISES')
    CASE 2784
        StrCopy(servicedesc, 'www-dev : world wide web - development')
    CASE 2785
        StrCopy(servicedesc, 'aic-np : aic-np')
    CASE 2786
        StrCopy(servicedesc, 'aic-oncrpc : aic-oncrpc - Destiny MCD database')
    CASE 2787
        StrCopy(servicedesc, 'piccolo : piccolo - Cornerstone Software')
    CASE 2788
        StrCopy(servicedesc, 'fryeserv : NetWare Loadable Module - Seagate Software')
    CASE 2789
        StrCopy(servicedesc, 'media-agent : Media Agent')
    CASE 2790
        StrCopy(servicedesc, 'plgproxy : PLG Proxy')
    CASE 2791
        StrCopy(servicedesc, 'mtport-regist : MT Port Registrator')
    CASE 2792
        StrCopy(servicedesc, 'f5-globalsite : f5-globalsite')
    CASE 2793
        StrCopy(servicedesc, 'initlsmsad : initlsmsad')
    CASE 2794
        StrCopy(servicedesc, 'aaftp : aaftp')
    CASE 2795
        StrCopy(servicedesc, 'livestats : LiveStats')
    CASE 2796
        StrCopy(servicedesc, 'ac-tech : ac-tech')
    CASE 2797
        StrCopy(servicedesc, 'esp-encap : esp-encap')
    CASE 2798
        StrCopy(servicedesc, 'tmesis-upshot : TMESIS-UPShot')
    CASE 2799
        StrCopy(servicedesc, 'icon-discover : ICON Discover')
    CASE 2800
        StrCopy(servicedesc, 'acc-raid : ACC RAID')
    CASE 2801
        StrCopy(servicedesc, 'igcp : IGCP ; \eb[TROJANS=Phineas Phucker]\en')
    CASE 2802
        StrCopy(servicedesc, 'veritas-tcp1 : Veritas TCP1')
    CASE 2803
        StrCopy(servicedesc, 'btprjctrl : btprjctrl')
    CASE 2804
        StrCopy(servicedesc, 'telexis-vtu : Telexis VTU')
    CASE 2805
        StrCopy(servicedesc, 'wta-wsp-s : WTA WSP-S')
    CASE 2806
        StrCopy(servicedesc, 'cspuni : cspuni')
    CASE 2807
        StrCopy(servicedesc, 'cspmulti : cspmulti')
    CASE 2808
        StrCopy(servicedesc, 'j-lan-p : J-LAN-P')
    CASE 2809
        StrCopy(servicedesc, 'corbaloc : CORBA LOC')
    CASE 2810
        StrCopy(servicedesc, 'netsteward : Active Net Steward')
    CASE 2811
        StrCopy(servicedesc, 'gsiftp : GSI FTP')
    CASE 2812
        StrCopy(servicedesc, 'atmtcp : atmtcp')
    CASE 2813
        StrCopy(servicedesc, 'llm-pass : llm-pass')
    CASE 2814
        StrCopy(servicedesc, 'llm-csv : llm-csv')
    CASE 2815
        StrCopy(servicedesc, 'lbc-measure : LBC Measurement')
    CASE 2816
        StrCopy(servicedesc, 'lbc-watchdog : LBC Watchdog')
    CASE 2817
        StrCopy(servicedesc, 'nmsigport : NMSig Port')
    CASE 2818
        StrCopy(servicedesc, 'rmlnk : rmlnk')
    CASE 2819
        StrCopy(servicedesc, 'fc-faultnotify : FC Fault Notification')
    CASE 2820
        StrCopy(servicedesc, 'univision : UniVision')
    CASE 2821
        StrCopy(servicedesc, 'vml-dms : vml_dms')
    CASE 2822
        StrCopy(servicedesc, 'ka0wuc : ka0wuc')
    CASE 2823
        StrCopy(servicedesc, 'cqg-netlan : CQG Net/LAN')
    CASE 2826
        StrCopy(servicedesc, 'slc-systemlog : slc systemlog')
    CASE 2827
        StrCopy(servicedesc, 'slc-ctrlrloops : slc ctrlrloops')
    CASE 2828
        StrCopy(servicedesc, 'itm-lm : ITM License Manager')
    CASE 2829
        StrCopy(servicedesc, 'silkp1 : silkp1')
    CASE 2830
        StrCopy(servicedesc, 'silkp2 : silkp2')
    CASE 2831
        StrCopy(servicedesc, 'silkp3 : silkp3')
    CASE 2832
        StrCopy(servicedesc, 'silkp4 : silkp4')
    CASE 2833
        StrCopy(servicedesc, 'glishd : glishd')
    CASE 2834
        StrCopy(servicedesc, 'evtp : EVTP')
    CASE 2835
        StrCopy(servicedesc, 'evtp-data : EVTP-DATA')
    CASE 2836
        StrCopy(servicedesc, 'catalyst : catalyst')
    CASE 2837
        StrCopy(servicedesc, 'repliweb : Repliweb')
    CASE 2838
        StrCopy(servicedesc, 'starbot : Starbot')
    CASE 2839
        StrCopy(servicedesc, 'nmsigport : NMSigPort')
    CASE 2840
        StrCopy(servicedesc, 'l3-exprt : l3-exprt')
    CASE 2841
        StrCopy(servicedesc, 'l3-ranger : l3-ranger')
    CASE 2842
        StrCopy(servicedesc, 'l3-hawk : l3-hawk')
    CASE 2843
        StrCopy(servicedesc, 'pdnet : PDnet')
    CASE 2844
        StrCopy(servicedesc, 'bpcp-poll : BPCP POLL')
    CASE 2845
        StrCopy(servicedesc, 'bpcp-trap : BPCP TRAP')
    CASE 2846
        StrCopy(servicedesc, 'aimpp-hello : AIMPP Hello')
    CASE 2847
        StrCopy(servicedesc, 'aimpp-port-req : AIMPP Port Req')
    CASE 2848
        StrCopy(servicedesc, 'amt-blc-port : AMT-BLC-PORT')
    CASE 2849
        StrCopy(servicedesc, 'fxp : FXP')
    CASE 2850
        StrCopy(servicedesc, 'metaconsole : MetaConsole')
    CASE 2851
        StrCopy(servicedesc, 'webemshttp : webemshttp')
    CASE 2852
        StrCopy(servicedesc, 'bears-01 : bears-01')
    CASE 2853
        StrCopy(servicedesc, 'ispipes : ISPipes')
    CASE 2854
        StrCopy(servicedesc, 'infomover : InfoMover')
    CASE 2856
        StrCopy(servicedesc, 'cesdinv : cesdinv')
    CASE 2857
        StrCopy(servicedesc, 'simctlp : SimCtIP')
    CASE 2858
        StrCopy(servicedesc, 'ecnp : ECNP')
    CASE 2859
        StrCopy(servicedesc, 'activememory : Active Memory')
    CASE 2860
        StrCopy(servicedesc, 'dialpad-voice1 : Dialpad Voice 1')
    CASE 2861
        StrCopy(servicedesc, 'dialpad-voice2 : Dialpad Voice 2')
    CASE 2862
        StrCopy(servicedesc, 'ttg-protocol : TTG Protocol')
    CASE 2863
        StrCopy(servicedesc, 'sonardata : Sonar Data')
    CASE 2864
        StrCopy(servicedesc, 'astromed-main : main 5001 cmd')
    CASE 2865
        StrCopy(servicedesc, 'pit-vpn : pit-vpn')
    CASE 2866
        StrCopy(servicedesc, 'lwlistener : lwlistener')
    CASE 2867
        StrCopy(servicedesc, 'esps-portal : esps-portal')
    CASE 2868
        StrCopy(servicedesc, 'npep-messaging : NPEP Messaging')
    CASE 2869
        StrCopy(servicedesc, 'icslap : ICSLAP')
    CASE 2870
        StrCopy(servicedesc, 'daishi : daishi')
    CASE 2871
        StrCopy(servicedesc, 'msi-selectplay : MSI Select Play')
    CASE 2872
        StrCopy(servicedesc, 'contract : CONTRACT')
    CASE 2873
        StrCopy(servicedesc, 'paspar2-zoomin : PASPAR2 ZoomIn')
    CASE 2874
        StrCopy(servicedesc, 'dxmessagebase1 : dxmessagebase1')
    CASE 2875
        StrCopy(servicedesc, 'dxmessagebase2 : dxmessagebase2')
    CASE 2876
        StrCopy(servicedesc, 'sps-tunnel : SPS Tunnel')
    CASE 2877
        StrCopy(servicedesc, 'bluelance : BLUELANCE')
    CASE 2878
        StrCopy(servicedesc, 'aap : AAP')
    CASE 2879
        StrCopy(servicedesc, 'ucentric-ds : ucentric-ds')
    CASE 2880
        StrCopy(servicedesc, 'synapse : synapse')
    CASE 2881
        StrCopy(servicedesc, 'ndsp : NDSP')
    CASE 2882
        StrCopy(servicedesc, 'ndtp : NDTP')
    CASE 2883
        StrCopy(servicedesc, 'ndnp : NDNP')
    CASE 2884
        StrCopy(servicedesc, 'flashmsg : Flash Msg')
    CASE 2885
        StrCopy(servicedesc, 'topflow : TopFlow')
    CASE 2886
        StrCopy(servicedesc, 'responselogic : RESPONSELOGIC')
    CASE 2887
        StrCopy(servicedesc, 'aironetddp : aironet')
    CASE 2888
        StrCopy(servicedesc, 'spcsdlobby : SPCSDLOBBY')
    CASE 2889
        StrCopy(servicedesc, 'rsom : RSOM')
    CASE 2890
        StrCopy(servicedesc, 'cspclmulti : CSPCLMULTI')
    CASE 2891
        StrCopy(servicedesc, 'cinegrfx-elmd : CINEGRFX-ELMD License Manager')
    CASE 2892
        StrCopy(servicedesc, 'snifferdata : SNIFFERDATA')
    CASE 2893
        StrCopy(servicedesc, 'vseconnector : VSECONNECTOR')
    CASE 2894
        StrCopy(servicedesc, 'abacus-remote : ABACUS-REMOTE')
    CASE 2895
        StrCopy(servicedesc, 'natuslink : NATUS LINK')
    CASE 2896
        StrCopy(servicedesc, 'ecovisiong6-1 : ECOVISIONG6-1')
    CASE 2897
        StrCopy(servicedesc, 'citrix-rtmp : Citrix RTMP')
    CASE 2898
        StrCopy(servicedesc, 'appliance-cfg : APPLIANCE-CFG')
    CASE 2899
        StrCopy(servicedesc, 'powergemplus : POWERGEMPLUS')
    CASE 2900
        StrCopy(servicedesc, 'quicksuite : QUICKSUITE')
    CASE 2901
        StrCopy(servicedesc, 'allstorcns : ALLSTORCNS')
    CASE 2902
        StrCopy(servicedesc, 'netaspi : NET ASPI')
    CASE 2903
        StrCopy(servicedesc, 'suitcase : SUITCASE')
    CASE 2904
        StrCopy(servicedesc, 'm2ua : M2UA')
    CASE 2905
        StrCopy(servicedesc, 'm3ua : M3UA')
    CASE 2906
        StrCopy(servicedesc, 'caller9 : CALLER9')
    CASE 2907
        StrCopy(servicedesc, 'webmethods-b2b : WEBMETHODS B2B')
    CASE 2908
        StrCopy(servicedesc, 'mao : mao')
    CASE 2909
        StrCopy(servicedesc, 'funk-dialout : Funk Dialout')
    CASE 2910
        StrCopy(servicedesc, 'tdaccess : TDAccess')
    CASE 2911
        StrCopy(servicedesc, 'blockade : Blockade')
    CASE 2912
        StrCopy(servicedesc, 'epicon : Epicon')
    CASE 2913
        StrCopy(servicedesc, 'boosterware : Booster Ware')
    CASE 2914
        StrCopy(servicedesc, 'gamelobby : Game Lobby')
    CASE 2915
        StrCopy(servicedesc, 'tksocket : TK Socket')
    CASE 2916
        StrCopy(servicedesc, 'elvin_server : Elvin Server')
    CASE 2917
        StrCopy(servicedesc, 'elvin_client : Elvin Client')
    CASE 2918
        StrCopy(servicedesc, 'kastenchasepad : Kasten Chase Pad')
    CASE 2919
        StrCopy(servicedesc, 'roboer : ROBOER')
    CASE 2920
        StrCopy(servicedesc, 'roboeda : ROBOEDA')
    CASE 2921
        StrCopy(servicedesc, 'cesdcdman : CESD Contents Delivery Management')
    CASE 2922
        StrCopy(servicedesc, 'cesdcdtrn : CESD Contents Delivery Data Transfer')
    CASE 2923
        StrCopy(servicedesc, 'wta-wsp-wtp-s : WTA-WSP-WTP-S')
    CASE 2924
        StrCopy(servicedesc, 'precise-vip : PRECISE-VIP')
    CASE 2926
        StrCopy(servicedesc, 'mobile-file-dl : MOBILE-FILE-DL')
    CASE 2927
        StrCopy(servicedesc, 'unimobilectrl : UNIMOBILECTRL')
    CASE 2928
        StrCopy(servicedesc, 'redstone-cpss : REDSTONE-CPSS')
    CASE 2929
        StrCopy(servicedesc, 'panja-webadmin : PANJA-WEBADMIN')
    CASE 2930
        StrCopy(servicedesc, 'panja-weblinx : PANJA-WEBLINX')
    CASE 2931
        StrCopy(servicedesc, 'circle-x : Circle-X')
    CASE 2932
        StrCopy(servicedesc, 'incp : INCP')
    CASE 2933
        StrCopy(servicedesc, '4-tieropmgw : 4-TIER OPM GW ')
    CASE 2934
        StrCopy(servicedesc, '4-tieropmcli : 4-TIER OPM CLI')
    CASE 2935
        StrCopy(servicedesc, 'qtp : QTP')
    CASE 2936
        StrCopy(servicedesc, 'otpatch : OTPatch')
    CASE 2937
        StrCopy(servicedesc, 'pnaconsult-lm : PNACONSULT-LM')
    CASE 2938
        StrCopy(servicedesc, 'sm-pas-1 : SM-PAS-1')
    CASE 2939
        StrCopy(servicedesc, 'sm-pas-2 : SM-PAS-2')
    CASE 2940
        StrCopy(servicedesc, 'sm-pas-3 : SM-PAS-3')
    CASE 2941
        StrCopy(servicedesc, 'sm-pas-4 : SM-PAS-4')
    CASE 2942
        StrCopy(servicedesc, 'sm-pas-5 : SM-PAS-5')
    CASE 2943
        StrCopy(servicedesc, 'ttnrepository : TTNRepository')
    CASE 2944
        StrCopy(servicedesc, 'megaco-h248 : Megaco H-248')
    CASE 2945
        StrCopy(servicedesc, 'h248-binary : H248 Binary')
    CASE 2946
        StrCopy(servicedesc, 'fjsvmpor : FJSVmpor')
    CASE 2947
        StrCopy(servicedesc, 'gpsd : GPSD')
    CASE 2948
        StrCopy(servicedesc, 'wap-push : WAP PUSH')
    CASE 2949
        StrCopy(servicedesc, 'wap-pushsecure : WAP PUSH SECURE')
    CASE 2950
        StrCopy(servicedesc, 'esip : ESIP')
    CASE 2951
        StrCopy(servicedesc, 'ottp : OTTP')
    CASE 2952
        StrCopy(servicedesc, 'mpfwsas : MPFWSAS')
    CASE 2953
        StrCopy(servicedesc, 'ovalarmsrv : OVALARMSRV')
    CASE 2954
        StrCopy(servicedesc, 'ovalarmsrv-cmd : OVALARMSRV-CMD')
    CASE 2955
        StrCopy(servicedesc, 'csnotify : CSNOTIFY')
    CASE 2956
        StrCopy(servicedesc, 'ovrimosdbman : OVRIMOSDBMAN')
    CASE 2957
        StrCopy(servicedesc, 'jmact5 : JAMCT5 ; AMarquee : AMarquee')
    CASE 2958
        StrCopy(servicedesc, 'jmact6 : JAMCT6')
    CASE 2959
        StrCopy(servicedesc, 'rmopagt : RMOPAGT')
    CASE 2960
        StrCopy(servicedesc, 'dfoxserver : DFOXSERVER')
    CASE 2961
        StrCopy(servicedesc, 'boldsoft-lm : BOLDSOFT-LM')
    CASE 2962
        StrCopy(servicedesc, 'iph-policy-cli : IPH-POLICY-CLI')
    CASE 2963
        StrCopy(servicedesc, 'iph-policy-adm : IPH-POLICY-ADM')
    CASE 2964
        StrCopy(servicedesc, 'bullant-srap : BULLANT SRAP')
    CASE 2965
        StrCopy(servicedesc, 'bullant-rap : BULLANT RAP')
    CASE 2966
        StrCopy(servicedesc, 'idp-infotrieve : IDP-INFOTRIEVE')
    CASE 2967
        StrCopy(servicedesc, 'ssc-agent : SSC-AGENT')
    CASE 2968
        StrCopy(servicedesc, 'enpp : ENPP')
    CASE 2969
        StrCopy(servicedesc, 'essp : ESSP')
    CASE 2970
        StrCopy(servicedesc, 'index-net : INDEX-NET')
    CASE 2971
        StrCopy(servicedesc, 'netclip : Net Clip')
    CASE 2972
        StrCopy(servicedesc, 'pmsm-webrctl : PMSM Webrctl')
    CASE 2973
        StrCopy(servicedesc, 'svnetworks : SV Networks')
    CASE 2974
        StrCopy(servicedesc, 'signal : Signal')
    CASE 2975
        StrCopy(servicedesc, 'fjmpcm : Fujitsu Configuration Management Service')
    CASE 2976
        StrCopy(servicedesc, 'cns-srv-port : CNS Server Port')
    CASE 2977
        StrCopy(servicedesc, 'ttc-etap-ns : TTCs Enterprise Test Access Protocol - NS')
    CASE 2978
        StrCopy(servicedesc, 'ttc-etap-ds : TTCs Enterprise Test Access Protocol - DS')
    CASE 2979
        StrCopy(servicedesc, 'h263-video : H.263 Video Streaming ')
    CASE 2980
        StrCopy(servicedesc, 'wimd : Instant Messaging Service')
    CASE 2981
        StrCopy(servicedesc, 'mylxamport : MYLXAMPORT')
    CASE 2982
        StrCopy(servicedesc, 'iwb-whiteboard : IWB-WHITEBOARD')
    CASE 2983
        StrCopy(servicedesc, 'netplan : NETPLAN')
    CASE 2984
        StrCopy(servicedesc, 'hpidsadmin : HPIDSADMIN')
    CASE 2985
        StrCopy(servicedesc, 'hpidsagent : HPIDSAGENT')
    CASE 2986
        StrCopy(servicedesc, 'stonefalls : STONEFALLS')
    CASE 2987
        StrCopy(servicedesc, 'identify : ResolveNet IOM IDENTIFY')
    CASE 2988
        StrCopy(servicedesc, 'classify : ResolveNet IOM CLASSIFY')
    CASE 2989
        StrCopy(servicedesc, 'zarkov : ZARKOV')
    CASE 2990
        StrCopy(servicedesc, 'boscap : BOSCAP')
    CASE 2991
        StrCopy(servicedesc, 'wkstn-mon : WKSTN-MON')
    CASE 2992
        StrCopy(servicedesc, 'itb301 : ITB301')
    CASE 2993
        StrCopy(servicedesc, 'veritas-vis1 : VERITAS VIS1')
    CASE 2994
        StrCopy(servicedesc, 'veritas-vis2 : VERITAS VIS2')
    CASE 2995
        StrCopy(servicedesc, 'idrs : IDRS')
    CASE 2996
        StrCopy(servicedesc, 'vsixml : vsixml')
    CASE 2997
        StrCopy(servicedesc, 'rebol : REBOL')
    CASE 2998
        StrCopy(servicedesc, 'realsecure : Real Secure Remote Console admin; afbackup : AFBackup System')
    CASE 2999
        StrCopy(servicedesc, 'remoteware-un : RemoteWare Unassigned')
    CASE 3000
        StrCopy(servicedesc, 'hbci : HBCI')
    CASE 3000
        StrCopy(servicedesc, 'remoteware-cl ppp : RemoteWare Client ; User Level PPP Daemon')
    CASE 3001
        StrCopy(servicedesc, 'redwood-broker nessusd : Redwood Broker ; Nessus Security Scanner')
    CASE 3002
        StrCopy(servicedesc, 'exlm-agent : EXLM Agent')
    CASE 3002
        StrCopy(servicedesc, 'remoteware-srv : RemoteWare Server')
    CASE 3003
        StrCopy(servicedesc, 'cgms : CGMS')
    CASE 3004
        StrCopy(servicedesc, 'csoftragent : Csoft Agent')
    CASE 3005
        StrCopy(servicedesc, 'geniuslm deslogin : Genius License Manager ; Encrypted Symmetric Login')
    CASE 3006
        StrCopy(servicedesc, 'ii-admin deslogind : Instant Internet Admin ; Encrypted Symmetic Login')
    CASE 3007
        StrCopy(servicedesc, 'lotusmtap : Lotus Mail Tracking Agent Protocol')
    CASE 3008
        StrCopy(servicedesc, 'midnight-tech : Midnight Technologies')
    CASE 3009
        StrCopy(servicedesc, 'pxc-ntfy : PXC-NTFY')
    CASE 3010
        StrCopy(servicedesc, 'gw : Telerate Workstation')
    CASE 3011
        StrCopy(servicedesc, 'trusted-web : Trusted Web')
    CASE 3012
        StrCopy(servicedesc, 'twsdss : Trusted Web Client')
    CASE 3013
        StrCopy(servicedesc, 'gilatskysurfer : Gilat Sky Surfer')
    CASE 3014
        StrCopy(servicedesc, 'broker_service : Broker Service')
    CASE 3015
        StrCopy(servicedesc, 'nati-dstp : NATI DSTP')
    CASE 3016
        StrCopy(servicedesc, 'notify_srvr : Notify Server')
    CASE 3017
        StrCopy(servicedesc, 'event_listener : Event Listener')
    CASE 3018
        StrCopy(servicedesc, 'srvc_registry : Service Registry')
    CASE 3019
        StrCopy(servicedesc, 'resource_mgr : Resource Manager')
    CASE 3020
        StrCopy(servicedesc, 'cifs : CIFS')
    CASE 3021
        StrCopy(servicedesc, 'agriserver : AGRI Server')
    CASE 3022
        StrCopy(servicedesc, 'csregagent : CSREGAGENT')
    CASE 3023
        StrCopy(servicedesc, 'magicnotes : magicnotes')
    CASE 3024
        StrCopy(servicedesc, 'nds_sso : NDS_SSO ; \eb[TROJANS=WinCrash]\en')
    CASE 3025
        StrCopy(servicedesc, 'arepa-raft : Arepa Raft ')
    CASE 3026
        StrCopy(servicedesc, 'agri-gateway : AGRI Gateway')
    CASE 3027
        StrCopy(servicedesc, 'LiebDevMgmt_C : LiebDevMgmt_C')
    CASE 3028
        StrCopy(servicedesc, 'LiebDevMgmt_DM : LiebDevMgmt_DM')
    CASE 3029
        StrCopy(servicedesc, 'LiebDevMgmt_A : LiebDevMgmt_A')
    CASE 3030
        StrCopy(servicedesc, 'arepa-cas : Arepa Cas')
    CASE 3031
        StrCopy(servicedesc, 'agentvu : AgentVU ')
    CASE 3032
        StrCopy(servicedesc, 'redwood-chat : Redwood Chat')
    CASE 3033
        StrCopy(servicedesc, 'pdb : PDB')
    CASE 3034
        StrCopy(servicedesc, 'osmosis-aeea : Osmosis AEEA')
    CASE 3035
        StrCopy(servicedesc, 'fjsv-gssagt : FJSV gssagt')
    CASE 3036
        StrCopy(servicedesc, 'hagel-dump : Hagel DUMP')
    CASE 3037
        StrCopy(servicedesc, 'hp-san-mgmt : HP SAN Mgmt')
    CASE 3038
        StrCopy(servicedesc, 'santak-ups : Santak UPS')
    CASE 3039
        StrCopy(servicedesc, 'cogitate : Cogitate, Inc.')
    CASE 3040
        StrCopy(servicedesc, 'tomato-springs : Tomato Springs')
    CASE 3041
        StrCopy(servicedesc, 'di-traceware : di-traceware')
    CASE 3042
        StrCopy(servicedesc, 'journee : journee')
    CASE 3043
        StrCopy(servicedesc, 'brp : BRP')
    CASE 3045
        StrCopy(servicedesc, 'responsenet : ResponseNet')
    CASE 3046
        StrCopy(servicedesc, 'di-ase : di-ase')
    CASE 3047
        StrCopy(servicedesc, 'hlserver : Fast Security HL Server')
    CASE 3048
        StrCopy(servicedesc, 'pctrader : Sierra Net PC Trader')
    CASE 3049
        StrCopy(servicedesc, 'nsws cfs : NSWS ; Cryptographic Filesystem')
    CASE 3050
        StrCopy(servicedesc, 'gds_db : gds_db')
    CASE 3051
        StrCopy(servicedesc, 'galaxy-server : Galaxy Server')
    CASE 3052
        StrCopy(servicedesc, 'apcpcns : APCPCNS')
    CASE 3053
        StrCopy(servicedesc, 'dsom-server : dsom-server')
    CASE 3054
        StrCopy(servicedesc, 'amt-cnf-prot : AMT CNF PROT')
    CASE 3055
        StrCopy(servicedesc, 'policyserver : Policy Server')
    CASE 3056
        StrCopy(servicedesc, 'cdl-server : CDL Server')
    CASE 3057
        StrCopy(servicedesc, 'goahead-fldup : GoAhead FldUp')
    CASE 3058
        StrCopy(servicedesc, 'videobeans : videobeans')
    CASE 3059
        StrCopy(servicedesc, 'qsoft : qsoft')
    CASE 3059
        StrCopy(servicedesc, 'qsoft : qsoft')
    CASE 3060
        StrCopy(servicedesc, 'interserver : interserver')
    CASE 3061
        StrCopy(servicedesc, 'cautcpd : cautcpd')
    CASE 3062
        StrCopy(servicedesc, 'ncacn-ip-tcp : ncacn-ip-tcp')
    CASE 3063
        StrCopy(servicedesc, 'ncadg-ip-udp : ncadg-ip-udp')
    CASE 3064
        StrCopy(servicedesc, 'distrib-net-proxy : Distributed.net Project Proxy')
    CASE 3065
        StrCopy(servicedesc, 'slinterbase : slinterbase')
    CASE 3066
        StrCopy(servicedesc, 'netattachsdmp : NETATTACHSDMP')
    CASE 3067
        StrCopy(servicedesc, 'fjhpjp : FJHPJP')
    CASE 3068
        StrCopy(servicedesc, 'ls3bcast : ls3 Broadcast')
    CASE 3069
        StrCopy(servicedesc, 'ls3 : ls3')
    CASE 3070
        StrCopy(servicedesc, 'mgxswitch : MGXSWITCH')
    CASE 3075
        StrCopy(servicedesc, 'orbix-locator : Orbix 2000 Locator')
    CASE 3076
        StrCopy(servicedesc, 'orbix-config : Orbix 2000 Config')
    CASE 3077
        StrCopy(servicedesc, 'orbix-loc-ssl : Orbix 2000 Locator SSL')
    CASE 3078
        StrCopy(servicedesc, 'orbix-cfg-ssl : Orbix 2000 Locator SSL')
    CASE 3079
        StrCopy(servicedesc, 'lv-frontpanel : LV Front Panel')
    CASE 3080
        StrCopy(servicedesc, 'stm_pproc : stm_pproc')
    CASE 3081
        StrCopy(servicedesc, 'tl1-lv : TL1-LV')
    CASE 3082
        StrCopy(servicedesc, 'tl1-raw : TL1-RAW')
    CASE 3083
        StrCopy(servicedesc, 'tl1-telnet : TL1-TELNET')
    CASE 3084
        StrCopy(servicedesc, 'itm-mccs : ITM-MCCS')
    CASE 3085
        StrCopy(servicedesc, 'pcihreq : PCIHReq')
    CASE 3086
        StrCopy(servicedesc, 'jdl-dbkitchen sj3 : JDL-DBKitchen ; SJ3 Kanji (japanese) input')
    CASE 3100
        StrCopy(servicedesc, 'opcon-xps : OpCon/xps')

    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC


EXPORT PROC service11(portserv:LONG)

SELECT portserv
    CASE 3105
        StrCopy(servicedesc, 'cardbox : Cardbox')
    CASE 3106
        StrCopy(servicedesc, 'cardbox-http : Cardbox HTTP')
    CASE 3128
        StrCopy(servicedesc, 'squid-http : Squid HTTP Proxy ; \eb[TROJANS=RingZero]\en')
    CASE 3129
        StrCopy(servicedesc, '\eb[TROJANS=Masters Paradise]\en')
    CASE 3130
        StrCopy(servicedesc, 'icp : Internet Cache Protocol ; icpv2 : Internet Cache Protocol (V2)')
    CASE 3131
        StrCopy(servicedesc, 'netbookmark : Net Book Mark')
    CASE 3141
        StrCopy(servicedesc, 'vmodem : VMODEM')
    CASE 3142
        StrCopy(servicedesc, 'rdc-wh-eos : RDC WH EOS')
    CASE 3143
        StrCopy(servicedesc, 'seaview : Sea View')
    CASE 3144
        StrCopy(servicedesc, 'tarantella : Tarantella')
    CASE 3145
        StrCopy(servicedesc, 'csi-lfap : CSI-LFAP')
    CASE 3147
        StrCopy(servicedesc, 'rfio : RFIO')
    CASE 3148
        StrCopy(servicedesc, 'nm-game-admin : NetMike Game Administrator')
    CASE 3149
        StrCopy(servicedesc, 'nm-game-server : NetMike Game Server')
    CASE 3150
        StrCopy(servicedesc, 'nm-asses-admin : NetMike Assessor Administrator ; \eb[TROJANS=Deep Throat, The Invasor]\en')
    CASE 3151
        StrCopy(servicedesc, 'nm-assessor : NetMike Assessor')
    CASE 3180
        StrCopy(servicedesc, 'mc-brk-srv : Millicent Broker Server')
    CASE 3181
        StrCopy(servicedesc, 'bmcpatrolagent : BMC Patrol Agent')
    CASE 3182
        StrCopy(servicedesc, 'bmcpatrolrnvu : BMC Patrol Rendezvous')
    CASE 3262
        StrCopy(servicedesc, 'necp : NECP')
    CASE 3264
        StrCopy(servicedesc, 'ccmail : cc:mail/lotus')
    CASE 3265
        StrCopy(servicedesc, 'altav-tunnel : Altav Tunnel')
    CASE 3266
        StrCopy(servicedesc, 'ns-cfg-server : NS CFG Server')
    CASE 3267
        StrCopy(servicedesc, 'ibm-dial-out : IBM Dial Out')
    CASE 3268
        StrCopy(servicedesc, 'msft-gc : Microsoft Global Catalog')
    CASE 3269
        StrCopy(servicedesc, 'msft-gc-ssl : Microsoft Global Catalog with LDAP/SSL')
    CASE 3270
        StrCopy(servicedesc, 'verismart : Verismart')
    CASE 3271
        StrCopy(servicedesc, 'csoft-prev : CSoft Prev Port')
    CASE 3272
        StrCopy(servicedesc, 'user-manager : Fujitsu User Manager')
    CASE 3273
        StrCopy(servicedesc, 'sxmp : Simple Extensible Multiplexed Protocol')
    CASE 3274
        StrCopy(servicedesc, 'ordinox-server : Ordinox Server')
    CASE 3275
        StrCopy(servicedesc, 'samd : SAMD')
    CASE 3276
        StrCopy(servicedesc, 'maxim-asics : Maxim ASICs')
    CASE 3277
        StrCopy(servicedesc, 'awg-proxy : AWG Proxy')
    CASE 3278
        StrCopy(servicedesc, 'lkcmserver : LKCM Server')
    CASE 3279
        StrCopy(servicedesc, 'admind : admind')
    CASE 3280
        StrCopy(servicedesc, 'vs-server : VS Server')
    CASE 3281
        StrCopy(servicedesc, 'sysopt : SYSOPT')
    CASE 3282
        StrCopy(servicedesc, 'datusorb : Datusorb')
    CASE 3283
        StrCopy(servicedesc, 'net-assistant : Net Assistant')
    CASE 3284
        StrCopy(servicedesc, '4talk : 4Talk')
    CASE 3285
        StrCopy(servicedesc, 'plato : Plato')
    CASE 3286
        StrCopy(servicedesc, 'e-net : E-Net')
    CASE 3287
        StrCopy(servicedesc, 'directvdata : DIRECTVDATA')
    CASE 3288
        StrCopy(servicedesc, 'cops : COPS')
    CASE 3289
        StrCopy(servicedesc, 'enpc : ENPC')
    CASE 3290
        StrCopy(servicedesc, 'caps-lm : CAPS LOGISTICS TOOLKIT - LM')
    CASE 3291
        StrCopy(servicedesc, 'sah-lm : S A Holditch & Associates - LM')
    CASE 3292
        StrCopy(servicedesc, 'cart-o-rama : Cart O Rama')
    CASE 3293
        StrCopy(servicedesc, 'fg-fps : fg-fps')
    CASE 3294
        StrCopy(servicedesc, 'fg-gip : fg-gip')
    CASE 3295
        StrCopy(servicedesc, 'dyniplookup : Dynamic IP Lookup')
    CASE 3296
        StrCopy(servicedesc, 'rib-slm : Rib License Manager')
    CASE 3297
        StrCopy(servicedesc, 'cytel-lm : Cytel License Manager')
    CASE 3298
        StrCopy(servicedesc, 'transview : Transview')
    CASE 3299
        StrCopy(servicedesc, 'pdrncs : pdrncs')
    CASE 3302
        StrCopy(servicedesc, 'mcs-fastmail : MCS Fastmail')
    CASE 3303
        StrCopy(servicedesc, 'opsession-clnt : OP Session Client')
    CASE 3304
        StrCopy(servicedesc, 'opsession-srvr : OP Session Server')
    CASE 3305
        StrCopy(servicedesc, 'odette-ftp : ODETTE-FTP')
    CASE 3306
        StrCopy(servicedesc, 'mysql : MySQL Database')
    CASE 3307
        StrCopy(servicedesc, 'opsession-prxy : OP Session Proxy')
    CASE 3308
        StrCopy(servicedesc, 'tns-server : TNS Server')
    CASE 3309
        StrCopy(servicedesc, 'tns-adv : TNS ADV')
    CASE 3310
        StrCopy(servicedesc, 'dyna-access : Dyna Access')
    CASE 3311
        StrCopy(servicedesc, 'mcns-tel-ret : MCNS Tel Ret')
    CASE 3312
        StrCopy(servicedesc, 'appman-server : Application Management Server')
    CASE 3313
        StrCopy(servicedesc, 'uorb : Unify Object Broker')
    CASE 3314
        StrCopy(servicedesc, 'uohost : Unify Object Host')
    CASE 3315
        StrCopy(servicedesc, 'cdid : CDID')
    CASE 3316
        StrCopy(servicedesc, 'aicc-cmi : AICC/CMI')
    CASE 3317
        StrCopy(servicedesc, 'vsaiport : VSAI PORT')
    CASE 3318
        StrCopy(servicedesc, 'ssrip : Swith to Swith Routing Information Protocol')
    CASE 3319
        StrCopy(servicedesc, 'sdt-lmd : SDT License Manager')
    CASE 3320
        StrCopy(servicedesc, 'officelink2000 : Office Link 2000')
    CASE 3321
        StrCopy(servicedesc, 'vnsstr : VNSSTR')
    CASE 3322
        StrCopy(servicedesc, 'active-net : Active Networks')
    CASE 3323
        StrCopy(servicedesc, 'active-net : Active Networks')
    CASE 3324
        StrCopy(servicedesc, 'active-net : Active Networks')
    CASE 3325
        StrCopy(servicedesc, 'active-net : Active Networks')
    CASE 3326
        StrCopy(servicedesc, 'sftu : SFTU')
    CASE 3327
        StrCopy(servicedesc, 'bbars : BBARS')
    CASE 3328
        StrCopy(servicedesc, 'egptlm : Eaglepoint License Manager')
    CASE 3329
        StrCopy(servicedesc, 'hp-device-disc : HP Device Disc')
    CASE 3330
        StrCopy(servicedesc, 'mcs-calypsoicf : MCS Calypso ICF')
    CASE 3331
        StrCopy(servicedesc, 'mcs-messaging : MCS Messaging')
    CASE 3332
        StrCopy(servicedesc, 'mcs-mailsvr : MCS Mail Server')
    CASE 3333
        StrCopy(servicedesc, 'dec-notes : DEC Notes')
    CASE 3334
        StrCopy(servicedesc, 'directv-web : Direct TV Webcasting')
    CASE 3335
        StrCopy(servicedesc, 'directv-soft : Direct TV Software Updates')
    CASE 3336
        StrCopy(servicedesc, 'directv-tick : Direct TV Tickers')
    CASE 3337
        StrCopy(servicedesc, 'directv-catlg : Direct TV Data Catalog')
    CASE 3338
        StrCopy(servicedesc, 'anet-b : OMF data b')
    CASE 3339
        StrCopy(servicedesc, 'anet-l : OMF data l')
    CASE 3340
        StrCopy(servicedesc, 'anet-m : OMF data m')
    CASE 3341
        StrCopy(servicedesc, 'anet-h : OMF data h')
    CASE 3342
        StrCopy(servicedesc, 'webtie : WebTIE')
    CASE 3343
        StrCopy(servicedesc, 'ms-cluster-net : MS Cluster Net')
    CASE 3344
        StrCopy(servicedesc, 'bnt-manager : BNT Manager')
    CASE 3345
        StrCopy(servicedesc, 'influence : Influence')
    CASE 3346
        StrCopy(servicedesc, 'trnsprntproxy : Trnsprnt Proxy')
    CASE 3347
        StrCopy(servicedesc, 'phoenix-rpc : Phoenix RPC')
    CASE 3348
        StrCopy(servicedesc, 'pangolin-laser : Pangolin Laser')
    CASE 3349
        StrCopy(servicedesc, 'chevinservices : Chevin Services')
    CASE 3350
        StrCopy(servicedesc, 'findviatv : FINDVIATV')
    CASE 3351
        StrCopy(servicedesc, 'btrieve : BTRIEVE')
    CASE 3352
        StrCopy(servicedesc, 'ssql : SSQL')
    CASE 3353
        StrCopy(servicedesc, 'fatpipe : FATPIPE')
    CASE 3354
        StrCopy(servicedesc, 'suitjd : SUITJD')
    CASE 3355
        StrCopy(servicedesc, 'ordinox-dbase : Ordinox Dbase')
    CASE 3356
        StrCopy(servicedesc, 'upnotifyps : UPNOTIFYPS')
    CASE 3357
        StrCopy(servicedesc, 'adtech-test : Adtech Test IP')
    CASE 3358
        StrCopy(servicedesc, 'mpsysrmsvr : Mp Sys Rmsvr')
    CASE 3359
        StrCopy(servicedesc, 'wg-netforce : WG NetForce')
    CASE 3360
        StrCopy(servicedesc, 'kv-server : KV Server')
    CASE 3361
        StrCopy(servicedesc, 'kv-agent : KV Agent ')
    CASE 3362
        StrCopy(servicedesc, 'dj-ilm : DJ ILM')
    CASE 3363
        StrCopy(servicedesc, 'nati-vi-server : NATI Vi Server')
    CASE 3364
        StrCopy(servicedesc, 'creativeserver : Creative Server')
    CASE 3365
        StrCopy(servicedesc, 'contentserver : Content Server')
    CASE 3366
        StrCopy(servicedesc, 'creativepartnr : Creative Partner')
    CASE 3367
        StrCopy(servicedesc, 'satvid-datalnk : Satellite Video Data Link')
    CASE 3368
        StrCopy(servicedesc, 'satvid-datalnk : Satellite Video Data Link')
    CASE 3369
        StrCopy(servicedesc, 'satvid-datalnk : Satellite Video Data Link')
    CASE 3370
        StrCopy(servicedesc, 'satvid-datalnk : Satellite Video Data Link')
    CASE 3371
        StrCopy(servicedesc, 'satvid-datalnk : Satellite Video Data Link')
    CASE 3372
        StrCopy(servicedesc, 'tip2 : TIP 2')
    CASE 3373
        StrCopy(servicedesc, 'lavenir-lm : Lavenir License Manager')
    CASE 3374
        StrCopy(servicedesc, 'cluster-disc : Cluster Disc')
    CASE 3375
        StrCopy(servicedesc, 'vsnm-agent : VSNM Agent')
    CASE 3376
        StrCopy(servicedesc, 'cdborker : CD Broker')
    CASE 3377
        StrCopy(servicedesc, 'cogsys-lm : Cogsys Network License Manager')
    CASE 3378
        StrCopy(servicedesc, 'wsicopy : WSICOPY')
    CASE 3379
        StrCopy(servicedesc, 'socorfs : SOCORFS')
    CASE 3380
        StrCopy(servicedesc, 'sns-channels : SNS Channels')
    CASE 3381
        StrCopy(servicedesc, 'geneous : Geneous')
    CASE 3382
        StrCopy(servicedesc, 'fujitsu-neat : Fujitsu Network Enhanced Antitheft function')
    CASE 3383
        StrCopy(servicedesc, 'esp-lm : Enterprise Software Products License Manager')
    CASE 3384
        StrCopy(servicedesc, 'hp-clic : Cluster Management Services')
    CASE 3385
        StrCopy(servicedesc, 'qnxnetman : qnxnetman')
    CASE 3386
        StrCopy(servicedesc, 'gprs-data : GPRS Data')
    CASE 3387
        StrCopy(servicedesc, 'backroomnet : Back Room Net')
    CASE 3388
        StrCopy(servicedesc, 'cbserver : CB Server')
    CASE 3389
        StrCopy(servicedesc, 'ms-wbt-server msrdp : MS WBT Server ; Microsoft Remote Display Protocol')
    CASE 3390
        StrCopy(servicedesc, 'dsc : Distributed Service Coordinator')
    CASE 3391
        StrCopy(servicedesc, 'savant : SAVANT')
    CASE 3392
        StrCopy(servicedesc, 'efi-lm : EFI License Management')
    CASE 3393
        StrCopy(servicedesc, 'd2k-tapestry1 : D2K Tapestry Client to Server')
    CASE 3394
        StrCopy(servicedesc, 'd2k-tapestry2 : D2K Tapestry Server to Server')
    CASE 3395
        StrCopy(servicedesc, 'dyna-lm : Dyna License Manager (Elam)')
    CASE 3396
        StrCopy(servicedesc, 'printer_agent : Printer Agent')
    CASE 3397
        StrCopy(servicedesc, 'cloanto-lm : Cloanto License Manager')
    CASE 3398
        StrCopy(servicedesc, 'mercantile : Mercantile')
    CASE 3399
        StrCopy(servicedesc, 'csms : CSMS')
    CASE 3400
        StrCopy(servicedesc, 'csms2 : CSMS2')
    CASE 3401
        StrCopy(servicedesc, 'filecast : filecast')
    CASE 3421
        StrCopy(servicedesc, 'bmap : Bull Apprise portmapper')
    CASE 3454
        StrCopy(servicedesc, 'mira : Apple Remote Access Protocol')
    CASE 3455
        StrCopy(servicedesc, 'prsvp : RSVP Port')
    CASE 3456
        StrCopy(servicedesc, 'vat : VAT default data')
    CASE 3457
        StrCopy(servicedesc, 'vat-control : VAT default control')
    CASE 3458
        StrCopy(servicedesc, 'd3winosfi : D3WinOsfi')
    CASE 3459
        StrCopy(servicedesc, 'integral : TIP Integral ; \eb[TROJANS=Eclipse 2000]\en')
    CASE 3460
        StrCopy(servicedesc, 'edm-manager : EDM Manger')
    CASE 3461
        StrCopy(servicedesc, 'edm-stager : EDM Stager')
    CASE 3462
        StrCopy(servicedesc, 'edm-std-notify track : EDM STD Notify ; Software Distribution')
    CASE 3463
        StrCopy(servicedesc, 'edm-adm-notify : EDM ADM Notify')
    CASE 3464
        StrCopy(servicedesc, 'edm-mgr-sync : EDM MGR Sync')
    CASE 3465
        StrCopy(servicedesc, 'edm-mgr-cntrl : EDM MGR Cntrl')
    CASE 3466
        StrCopy(servicedesc, 'workflow : WORKFLOW')
    CASE 3467
        StrCopy(servicedesc, 'rcst : RCST')
    CASE 3468
        StrCopy(servicedesc, 'ttcmremotectrl : TTCM Remote Controll')
    CASE 3469
        StrCopy(servicedesc, 'pluribus : Pluribus')
    CASE 3470
        StrCopy(servicedesc, 'jt400 : jt400')
    CASE 3471
        StrCopy(servicedesc, 'jt400-ssl : jt400-ssl')
    CASE 3535
        StrCopy(servicedesc, 'ms-la : MS-LA')
    CASE 3563
        StrCopy(servicedesc, 'watcomdebug : Watcom Debug')
    CASE 3672
        StrCopy(servicedesc, 'harlequinorb : harlequinorb')
    CASE 3700
        StrCopy(servicedesc, '\eb[TROJANS=Portal of Doom]\en')
    CASE 3791
        StrCopy(servicedesc, '\eb[TROJANS=Eclypse]\en')
    CASE 3802
        StrCopy(servicedesc, 'vhd : VHD')
    CASE 3845
        StrCopy(servicedesc, 'v-one-spp : V-ONE Single Port Proxy')
    CASE 3852
        StrCopy(servicedesc, 'sunscreen : SunScreen firewall web management')
    CASE 3862
        StrCopy(servicedesc, 'giga-pocket : GIGA-POCKET')
    CASE 3875
        StrCopy(servicedesc, 'pnbscada : PNBSCADA')
    CASE 3900
        StrCopy(servicedesc, 'udt_os : Unidata UDT OS')
    CASE 3984
        StrCopy(servicedesc, 'mapper-nodemgr : MAPPER network node manager')
    CASE 3985
        StrCopy(servicedesc, 'mapper-mapethd : MAPPER TCP/IP server')
    CASE 3986
        StrCopy(servicedesc, 'mapper-ws_ethd : MAPPER workstation server')
    CASE 3987
        StrCopy(servicedesc, 'centerline : Centerline')
    CASE 4000
        StrCopy(servicedesc, 'terabase : Terabase')
    CASE 4001
        StrCopy(servicedesc, 'newoak : NewOak')
    CASE 4002
        StrCopy(servicedesc, 'pxc-spvr-ft : pxc-spvr-ft')
    CASE 4003
        StrCopy(servicedesc, 'pxc-splr-ft : pxc-splr-ft')
    CASE 4004
        StrCopy(servicedesc, 'pxc-roid : pxc-roid')
    CASE 4005
        StrCopy(servicedesc, 'pxc-pin : pxc-pin')
    CASE 4006
        StrCopy(servicedesc, 'pxc-spvr : pxc-spvr')
    CASE 4007
        StrCopy(servicedesc, 'pxc-splr : pxc-splr')
    CASE 4008
        StrCopy(servicedesc, 'netcheque : NetCheque accounting ')
    CASE 4009
        StrCopy(servicedesc, 'chimera-hwm : Chimera HWM')
    CASE 4010
        StrCopy(servicedesc, 'samsung-unidex : Samsung Unidex')
    CASE 4011
        StrCopy(servicedesc, 'altserviceboot : Alternate Service Boot')
    CASE 4012
        StrCopy(servicedesc, 'pda-gate : PDA Gate')
    CASE 4013
        StrCopy(servicedesc, 'acl-manager : ACL Manager')
    CASE 4014
        StrCopy(servicedesc, 'taiclock : TAICLOCK')
    CASE 4015
        StrCopy(servicedesc, 'talarian-mcast1 : Talarian Mcast')
    CASE 4016
        StrCopy(servicedesc, 'talarian-mcast2 : Talarian Mcast')
    CASE 4017
        StrCopy(servicedesc, 'talarian-mcast3 : Talarian Mcast')
    CASE 4018
        StrCopy(servicedesc, 'talarian-mcast4 : Talarian Mcast')
    CASE 4019
        StrCopy(servicedesc, 'talarian-mcast5 : Talarian Mcast')
    CASE 4042
        StrCopy(servicedesc, 'ldxp : LDXP')
    CASE 4045
        StrCopy(servicedesc, 'lockd : NFS Lock daemon/manager')
    CASE 4092
        StrCopy(servicedesc, '\eb[TROJANS=WinCrash]\en')
    CASE 4096
        StrCopy(servicedesc, 'bre : BRE (Bridge Relay Element)')
    CASE 4097
        StrCopy(servicedesc, 'patrolview : Patrol View')
    CASE 4098
        StrCopy(servicedesc, 'drmsfsd : drmsfsd')
    CASE 4099
        StrCopy(servicedesc, 'dpcp : DPCP')
    CASE 4132
        StrCopy(servicedesc, 'nuts_dem : NUTS Daemon')
    CASE 4133
        StrCopy(servicedesc, 'nuts_bootp : NUTS Bootp Server')
    CASE 4134
        StrCopy(servicedesc, 'nifty-hmi : NIFTY-Serve HMI protocol')
    CASE 4141
        StrCopy(servicedesc, 'oirtgsvc : Workflow Server')
    CASE 4142
        StrCopy(servicedesc, 'oidocsvc : Document Server')
    CASE 4143
        StrCopy(servicedesc, 'oidsr : Document Replication')
    CASE 4144
        StrCopy(servicedesc, 'wincim : PC Windows Compuserve.com protocol')
    CASE 4160
        StrCopy(servicedesc, 'jini-discovery : Jini Discovery')
    CASE 4199
        StrCopy(servicedesc, 'eims-admin : EIMS ADMIN')
    CASE 4200
        StrCopy(servicedesc, 'vrml-multi-use : VRML Multi User Systems (Also ports 4201 to 4299')
    CASE 4300
        StrCopy(servicedesc, 'corelccam : Corel CCam')
    CASE 4321
        StrCopy(servicedesc, 'rwhois : Remote Who Is ; \eb[TROJANS=BoBo]\en')
    CASE 4333
        StrCopy(servicedesc, 'msql : Mini SQL Server')
    CASE 4343
        StrCopy(servicedesc, 'unicall : UNICALL')
    CASE 4344
        StrCopy(servicedesc, 'vinainstall : VinaInstall')
    CASE 4345
        StrCopy(servicedesc, 'm4-network-as : Macro 4 Network AS')
    CASE 4346
        StrCopy(servicedesc, 'elanlm : ELAN LM')
    CASE 4347
        StrCopy(servicedesc, 'lansurveyor : LAN Surveyor')
    CASE 4348
        StrCopy(servicedesc, 'itose : ITOSE')
    CASE 4349
        StrCopy(servicedesc, 'fsportmap : File System Port Map')
    CASE 4350
        StrCopy(servicedesc, 'net-device : Net Device')
    CASE 4351
        StrCopy(servicedesc, 'plcy-net-svcs : PLCY Net Services')
    CASE 4353
        StrCopy(servicedesc, 'f5-iquery : F5 iQuery ')
    CASE 4442
        StrCopy(servicedesc, 'saris : Saris')
    CASE 4443
        StrCopy(servicedesc, 'pharos : Pharos')
    CASE 4444
        StrCopy(servicedesc, 'krb524 nv-video : Kerberos 5 to 4 Ticket Xlator ; NV Video default')
    CASE 4445
        StrCopy(servicedesc, 'upnotifyp : UPNOTIFYP')
    CASE 4446
        StrCopy(servicedesc, 'n1-fwp : N1-FWP')
    CASE 4447
        StrCopy(servicedesc, 'n1-rmgmt : N1-RMGMT')
    CASE 4448
        StrCopy(servicedesc, 'asc-slmd : ASC Licence Manager')
    CASE 4449
        StrCopy(servicedesc, 'privatewire : PrivateWire')
    CASE 4450
        StrCopy(servicedesc, 'camp : Camp')
    CASE 4451
        StrCopy(servicedesc, 'ctisystemmsg : CTI System Msg')
    CASE 4452
        StrCopy(servicedesc, 'ctiprogramload : CTI Program Load')
    CASE 4453
        StrCopy(servicedesc, 'nssalertmgr : NSS Alert Manager')
    CASE 4454
        StrCopy(servicedesc, 'nssagentmgr : NSS Agent Manager')
    CASE 4455
        StrCopy(servicedesc, 'prchat-user : PR Chat User')
    CASE 4456
        StrCopy(servicedesc, 'prchat-server : PR Chat Server')
    CASE 4457
        StrCopy(servicedesc, 'prRegister : PR Register')
    CASE 4500
        StrCopy(servicedesc, 'sae-urn : sae-urn')
    CASE 4501
        StrCopy(servicedesc, 'urn-x-cdchoice : urn-x-cdchoice')
    CASE 4545
        StrCopy(servicedesc, 'worldscores : WorldScores')
    CASE 4546
        StrCopy(servicedesc, 'sf-lm : SF License Manager (Sentinel)')
    CASE 4547
        StrCopy(servicedesc, 'lanner-lm : Lanner License Manager')
    CASE 4557
        StrCopy(servicedesc, 'fax : FAX Transmission Service')
    CASE 4559
        StrCopy(servicedesc, 'hylafax : HylaFAX client-server protocol')
    CASE 4567
        StrCopy(servicedesc, 'tram : TRAM ; \eb[TROJANS=File Nail]\en')
    CASE 4568
        StrCopy(servicedesc, 'bmc-reporting : BMC Reporting ')
    CASE 4590
        StrCopy(servicedesc, '\eb[TROJANS=ICQTrojan]\en')
    CASE 4600
        StrCopy(servicedesc, 'piranha1 : Piranha1')
    CASE 4601
        StrCopy(servicedesc, 'piranha2 : Piranha2')
    CASE 4672
        StrCopy(servicedesc, 'rfa : remote file access server')
    CASE 4800
        StrCopy(servicedesc, 'iims : Icona Instant Messenging System')
    CASE 4801
        StrCopy(servicedesc, 'iwec : Icona Web Embedded Chat')
    CASE 4802
        StrCopy(servicedesc, 'ilss : Icona License System Server')
    CASE 4827
        StrCopy(servicedesc, 'htcp : HTCP')
    CASE 4837
        StrCopy(servicedesc, 'varadero-0 : Varadero-0')
    CASE 4838
        StrCopy(servicedesc, 'varadero-1 : Varadero-1')
    CASE 4868
        StrCopy(servicedesc, 'phrelay : Photon Relay')
    CASE 4869
        StrCopy(servicedesc, 'phrelaydbg : Photon Relay Debug')
    CASE 4885
        StrCopy(servicedesc, 'abbs : ABBS')
    CASE 4983
        StrCopy(servicedesc, 'att-intercom : AT&T Intercom')
    CASE 5000
        StrCopy(servicedesc, 'commplex-main : commplex-main ; \eb[Sockets de Troie, Bubbel, Back Door Setup, Socket23]\en ')
    CASE 5001
        StrCopy(servicedesc, 'commplex-link : commplex-link ; \eb[TROJANS=Sockets de Troie, Back Door Setup]\en ')
    CASE 5002
        StrCopy(servicedesc, 'rfe : Radio Free Ethernet')
    CASE 5003
        StrCopy(servicedesc, 'fmpro-internal : FileMaker, Inc. - Proprietary transport')
    CASE 5004
        StrCopy(servicedesc, 'avt-profile-1 : avt-profile-1')
    CASE 5005
        StrCopy(servicedesc, 'avt-profile-2 : avt-profile-2')
    CASE 5006
        StrCopy(servicedesc, 'wsm-server : wsm server')
    CASE 5007
        StrCopy(servicedesc, 'wsm-server-ssl : wsm server ssl')
    CASE 5010
        StrCopy(servicedesc, 'telelpathstart : TelepathStart')
    CASE 5011
        StrCopy(servicedesc, 'telelpathattack : TelepathAttack ; \eb[TROJANS=One of the Last Trojans (OOTLT)]\en')
    CASE 5020
        StrCopy(servicedesc, 'zenginkyo-1 : zenginkyo-1')
    CASE 5021
        StrCopy(servicedesc, 'zenginkyo-2 : zenginkyo-2')
    CASE 5031
        StrCopy(servicedesc, '\eb[TROJANS=NetMetro]\en')
    CASE 5042
        StrCopy(servicedesc, 'asnaacceler8db : asnaacceler8db')
    CASE 5050
        StrCopy(servicedesc, 'mmcc : multimedia conference control tool')
    CASE 5051
        StrCopy(servicedesc, 'ita-agent : ITA Agent')
    CASE 5052
        StrCopy(servicedesc, 'ita-manager : ITA Manager')
    CASE 5055
        StrCopy(servicedesc, 'unot : UNOT')
    CASE 5056
        StrCopy(servicedesc, 'intecom-ps1 : Intecom PS 1')
    CASE 5057
        StrCopy(servicedesc, 'intecom-ps2 : Intecom PS 2')
    CASE 5060
        StrCopy(servicedesc, 'sip : SIP')
    CASE 5061
        StrCopy(servicedesc, 'sip-tls : SIP-TLS')
    CASE 5066
        StrCopy(servicedesc, 'stanag-5066 : STANAG-5066-SUBNET-INTF')
    CASE 5069
        StrCopy(servicedesc, 'i-net-2000-npr : I/Net 2000-NPR')
    CASE 5071
        StrCopy(servicedesc, 'powerschool : PowerSchool')
    CASE 5093
        StrCopy(servicedesc, 'sentinel-lm : Sentinel LM')
    CASE 5099
        StrCopy(servicedesc, 'sentlm-srv2srv : SentLM Srv2Srv')
    CASE 5130
        StrCopy(servicedesc, 'sgi-dogfight : Silicon Graphics Dog Fight Game')
    CASE 5131
        StrCopy(servicedesc, 'sgi-arena : Silicon Graphics Arena')
    CASE 5133
        StrCopy(servicedesc, 'sgi-bznet : Silicon Graphocs port of BZ Demo')
    CASE 5135
        StrCopy(servicedesc, 'sgi-objectserver : Silicon Graphics Object Server')
    CASE 5136
        StrCopy(servicedesc, 'sgi-directoryserver : Silicon Graphics Directory Server')
    CASE 5137
        StrCopy(servicedesc, 'sgi-oortnet : Oort Port')
    CASE 5138
        StrCopy(servicedesc, 'sgi-vroom-server : Silicon Graphics Vroom Server')
    CASE 5139
        StrCopy(servicedesc, 'sgi-vroom-client : Silicon Graphics Vroom Client')
    CASE 5140
        StrCopy(servicedesc, 'sgi-mekton0 : Mekton Port')
    CASE 5141
        StrCopy(servicedesc, 'sgi-mekton1 : Mekton Port')
    CASE 5142
        StrCopy(servicedesc, 'sgi-mekton2 : Mekton Port')
    CASE 5143
        StrCopy(servicedesc, 'sgi-mekton3 : Mekton Port')
    CASE 5144
        StrCopy(servicedesc, 'sgi-mekton4 : Mekton Port')
    CASE 5145
        StrCopy(servicedesc, 'rmonitor_secure : RMONITOR SECURE ; sgi-mekton5 : Mekton Port')
    CASE 5146
        StrCopy(servicedesc, 'sgi-mekton6 : Mekton Port')
    CASE 5147
        StrCopy(servicedesc, 'sgi-mekton7 : Mekton Port')
    CASE 5150
        StrCopy(servicedesc, 'atmp : Ascend Tunnel Management Protocol ; sgi-pointblank : Silicon Graphics Pointblank')
    CASE 5151
        StrCopy(servicedesc, 'esri_sde : ESRI SDE Instance')
    CASE 5152
        StrCopy(servicedesc, 'sde-discovery : ESRI SDE Instance Discovery')
    CASE 5165
        StrCopy(servicedesc, 'ife_icorp : ife_1corp')
    CASE 5190
        StrCopy(servicedesc, 'aol : America-Online')
    CASE 5191
        StrCopy(servicedesc, 'aol-1 : AmericaOnline1')
    CASE 5192
        StrCopy(servicedesc, 'aol-2 : AmericaOnline2')
    CASE 5193
        StrCopy(servicedesc, 'aol-3 : AmericaOnline3')
    CASE 5200
        StrCopy(servicedesc, 'targus-getdata : TARGUS GetData ')
    CASE 5201
        StrCopy(servicedesc, 'targus-getdata1 : TARGUS GetData 1')
    CASE 5202
        StrCopy(servicedesc, 'targus-getdata2 : TARGUS GetData 2')
    CASE 5203
        StrCopy(servicedesc, 'targus-getdata3 : TARGUS GetData 3 ')
    CASE 5232
        StrCopy(servicedesc, 'sgi-dgl : Silicon Graphics Inc. Distributed Graphics')
    CASE 5236
        StrCopy(servicedesc, 'padl2sim : padl2sim ')
    CASE 5272
        StrCopy(servicedesc, 'pk : PK')
    CASE 5300
        StrCopy(servicedesc, 'hacl-hb : # HA cluster heartbeat')
    CASE 5301
        StrCopy(servicedesc, 'hacl-gs : # HA cluster general services')
    CASE 5302
        StrCopy(servicedesc, 'hacl-cfg : # HA cluster configuration')
    CASE 5303
        StrCopy(servicedesc, 'hacl-probe : # HA cluster probing')
    CASE 5304
        StrCopy(servicedesc, 'hacl-local : # HA Cluster Commands')
    CASE 5305
        StrCopy(servicedesc, 'hacl-test : # HA Cluster Test')
    CASE 5306
        StrCopy(servicedesc, 'sun-mc-grp : Sun MC Group')
    CASE 5307
        StrCopy(servicedesc, 'sco-aip : SCO AIP')
    CASE 5308
        StrCopy(servicedesc, 'cfengine : CFengine')
    CASE 5309
        StrCopy(servicedesc, 'jprinter : J Printer')
    CASE 5310
        StrCopy(servicedesc, 'outlaws : Outlaws')
    CASE 5311
        StrCopy(servicedesc, 'tmlogin : TM Login')
    CASE 5314
        StrCopy(servicedesc, 'opalis-rbt-ipc : opalis-rbt-ipc')
    CASE 5321
        StrCopy(servicedesc, '\eb[TROJANS=Firehotcker]\en')
    CASE 5354
        StrCopy(servicedesc, 'noclog : noclog (nocol)')
    CASE 5355
        StrCopy(servicedesc, 'hostmon : Hostmon')
    CASE 5400
        StrCopy(servicedesc, 'excerpt pcduo-old : Excerpt Search ; RemCon PC Duo - old port ; \eb[TROJANS=Blade Runner, BackContruction 1.2]\en')
    CASE 5401
        StrCopy(servicedesc, 'excerpts : Excerpt Search Secure ; \eb[TROJANS=Blade Runner]\en')
    CASE 5402
        StrCopy(servicedesc, 'mftp : MFTP')
    CASE 5403
        StrCopy(servicedesc, 'hpoms-ci-lstn : HPOMS-CI-LSTN')
    CASE 5404
        StrCopy(servicedesc, 'hpoms-dps-lstn : HPOMS-DPS-LSTN')
    CASE 5405
        StrCopy(servicedesc, 'netsupport pcduo : NetSupport ; RemCon PC Duo - new port')
    CASE 5406
        StrCopy(servicedesc, 'systemics-sox : Systemics Sox')
    CASE 5407
        StrCopy(servicedesc, 'foresyte-clear : Foresyte-Clear')
    CASE 5408
        StrCopy(servicedesc, 'foresyte-sec : Foresyte-Sec')
    CASE 5409
        StrCopy(servicedesc, 'salient-dtasrv : Salient Data Server')
    CASE 5410
        StrCopy(servicedesc, 'salient-usrmgr : Salient User Manager')
    CASE 5411
        StrCopy(servicedesc, 'actnet : ActNet')
    CASE 5412
        StrCopy(servicedesc, 'continuus : Continuus')
    CASE 5413
        StrCopy(servicedesc, 'wwiotalk : WWIOTALK')
    CASE 5414
        StrCopy(servicedesc, 'statusd : StatusD')
    CASE 5415
        StrCopy(servicedesc, 'ns-server : NS Server')
    CASE 5416
        StrCopy(servicedesc, 'sns-gateway : SNS Gateway')
    CASE 5417
        StrCopy(servicedesc, 'sns-agent : SNS Agent')
    CASE 5418
        StrCopy(servicedesc, 'mcntp : MCNTP')
    CASE 5419
        StrCopy(servicedesc, 'dj-ice : DJ-ICE')
    CASE 5420
        StrCopy(servicedesc, 'cylink-c : Cylink-C')
    CASE 5421
        StrCopy(servicedesc, 'netsupport2 : Net Support 2')
    CASE 5422
        StrCopy(servicedesc, 'salient-mux : Salient MUX')
    CASE 5423
        StrCopy(servicedesc, 'virtualuser : VIRTUALUSER')
    CASE 5426
        StrCopy(servicedesc, 'devbasic : DEVBASIC')
    CASE 5427
        StrCopy(servicedesc, 'sco-peer-tta : SCO-PEER-TTA')
    CASE 5428
        StrCopy(servicedesc, 'telaconsole : TELACONSOLE')
    CASE 5429
        StrCopy(servicedesc, 'base : Billing and Accounting System Exchange')
    CASE 5430
        StrCopy(servicedesc, 'radec-corp : RADEC CORP')
    CASE 5431
        StrCopy(servicedesc, 'park-agent : PARK AGENT')
    CASE 5432
        StrCopy(servicedesc, 'postgres : Postgres Database Server')
    CASE 5434
        StrCopy(servicedesc, 'sgi-arrayd : Silicon Graphics Array Services Daemon')
    CASE 5435
        StrCopy(servicedesc, 'dttl : Data Tunneling Transceiver Linking (DTTL)')
    CASE 5454
        StrCopy(servicedesc, 'apc-tcp-udp-4 : apc-tcp-udp-4')
    CASE 5455
        StrCopy(servicedesc, 'apc-tcp-udp-5 : apc-tcp-udp-5')
    CASE 5456
        StrCopy(servicedesc, 'apc-tcp-udp-6 : apc-tcp-udp-6')
    CASE 5461
        StrCopy(servicedesc, 'silkmeter : SILKMETER')
    CASE 5462
        StrCopy(servicedesc, 'ttl-publisher : TTL Publisher')
    CASE 5465
        StrCopy(servicedesc, 'netops-broker : NETOPS-BROKER')
    CASE 5500
        StrCopy(servicedesc, 'fcp-addr-srvr1 securid : fcp-addr-srvr1 ; SecurID')
    CASE 5501
        StrCopy(servicedesc, 'fcp-addr-srvr2 : fcp-addr-srvr2')
    CASE 5502
        StrCopy(servicedesc, 'fcp-srvr-inst1 : fcp-srvr-inst1')
    CASE 5503
        StrCopy(servicedesc, 'fcp-srvr-inst2 : fcp-srvr-inst2')
    CASE 5504
        StrCopy(servicedesc, 'fcp-cics-gw1 : fcp-cics-gw1')
    CASE 5510
        StrCopy(servicedesc, 'secureidprop : ACE Server')
    CASE 5512
        StrCopy(servicedesc, '\eb[TROJANS=Illusion Mailer]\en')
    CASE 5520
        StrCopy(servicedesc, 'sdlog : ACE Server')
    CASE 5530
        StrCopy(servicedesc, 'sdserv : ACE Server')
    CASE 5540
        StrCopy(servicedesc, 'sdreport : ACE Server')
    CASE 5550
        StrCopy(servicedesc, 'sdadmind : ACE Server ; \eb[TROJANS=Xtcp]\en')
    CASE 5554
        StrCopy(servicedesc, 'sgi-esphttp : SGI ESP HTTP')
    CASE 5555
        StrCopy(servicedesc, 'personal-agent rplay : Personal Agent ; sbm-comm : Space Boulders Game ; \eb[TROJANS=ServeMe]\en')
    CASE 5556
        StrCopy(servicedesc, '\eb[TROJANS=BO Facil]\en')
    CASE 5557
        StrCopy(servicedesc, '\eb[TROJANS=BO Facil]\en')
    CASE 5566
        StrCopy(servicedesc, 'udpplus : UDPPlus')
    CASE 5569
        StrCopy(servicedesc, '\eb[TROJANS=RoboHack]\en')
    CASE 5599
        StrCopy(servicedesc, 'esinstall : Enterprise Security Remote Install')
    CASE 5600
        StrCopy(servicedesc, 'esmmanager : Enterprise Security Manager')
    CASE 5601
        StrCopy(servicedesc, 'esmagent : Enterprise Security Agent')
    CASE 5602
        StrCopy(servicedesc, 'a1-msc : A1-MSC')
    CASE 5603
        StrCopy(servicedesc, 'a1-bs : A1-BS')
    CASE 5604
        StrCopy(servicedesc, 'a3-sdunode : A3-SDUNode')
    CASE 5605
        StrCopy(servicedesc, 'a4-sdunode : A4-SDUNode')
    CASE 5631
        StrCopy(servicedesc, 'pcanywheredata : PC Anywhere Remote Control (data)')
    CASE 5632
        StrCopy(servicedesc, 'pcanywherestat : PC Anywhere Remote Control (stat)')
    CASE 5678
        StrCopy(servicedesc, 'rrac : Remote Replication Agent Connection')
    CASE 5679
        StrCopy(servicedesc, 'dccm : Direct Cable Connect Manager')
    CASE 5680
        StrCopy(servicedesc, 'canna : Canna (japanese) input')
    CASE 5713
        StrCopy(servicedesc, 'proshareaudio : proshare conf audio')
    CASE 5714
        StrCopy(servicedesc, 'prosharevideo : proshare conf video')
    CASE 5715
        StrCopy(servicedesc, 'prosharedata : proshare conf data')
    CASE 5716
        StrCopy(servicedesc, 'prosharerequest : proshare conf request')
    CASE 5717
        StrCopy(servicedesc, 'prosharenotify : proshare conf notify')
    CASE 5729
        StrCopy(servicedesc, 'openmail : Openmail User Agent Layer')
    CASE 5741
        StrCopy(servicedesc, 'ida-discover1 : IDA Discover Port 1')
    CASE 5742
        StrCopy(servicedesc, 'ida-discover2 : IDA Discover Port 2 ; \eb[TROJANS=WinCrash]\en')
    CASE 5745
        StrCopy(servicedesc, 'fcopy-server : fcopy-server')
    CASE 5746
        StrCopy(servicedesc, 'fcopys-server : fcopys-server')
    CASE 5755
        StrCopy(servicedesc, 'openmailg : OpenMail Desk Gateway server')
    CASE 5757
        StrCopy(servicedesc, 'x500ms : OpenMail X.500 Directory Server')
    CASE 5766
        StrCopy(servicedesc, 'openmailns : OpenMail NewMail Server')
    CASE 5767
        StrCopy(servicedesc, 's-openmail : OpenMail Suer Agent Layer (Secure)')
    CASE 5768
        StrCopy(servicedesc, 'openmailpxy : OpenMail CMTS Server')
    CASE 5771
        StrCopy(servicedesc, 'netagent : NetAgent')
    CASE 5800
        StrCopy(servicedesc, 'vnc : VNC Remote Desktop Viewer')
    CASE 5801
        StrCopy(servicedesc, 'vnc : VNC Remote Desktop Viewer')
    CASE 5813
        StrCopy(servicedesc, 'icmpd : ICMPD')
    CASE 5859
        StrCopy(servicedesc, 'wherehoo : WHEREHOO')
    CASE 5900
        StrCopy(servicedesc, 'vnc : VNC (Remote Desktop Viewer)')
    CASE 5901
        StrCopy(servicedesc, 'vnc-1 : VNC Remote Desktop Viewer - Display 1')
    CASE 5902
        StrCopy(servicedesc, 'vnc-2 : VNC Remote Desktop Viewer - Display 2')
    CASE 5968
        StrCopy(servicedesc, 'mppolicy-v5 : mppolicy-v5')
    CASE 5969
        StrCopy(servicedesc, 'mppolicy-mgr : mppolicy-mgr')
    CASE 5977
        StrCopy(servicedesc, 'ncd-pref-tcp : NCD Preferences TCP port')
    CASE 5978
        StrCopy(servicedesc, 'ncd-diag-tcp : NCD Diagnostic TCP port')
    CASE 5979
        StrCopy(servicedesc, 'ncd-conf-rcp : NCD Configuration TCP port')
    CASE 5997
        StrCopy(servicedesc, 'ncd-pref : NCD Preferences telnet port')
    CASE 5998
        StrCopy(servicedesc, 'ncd-diag : NCD Diagnostic telnet port')
    CASE 5999
        StrCopy(servicedesc, 'cvsup ncd-conf : CVSup ; NCD Configuration telnet port')
    CASE 6000
        StrCopy(servicedesc, 'x11 : X Window System (Also ports 6001-6063)')
    CASE 6001
        StrCopy(servicedesc, 'x11:1 : X Window System (Also ports 6001-6063)')
    CASE 6002
        StrCopy(servicedesc, 'x11:2 : X Window System (Also ports 6001-6063)')
    CASE 6003
        StrCopy(servicedesc, 'x11:3 : X Window System (Also ports 6001-6063)')
    CASE 6004
        StrCopy(servicedesc, 'x11:4 : X Window System (Also ports 6001-6063)')
    CASE 6005
        StrCopy(servicedesc, 'x11:5 : X Window System (Also ports 6001-6063)')
    CASE 6006
        StrCopy(servicedesc, 'x11:6 : X Window System (Also ports 6001-6063)')
    CASE 6007
        StrCopy(servicedesc, 'x11:7 : X Window System (Also ports 6001-6063)')
    CASE 6008
        StrCopy(servicedesc, 'x11:8 : X Window System (Also ports 6001-6063)')
    CASE 6009
        StrCopy(servicedesc, 'x11:9 : X Window System (Also ports 6001-6063)')
    CASE 6050
        StrCopy(servicedesc, 'arcserver : ARCServe Backup Agent (possibly also X Window System)')
    CASE 6064
        StrCopy(servicedesc, 'ndl-ahp-svc : NDL-AHP-SVC')
    CASE 6065
        StrCopy(servicedesc, 'winpharaoh : WinPharaoh')
    CASE 6066
        StrCopy(servicedesc, 'ewctsp : EWCTSP')
    CASE 6067
        StrCopy(servicedesc, 'srb : SRB')
    CASE 6068
        StrCopy(servicedesc, 'gsmp : GSMP')
    CASE 6069
        StrCopy(servicedesc, 'trip : TRIP')
    CASE 6070
        StrCopy(servicedesc, 'messageasap : Messageasap')
    CASE 6071
        StrCopy(servicedesc, 'ssdtp : SSDTP')
    CASE 6072
        StrCopy(servicedesc, 'diagnose-proc : DIAGNOSE-PROC')
    CASE 6073
        StrCopy(servicedesc, 'directplay8 : DirectPlay8')
    CASE 6100
        StrCopy(servicedesc, 'synchronet-db : SynchroNet-db')
    CASE 6101
        StrCopy(servicedesc, 'synchronet-rtc : SynchroNet-rtc')
    CASE 6102
        StrCopy(servicedesc, 'synchronet-upd : SynchroNet-upd')
    CASE 6103
        StrCopy(servicedesc, 'rets : RETS')
    CASE 6104
        StrCopy(servicedesc, 'dbdb : DBDB')
    CASE 6105
        StrCopy(servicedesc, 'primaserver isdninfo : Prima Server ; ISDN Info')
    CASE 6106
        StrCopy(servicedesc, 'mpsserver : MPS Server')
    CASE 6107
        StrCopy(servicedesc, 'etc-control : ETC Control')
    CASE 6108
        StrCopy(servicedesc, 'sercomm-scadmin : Sercomm-SCAdmin')
    CASE 6109
        StrCopy(servicedesc, 'globecast-id : GLOBECAST-ID')
    CASE 6110
        StrCopy(servicedesc, 'softcm : HP SoftBench CM')
    CASE 6111
        StrCopy(servicedesc, 'spc : HP SoftBench Sub-Process Control')
    CASE 6112
        StrCopy(servicedesc, 'dtspcd : Common Desktop Environment subprocess control')
    CASE 6123
        StrCopy(servicedesc, 'backup-express : Backup Express')
    CASE 6141
        StrCopy(servicedesc, 'meta-corp : Meta Corporation License Manager')
    CASE 6142
        StrCopy(servicedesc, 'aspentec-lm : Aspen Technology License Manager')
    CASE 6143
        StrCopy(servicedesc, 'watershed-lm : Watershed License Manager')
    CASE 6144
        StrCopy(servicedesc, 'statsci1-lm : StatSci License Manager - 1')
    CASE 6145
        StrCopy(servicedesc, 'statsci2-lm : StatSci License Manager - 2')
    CASE 6146
        StrCopy(servicedesc, 'lonewolf-lm : Lone Wolf Systems License Manager')
    CASE 6147
        StrCopy(servicedesc, 'montage-lm : Montage License Manager')
    CASE 6148
        StrCopy(servicedesc, 'ricardo-lm : Ricardo North America License Manager')
    CASE 6149
        StrCopy(servicedesc, 'tal-pod : tal-pod ')
    CASE 6253
        StrCopy(servicedesc, 'crip : CRIP')
    CASE 6300
        StrCopy(servicedesc, 'bmc-grx : BMC GRX')
    CASE 6318
        StrCopy(servicedesc, 'dynamite : !Dynamite Game Server')
    CASE 6321
        StrCopy(servicedesc, 'emp-server1 : Empress Software Connectivity Server 1')
    CASE 6322
        StrCopy(servicedesc, 'emp-server2 : Empress Software Connectivity Server 2')
    CASE 6346
        StrCopy(servicedesc, 'gnutella-svc : gnutella-svc')
    CASE 6347
        StrCopy(servicedesc, 'gnutella-rtr : gnutella-rtr')
    CASE 6389
        StrCopy(servicedesc, 'clariion-evr01 : clariion-evr01')
    CASE 6400
        StrCopy(servicedesc, 'info-aps : info-aps ; \eb[TROJANS=The Thing]\en')
    CASE 6401
        StrCopy(servicedesc, 'info-was : info-was')
    CASE 6402
        StrCopy(servicedesc, 'info-eventsvr : info-eventsvr')
    CASE 6403
        StrCopy(servicedesc, 'info-cachesvr : info-cachesvr')
    CASE 6404
        StrCopy(servicedesc, 'info-filesvr : info-filesvr')
    CASE 6405
        StrCopy(servicedesc, 'info-pagesvr : info-pagesvr')
    CASE 6406
        StrCopy(servicedesc, 'info-processvr : info-processvr')
    CASE 6455
        StrCopy(servicedesc, 'skip-cert-recv : SKIP Certificate Receive')
    CASE 6456
        StrCopy(servicedesc, 'skip-cert-send : SKIP Certificate Send')
    CASE 6471
        StrCopy(servicedesc, 'lvision-lm : LVision License Manager')
    CASE 6500
        StrCopy(servicedesc, 'boks : BoKS Master')
    CASE 6501
        StrCopy(servicedesc, 'boks_servc : BoKS Servc')
    CASE 6502
        StrCopy(servicedesc, 'boks_servm netop-rc : BoKS Servm ; NetOP Remote Control')
    CASE 6503
        StrCopy(servicedesc, 'boks_clntd : BoKS Clntd')
    CASE 6505
        StrCopy(servicedesc, 'badm_priv : BoKS Admin Private Port')
    CASE 6506
        StrCopy(servicedesc, 'badm_pub : BoKS Admin Public Port')
    CASE 6507
        StrCopy(servicedesc, 'bdir_priv : BoKS Dir Server, Private Port')
    CASE 6508
        StrCopy(servicedesc, 'bdir_pub : BoKS Dir Server, Public Port')
    CASE 6547
        StrCopy(servicedesc, 'apc-tcp-udp-1 : apc-tcp-udp-1')
    CASE 6548
        StrCopy(servicedesc, 'apc-tcp-udp-2 : apc-tcp-udp-2')
    CASE 6549
        StrCopy(servicedesc, 'apc-tcp-udp-3 : apc-tcp-udp-3')
    CASE 6550
        StrCopy(servicedesc, 'fg-sysupdate : fg-sysupdate')
    CASE 6558
        StrCopy(servicedesc, 'xdsxdm : fg-sysupdate')
    CASE 6665
        StrCopy(servicedesc, 'ircu : IRCU')
    CASE 6666
        StrCopy(servicedesc, 'irc-serv : Internet Relay Chat Server')
    CASE 6667
        StrCopy(servicedesc, 'irc : Internet Relay Chat')
    CASE 6668
        StrCopy(servicedesc, 'irc : Internet Relay Chat')
    CASE 6669
        StrCopy(servicedesc, '\eb[TROJANS=Vampyre]\en')
    CASE 6670
        StrCopy(servicedesc, 'vocaltec-gold : Vocaltec Global Online Directory ; \eb[TROJANS=Deep Throat]\en')
    CASE 6672
        StrCopy(servicedesc, 'vision_server : vision_server')
    CASE 6673
        StrCopy(servicedesc, 'vision_elmd : vision_elmd')
    CASE 6674
        StrCopy(servicedesc, '\eb[TROJANS=Deep Throat]\en')
    CASE 6701
        StrCopy(servicedesc, 'kti-icad-srvr : KTI/ICAD Nameserver')
    CASE 6711
        StrCopy(servicedesc, '\eb[TROJANS=SubSeven]\en')
    CASE 6714
        StrCopy(servicedesc, 'ibprotocol : Internet Backplane Protocol')
    CASE 6767
        StrCopy(servicedesc, 'bmc-perf-agent : BMC PERFORM AGENT')
    CASE 6768
        StrCopy(servicedesc, 'bmc-perf-mgrd : BMC PERFORM MGRD')
    CASE 6771
        StrCopy(servicedesc, '\eb[TROJANS=Deep Throat]\en')
    CASE 6776
        StrCopy(servicedesc, '\eb[TROJANS=SubSeven]\en')
    CASE 6790
        StrCopy(servicedesc, 'hnmp : HNMP')
    CASE 6831
        StrCopy(servicedesc, 'ambit-lm : ambit-lm')
    CASE 6841
        StrCopy(servicedesc, 'netmo-default : Netmo Default')
    CASE 6842
        StrCopy(servicedesc, 'netmo-http : Netmo HTTP')
    CASE 6850
        StrCopy(servicedesc, 'iccrushmore : ICCRUSHMORE')
    CASE 6883
        StrCopy(servicedesc, '\eb[TROJANS=DeltaSource]\en')
    CASE 6888
        StrCopy(servicedesc, 'muse : MUSE')
    CASE 6912
        StrCopy(servicedesc, '\eb[TROJANS=ShitHeap]\en')
    CASE 6939
        StrCopy(servicedesc, '\eb[TROJANS=Indoctrination]\en')
    CASE 6961
        StrCopy(servicedesc, 'jmact3 : JMACT3')
    CASE 6962
        StrCopy(servicedesc, 'jmevt2 : jmevt2')
    CASE 6963
        StrCopy(servicedesc, 'swismgr1 : swismgr1')
    CASE 6964
        StrCopy(servicedesc, 'swismgr2 : swismgr2')
    CASE 6965
        StrCopy(servicedesc, 'swistrap : swistrap')
    CASE 6966
        StrCopy(servicedesc, 'swispol : swispol')
    CASE 6969
        StrCopy(servicedesc, 'acmsoda napster : acmsoda ; Napster MP3 Filesharing ; \eb[TROJANS=GateCrasher, IRC 3, Priority]\en')
    CASE 6970
        StrCopy(servicedesc, '\eb[TROJANS=GateCrasher]\en')
    CASE 6998
        StrCopy(servicedesc, 'iatp-highpri : IATP-highPri')
    CASE 6999
        StrCopy(servicedesc, 'iatp-normalpri : IATP-normalPri')
    CASE 7000
        StrCopy(servicedesc, 'afs3-fileserver : file server itself ; bbs : Bulletin Board System ; \eb[TROJANS=Remote Grab, Kazimas]\en')


    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC


EXPORT PROC service12(portserv:LONG)

SELECT portserv
    CASE 7001
        StrCopy(servicedesc, 'afs3-callback : callbacks to cache managers ; mi-ray : Mental Images Mental Ray')
    CASE 7002
        StrCopy(servicedesc, 'afs3-prserver : users & groups database ; mi-ray2xsi : Mental Ray Softimage XSI')
    CASE 7003
        StrCopy(servicedesc, 'afs3-vlserver : volume location database ; mi-ray2soft3d39 : Mental Ray Softimage 3D 3.9')
    CASE 7004
        StrCopy(servicedesc, 'afs3-kaserver : AFS/Kerberos authentication service')
    CASE 7005
        StrCopy(servicedesc, 'afs3-volser : volume managment server')
    CASE 7006
        StrCopy(servicedesc, 'afs3-errors : error interpretation service')
    CASE 7007
        StrCopy(servicedesc, 'afs3-bos : basic overseer process')
    CASE 7008
        StrCopy(servicedesc, 'afs3-update : server-to-server updater')
    CASE 7009
        StrCopy(servicedesc, 'afs3-rmtsys : remote cache manager service')
    CASE 7010
        StrCopy(servicedesc, 'ups-onlinet : onlinet uninterruptable power supplies')
    CASE 7011
        StrCopy(servicedesc, 'talon-disc : Talon Discovery Port')
    CASE 7012
        StrCopy(servicedesc, 'talon-engine : Talon Engine')
    CASE 7013
        StrCopy(servicedesc, 'microtalon-dis : Microtalon Discovery')
    CASE 7014
        StrCopy(servicedesc, 'microtalon-com : Microtalon Communications')
    CASE 7015
        StrCopy(servicedesc, 'talon-webserver : Talon Webserver')
    CASE 7020
        StrCopy(servicedesc, 'dpserve : DP Serve')
    CASE 7021
        StrCopy(servicedesc, 'dpserveadmin : DP Serve Admin')
    CASE 7070
        StrCopy(servicedesc, 'arcp : ARCP ; realaudio ra : Progr. Tech. RealAudio')
    CASE 7099
        StrCopy(servicedesc, 'lazy-ptop : lazy-ptop')
    CASE 7100
        StrCopy(servicedesc, 'fs font-service : X Font Server')
    CASE 7121
        StrCopy(servicedesc, 'virprot-lm : Virtual Prototypes License Manager')
    CASE 7174
        StrCopy(servicedesc, 'clutild : Clutild')
    CASE 7200
        StrCopy(servicedesc, 'fodms : FODMS FLIP')
    CASE 7201
        StrCopy(servicedesc, 'dlip : DLIP')
    CASE 7280
        StrCopy(servicedesc, 'itactionserver1 : ITACTIONSERVER 1')
    CASE 7281
        StrCopy(servicedesc, 'itactionserver2 : ITACTIONSERVER 2')
    CASE 7300
        StrCopy(servicedesc, 'swx : The Swiss Exchange (Also on ports 7301 - 7390) ; \eb[TROJANS=NetMonitor]\en')
    CASE 7301
        StrCopy(servicedesc, '\eb[TROJANS=Net Monitor]\en')
    CASE 7306
        StrCopy(servicedesc, '\eb[TROJANS=Net Monitor]\en')
    CASE 7307
        StrCopy(servicedesc, '\eb[TROJANS=Net Monitor]\en')
    CASE 7308
        StrCopy(servicedesc, '\eb[TROJANS=Net Monitor]\en')
    CASE 7326
        StrCopy(servicedesc, 'icb : Internet Citizens Band')
    CASE 7391
        StrCopy(servicedesc, 'mindfilesys : mind-file system server')
    CASE 7392
        StrCopy(servicedesc, 'mrssrendezvous : mrss-rendezvous server')
    CASE 7395
        StrCopy(servicedesc, 'winqedit : winqedit')
    CASE 7426
        StrCopy(servicedesc, 'pmdmgr : OpenView DM Postmaster Manager')
    CASE 7427
        StrCopy(servicedesc, 'oveadmgr : OpenView DM Event Agent Manager')
    CASE 7428
        StrCopy(servicedesc, 'ovladmgr : OpenView DM Log Agent Manager')
    CASE 7429
        StrCopy(servicedesc, 'opi-sock : OpenView DM rqt communication')
    CASE 7430
        StrCopy(servicedesc, 'xmpv7 : OpenView DM xmpv7 api pipe')
    CASE 7431
        StrCopy(servicedesc, 'pmd : OpenView DM ovc/xmpv3 api pipe')
    CASE 7437
        StrCopy(servicedesc, 'faximum : Faximum')
    CASE 7491
        StrCopy(servicedesc, 'telops-lmd : telops-lmd')
    CASE 7511
        StrCopy(servicedesc, 'pafec-lm : pafec-lm')
    CASE 7544
        StrCopy(servicedesc, 'nta-ds : FlowAnalyzer DisplayServer')
    CASE 7545
        StrCopy(servicedesc, 'nta-us : FlowAnalyzer UtilityServer')
    CASE 7566
        StrCopy(servicedesc, 'vsi-omega : VSI Omega')
    CASE 7570
        StrCopy(servicedesc, 'aries-kfinder : Aries Kfinder')
    CASE 7588
        StrCopy(servicedesc, 'sun-lm : Sun License Manager')
    CASE 7597
        StrCopy(servicedesc, '\eb[TROJANS=Quaz Trojan Worm]\en')
    CASE 7633
        StrCopy(servicedesc, 'pmdfmgt : PMDF Management')
    CASE 7648
        StrCopy(servicedesc, 'cucme-1 : CUCME Live video/audio server')
    CASE 7649
        StrCopy(servicedesc, 'cucme-2 : CUCME Live video/audio server')
    CASE 7650
        StrCopy(servicedesc, 'cucme-3 : CUCME Live video/audio server')
    CASE 7651
        StrCopy(servicedesc, 'cucme-4 : CUCME Live video/audio server')
    CASE 7777
        StrCopy(servicedesc, 'cbt : cbt')
    CASE 7778
        StrCopy(servicedesc, 'interwise : Interwise')
    CASE 7779
        StrCopy(servicedesc, 'vstat : VSTAT')
    CASE 7781
        StrCopy(servicedesc, 'accu-lmgr : accu-lmgr')
    CASE 7786
        StrCopy(servicedesc, 'minivend : MINIVEND')
    CASE 7789
        StrCopy(servicedesc, '\eb[TROJANS=ICKiller, Back Door Setup]\en')
    CASE 7932
        StrCopy(servicedesc, 't2-drm : Tier 2 Data Resource Manager')
    CASE 7933
        StrCopy(servicedesc, 't2-brm : Tier 2 Business Rules Manager')
    CASE 7967
        StrCopy(servicedesc, 'supercell : Supercell')
    CASE 7979
        StrCopy(servicedesc, 'micromuse-ncps : Micromuse-ncps')
    CASE 7980
        StrCopy(servicedesc, 'quest-vista : Quest Vista')
    CASE 7999
        StrCopy(servicedesc, 'irdmi2 : iRDMI2')
    CASE 8000
        StrCopy(servicedesc, 'irdmi : iRDMI')
    CASE 8001
        StrCopy(servicedesc, 'vcom-tunnel : VCOM Tunnel')
    CASE 8002
        StrCopy(servicedesc, 'teradataordbms : Teradata ORDBMS')
    CASE 8007
        StrCopy(servicedesc, 'jserv : Apache JServe Protocol 1.x')
    CASE 8008
        StrCopy(servicedesc, 'http-alt : HTTP Alternate')
    CASE 8009
        StrCopy(servicedesc, 'ajp13 : Apache JServe Protocol 1.3')
    CASE 8022
        StrCopy(servicedesc, 'oa-system : oa-system')
    CASE 8032
        StrCopy(servicedesc, 'pro-ed : ProEd')
    CASE 8033
        StrCopy(servicedesc, 'mindprint : MindPrint')
    CASE 8080
        StrCopy(servicedesc, 'http-alt : HTTP Alternate (see port 80) ; webcache : WWW Caching Service ; \eb[TROJANS=RingZero]\en')
    CASE 8081
        StrCopy(servicedesc, 'tproxy blackice-icecap : Transparent Proxy ; ICECap user console')
    CASE 8082
        StrCopy(servicedesc, 'backice-alerts : Blackice Alerts sent here')
    CASE 8130
        StrCopy(servicedesc, 'indigo-vrmi : INDIGO-VRMI')
    CASE 8131
        StrCopy(servicedesc, 'indigo-vbcp : INDIGO-VBCP')
    CASE 8132
        StrCopy(servicedesc, 'dbabble : dbabble')
    CASE 8160
        StrCopy(servicedesc, 'patrol : Patrol')
    CASE 8161
        StrCopy(servicedesc, 'patrol-snmp : Patrol SNMP')
    CASE 8192
        StrCopy(servicedesc, 'sdss sdssd : FlashNet 5 Backup Client Service')
    CASE 8200
        StrCopy(servicedesc, 'trivnet1 : TRIVNET')
    CASE 8201
        StrCopy(servicedesc, 'trivnet2 : TRIVNET')
    CASE 8204
        StrCopy(servicedesc, 'lm-perfworks : LM Perfworks')
    CASE 8205
        StrCopy(servicedesc, 'lm-instmgr : LM Instmgr')
    CASE 8206
        StrCopy(servicedesc, 'lm-dta : LM Dta')
    CASE 8207
        StrCopy(servicedesc, 'lm-sserver : LM SServer')
    CASE 8208
        StrCopy(servicedesc, 'lm-webwatcher : LM Webwatcher')
    CASE 8351
        StrCopy(servicedesc, 'server-find : Server Find')
    CASE 8376
        StrCopy(servicedesc, 'cruise-enum : Cruise ENUM')
    CASE 8377
        StrCopy(servicedesc, 'cruise-swroute : Cruise SWROUTE')
    CASE 8378
        StrCopy(servicedesc, 'cruise-config : Cruise CONFIG')
    CASE 8379
        StrCopy(servicedesc, 'cruise-diags : Cruise DIAGS')
    CASE 8380
        StrCopy(servicedesc, 'cruise-update : Cruise UPDATE')
    CASE 8400
        StrCopy(servicedesc, 'cvd : cvd')
    CASE 8401
        StrCopy(servicedesc, 'sabarsd : sabarsd')
    CASE 8402
        StrCopy(servicedesc, 'abarsd : abarsd')
    CASE 8403
        StrCopy(servicedesc, 'admind : admind')
    CASE 8450
        StrCopy(servicedesc, 'npmp : npmp')
    CASE 8473
        StrCopy(servicedesc, 'vp2p : Virtual Point to Point')
    CASE 8554
        StrCopy(servicedesc, 'rtsp-alt : RTSP Alternate (see port 554)')
    CASE 8733
        StrCopy(servicedesc, 'ibus : iBus')
    CASE 8763
        StrCopy(servicedesc, 'mc-appserver : MC-APPSERVER')
    CASE 8764
        StrCopy(servicedesc, 'openqueue : OPENQUEUE')
    CASE 8765
        StrCopy(servicedesc, 'ultraseek-http : Ultraseek HTTP')
    CASE 8778
        StrCopy(servicedesc, 'wn-http : WhatsNew HTTP Protocol')
    CASE 8804
        StrCopy(servicedesc, 'truecm : truecm')
    CASE 8880
        StrCopy(servicedesc, 'cddbp-alt : CDDBP')
    CASE 8888
        StrCopy(servicedesc, 'ddi-tcp-1 sun-answerbook : NewsEDGE server TCP (TCP 1) ; Sun Answerbook HTTP server')
    CASE 8889
        StrCopy(servicedesc, 'ddi-tcp-2 : Desktop Data TCP 1')
    CASE 8890
        StrCopy(servicedesc, 'ddi-tcp-3 : Desktop Data TCP 2')
    CASE 8891
        StrCopy(servicedesc, 'ddi-tcp-4 : Desktop Data TCP 3: NESS application')
    CASE 8892
        StrCopy(servicedesc, 'ddi-tcp-5 seosload : Desktop Data TCP 4: FARM product ; Computer Associates ETrust ACX')
    CASE 8893
        StrCopy(servicedesc, 'ddi-tcp-6 : Desktop Data TCP 5: NewsEDGE/Web application')
    CASE 8894
        StrCopy(servicedesc, 'ddi-tcp-7 : Desktop Data TCP 6: COAL application')
    CASE 8900
        StrCopy(servicedesc, 'jmb-cds1 : JMB-CDS 1')
    CASE 8901
        StrCopy(servicedesc, 'jmb-cds2 : JMB-CDS 2')
    CASE 9000
        StrCopy(servicedesc, 'cslistener : CSlistener')
    CASE 9090
        StrCopy(servicedesc, 'websm zeus-admin : WebSM ; Zeus WWW Admin Server')
    CASE 9091
        StrCopy(servicedesc, 'xmltec-xmlmail : xmltec-xmlmail')
    CASE 9100
        StrCopy(servicedesc, 'jetdirect : HP Jet Direct Print Server')
    CASE 9111
        StrCopy(servicedesc, 'dragon : Dragon IDS Console')
    CASE 9160
        StrCopy(servicedesc, 'netlock1 : NetLOCK1')
    CASE 9161
        StrCopy(servicedesc, 'netlock2 : NetLOCK2')
    CASE 9162
        StrCopy(servicedesc, 'netlock3 : NetLOCK3')
    CASE 9163
        StrCopy(servicedesc, 'netlock4 : NetLOCK4')
    CASE 9164
        StrCopy(servicedesc, 'netlock5 : NetLOCK5')
    CASE 9200
        StrCopy(servicedesc, 'wap-wsp : WAP connectionless session service')
    CASE 9201
        StrCopy(servicedesc, 'wap-wsp-wtp : WAP session service')
    CASE 9202
        StrCopy(servicedesc, 'wap-wsp-s : WAP secure connectionless session service')
    CASE 9203
        StrCopy(servicedesc, 'wap-wsp-wtp-s : WAP secure session service')
    CASE 9204
        StrCopy(servicedesc, 'wap-vcard : WAP vCard')
    CASE 9205
        StrCopy(servicedesc, 'wap-vcal : WAP vCal')
    CASE 9206
        StrCopy(servicedesc, 'wap-vcard-s : WAP vCard Secure')
    CASE 9207
        StrCopy(servicedesc, 'wap-vcal-s : WAP vCal Secure')
    CASE 9283
        StrCopy(servicedesc, 'callwaveiam : CallWaveIAM')
    CASE 9292
        StrCopy(servicedesc, 'armtechdaemon : ArmTech Daemon')
    CASE 9321
        StrCopy(servicedesc, 'guibase : guibase')
    CASE 9343
        StrCopy(servicedesc, 'mpidcmgr : MpIdcMgr')
    CASE 9344
        StrCopy(servicedesc, 'mphlpdmc : Mphlpdmc')
    CASE 9346
        StrCopy(servicedesc, 'ctechlicensing : C Tech Licensing')
    CASE 9359
        StrCopy(servicedesc, 'mandelspawn mandelbrot : Network Mandelbrot')
    CASE 9374
        StrCopy(servicedesc, 'fjdmimgr : fjdmimgr')
    CASE 9396
        StrCopy(servicedesc, 'fjinvmgr : fjinvmgr')
    CASE 9400
        StrCopy(servicedesc, '\eb[TROJANS=InCommand]\en')
    CASE 9397
        StrCopy(servicedesc, 'mpidcagt : MpIdcAgt')
    CASE 9500
        StrCopy(servicedesc, 'ismserver : ismserver')
    CASE 9535
        StrCopy(servicedesc, 'mngsuite man : mngsuite ; man')
    CASE 9594
        StrCopy(servicedesc, 'msgsys : Message System')
    CASE 9595
        StrCopy(servicedesc, 'pds : Ping Discovery Service')
    CASE 9600
        StrCopy(servicedesc, 'micromuse-ncpw : MICROMUSE-NCPW')
    CASE 9753
        StrCopy(servicedesc, 'rasadv : rasadv')
    CASE 9872
        StrCopy(servicedesc, '\eb[TROJANS=Portal of Doom]\en')
    CASE 9873
        StrCopy(servicedesc, '\eb[TROJANS=Portal of Doom]\en')
    CASE 9874
        StrCopy(servicedesc, '\eb[TROJANS=Portal of Doom]\en')
    CASE 9875
        StrCopy(servicedesc, '\eb[TROJANS=Portal of Doom]\en')
    CASE 9876
        StrCopy(servicedesc, 'sd : Session Director ; \eb[TROJANS=Cyber Attacker]\en')
    CASE 9878
        StrCopy(servicedesc, '\eb[TROJANS=Transcout]\en')
    CASE 9888
        StrCopy(servicedesc, 'cyborg-systems : CYBORG Systems')
    CASE 9898
        StrCopy(servicedesc, 'monkeycom : MonkeyCom')
    CASE 9899
        StrCopy(servicedesc, 'sctp-tunneling : SCTP TUNNELING')
    CASE 9900
        StrCopy(servicedesc, 'iua : IUA')
    CASE 9909
        StrCopy(servicedesc, 'domaintime : domaintime')
    CASE 9950
        StrCopy(servicedesc, 'apcpcpluswin1 : APCPCPLUSWIN1')
    CASE 9951
        StrCopy(servicedesc, 'apcpcpluswin2 : APCPCPLUSWIN2')
    CASE 9952
        StrCopy(servicedesc, 'apcpcpluswin3 : APCPCPLUSWIN3')
    CASE 9989
        StrCopy(servicedesc, '\eb[TROJANS=iNi Killer]\en')
    CASE 9991
        StrCopy(servicedesc, 'issa : ISS System Scanner Agent')
    CASE 9992
        StrCopy(servicedesc, 'palace-1 issc : OnLive-1 ; ISS System Scanner Console')
    CASE 9993
        StrCopy(servicedesc, 'palace-2 : OnLive-2')
    CASE 9994
        StrCopy(servicedesc, 'palace-3 : OnLive-3')
    CASE 9995
        StrCopy(servicedesc, 'palace-4 : Palace-4')
    CASE 9996
        StrCopy(servicedesc, 'palace-5 : Palace-5')
    CASE 9997
        StrCopy(servicedesc, 'palace-6 : Palace-6')
    CASE 9998
        StrCopy(servicedesc, 'distinct32 : Distinct32')
    CASE 9999
        StrCopy(servicedesc, 'distinct : distinct ; \eb[TROJANS=The Prayer]\en')
    CASE 10000
        StrCopy(servicedesc, 'ndmp : Network Data Management Protocol')
    CASE 10005
        StrCopy(servicedesc, 'stel : Secure Telnet')
    CASE 10007
        StrCopy(servicedesc, 'mvs-capacity : MVS Capacity')
    CASE 10067
        StrCopy(servicedesc, '\eb[TROJANS=Portal of Doom]\en')
    CASE 10080
        StrCopy(servicedesc, 'amanda : Amanda Backup Services')
    CASE 10081
        StrCopy(servicedesc, 'kamanda : Amanda Backup Services via Kerberos')
    CASE 10082
        StrCopy(servicedesc, 'amandaidx : Amanda Backup Indexing Services')
    CASE 10083
        StrCopy(servicedesc, 'amidxtape : Amanda Backup Tape Indexing Services')
    CASE 10101
        StrCopy(servicedesc, '\eb[TROJANS=BrainSpy]\en')
    CASE 10113
        StrCopy(servicedesc, 'netiq-endpoint : NetIQ Endpoint')
    CASE 10114
        StrCopy(servicedesc, 'netiq-qcheck : NetIQ Qcheck')
    CASE 10115
        StrCopy(servicedesc, 'netiq-endpt : NetIQ Endpoint')
    CASE 10128
        StrCopy(servicedesc, 'bmc-perf-sd : BMC-PERFORM-SERVICE DAEMON')
    CASE 10288
        StrCopy(servicedesc, 'blocks : Blocks')
    CASE 10520
        StrCopy(servicedesc, '\eb[TROJANS=Acid Shivers]\en')
    CASE 10607
        StrCopy(servicedesc, '\eb[TROJANS=Coma]\en')
    CASE 10646
        StrCopy(servicedesc, '\eb[TROJANS=Lion Worm]\en')
    CASE 11000
        StrCopy(servicedesc, 'irisa : IRISA ; \eb[TROJANS=Senna Spy Trojans]\en')
    CASE 11001
        StrCopy(servicedesc, 'metasys : Metasys')
    CASE 11111
        StrCopy(servicedesc, 'vce : Viral Computing Environment (VCE)')
    CASE 11201
        StrCopy(servicedesc, 'smsqp : smsqp')
    CASE 11223
        StrCopy(servicedesc, '\eb[TROJANS=Progenic Trojan]\en')
    CASE 11319
        StrCopy(servicedesc, 'imip : IMIP')
    CASE 11367
        StrCopy(servicedesc, 'atm-uhas : ATM UHAS')
    CASE 11371
        StrCopy(servicedesc, 'pksd : PGP Public Key Server')
    CASE 11720
        StrCopy(servicedesc, 'h323callsigalt : h323 Call Signal Alternate')
    CASE 12000
        StrCopy(servicedesc, 'entextxid cce4x : IBM Enterprise Extender SNA XID Exchange ; Clear Commerce Engine 4.x')
    CASE 12001
        StrCopy(servicedesc, 'entextnetwk : IBM Enterprise Extender SNA COS Network Priority')
    CASE 12002
        StrCopy(servicedesc, 'entexthigh : IBM Enterprise Extender SNA COS High Priority')
    CASE 12003
        StrCopy(servicedesc, 'entextmed : IBM Enterprise Extender SNA COS Medium Priority')
    CASE 12004
        StrCopy(servicedesc, 'entextlow : IBM Enterprise Extender SNA COS Low Priority')
    CASE 12076
        StrCopy(servicedesc, '\eb[TROJANS=Gjamer]\en')
    CASE 12172
        StrCopy(servicedesc, 'hivep : HiveP')
    CASE 12223
        StrCopy(servicedesc, '\eb[TROJANS=Hack 99 Keylogger]\en')
    CASE 12345
        StrCopy(servicedesc, '\eb[TROJANS=GabanBus, Netbus 1.x, Pie Bill Gates, X Bill]\en')
    CASE 12346
        StrCopy(servicedesc, '\eb[TROJANS=GabanBus, Netbus 1.x (avoiding NetBust), X Bill]\en')
    CASE 12361
        StrCopy(servicedesc, '\eb[TROJANS=Whack a Mole]\en')
    CASE 12362
        StrCopy(servicedesc, '\eb[TROJANS=Whack a Mole]\en')
    CASE 12631
        StrCopy(servicedesc, '\eb[TROJANS=WhackJob]\en')
    CASE 12753
        StrCopy(servicedesc, 'tsaf : tsaf port')
    CASE 13000
        StrCopy(servicedesc, '\eb[TROJANS=Senna Spy Trojan]\en')
    CASE 13160
        StrCopy(servicedesc, 'i-zipqd : I-ZIPQD')
    CASE 13223
        StrCopy(servicedesc, 'powwow-client : PowWow Client')
    CASE 13224
        StrCopy(servicedesc, 'powwow-server : PowWow Server')
    CASE 13720
        StrCopy(servicedesc, 'bprd : BPRD Protocol (VERITAS NetBackup)')
    CASE 13721
        StrCopy(servicedesc, 'bpbrm : BPBRM Protocol (VERITAS NetBackup)')
    CASE 13722
        StrCopy(servicedesc, 'bpjava-msvc : BP Java MSVC Protocol')
    CASE 13782
        StrCopy(servicedesc, 'bpcd : VERITAS NetBackup')
    CASE 13783
        StrCopy(servicedesc, 'vopied : VOPIED Protnocol')
    CASE 13818
        StrCopy(servicedesc, 'dsmcc-config : DSMCC Config')
    CASE 13819
        StrCopy(servicedesc, 'dsmcc-session : DSMCC Session Messages')
    CASE 13820
        StrCopy(servicedesc, 'dsmcc-passthru : DSMCC Pass-Thru Messages')
    CASE 13821
        StrCopy(servicedesc, 'dsmcc-download : DSMCC Download Protocol')
    CASE 13822
        StrCopy(servicedesc, 'dsmcc-ccp : DSMCC Channel Change Protocol')
    CASE 14001
        StrCopy(servicedesc, 'itu-sccp-ss7 : ITU SCCP (SS7)')
    CASE 14936
        StrCopy(servicedesc, 'hde-lcesrvr-1 : hde-lcesrvr-1')
    CASE 14937
        StrCopy(servicedesc, 'hde-lcesrvr-2 : hde-lcesrvr-2')
    CASE 16360
        StrCopy(servicedesc, 'netserialext1 : netserialext1')
    CASE 16361
        StrCopy(servicedesc, 'netserialext2 : netserialext2')
    CASE 16367
        StrCopy(servicedesc, 'netserialext3 : netserialext3')
    CASE 16368
        StrCopy(servicedesc, 'netserialext4 : netserialext4')
    CASE 16969
        StrCopy(servicedesc, '\eb[TROJANS=Priority]\en')
    CASE 16991
        StrCopy(servicedesc, 'intel-rci-mp : INTEL-RCI-MP')
    CASE 17007
        StrCopy(servicedesc, 'isode-dua : isode-dua')
    CASE 17185
        StrCopy(servicedesc, 'soundsvirtual : Sounds Virtual')
    CASE 17219
        StrCopy(servicedesc, 'chipper : Chipper')
    CASE 17300
        StrCopy(servicedesc, '\eb[TROJANS=Kuang2 the Virus]\en')
    CASE 18000
        StrCopy(servicedesc, 'biimenu : Beckman Instruments, Inc.')
    CASE 18181
        StrCopy(servicedesc, 'opsec-cvp : OPSEC CVP')
    CASE 18182
        StrCopy(servicedesc, 'opsec-ufp : OPSEC UFP')
    CASE 18183
        StrCopy(servicedesc, 'opsec-sam : OPSEC SAM')
    CASE 18184
        StrCopy(servicedesc, 'opsec-lea : OPSEC LEA')
    CASE 18185
        StrCopy(servicedesc, 'opsec-omi : OPSEC OMI')
    CASE 18187
        StrCopy(servicedesc, 'opsec-ela : OPSEC ELA')
    CASE 18463
        StrCopy(servicedesc, 'ac-cluster : AC Cluster')
    CASE 18888
        StrCopy(servicedesc, 'apc-necmp : APCNECMP ')
    CASE 19191
        StrCopy(servicedesc, 'opsec-uaa : opsec-uaa')
    CASE 19283
        StrCopy(servicedesc, 'keysrvr : Key Server for SASSAFRAS')
    CASE 19315
        StrCopy(servicedesc, 'keyshadow : Key Shadow for SASSAFRAS')
    CASE 19410
        StrCopy(servicedesc, 'hp-sco : hp-sco')
    CASE 19411
        StrCopy(servicedesc, 'hp-sca : hp-sca')
    CASE 19412
        StrCopy(servicedesc, 'hp-sessmon : HP-SESSMON')
    CASE 19541
        StrCopy(servicedesc, 'jcp : JCP Client')
    CASE 20000
        StrCopy(servicedesc, 'dnp : DNP ; \eb[TROJANS=Millennium]\en')
    CASE 20001
        StrCopy(servicedesc, '\eb[TROJANS=Millennium]\en')
    CASE 20005
        StrCopy(servicedesc, 'btx : xcept4 (Interacrs with Deutsche Telekoms CEPT videotext)')
    CASE 20011
        StrCopy(servicedesc, 'isdn : ISDN Logging System')
    CASE 20012
        StrCopy(servicedesc, 'vboxd : Voice Box System')
    CASE 20034
        StrCopy(servicedesc, '\eb[TROJANS=Netbus 2 Pro]\en')
    CASE 20203
        StrCopy(servicedesc, '\eb[TROJANS=Logged]\en')
    CASE 20222
        StrCopy(servicedesc, 'ipulse-ics : iPulse-ICS')
    CASE 20331
        StrCopy(servicedesc, '\eb[TROJANS=Bla]\en')
    CASE 20670
        StrCopy(servicedesc, 'track : Track')
    CASE 20999
        StrCopy(servicedesc, 'athand-mmp : At Hand MMP')
    CASE 21554
        StrCopy(servicedesc, '\eb[TROJANS=Girlfriend, Schwindler 1.82]\en')
    CASE 21590
        StrCopy(servicedesc, 'vofr-gateway : VoFR Gateway')
    CASE 21845
        StrCopy(servicedesc, 'webphone : webphone')
    CASE 21846
        StrCopy(servicedesc, 'netspeak-is : NetSpeak Corp. Directory Services')
    CASE 21847
        StrCopy(servicedesc, 'netspeak-cs : NetSpeak Corp. Connection Services')
    CASE 21848
        StrCopy(servicedesc, 'netspeak-acd : NetSpeak Corp. Automatic Call Distribution')
    CASE 21849
        StrCopy(servicedesc, 'netspeak-cps : NetSpeak Corp. Credit Processing System')
    CASE 22000
        StrCopy(servicedesc, 'snapenetio : SNAPenetIO')
    CASE 22001
        StrCopy(servicedesc, 'optocontrol : OptoControl')
    CASE 22222
        StrCopy(servicedesc, '\eb[TROJANS=Prosiak]\en')
    CASE 22273
        StrCopy(servicedesc, 'wnn6 : wnn6 (Japanese Input)')
    CASE 22289
        StrCopy(servicedesc, 'wnn6_Cn : Wnn6 (Chinese Input)')
    CASE 22305
        StrCopy(servicedesc, 'wnn6_Kr : Wnn6 (Korean Input)')
    CASE 22321
        StrCopy(servicedesc, 'wnn6_Tw : Wnn6 (Taiwanese Input)')
    CASE 22370
        StrCopy(servicedesc, 'hpnpd : Hewlett Packard Network Printer')
    CASE 22555
        StrCopy(servicedesc, 'vocaltec-wconf : Vocaltec Web Conference')
    CASE 22800
        StrCopy(servicedesc, 'aws-brf : Telerate Information Platform LAN')
    CASE 22951
        StrCopy(servicedesc, 'brf-gw : Telerate Information Platform WAN')
    CASE 23456
        StrCopy(servicedesc, '\eb[TROJANS=Evil FTP, Ugly FTP, WhackJob]\en')
    CASE 23476
        StrCopy(servicedesc, '\eb[TROJANS=Donald Dick]\en')
    CASE 23477
        StrCopy(servicedesc, '\eb[TROJANS=Donald Dick]\en')
    CASE 24000
        StrCopy(servicedesc, 'med-ltp : med-ltp')
    CASE 24001
        StrCopy(servicedesc, 'med-fsp-rx : med-fsp-rx')
    CASE 24002
        StrCopy(servicedesc, 'med-fsp-tx : med-fsp-tx')
    CASE 24003
        StrCopy(servicedesc, 'med-supp : med-supp')
    CASE 24004
        StrCopy(servicedesc, 'med-ovw : med-ovw')
    CASE 24005
        StrCopy(servicedesc, 'med-ci : med-ci')
    CASE 24006
        StrCopy(servicedesc, 'med-net-svc : med-net-svc')
    CASE 24242
        StrCopy(servicedesc, 'filesphere : fileSphere')
    CASE 24386
        StrCopy(servicedesc, 'intel_rci : Intel RCI')
    CASE 24554
        StrCopy(servicedesc, 'binkp : Binkley')
    CASE 24677
        StrCopy(servicedesc, 'flashfiler : FlashFiler')
    CASE 25000
        StrCopy(servicedesc, 'icl-twobase1 : icl-twobase1')
    CASE 25001
        StrCopy(servicedesc, 'icl-twobase2 : icl-twobase2')
    CASE 25002
        StrCopy(servicedesc, 'icl-twobase3 : icl-twobase3')
    CASE 25003
        StrCopy(servicedesc, 'icl-twobase4 : icl-twobase4')
    CASE 25004
        StrCopy(servicedesc, 'icl-twobase5 : icl-twobase5')
    CASE 25005
        StrCopy(servicedesc, 'icl-twobase6 : icl-twobase6')
    CASE 25006
        StrCopy(servicedesc, 'icl-twobase7 : icl-twobase7')
    CASE 25007
        StrCopy(servicedesc, 'icl-twobase8 : icl-twobase8')
    CASE 25008
        StrCopy(servicedesc, 'icl-twobase9 : icl-twobase9')
    CASE 25009
        StrCopy(servicedesc, 'icl-twobase10 : icl-twobase10')
    CASE 25793
        StrCopy(servicedesc, 'vocaltec-hos : Vocaltec Address Server')
    CASE 26000
        StrCopy(servicedesc, 'quake : Quake Game Server')
    CASE 26208
        StrCopy(servicedesc, 'wnn6-ds : wnn6 DServer')
    CASE 26262
        StrCopy(servicedesc, 'k3software-svr : K3 Software-Server')
    CASE 26262
        StrCopy(servicedesc, 'k3software-svr : K3 Software-Server')
    CASE 26264
        StrCopy(servicedesc, 'gserver : Gserver')
    CASE 27000
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27001
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27002
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27003
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27004
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27005
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27006
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27007
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27008
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27009
        StrCopy(servicedesc, 'flex-lm : FLEX License Manager')
    CASE 27345
        StrCopy(servicedesc, 'imagepump : ImagePump')
    CASE 27374
        StrCopy(servicedesc, 'asp : Address Search Protocol')
    CASE 27444
        StrCopy(servicedesc, 'trinoo_bcast : Trinoo Distributed Attack Tool Master')
    CASE 27665
        StrCopy(servicedesc, 'trinoo_master : Trinoo Distributed Attack Tool master server')
    CASE 27960
        StrCopy(servicedesc, 'quake3 : Quake 3 Game Server')
    CASE 27999
        StrCopy(servicedesc, 'tw-auth-key : TW Authentication/Key Distribution')
    CASE 30029
        StrCopy(servicedesc, '\eb[TROJANS=AOL Trojan]\en')
    CASE 30100
        StrCopy(servicedesc, '\eb[TROJANS=NetSphere 1.27a/1.29/1.31]\en')
    CASE 30101
        StrCopy(servicedesc, '\eb[TROJANS=NetSphere 1.27a/1.29/1.31]\en')
    CASE 30102
        StrCopy(servicedesc, '\eb[TROJANS=NetSphere 1.27a/1.29/1.31]\en')
    CASE 30103
        StrCopy(servicedesc, '\eb[TROJANS=NetSphere 1.31]\en')
    CASE 30303
        StrCopy(servicedesc, '\eb[TROJANS=Socket25, Sockets de Troie]\en')
    CASE 30999
        StrCopy(servicedesc, '\eb[TROJANS=Kuang]\en')
    CASE 31335
        StrCopy(servicedesc, 'trinoo_register : Trinoo Distributed Attack Tool Registration Port')
    CASE 31336
        StrCopy(servicedesc, '\eb[TROJANS=BOWhack]\en')
    CASE 31337
        StrCopy(servicedesc, '\eb[TROJANS=Back Orifice, BO Facil, Baron Night, Elite]\en')
    CASE 31338
        StrCopy(servicedesc, '\eb[TROJANS=NetSpy DK]\en')
    CASE 31339
        StrCopy(servicedesc, '\eb[TROJANS=NetSpy DK]\en')
    CASE 31666
        StrCopy(servicedesc, '\eb[TROJANS=BOWhack]\en')
    CASE 31780
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 31785
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 31787
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 31788
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 31789
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 31790
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 31791
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 31792
        StrCopy(servicedesc, '\eb[TROJANS=Hack a Tack]\en')
    CASE 32768
        StrCopy(servicedesc, 'filenet-tms : Filenet TMS')
    CASE 32769
        StrCopy(servicedesc, 'filenet-rpc : Filenet RPC ; sgi_iphone : Silicon Graphics InPerson Phone')
    CASE 32770
        StrCopy(servicedesc, 'filenet-nch sun-rpc : Filenet NCH ; Sun RPC on Solaris')
    CASE 32771
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32772
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32773
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32774
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32775
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32776
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32777
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32778
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32779
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32780
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32786
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 32787
        StrCopy(servicedesc, 'sun-rpc : Sun RPC on Solaris')
    CASE 33333
        StrCopy(servicedesc, '\eb[TROJANS=Prosiak]\en')
    CASE 33434
        StrCopy(servicedesc, 'traceroute : traceroute use')
    CASE 33911
        StrCopy(servicedesc, '\eb[TROJANS=Trojan Spirit]\en')
    CASE 34324
        StrCopy(servicedesc, '\eb[TROJANS=BigGluck, TN, Tiny Telnet]\en')
    CASE 36865
        StrCopy(servicedesc, 'kastenxpipe : KastenX Pipe')
    CASE 39213
        StrCopy(servicedesc, 'sygatefw : Sygate Firewall management port V 3')
    CASE 40412
        StrCopy(servicedesc, '\eb[TROJANS=The Spy]\en')
    CASE 40421
        StrCopy(servicedesc, '\eb[TROJANS=Masters Paradise, Agent 40421]\en')
    CASE 40422
        StrCopy(servicedesc, '\eb[TROJANS=Masters Paradise]\en')
    CASE 40423
        StrCopy(servicedesc, '\eb[TROJANS=Masters Paradise]\en')
    CASE 40425
        StrCopy(servicedesc, '\eb[TROJANS=Masters Paradise]\en')
    CASE 40426
        StrCopy(servicedesc, '\eb[TROJANS=Masters Paradise]\en')
    CASE 40841
        StrCopy(servicedesc, 'cscp : CSCP')
    CASE 43188
        StrCopy(servicedesc, 'reachout : REACHOUT')
    CASE 43189
        StrCopy(servicedesc, 'ndm-agent-port : NDM-AGENT-PORT')
    CASE 43190
        StrCopy(servicedesc, 'ip-provision : IP-PROVISION')
    CASE 44442
        StrCopy(servicedesc, 'coldfusion-auth : ColdFusion advanced security/Sireminder')
    CASE 44443
        StrCopy(servicedesc, 'coldfusion-auth : ColdFusion advanced security/Sireminder')
    CASE 44818
        StrCopy(servicedesc, 'rockwell-encap : Rockwell Encapsulation')
    CASE 45000
        StrCopy(servicedesc, 'ciscopop : Cisco Post Office Protocol for Cisco IDS')
    CASE 45054
        StrCopy(servicedesc, 'invision-ag : InVision AG')
    CASE 45678
        StrCopy(servicedesc, 'eba : EBA PRISE')
    CASE 45966
        StrCopy(servicedesc, 'ssr-servermgr : SSRServerMgr')
    CASE 47262
        StrCopy(servicedesc, '\eb[TROJANS=Delta Source]\en')
    CASE 47557
        StrCopy(servicedesc, 'dbbrowse : Databeam Corporation')
    CASE 47624
        StrCopy(servicedesc, 'directplaysrvr : Direct Play Server')
    CASE 47806
        StrCopy(servicedesc, 'ap : ALC Protocol')
    CASE 47808
        StrCopy(servicedesc, 'bacnet : Building Automation and Control Networks')
    CASE 48000
        StrCopy(servicedesc, 'nimcontroller : Nimbus Controller')
    CASE 48001
        StrCopy(servicedesc, 'nimspooler : Nimbus Spooler')
    CASE 48002
        StrCopy(servicedesc, 'nimhub : Nimbus Hub')
    CASE 48003
        StrCopy(servicedesc, 'nimgtw : Nimbus Gateway')
    CASE 48556
        StrCopy(servicedesc, 'com-bardac-dw : com-bardac-dw')
    CASE 50505
        StrCopy(servicedesc, '\eb[TROJANS=Sockets de Troie]\en')
    CASE 50766
        StrCopy(servicedesc, '\eb[TROJANS=Fore, Schwindler]\en')
    CASE 53001
        StrCopy(servicedesc, '\eb[TROJANS=Remote Windows Shutdown]\en')
    CASE 54320
        StrCopy(servicedesc, '\eb[TROJANS=Back Orifice]\en')
    CASE 54321
        StrCopy(servicedesc, '\eb[TROJANS=Back Orifice, Schoolbus]\en')
    CASE 60000
        StrCopy(servicedesc, '\eb[TROJANS=Deep Throat]\en')
    CASE 60177
        StrCopy(servicedesc, 'tfido : IfMail')
    CASE 60179
        StrCopy(servicedesc, 'fido : IfMail')
    CASE 61439
        StrCopy(servicedesc, 'netprowler : netprowler')
    CASE 61440
        StrCopy(servicedesc, 'netprowler : netprowler')
    CASE 61441
        StrCopy(servicedesc, 'netprowler : netprowler')
    CASE 61466
        StrCopy(servicedesc, '\eb[TROJANS=Telecommando]\en')
    CASE 65000
        StrCopy(servicedesc, '\eb[TROJANS=Devil]\en')
    CASE 65301
        StrCopy(servicedesc, 'pcanywhere : PC Anywhere Remote Control')
    DEFAULT
        StrCopy(servicedesc, 'UNKNOWN')
ENDSELECT
ENDPROC
