/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_die.c,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_die.c
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_die.c,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:26  root
 * Initial revision
 *
 *-------------------------------------------------*/
#include "rain_common.h"


/* 
 * Print version information
 */
extern void 
DieWithVersion(void) {
  printf("\nrain %s (%s) [%s]\nCompiled %s %s\n",RAIN_VERSION,RAIN_PLATFORM,RAIN_URL,__DATE__,__TIME__);
  exit(0);
}

/* 
 * Main error handling
 */
extern void 
DieWithError(char *error, int errornum) {

  if(errornum == 0); 
  else errno = errornum;

  fprintf(stderr,"\n\n- - Error: %s", error);
  if(errno != 0) fprintf(stderr," (%s)", strerror(errno));

  /* 
   * Print possible solutions to certain error numbers: 
   */
  printf("\n- - Solution:");
  switch(errno) {
    /* 
     * system errors 
     */
    case ENOMEM:{ fprintf(stderr," Try shutting down any unnecessary processes and try again."); break; }

    /* 
     * socket errors - return values determined from man pages 
     */
    case ECONNREFUSED:{ fprintf(stderr," Try a different port"); break; }
    case EMSGSIZE:{ fprintf(stderr," Set packet-size below your outgoing MTU (Usually 1500)"); break; }
    case EACCES:{ fprintf(stderr," Make sure you run this program as root"); break; }
    case TRY_AGAIN:{ fprintf(stderr, " Use a valid hostname"); break; }
    case 11: /* resource temporarily unavailable */
    case NO_RECOVERY:
    case ENETUNREACH:{ fprintf(stderr," Make sure you are connected to the internet"); break; }

    /* 
     * custom errors 
     */
    case R_CONFLICT:{ fprintf(stderr," Do not combine protocol types such as --tcp and --udp"); break; }
    case R_CONFLICTTCP:{ fprintf(stderr," The only TCP type flags that can be combined are --ack and --syn"); break; }
    case R_UNKNOWNICMP:{ fprintf(stderr," Use a valid ICMP type/code combination. Try --help --icmp-type"); break; }
    case R_NOSPOOF:{ fprintf(stderr, " --stream and --connect cannot be used with a spoofed source address"); break; }
    case R_NOPROTO:{ fprintf(stderr, " Specify a protocol to use. ie: --tcp, --udp, --icmp, --igmp"); break; }  
    case R_MAXLINES:{ fprintf(stderr," Make sure the config file you specified does not exceed 80 lines"); break; }
    case R_TOOBIG:{ fprintf(stderr," Make sure payload length does not exceed packet size"); break; }

    default:{ fprintf(stderr," No suggestions for this error."); break; }
  }

  printf("\n");

  /*
   * Free our buffered memory
   */
  freebuf(buffer);
  exit(1);
}


/*
 * Incompatible arguments
 */
extern void
DieWithIncompatible(char *arg1, char *arg2) {
  fprintf(stderr,"\n- - Error: %s is not compatible with %s\n", arg1, arg2); 
  exit(1);
}

/*
 * Bad argument specified
 */
extern void 
DieWithBadArg(char *arg) {
    fprintf(stderr,"\n- - Error: %s is not recognized\n", arg);
    exit(1);
}

/*
 * Argument requires an extra parameter
 */
extern void 
DieWithRequire(char *arg) {
    fprintf(stderr,"\n- - Error: %s requires an argument\n", arg);
    DieWithHelp(NULL,arg);
    exit(1);
}

/*
 * Print usage
 */
extern void 
DieWithUsage(char *program) {
  fprintf(stderr,"\nUsage: %s [options] -t <target-host>\n"
                 "Try %s --help for a list of options.\n", program, program);
  exit(1);
}


/*
 * Print help menu
 *
 * Note: root and normal users have two
 * seperate menus
 */
