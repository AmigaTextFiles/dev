/*
 * igmpv3hack.c - IGMP version 3 multicast join/leave hack
 * by megacz@usa.com
 *
 * Avoid strict aliasing(use '-fno-strict-aliasing') when compiling!!!
*/

#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define MTI_ADDRESS 0x00000000  /* Dummy multicast address for the init.    */
#define SRC_ADDRESS 0x00000000  /* Dummy address for intialization          */
#define DST_ADDRESS 0xE0000016  /* IGMPv3 announce address(224.0.0.22)      */

#define OPT_MIENTER 0x04000000  /* Subscribe to the multicast group         */
#define OPT_MILEAVE 0x03000000  /* Unsubscribe from multicast group         */

#define PTO_DATALEN 10          /* Dummy IGMP packet length                 */



u_int16_t igmp_checksum(u_int16_t *header, int words)
{
  register int wordsreg = words;
  register u_int16_t sum = 0;


  while (wordsreg-- > 0)
  {
    sum += *header++;
  }

  sum = (sum >> 16) + (sum & 0xFFFF);

  sum += (sum >> 16) + 2;

  return (u_int16_t)~sum;
}

int igmp_sendtherequest(u_int32_t dest, void *ptr, int len)
{
  struct sockaddr_in sin;
  struct timeval tv;
  int sock;
  int on = 1;
  int res = 0;

  
  if ((sock = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) >= 0)
  {
    memset(&sin, 0, sizeof(struct sockaddr_in));
    
    sin.sin_family = AF_INET;

    sin.sin_addr.s_addr = htonl(dest);

    tv.tv_sec = 5;

    tv.tv_usec = 0;

    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &tv, 
                                            sizeof(struct timeval));

    setsockopt(sock, IPPROTO_IP, IP_HDRINCL, &on, sizeof(on));

    if (sendto(sock, ptr, len, 0, (struct sockaddr *)&sin,
                                    sizeof(struct sockaddr_in)) > 0)
    {
      res = 1;
    }

    close(sock);
  }

  return res;
}

int igmp_optsel(u_int32_t opt, u_int32_t localip, u_int32_t multiip)
{
  u_int32_t igmp_data[(PTO_DATALEN + 2)] = 
                        {0x46C00028  /*[0]*/ , 0x00004000  /*[1]*/ ,
                         0x01020000  /*[2]*/ , SRC_ADDRESS /*[3]*/ ,
                         DST_ADDRESS /*[4]*/ , 0x94040000  /*[5]*/ ,
                         0x22000000  /*[6]*/ , 0x00000001  /*[7]*/ , 
                         OPT_MIENTER /*[8]*/ , MTI_ADDRESS /*[9]*/ ,
                         0x00000000  /*PAD*/ , 0x00000000  /*PAD*/};
  u_int16_t *igmp_ptr = (u_int16_t *)&igmp_data[0];

 
  igmp_data[3] = localip;

  igmp_data[8] = opt;

  igmp_data[9] = multiip;
  
  igmp_data[2] |= igmp_checksum((u_int16_t *)&igmp_ptr[0], 12);

  igmp_data[6] |= igmp_checksum((u_int16_t *)&igmp_ptr[12], 8);

#if BYTE_ORDER == LITTLE_ENDIAN
  {
    int cnt;


    for(cnt = 0; cnt < PTO_DATALEN; cnt++)
    {
      igmp_data[cnt] = htonl(igmp_data[cnt]);
    }
  }
#endif

  return igmp_sendtherequest(DST_ADDRESS, &igmp_data[0],
                                             sizeof(igmp_data) - 2);
}

int igmp_joingroup(u_int32_t localip, u_int32_t multiip)
{
  return igmp_optsel(OPT_MIENTER, localip, multiip);
}

int igmp_leavegroup(u_int32_t localip, u_int32_t multiip)
{
  return igmp_optsel(OPT_MILEAVE, localip, multiip);
}
