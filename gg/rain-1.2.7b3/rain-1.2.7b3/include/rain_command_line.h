/*--------------------------------------------------*
 * $Header: /usr/src/Projects/rain/RCS/rain_command_line.h,v 1.1 2001/06/11 20:44:09 root Exp root $
 * $Author: root $
 * rain_command_line.h
 * rain - by Evil (mystic@tenebrous.com)
 * A flexible packet flooder for testing stability.
 * Copyright(c) 2001
 * Licensed under the GNU General Public License
 *
 * $Log: rain_command_line.h,v $
 * Revision 1.1  2001/06/11 20:44:09  root
 * Initial revision
 *
 * Revision 1.1  2001/06/11 02:59:47  root
 * Initial revision
 *
 *-------------------------------------------------*/

#ifndef _RAIN_COMMAND_LINE_H
#define _RAIN_COMMAND_LINE_H


extern char *filter_argument(char *);

void parse_command_line(int argc, char **argv,
                        struct pkt_info *,
                        struct pkt_info_tcp  *,
                        struct pkt_info_icmp *,
                        struct pkt_info_igmp *,
                        u_short *);

#endif /* _RAIN_COMMAND_LINE_H */
