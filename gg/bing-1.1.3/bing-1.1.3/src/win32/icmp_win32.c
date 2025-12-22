/*
 * This module provides an interface to send and receive ICMP messages
 * which is closer to the way Unix programs are written than the standard
 * WIN32 icmp dll's interface.
 */


#include "win32/win32.h"
#include <winsock.h>
#include "win32/types.h"

#include "netinet/ip.h"
#include "netinet/ip_var.h"
#include "netinet/ip_icmp.h"

#include <ipexport.h>
#include <icmpapi.h>

#include "mod_icmp.h"

#include <malloc.h>
#include <errno.h>

typedef struct {
		HANDLE			hICMP;		/* The ICMP dll handle */

		/* "Socket" options */
		int			rcvbufsize;	/* Size of the receive buffer */
		struct ip_option_information ip_options;/* The IP options */
		unsigned long		timeout;	/* Time to wait for a reply */

		/* A few things to remember about the request */
		u_short			msg_id;
		u_short			msg_seq;

		/* Some fields to process the answers */
		struct icmp_echo_reply* rcvbuf;		/* The buffer in which */
							/* IcmpSendEcho will store the answers */
		int			nb_replies;	/* -1 => message not sent yet. */
									/* >=0 => number of reply messages */
		struct icmp_echo_reply*	current;	/* Pointer to next reply */

		LARGE_INTEGER rtt_in_ticks;		/* This is our own measurment of the RTT */
		LARGE_INTEGER ticks_freq;
	} icmp_state_i;

#define handle2state(h)		((icmp_state_i*)h)

icmp_handle icmp_open()
{
	icmp_state_i* handle;

	/* Perform some initialisation to ease error recovery */
	handle=NULL;

	/* Give a higher priority so that bing has better 
	 * chances not to be delayed when measuring the RTT.
	 */
	SetPriorityClass(GetCurrentProcess(),HIGH_PRIORITY_CLASS);

	/* Allocate the handle */
	handle=malloc(sizeof(icmp_state_i));

	/* Fill defaults */
	handle->hICMP=IcmpCreateFile();
	handle->rcvbufsize=4096;
	handle->rcvbuf=NULL;
	handle->nb_replies=-1;
	QueryPerformanceFrequency(&handle->ticks_freq);

	/* Set options defaults */
	handle->ip_options.Ttl=255;
	handle->ip_options.Tos=0;
	handle->ip_options.Flags=0;
	handle->ip_options.OptionsSize=0;
	handle->ip_options.OptionsData=NULL;
	return (icmp_handle)handle;

error:
	if (handle!=NULL)
		free(handle);
	return NULL;
}

int icmp_set_option(icmp_handle handle, int level, int optname, char* optval,
						   int optlen)
{
	int ret;

	ret=0;
	switch (level) {
	case IPPROTO_IP:
			/* The IP options are handled by building the 
			 * corresponding IP structure by hand.
			 */
			/* No IP option is supported yet */
			errno=ENOSYS;
			ret=-1;
		break;
	case SOL_SOCKET:
		switch (optname) {
		case SO_RCVBUF:
			handle2state(handle)->rcvbufsize=*((int*)optval);
			break;
		default:
			errno=ENOSYS;
			ret=-1;
			break;
		}
		break;
	default:
		errno=ENOSYS;
		ret=-1;
	}

	return ret;
}

void icmp_set_timeout(icmp_handle handle,unsigned long timeout)
{
	handle2state(handle)->timeout=timeout/1000;
}

unsigned short icmp_get_id(icmp_handle handle)
{
	return handle2state(handle)->msg_id;
}

int icmp_send(icmp_handle handle, char* msg, int msg_size, 
			  struct sockaddr* to_addr, int to_addr_size)
{
	DWORD reply_size;
	LARGE_INTEGER start,stop;
	static int nb_toohigh=0,nb=0;
	static int icmp_min=1000000,query_min=1000000;

	/* Record some information for the recv */
	handle2state(handle)->msg_id=((struct icmp*)msg)->icmp_id;
	handle2state(handle)->msg_seq=((struct icmp*)msg)->icmp_seq;

	/* allocate the buffer for the replies */
	handle2state(handle)->rcvbuf=realloc(handle2state(handle)->rcvbuf,
		handle2state(handle)->rcvbufsize);

	QueryPerformanceCounter(&start);
	handle2state(handle)->nb_replies=IcmpSendEcho(
		handle2state(handle)->hICMP,
		*((IPAddr*)&(((struct sockaddr_in*)to_addr)->sin_addr)),
		msg+ICMP_MINLEN,
		(WORD)(msg_size-ICMP_MINLEN),
		&handle2state(handle)->ip_options,
		handle2state(handle)->rcvbuf,
		handle2state(handle)->rcvbufsize,
		handle2state(handle)->timeout
		);
	QueryPerformanceCounter(&stop);
	if ((handle2state(handle)->ticks_freq.QuadPart!=0) && 
	    (handle2state(handle)->nb_replies==1)) {
		/* If we have a high performance counter, use it to measure 
		 * the RTT. The high performance counter will either give us 
		 * a much more precise measure of the RTT than the ICMP 
		 * library or it will give us a gross exageration of the RTT 
		 * if the execution of our process has been delayed by the 
		 * scheduler. Statistically this should give much better 
		 * results than the ICMP library (which tends to sometimes 
		 * under-estimate the RTT by up to nearly 2 ms which is 
		 * BAD in our case.
		 */
		handle2state(handle)->rtt_in_ticks.QuadPart=
			stop.QuadPart-start.QuadPart;
	} else
		handle2state(handle)->rtt_in_ticks.QuadPart=0;

