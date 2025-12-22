/*
 * Do diagnostic tests which are not necessary in production version
 */
#define DIAGNOSTIC 1

/*
 * Be compatible with BSD 4.2. Affects only checksumming of UDP data. If true
 * the checksum is NOT calculated by default.
 */
#define COMPAT_42 0

/*
 * Make TCP compatible with BSD 4.2
 */
#define TCP_COMPAT_42 0

/*
 * protocol families
 */
#define INET 1
#define CCITT 0
#define NHY 0			/* HYPERchannel */
#define NIMP 0
#define ISO 0
#define NS 0
#define RMP 0

/*
 * optional protocols over IP
 */
#define NSIP 0
#define EON 0
#define TPIP 0

/*
 * default values for IP configurable flags
 */
#define IPFORWARDING    0
#define IPSENDREDIRECTS 1
#define IPPRINTFS       0

/*
 * Network level
 */
#define NETHER 1		/* Call ARP ioctl */
