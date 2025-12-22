/*
 * This file provides a system independant interface to send and
 * receive ICMP messages.
 */

#ifndef _mod_icmp_h_
#define _mod_icmp_h_

#if defined(__STDC__) || defined(__cplusplus)
#define PROTO(a,b) a b
#else
#define PROTO(a,b) a()
#endif
#ifdef __cplusplus
#define API "C"
#else
#define API
#endif

typedef void* icmp_handle;

/* initialize the ICMP module, return a pointer to it. */
extern icmp_handle PROTO(
   icmp_open,
   (
	void
   ));

/* set a socket option. Returns >= 0 if successful, -1 otherwise */
extern int PROTO(
   icmp_set_option,
   (
	icmp_handle handle,	/* module handle */
	int level,
	int optname,		/* option to be set */
	void *optval,		/* option value */
	int optlen		/* length of option value */
   ));

/* set the timeout for receives */
extern void PROTO(
   icmp_set_timeout,
   (
	icmp_handle handle,
	unsigned long timeout	/* timeout in microseconds */
   ));

/* get the ID used in packets */
extern unsigned short PROTO(
   icmp_get_id,
   (
	icmp_handle handle
   ));

/* send an ICMP message. Returns >= 0 if successful, -1 otherwise */
extern int PROTO(
   icmp_send,
   (
	icmp_handle handle,		/* module handle */
	void *msg,			/* ICMP message contents */
	int msg_size,			/* size */
	struct sockaddr *to_addr,	/* who to send to */
	int to_addr_size		/* sockaddr size */
   ));

/*
 * Wait for an ICMP message.
 * Returns:
 * >0: successful, return value is the packet size
 * 0:  timeout
 * -1: interrupted, should be called again
 */
extern int PROTO(
   icmp_recv,
   (
	icmp_handle handle,		/* module handle */
	char *buffer,			/* buffer pointer */
	int buffer_size,		/* buffer size */
	struct sockaddr *from_addr,
	int *from_addr_size,
	double *elapsed			/* elapsed microseconds since last icmp_send */
   ));

/* close the ICMP module. Returns >= 0 if successful, -1 otherwise */
extern int PROTO(
   icmp_close,
   (
	icmp_handle handle
   ));

#endif	/* End of File */
