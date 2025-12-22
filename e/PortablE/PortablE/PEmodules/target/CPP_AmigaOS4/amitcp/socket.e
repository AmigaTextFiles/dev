OPT NATIVE, PREPROCESS
MODULE 'target/exec/lists', 'target/devices/timer', 'target/utility/tagitem', 'target/utility/hooks', 'target/amitcp/netinet/in', 'target/amitcp/sys/socket', 'target/amitcp/sys/mbuf', 'target/amitcp/net/route', 'target/amitcp/netdb', 'target/amitcp/libraries/bsdsocket', 'target/dos/dosextens'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types', 'target/amitcp/sys/timeval'
{
#include <proto/bsdsocket.h>
}
{
struct Library* SocketBase = NULL;
struct SocketIFace* ISocket = NULL;
}
/*
 * $Id: bsdsocket_protos.h,v 1.10 2007-08-26 12:30:21 obarthel Exp $
 *
 * :ts=8
 *
 * 'Roadshow' -- Amiga TCP/IP stack
 * Copyright © 2001-2007 by Olaf Barthel.
 * All Rights Reserved.
 *
 * Amiga specific TCP/IP 'C' header files;
 * Freely Distributable
 */

NATIVE {CLIB_BSDSOCKET_PROTOS_H} CONST
NATIVE {PROTO_BSDSOCKET_H} CONST
NATIVE {BSDSOCKET_INTERFACE_DEF_H} CONST

NATIVE {SocketBase} DEF socketbase:PTR TO lib
NATIVE {ISocket} DEF