extern void 
DieWithHelp(char *program, char *topic) {

  int i = 0;
  int userid = getuid();
  static unsigned char siminfo[6][16] = {
    "fawx2.c",
    "bloop.c",
    "jolt2.c",
    "trash2.c",
    "raped.c"
  };

  /*
   * root (userid 0) help menu 
   */
  if((topic == NULL) && (userid == 0)) {
    printf("Usage: %s [options] -t <target-host>\n", program);
    printf("options available for root:\n"
           "  -v                          Causes rain to output more information (verbose)\n"
           "                              Use up to 3 times for more verbose output\n"
	   "  -c      <count>             Specifies how many packets to send\n"
           "                                - Default is 0 (infinite)\n"
           "  -d      <delay>             Specifies delay (in microseconds) between sends\n"
           "                                - Default is 10000\n"
           "  -b                          Specify this option if the target host is a\n"
           "                              broadcast address\n"
           "  -s      <spoofed-hostname>  Specifies source address; 0 for random\n"
           "                                - Default is 127.0.0.1\n"
           "  -t      <target-hostname>   Specifies target address\n"
           "  --size  <bytes>             Specifies packet size in bytes\n"
           "                                - Default is 1024\n"
           "  --dport | -p <target-port>  Specifies port on target host\n"
           "                                - 0 for random; Default is 138\n"
           "  --sport <source-port>       Specifies port on local host\n"
           "                                - 0 for random; Default is 420\n"
           "  --timeout <seconds>         Specifies timeout in seconds\n"
           "                              for streamed packets.\n"
           "  --sim   <sim-number>        Simulate other known attacks\n" 
           "                                (--help --sim for a list of attacks)\n"     
           "\n"
           "  --noblock                   Sets non-blocking I/O on socket\n"
           "\n"
           "  --udp                       Use UDP shower\n"
           "\n"
           "  --tcp                       Use TCP shower (Default)\n"
           "    --stream                  Use a streaming, non-spoofed TCP send shower\n"
           "    --connect                 Use a streaming, non-spoofed TCP connect shower\n"
           "    --seq <number>            Specifies the TCP sequence number\n"
           "                                - Default is process ID\n"
           "    --win <number>            Specifies the TCP window size\n"
           "                                - Default is 56\n"
           "    --urg                     Set TCP URG bit\n"
           "    --ack                     Set TCP ACK bit\n"
           "    --psh                     Set TCP PSH bit\n"
           "    --rst                     Set TCP RST bit\n"
           "    --syn                     Set TCP SYN bit\n"
           "    --fin                     Set TCP FIN bit\n"
           "    --ack-seq <number>        Specifies the initial TCP acknowledgement sequence\n"
           "                                - Default is 0 (overflow)\n"
           "\n"
           "  --icmp                      Use ICMP shower\n"
           "    --list-icmp               Lists ICMP type/code combinations\n"
           "    --icmp-type <number>      Set ICMP type\n"
           "    --icmp-code <number>      Set ICMP code\n"
           "    --icmp-id   <number>      Specifies the ICMP id number\n"
           "    --icmp-seq  <number>      Specifies the ICMP sequences number\n"
           "    --icmp-mtu  <number>      Specifies the allowed MTU for certain ICMP types\n"
           "    --icmp-gw | -g <address>  Specifies the ICMP gateway address\n"
           "\n"
           "  --igmp                      Use IGMP shower\n"
           "    --list-igmp               Lists IGMP type/code combinations\n"
           "    --igmp-type <number>      Set IGMP type\n"
           "    --igmp-code <number>      Set IGMP code\n"
           "    --igmp-ga | -g <address>  Specifies the IGMP group address\n"
           "\n"
           "  --frag  <number>            Set fragment offset; - Default is 0 (No setting)\n"
           "  --df                        Set \"Don't Fragment\" bits\n"
           "  --tos   <number>            Specifies Type of Service value\n"
           "  --ttl   <number>            Specifies the Time to Live of the packet\n"
           "                                - Default is 64\n"
           "  --id    <number>            Specifies the id sequence of the packet\n"
           "                                - Default is the process ID\n"
           "  --id-of                     When specified, rain will overflow the id field of\n"
           "                              each packet by increasing it with each send\n"
           "  --payload | --pl <string>   Specifies an (optional) string to store in the\n" 
	   "                              packet's payload\n"
           "  --fill <ascii-character>    Specifies an ascii character to fill the send\n"
           "                              buffer with.\n"
           "                                - This does not conflict with --payload\n"
           "\n"
           "  --version | -V              Prints version information\n"
           "  --help                      Prints this help menu\n"
           "\nTry %s --help <option> for more information about specific options.\n",
           program);
	   exit(0);
  } 
  /* 
   * Normal user help menu
   */
  else if ((topic == NULL) && (getuid() != 0)) {
    printf("options available for %s:\n"
           "  -v                          Causes rain to output more information (verbose)\n"
           "                              Use up to 3 times for more verbose output\n"
           "  -b                          Specify this option if the target host is a\n"
           "                              broadcast address\n"
           "  -t      <target-hostname>   Specifies target address\n"
           "  -c      <value>             Specifies how many packets to send\n"
           "                                - Default is 0 (infinite)\n"
           "  -d      <delay>             Specifies delay (in microseconds) between sends\n"
           "                                - Default is 10000\n"
           "  --size  <bytes>             Specifies packet size in bytes; - Default is 1024\n"
           "  --timeout <seconds>         Specifies timeout in seconds\n"
           "  --dport | -p <target-port>  Specifies port on target host; - Default is 138\n"
           "  --sport <source-port>       Specifies port on local host; - Default is 420\n"  
           "\n"
           "  --noblock                   Sets non-blocking I/O on socket\n"
           "\n"
           "  --tcp                       Use TCP shower (Default)\n"
           "    --stream                  Use a streaming, non-spoofed TCP send shower\n"
           "    --connect                 Use a streaming, non-spoofed TCP connect shower\n"
           "\n"
           "  --udp                       Use UDP shower\n"
           "\n"
           "  --tos   <number>            Specifies Type of Service value\n"
           "  --ttl   <number>            Specifies the Time to Live of the packet\n"
           "                                - Default is 64\n"
           "  --payload | --pl <string>   Specifies an (optional) string to store in the\n" 
	   "                              packet's payload\n"
           "  --fill <ascii-character>    Specifies an ascii character to fill the send\n"
           "                              buffer with.\n"
           "                                - This does not conflict with --payload\n"
           "\n"
           "  --version | -V              Prints version information\n"
           "  --help                      Prints this help menu\n"
           "\nTry %s --help <option> for more information about specific options.\n",
           getlogin(), program);
    exit(0);
  }
  /*
   * This code is reached of topic is 
   * not NULL (they specified --help <topic>)
   */
  else {
    if(strcmp(topic,"--stream") == 0) { /* --stream */
      printf("\nUsage: --stream\n"
             "This option causes rain to use a TCP streaming send shower.\n"
             "This option can not be used with any packet customization options as\n"
             "it does not use raw sockets (Hence cannot be spoofed).\n\n");
      exit(0);
    }
    if(strcmp(topic,"--connect") == 0) { /* --connect */
      printf("\nUsage: --connect\n"
             "This option causes rain to use a TCP connect shower.\n"
             "This option can not be used with any packet customization options as\n"
             "it does not use raw sockets (Hence cannot be spoofed).\n\n");
      exit(0);
    }
    if(strcmp(topic,"--sim") == 0) { /* --sim */
      printf("\nUsage: --sim <sim-type>\n"
             "This option causes rain to simulate the specified attack.\n"
             "Possible values are:\n");
      for(; i < 5; i++) printf("\t%d - %s\n", i, siminfo[i]);
      printf("\n");
      exit(0);
    }
    if(strcmp(topic,"-s") == 0) { /* -s */
      printf("\nUsage: -s <spoofed-hostname>\n"
             "This specifies the source address to use in packet sending.\n"
             "Be aware that alot of routers will not forward packets with a source "
             "\naddress is not a node in the sender's subnet address, \n"
             "in which case the packets will never arrive at the target host.\n\n");
      exit(0);
    }
    if(strcmp(topic,"--icmp-type") == 0) {
      printf("\nUsage: --icmp-type <ICMP-type>\n"
             "This specifies the type of ICMP packet to send. (RFC 792)\n"
             "Try --list-icmp for a list of ICMP type/code combinations.\n\n");
      exit(0);
    }
    if(strcmp(topic,"--icmp-code") == 0) {
      printf("\nUsage: --icmp-code <ICMP-code>\n"
             "This specifies the code in the ICMP packet to send. (RFC 792)\n"
             "Try --list-icmp for a list of ICMP type/code combinations.\n\n");
      exit(0);
    }
    if(strcmp(topic,"--igmp-type") == 0) {
      printf("\nUsage: --igmp-type <IGMP-type>\n"
             "This specifies the type of IGMP packet to send. (RFC 2236)\n"
             "Try --list-igmp for a list of IGMP type/code combinations.\n\n");
      exit(0);
    }
    if(strcmp(topic,"--igmp-code") == 0) {
      printf("\nUsage: --igmp-code <IGMP-code>\n"
             "This specifies the code in the ICMP packet to send. (RFC 2236)\n"
             "Try --list-igmp for a list of IGMP type/code combinations.\n\n");
      exit(0);
    }
    if((strcmp(topic,"--icmp-gw") == 0) || (strcmp(topic,"-g") == 0) || (strcmp(topic,"--igmp-ga") == 0)) {
      printf("\nUsage: --icmp-gw | --igmp-ga | -g <gateway-host>\n"
             "This specifies the gateway or group address used in certain ICMP and IGMP packets.\n"
             "For ICMP, this is only useful if you are sending an ICMP redirect message.\n"
             "Please see RFC 792 for a more detailed description of ICMP gateway addresses.\n");
      printf("Please see RFC 2236 for a more detailed description of IGMP group addresses.\n\n");
      exit(0);
    }
    if(strcmp(topic,"--frag") == 0) { /* --frag */
      printf("\nUsage: --frag <fragment-offset>\n"
             "This specifies where in the IP datagram each fragment belongs.\n"
             "It is recommended you do not use this option unless you are confident "
             "\nwith what you are doing.\n\n");
     exit(0);
    }
    if(strcmp(topic,"--tos") == 0) {  /* --tos */
      printf("\nUsage: --tos <type-of-service>\n"
             "This specifies the value of the tos field in the IP header.\n"
             "It is recommended you do not use this option unless you are confident "
             "\nwith what you are doing.\n\n");
      exit(0);
    }
    else { fprintf(stderr,"\n- - No help available for %s\n", topic); }
  }
  exit(0);
}
