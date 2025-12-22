
#ifndef CLASSES_MULTIMEDIA_STREAMS_H
#define CLASSES_MULTIMEDIA_STREAMS_H

#include <classes/multimedia/multimedia.h>

/******************************************************************************/
/**** http.stream *************************************************************/
/******************************************************************************/

/* [..G.Q] STRPTR  first line of response (e.g. "HTTP1/1 200 OK") */

#define MMA_Http_Response              (MMA_Dummy + 1100)


/* [..G.Q] STRPTR* parsed response header (table of strings) */

#define MMA_Http_Header                (MMA_Dummy + 1101)


/* [..G.Q] ULONG   number of name-value pairs in the parsed header table */

#define MMA_Http_HeaderEntries         (MMA_Dummy + 1102)


/* [..G..] struct Process*  pointer to network process (send CTRL-C to break  */
/* network operations anytime). */

#define MMA_Http_NetProcess            (MMA_Dummy + 1103)


/* [I.G..] STRPTR  The name of created network process. It can be specified   */
/* at init time, then an application is able to break in object constructor   */
/* typically in GetHostByName() or Connect().                                 */
/* If an [multithreaded] application wants to quit immediately while one of   */
/* http.stream object is still being constructed (OM_NEW), it sends break     */
/* signal to the task of passed name (if it exists). Then OM_NEW will fail    */
/* immediately.                                                               */

#define MMA_Http_NetProcessName        (MMA_Dummy + 1104)


/* [I....] STRPTR  Hostname of proxy server to use. If NULL, connection is    */
/* direct to the host from URL. Default is NULL (no proxy).                   */

#define MMA_Http_ProxyServer           (MMA_Dummy + 1105)


/* [I....] ULONG  Port number of proxy server. This attribute is used only if */
/* MMA_Http_ProxyServer is not NULL. Default is 8080.                        */

#define MMA_Http_ProxyPort             (MMA_Dummy + 1106)


/* [I....] BOOL  Controls autoredirection feature. If a server responds with  */
/* 30x response code and specifies "Location" field in the response header,   */
/* the object can automatically issue a new request with the new location.    */
/* This feature is on by default.                                             */

#define MMA_Http_AutoRedirect          (MMA_Dummy + 1107)


/* [I....] STRPTR  The first part of User-Agent HTTP header field, default is */
/* "unknown", a string "/http.stream-xx.xx(MorphOS)" is appended to this      */
/* string, where "xx.xx" is replaced by http.stream version and revision.     */

#define MMA_Http_UserAgent             (MMA_Dummy + 1108)


/* The method returns value of HTTP header field identified by passed         */
/* 'EntryName'. Field value is returned as NULL-terminated read-only string.  */
/* If a field can't be found in the header, the method returns NULL.          */
/* According to RFC2616 field names are case insensitive.                     */

#define MMM_Http_GetHeaderEntry        (MMA_Dummy + 1199)

struct mmopHttpGetHeaderEntry
{
  ULONG MethodID;
  STRPTR EntryName;
};

/******************************************************************************/
/******************************************************************************/

#endif /* CLASSES_MULTIMEDIA_STREAMS_H */
