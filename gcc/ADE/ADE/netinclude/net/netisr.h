/*
 * Frame dispatchers set an appropriate protocol input queue bit 
 */

#define	NETISR_RAW	0		/* same as AF_UNSPEC */
#define	NETISR_IP	2		/* same as AF_INET */
#define	NETISR_IMP	3		/* same as AF_IMPLINK */
#define	NETISR_NS	6		/* same as AF_NS */
#define	NETISR_ISO	7		/* same as AF_ISO */
#define	NETISR_CCITT	10		/* same as AF_CCITT */
#define NETISR_ARP      31

void schednetisr(int isr);
void schednetisr_nosignal(int isr);
void net_poll(void);