	if (handle2state(handle)->nb_replies==0) {
		if (GetLastError()==IP_REQ_TIMED_OUT)
			return 0;
		printf("icmp_send: error %d\n",GetLastError());
		errno=GetLastError();
		return -1;
	}
	handle2state(handle)->current=handle2state(handle)->rcvbuf;
	return msg_size;
}

int icmp_recv(icmp_handle handle, char* buffer, int buffer_size,
			  struct sockaddr* from_addr, int* from_addr_size, 
			  double* elapsed)
{
	if (handle2state(handle)->nb_replies>0) {
		struct ip*	ip_msg;
		struct icmp*	icmp_msg;

		/* Misc return values */
		((struct sockaddr_in*)from_addr)->sin_family=AF_INET;
		((struct sockaddr_in*)from_addr)->sin_port=0;
		memcpy(&(((struct sockaddr_in*)from_addr)->sin_addr),
			&handle2state(handle)->current->Address,4);
		if (handle2state(handle)->rtt_in_ticks.QuadPart==0)
			*elapsed=(double)(handle2state(handle)->current->RoundTripTime);
		else
			*elapsed=((double)(handle2state(handle)->rtt_in_ticks.QuadPart*1000))/
				handle2state(handle)->ticks_freq.QuadPart;

		/* Reconstruct the ip header */
		ip_msg=(struct ip*)buffer;
		ip_msg->ip_v=4;
		ip_msg->ip_hl=(sizeof(struct ip)
			+handle2state(handle)->current->Options.OptionsSize) >> 2;
		ip_msg->ip_tos=handle2state(handle)->current->Options.Tos;
		ip_msg->ip_len=((ip_msg->ip_hl) << 2)
			+ICMP_MINLEN
			+handle2state(handle)->current->DataSize;
		ip_msg->ip_id=0;
		ip_msg->ip_off=0;
		ip_msg->ip_ttl=handle2state(handle)->current->Options.Ttl;
		ip_msg->ip_p=0;
		ip_msg->ip_sum=0;
		memcpy(&(ip_msg->ip_src),&handle2state(handle)->current->Address,4);
		memset(&ip_msg->ip_dst,0,4);
		if (handle2state(handle)->current->Options.OptionsSize>0)
			memcpy(buffer+sizeof(struct ip),
				handle2state(handle)->current->Options.OptionsData,
				handle2state(handle)->current->Options.OptionsSize);

		/* Reconstruct the icmp header */
		icmp_msg=(struct icmp*)(buffer+((ip_msg->ip_hl) << 2));
		switch (handle2state(handle)->current->Status) {
		/* Echo Reply (what we expect) */
		case IP_SUCCESS:
			icmp_msg->icmp_type=0;
			icmp_msg->icmp_code=0;
			icmp_msg->icmp_id=handle2state(handle)->msg_id;
			icmp_msg->icmp_seq=handle2state(handle)->msg_seq;
			break;

		/* Destination Unreachable */
		case IP_DEST_NET_UNREACHABLE:
			icmp_msg->icmp_type=3;
			icmp_msg->icmp_code=0;
			break;
		case IP_DEST_HOST_UNREACHABLE:
			icmp_msg->icmp_type=3;
			icmp_msg->icmp_code=1;
			break;
		case IP_DEST_PROT_UNREACHABLE:
			icmp_msg->icmp_type=3;
			icmp_msg->icmp_code=2;
			break;
		case IP_DEST_PORT_UNREACHABLE:
			icmp_msg->icmp_type=3;
			icmp_msg->icmp_code=3;
			break;

		/* Time Exceeded */
		case IP_TTL_EXPIRED_TRANSIT:
			icmp_msg->icmp_type=11;
			icmp_msg->icmp_code=0;
			break;
		case IP_TTL_EXPIRED_REASSEM:
			icmp_msg->icmp_type=11;
			icmp_msg->icmp_code=1;
			break;

		/* Parameter Problem */
		case IP_PARAM_PROBLEM:
			icmp_msg->icmp_type=12;
			icmp_msg->icmp_code=0;
			/* how can I get a value for the pointer field ? */
			break;

		/* Source Quench */
		case IP_SOURCE_QUENCH:
			icmp_msg->icmp_type=4;
			icmp_msg->icmp_code=0;
			break;

		default:
			handle2state(handle)->nb_replies--;
			handle2state(handle)->current++;
			return -handle2state(handle)->current->Status;
		}

		/* Who cares about the checksum ? */
		icmp_msg->icmp_cksum=0;

		/* Copy data */
		memcpy(buffer+((ip_msg->ip_hl) << 2)+ICMP_MINLEN,
			handle2state(handle)->current->Data,
			handle2state(handle)->current->DataSize);

		handle2state(handle)->nb_replies--;
		handle2state(handle)->current++;
		return ip_msg->ip_len;
	} else
		return 0;
}

int icmp_close(icmp_handle handle)
{
	int ret;

	ret=IcmpCloseHandle((HANDLE)(((icmp_state_i*)handle)->hICMP));
	free(handle);
	return (ret?0:-1);
}
