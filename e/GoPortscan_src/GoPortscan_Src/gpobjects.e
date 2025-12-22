OPT PREPROCESS
OPT MODULE
OPT EXPORT

/*
    Description: Some custom OBJECTS for Go Portscan.
*/

MODULE 'amitcp/netinet/in',
       'amitcp/sys/time'

#define PCAP_ERRBUF_SIZE 256

->Simple object to help with parsing port entries (link list style)
OBJECT portentry
    lower
    upper
    next:PTR TO portentry
ENDOBJECT

->Object used for integer folding for TCP/IP checksum calculations
OBJECT intfold
    arr[200]:ARRAY OF INT
ENDOBJECT

OBJECT pseudo
    src:in_addr
    dst:in_addr
    place:CHAR
    protocol:CHAR
    len:INT
ENDOBJECT

/*
->Pcap Packet Header Object
OBJECT pcap_pkthdr
    ts:compatible_timeval
    caplen:LONG
    len:LONG
ENDOBJECT

->Object for Miami's custom link header
OBJECT linkheader
packettype:CHAR
linktype:CHAR
padding[14]:ARRAY OF CHAR
ENDOBJECT
*/