PROC new()
	InitLibrary('bsdsocket.library', NATIVE {(struct Interface **) &ISocket} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

NATIVE {socket} PROC
PROC Socket( domain:VALUE, type:VALUE, protocol:VALUE ) IS NATIVE {ISocket->socket(} domain {,} type {,} protocol {)} ENDNATIVE !!VALUE
NATIVE {bind} PROC
PROC Bind( sock:VALUE, name:PTR TO sockaddr, namelen:SOCKLEN_T ) IS NATIVE {ISocket->bind(} sock {,} name {,} namelen {)} ENDNATIVE !!VALUE
NATIVE {listen} PROC
PROC Listen( sock:VALUE, backlog:VALUE ) IS NATIVE {ISocket->listen(} sock {,} backlog {)} ENDNATIVE !!VALUE
NATIVE {accept} PROC
PROC Accept( sock:VALUE, addr:PTR TO sockaddr, addrlen:PTR TO SOCKLEN_T ) IS NATIVE {ISocket->accept(} sock {,} addr {,} addrlen {)} ENDNATIVE !!VALUE
NATIVE {connect} PROC
PROC Connect( sock:VALUE, name:PTR TO sockaddr, namelen:SOCKLEN_T ) IS NATIVE {ISocket->connect(} sock {,} name {,} namelen {)} ENDNATIVE !!VALUE
NATIVE {sendto} PROC
PROC Sendto( sock:VALUE, buf:APTR, len:VALUE, flags:VALUE, to:PTR TO sockaddr, tolen:SOCKLEN_T ) IS NATIVE {ISocket->sendto(} sock {,} buf {,} len {,} flags {,} to {,} tolen {)} ENDNATIVE !!VALUE
NATIVE {send} PROC
PROC Send( sock:VALUE, buf:APTR, len:VALUE, flags:VALUE ) IS NATIVE {ISocket->send(} sock {,} buf {,} len {,} flags {)} ENDNATIVE !!VALUE
NATIVE {recvfrom} PROC
PROC Recvfrom( sock:VALUE, buf:APTR, len:VALUE, flags:VALUE, addr:PTR TO sockaddr, addrlen:PTR TO SOCKLEN_T ) IS NATIVE {ISocket->recvfrom(} sock {,} buf {,} len {,} flags {,} addr {,} addrlen {)} ENDNATIVE !!VALUE
NATIVE {recv} PROC
PROC Recv( sock:VALUE, buf:APTR, len:VALUE, flags:VALUE ) IS NATIVE {ISocket->recv(} sock {,} buf {,} len {,} flags {)} ENDNATIVE !!VALUE
NATIVE {shutdown} PROC
PROC Shutdown( sock:VALUE, how:VALUE ) IS NATIVE {ISocket->shutdown(} sock {,} how {)} ENDNATIVE !!VALUE
NATIVE {setsockopt} PROC
PROC Setsockopt( sock:VALUE, level:VALUE, optname:VALUE, optval:APTR, optlen:SOCKLEN_T ) IS NATIVE {ISocket->setsockopt(} sock {,} level {,} optname {,} optval {,} optlen {)} ENDNATIVE !!VALUE
NATIVE {getsockopt} PROC
PROC Getsockopt( sock:VALUE, level:VALUE, optname:VALUE, optval:APTR, optlen:PTR TO SOCKLEN_T ) IS NATIVE {ISocket->getsockopt(} sock {,} level {,} optname {,} optval {,} optlen {)} ENDNATIVE !!VALUE
NATIVE {getsockname} PROC
PROC Getsockname( sock:VALUE, name:PTR TO sockaddr, namelen:PTR TO SOCKLEN_T ) IS NATIVE {ISocket->getsockname(} sock {,} name {,} namelen {)} ENDNATIVE !!VALUE
NATIVE {getpeername} PROC
PROC Getpeername( sock:VALUE, name:PTR TO sockaddr, namelen:PTR TO SOCKLEN_T ) IS NATIVE {ISocket->getpeername(} sock {,} name {,} namelen {)} ENDNATIVE !!VALUE
NATIVE {IoctlSocket} PROC
PROC IoctlSocket( sock:VALUE, req:ULONG, argp:APTR ) IS NATIVE {ISocket->IoctlSocket(} sock {,} req {,} argp {)} ENDNATIVE !!VALUE
NATIVE {CloseSocket} PROC
PROC CloseSocket( sock:VALUE ) IS NATIVE {ISocket->CloseSocket(} sock {)} ENDNATIVE !!VALUE
NATIVE {WaitSelect} PROC
PROC WaitSelect( nfds:VALUE, read_fds:APTR, write_fds:APTR, except_fds:APTR, _timeout:PTR TO __timeval, signals:PTR TO ULONG ) IS NATIVE {ISocket->WaitSelect(} nfds {,} read_fds {,} write_fds {,} except_fds {,} _timeout {,} signals {)} ENDNATIVE !!VALUE
NATIVE {SetSocketSignals} PROC
PROC SetSocketSignals( int_mask:ULONG, io_mask:ULONG, urgent_mask:ULONG ) IS NATIVE {ISocket->SetSocketSignals(} int_mask {,} io_mask {,} urgent_mask {)} ENDNATIVE
NATIVE {getdtablesize} PROC
PROC Getdtablesize( ) IS NATIVE {ISocket->getdtablesize()} ENDNATIVE !!VALUE
NATIVE {ObtainSocket} PROC
PROC ObtainSocket( id:VALUE, domain:VALUE, type:VALUE, protocol:VALUE ) IS NATIVE {ISocket->ObtainSocket(} id {,} domain {,} type {,} protocol {)} ENDNATIVE !!VALUE
NATIVE {ReleaseSocket} PROC
PROC ReleaseSocket( sock:VALUE, id:VALUE ) IS NATIVE {ISocket->ReleaseSocket(} sock {,} id {)} ENDNATIVE !!VALUE
NATIVE {ReleaseCopyOfSocket} PROC
PROC ReleaseCopyOfSocket( sock:VALUE, id:VALUE ) IS NATIVE {ISocket->ReleaseCopyOfSocket(} sock {,} id {)} ENDNATIVE !!VALUE
NATIVE {Errno} PROC
PROC Errno( ) IS NATIVE {ISocket->Errno()} ENDNATIVE !!VALUE
NATIVE {SetErrnoPtr} PROC
PROC SetErrnoPtr( errno_ptr:APTR, size:VALUE ) IS NATIVE {ISocket->SetErrnoPtr(} errno_ptr {,} size {)} ENDNATIVE
NATIVE {Inet_NtoA} PROC
PROC Inet_NtoA( ip:IN_ADDR_T ) IS NATIVE {ISocket->Inet_NtoA(} ip {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {inet_addr} PROC
PROC Inet_addr( cp:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->inet_addr(} cp {)} ENDNATIVE !!IN_ADDR_T
NATIVE {Inet_LnaOf} PROC
PROC Inet_LnaOf( in:IN_ADDR_T ) IS NATIVE {ISocket->Inet_LnaOf(} in {)} ENDNATIVE !!IN_ADDR_T
NATIVE {Inet_NetOf} PROC
PROC Inet_NetOf( in:IN_ADDR_T ) IS NATIVE {ISocket->Inet_NetOf(} in {)} ENDNATIVE !!IN_ADDR_T
NATIVE {Inet_MakeAddr} PROC
PROC Inet_MakeAddr( net:IN_ADDR_T, host:IN_ADDR_T ) IS NATIVE {ISocket->Inet_MakeAddr(} net {,} host {)} ENDNATIVE !!IN_ADDR_T
NATIVE {inet_network} PROC
PROC Inet_network( cp:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->inet_network(} cp {)} ENDNATIVE !!IN_ADDR_T
NATIVE {gethostbyname} PROC
PROC Gethostbyname( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->gethostbyname(} name {)} ENDNATIVE !!PTR TO hostent
NATIVE {gethostbyaddr} PROC
PROC Gethostbyaddr( addr:/*STRPTR*/ ARRAY OF CHAR, len:VALUE, type:VALUE ) IS NATIVE {ISocket->gethostbyaddr(} addr {,} len {,} type {)} ENDNATIVE !!PTR TO hostent
NATIVE {getnetbyname} PROC
PROC Getnetbyname( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->getnetbyname(} name {)} ENDNATIVE !!PTR TO netent
NATIVE {getnetbyaddr} PROC
PROC Getnetbyaddr( net:IN_ADDR_T, type:VALUE ) IS NATIVE {ISocket->getnetbyaddr(} net {,} type {)} ENDNATIVE !!PTR TO netent
NATIVE {getservbyname} PROC
PROC Getservbyname( name:/*STRPTR*/ ARRAY OF CHAR, proto:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->getservbyname(} name {,} proto {)} ENDNATIVE !!PTR TO servent
NATIVE {getservbyport} PROC
PROC Getservbyport( port:VALUE, proto:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->getservbyport(} port {,} proto {)} ENDNATIVE !!PTR TO servent
NATIVE {getprotobyname} PROC
PROC Getprotobyname( name:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->getprotobyname(} name {)} ENDNATIVE !!PTR TO protoent
NATIVE {getprotobynumber} PROC
PROC Getprotobynumber( proto:VALUE ) IS NATIVE {ISocket->getprotobynumber(} proto {)} ENDNATIVE !!PTR TO protoent
NATIVE {vsyslog} PROC
PROC Vsyslog( pri:VALUE, msg:/*STRPTR*/ ARRAY OF CHAR, args:APTR ) IS NATIVE {ISocket->vsyslog(} pri {,} msg {,} args {)} ENDNATIVE
NATIVE {syslog} PROC
PROC Syslog( pri:VALUE, msg:/*STRPTR*/ ARRAY OF CHAR, first_parameter:VALUE, first_parameter2=0:ULONG, ... ) IS NATIVE {ISocket->syslog(} pri {,} msg {,} first_parameter {,} first_parameter2 {,} ... {)} ENDNATIVE
NATIVE {Dup2Socket} PROC
PROC Dup2Socket( old_socket:VALUE, new_socket:VALUE ) IS NATIVE {ISocket->Dup2Socket(} old_socket {,} new_socket {)} ENDNATIVE !!VALUE
NATIVE {sendmsg} PROC
PROC Sendmsg( sock:VALUE, msg:PTR TO msghdr, flags:VALUE ) IS NATIVE {ISocket->sendmsg(} sock {,} msg {,} flags {)} ENDNATIVE !!VALUE
NATIVE {recvmsg} PROC
PROC Recvmsg( sock:VALUE, msg:PTR TO msghdr, flags:VALUE ) IS NATIVE {ISocket->recvmsg(} sock {,} msg {,} flags {)} ENDNATIVE !!VALUE
NATIVE {gethostname} PROC
PROC Gethostname( name:/*STRPTR*/ ARRAY OF CHAR, namelen:VALUE ) IS NATIVE {ISocket->gethostname(} name {,} namelen {)} ENDNATIVE !!VALUE
NATIVE {gethostid} PROC
PROC Gethostid( ) IS NATIVE {ISocket->gethostid()} ENDNATIVE !!IN_ADDR_T
NATIVE {SocketBaseTagList} PROC
PROC SocketBaseTagList( tags:PTR TO tagitem ) IS NATIVE {ISocket->SocketBaseTagList(} tags {)} ENDNATIVE !!VALUE
NATIVE {SocketBaseTags} PROC
PROC SocketBaseTags( first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->SocketBaseTags(} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {GetSocketEvents} PROC
PROC GetSocketEvents( event_ptr:PTR TO ULONG ) IS NATIVE {ISocket->GetSocketEvents(} event_ptr {)} ENDNATIVE !!VALUE
/* Ten reserved slots for future expansion */
/* Berkeley Packet Filter (Roadshow extensions start here) */
NATIVE {bpf_open} PROC
PROC Bpf_open( channel:VALUE ) IS NATIVE {ISocket->bpf_open(} channel {)} ENDNATIVE !!VALUE
NATIVE {bpf_close} PROC
PROC Bpf_close( channel:VALUE ) IS NATIVE {ISocket->bpf_close(} channel {)} ENDNATIVE !!VALUE
NATIVE {bpf_read} PROC
PROC Bpf_read( channel:VALUE, buffer:APTR, len:VALUE ) IS NATIVE {ISocket->bpf_read(} channel {,} buffer {,} len {)} ENDNATIVE !!VALUE
NATIVE {bpf_write} PROC
PROC Bpf_write( channel:VALUE, buffer:APTR, len:VALUE ) IS NATIVE {ISocket->bpf_write(} channel {,} buffer {,} len {)} ENDNATIVE !!VALUE
NATIVE {bpf_set_notify_mask} PROC
PROC Bpf_set_notify_mask( channel:VALUE, signal_mask:ULONG ) IS NATIVE {ISocket->bpf_set_notify_mask(} channel {,} signal_mask {)} ENDNATIVE !!VALUE
NATIVE {bpf_set_interrupt_mask} PROC
PROC Bpf_set_interrupt_mask( channel:VALUE, signal_mask:ULONG ) IS NATIVE {ISocket->bpf_set_interrupt_mask(} channel {,} signal_mask {)} ENDNATIVE !!VALUE
NATIVE {bpf_ioctl} PROC
PROC Bpf_ioctl( channel:VALUE, command:ULONG, buffer:APTR ) IS NATIVE {ISocket->bpf_ioctl(} channel {,} command {,} buffer {)} ENDNATIVE !!VALUE
NATIVE {bpf_data_waiting} PROC
PROC Bpf_data_waiting( channel:VALUE ) IS NATIVE {ISocket->bpf_data_waiting(} channel {)} ENDNATIVE !!VALUE
/* Route management */
NATIVE {AddRouteTagList} PROC
PROC AddRouteTagList( tags:PTR TO tagitem ) IS NATIVE {ISocket->AddRouteTagList(} tags {)} ENDNATIVE !!VALUE
NATIVE {AddRouteTags} PROC
PROC AddRouteTags( first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->AddRouteTags(} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {DeleteRouteTagList} PROC
PROC DeleteRouteTagList( tags:PTR TO tagitem ) IS NATIVE {ISocket->DeleteRouteTagList(} tags {)} ENDNATIVE !!VALUE
NATIVE {DeleteRouteTags} PROC
PROC DeleteRouteTags( first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->DeleteRouteTags(} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {FreeRouteInfo} PROC
PROC FreeRouteInfo( buf:PTR TO rt_msghdr ) IS NATIVE {ISocket->FreeRouteInfo(} buf {)} ENDNATIVE
NATIVE {GetRouteInfo} PROC
PROC GetRouteInfo( address_family:VALUE, flags:VALUE ) IS NATIVE {ISocket->GetRouteInfo(} address_family {,} flags {)} ENDNATIVE !!PTR TO rt_msghdr
/* Interface management */
NATIVE {AddInterfaceTagList} PROC
PROC AddInterfaceTagList( interface_name:/*STRPTR*/ ARRAY OF CHAR, device_name:/*STRPTR*/ ARRAY OF CHAR, unit:VALUE, tags:PTR TO tagitem ) IS NATIVE {ISocket->AddInterfaceTagList(} interface_name {,} device_name {,} unit {,} tags {)} ENDNATIVE !!VALUE
NATIVE {AddInterfaceTags} PROC
PROC AddInterfaceTags( interface_name:/*STRPTR*/ ARRAY OF CHAR, device_name:/*STRPTR*/ ARRAY OF CHAR, unit:VALUE, first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->AddInterfaceTags(} interface_name {,} device_name {,} unit {,} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {ConfigureInterfaceTagList} PROC
PROC ConfigureInterfaceTagList( interface_name:/*STRPTR*/ ARRAY OF CHAR, tags:PTR TO tagitem ) IS NATIVE {ISocket->ConfigureInterfaceTagList(} interface_name {,} tags {)} ENDNATIVE !!VALUE
NATIVE {ConfigureInterfaceTags} PROC
PROC ConfigureInterfaceTags( interface_name:/*STRPTR*/ ARRAY OF CHAR, first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->ConfigureInterfaceTags(} interface_name {,} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {ReleaseInterfaceList} PROC
PROC ReleaseInterfaceList( list:PTR TO lh ) IS NATIVE {ISocket->ReleaseInterfaceList(} list {)} ENDNATIVE
NATIVE {ObtainInterfaceList} PROC
PROC ObtainInterfaceList( ) IS NATIVE {ISocket->ObtainInterfaceList()} ENDNATIVE !!PTR TO lh
NATIVE {QueryInterfaceTagList} PROC
PROC QueryInterfaceTagList( interface_name:/*STRPTR*/ ARRAY OF CHAR, tags:PTR TO tagitem ) IS NATIVE {ISocket->QueryInterfaceTagList(} interface_name {,} tags {)} ENDNATIVE !!VALUE
NATIVE {QueryInterfaceTags} PROC
PROC QueryInterfaceTags( interface_name:/*STRPTR*/ ARRAY OF CHAR, first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->QueryInterfaceTags(} interface_name {,} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {CreateAddrAllocMessageA} PROC
PROC CreateAddrAllocMessageA( version:VALUE, protocol:VALUE, interface_name:/*STRPTR*/ ARRAY OF CHAR, result_ptr:ARRAY OF ARRAY OF addressallocationmessage, tags:PTR TO tagitem ) IS NATIVE {ISocket->CreateAddrAllocMessageA(} version {,} protocol {,} interface_name {, (AddressAllocationMessage **) } result_ptr {,} tags {)} ENDNATIVE !!VALUE
NATIVE {CreateAddrAllocMessage} PROC
PROC CreateAddrAllocMessage( version:VALUE, protocol:VALUE, interface_name:/*STRPTR*/ ARRAY OF CHAR, result_ptr:ARRAY OF ARRAY OF addressallocationmessage, first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->CreateAddrAllocMessage(} version {,} protocol {,} interface_name {, (AddressAllocationMessage **) } result_ptr {,} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {DeleteAddrAllocMessage} PROC
PROC DeleteAddrAllocMessage( aam:PTR TO addressallocationmessage ) IS NATIVE {ISocket->DeleteAddrAllocMessage(} aam {)} ENDNATIVE
NATIVE {BeginInterfaceConfig} PROC
PROC BeginInterfaceConfig( message:PTR TO addressallocationmessage ) IS NATIVE {ISocket->BeginInterfaceConfig(} message {)} ENDNATIVE
NATIVE {AbortInterfaceConfig} PROC
PROC AbortInterfaceConfig( message:PTR TO addressallocationmessage ) IS NATIVE {ISocket->AbortInterfaceConfig(} message {)} ENDNATIVE
/* Monitor management */
NATIVE {AddNetMonitorHookTagList} PROC
PROC AddNetMonitorHookTagList( type:VALUE, hook:PTR TO hook, tags:PTR TO tagitem ) IS NATIVE {ISocket->AddNetMonitorHookTagList(} type {,} hook {,} tags {)} ENDNATIVE !!VALUE
NATIVE {AddNetMonitorHookTags} PROC
PROC AddNetMonitorHookTags( type:VALUE, hook:PTR TO hook, first_tag:TAG, first_tag2=0:ULONG, ... ) IS NATIVE {ISocket->AddNetMonitorHookTags(} type {,} hook {,} first_tag {,} first_tag2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {RemoveNetMonitorHook} PROC
PROC RemoveNetMonitorHook( hook:PTR TO hook ) IS NATIVE {ISocket->RemoveNetMonitorHook(} hook {)} ENDNATIVE
/* Status query */
NATIVE {GetNetworkStatistics} PROC
PROC GetNetworkStatistics( type:VALUE, version:VALUE, destination:APTR, size:VALUE ) IS NATIVE {ISocket->GetNetworkStatistics(} type {,} version {,} destination {,} size {)} ENDNATIVE !!VALUE
/* Domain name server management */
NATIVE {AddDomainNameServer} PROC
PROC AddDomainNameServer( address:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->AddDomainNameServer(} address {)} ENDNATIVE !!VALUE
NATIVE {RemoveDomainNameServer} PROC
PROC RemoveDomainNameServer( address:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->RemoveDomainNameServer(} address {)} ENDNATIVE !!VALUE
NATIVE {ReleaseDomainNameServerList} PROC
PROC ReleaseDomainNameServerList( list:PTR TO lh ) IS NATIVE {ISocket->ReleaseDomainNameServerList(} list {)} ENDNATIVE
NATIVE {ObtainDomainNameServerList} PROC
PROC ObtainDomainNameServerList( ) IS NATIVE {ISocket->ObtainDomainNameServerList()} ENDNATIVE !!PTR TO lh
/* Local database access */
NATIVE {setnetent} PROC
PROC Setnetent( stay_open:VALUE ) IS NATIVE {ISocket->setnetent(} stay_open {)} ENDNATIVE
NATIVE {endnetent} PROC
PROC Endnetent( ) IS NATIVE {ISocket->endnetent()} ENDNATIVE
NATIVE {getnetent} PROC
PROC Getnetent( ) IS NATIVE {ISocket->getnetent()} ENDNATIVE !!PTR TO netent
NATIVE {setprotoent} PROC
PROC Setprotoent( stay_open:VALUE ) IS NATIVE {ISocket->setprotoent(} stay_open {)} ENDNATIVE
NATIVE {endprotoent} PROC
PROC Endprotoent( ) IS NATIVE {ISocket->endprotoent()} ENDNATIVE
NATIVE {getprotoent} PROC
PROC Getprotoent( ) IS NATIVE {ISocket->getprotoent()} ENDNATIVE !!PTR TO protoent
NATIVE {setservent} PROC
PROC Setservent( stay_open:VALUE ) IS NATIVE {ISocket->setservent(} stay_open {)} ENDNATIVE
NATIVE {endservent} PROC
PROC Endservent( ) IS NATIVE {ISocket->endservent()} ENDNATIVE
NATIVE {getservent} PROC
PROC Getservent( ) IS NATIVE {ISocket->getservent()} ENDNATIVE !!PTR TO servent
/* Address conversion */
NATIVE {inet_aton} PROC
PROC Inet_aton( cp:/*STRPTR*/ ARRAY OF CHAR, addr:PTR TO in_addr ) IS NATIVE {ISocket->inet_aton(} cp {,} addr {)} ENDNATIVE !!VALUE
NATIVE {inet_ntop} PROC
PROC Inet_ntop( af:VALUE, src:APTR, dst:/*STRPTR*/ ARRAY OF CHAR, size:VALUE ) IS NATIVE {ISocket->inet_ntop(} af {,} src {,} dst {,} size {)} ENDNATIVE !!/*STRPTR*/ ARRAY OF CHAR
NATIVE {inet_pton} PROC
PROC Inet_pton( af:VALUE, src:/*STRPTR*/ ARRAY OF CHAR, dst:APTR ) IS NATIVE {ISocket->inet_pton(} af {,} src {,} dst {)} ENDNATIVE !!VALUE
NATIVE {In_LocalAddr} PROC
PROC In_LocalAddr( address:IN_ADDR_T ) IS NATIVE {ISocket->In_LocalAddr(} address {)} ENDNATIVE !!VALUE
NATIVE {In_CanForward} PROC
PROC In_CanForward( address:IN_ADDR_T ) IS NATIVE {ISocket->In_CanForward(} address {)} ENDNATIVE !!VALUE
/* Kernel memory management */
NATIVE {mbuf_copym} PROC
PROC Mbuf_copym( m:PTR TO mbuf, off:VALUE, len:VALUE ) IS NATIVE {ISocket->mbuf_copym(} m {,} off {,} len {)} ENDNATIVE !!PTR TO mbuf
NATIVE {mbuf_copyback} PROC
PROC Mbuf_copyback( m:PTR TO mbuf, off:VALUE, len:VALUE, cp:APTR ) IS NATIVE {ISocket->mbuf_copyback(} m {,} off {,} len {,} cp {)} ENDNATIVE !!VALUE
NATIVE {mbuf_copydata} PROC
PROC Mbuf_copydata( m:PTR TO mbuf, off:VALUE, len:VALUE, cp:APTR ) IS NATIVE {ISocket->mbuf_copydata(} m {,} off {,} len {,} cp {)} ENDNATIVE !!VALUE
NATIVE {mbuf_free} PROC
PROC Mbuf_free( m:PTR TO mbuf ) IS NATIVE {ISocket->mbuf_free(} m {)} ENDNATIVE !!PTR TO mbuf
NATIVE {mbuf_freem} PROC
PROC Mbuf_freem( m:PTR TO mbuf ) IS NATIVE {ISocket->mbuf_freem(} m {)} ENDNATIVE
NATIVE {mbuf_get} PROC
PROC Mbuf_get( ) IS NATIVE {ISocket->mbuf_get()} ENDNATIVE !!PTR TO mbuf
NATIVE {mbuf_gethdr} PROC
PROC Mbuf_gethdr( ) IS NATIVE {ISocket->mbuf_gethdr()} ENDNATIVE !!PTR TO mbuf
NATIVE {mbuf_prepend} PROC
PROC Mbuf_prepend( m:PTR TO mbuf, len:VALUE ) IS NATIVE {ISocket->mbuf_prepend(} m {,} len {)} ENDNATIVE !!PTR TO mbuf
NATIVE {mbuf_cat} PROC
PROC Mbuf_cat( m:PTR TO mbuf, n:PTR TO mbuf ) IS NATIVE {ISocket->mbuf_cat(} m {,} n {)} ENDNATIVE !!VALUE
NATIVE {mbuf_adj} PROC
PROC Mbuf_adj( mp:PTR TO mbuf, req_len:VALUE ) IS NATIVE {ISocket->mbuf_adj(} mp {,} req_len {)} ENDNATIVE !!VALUE
NATIVE {mbuf_pullup} PROC
PROC Mbuf_pullup( m:PTR TO mbuf, len:VALUE ) IS NATIVE {ISocket->mbuf_pullup(} m {,} len {)} ENDNATIVE !!PTR TO mbuf
/* Internet servers */
NATIVE {ProcessIsServer} PROC
PROC ProcessIsServer( pr:PTR TO process ) IS NATIVE {-ISocket->ProcessIsServer(} pr {)} ENDNATIVE !!INT
NATIVE {ObtainServerSocket} PROC
PROC ObtainServerSocket( ) IS NATIVE {ISocket->ObtainServerSocket()} ENDNATIVE !!VALUE
/* Default domain name */
NATIVE {GetDefaultDomainName} PROC
PROC GetDefaultDomainName( buffer:/*STRPTR*/ ARRAY OF CHAR, buffer_size:VALUE ) IS NATIVE {-ISocket->GetDefaultDomainName(} buffer {,} buffer_size {)} ENDNATIVE !!INT
NATIVE {SetDefaultDomainName} PROC
PROC SetDefaultDomainName( buffer:/*STRPTR*/ ARRAY OF CHAR ) IS NATIVE {ISocket->SetDefaultDomainName(} buffer {)} ENDNATIVE
/* Global data access */
NATIVE {ObtainRoadshowData} PROC
PROC ObtainRoadshowData( access:VALUE ) IS NATIVE {ISocket->ObtainRoadshowData(} access {)} ENDNATIVE !!PTR TO lh
NATIVE {ReleaseRoadshowData} PROC
PROC ReleaseRoadshowData( list:PTR TO lh ) IS NATIVE {ISocket->ReleaseRoadshowData(} list {)} ENDNATIVE
NATIVE {ChangeRoadshowData} PROC
PROC ChangeRoadshowData( list:PTR TO lh, name:/*STRPTR*/ ARRAY OF CHAR, length:ULONG, data:APTR ) IS NATIVE {-ISocket->ChangeRoadshowData(} list {,} name {,} length {,} data {)} ENDNATIVE !!INT
/* The counterpart to AddInterfaceTagList */
NATIVE {RemoveInterface} PROC
PROC RemoveInterface( interface_name:/*STRPTR*/ ARRAY OF CHAR, force:VALUE ) IS NATIVE {ISocket->RemoveInterface(} interface_name {,} force {)} ENDNATIVE !!VALUE
/* Four reserved slots for future expansion */
/* Ten reserved slots for future expansion */
