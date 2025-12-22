/*

    Packetsupport.lib
    -----------------

    C include definitions & prototypes

    no © by Oliver Wagner,
	    Landsberge 5,
	    4322 Sprockhövel,
	    West Germany.

    Use at your own risk, in everything you want!

*/

/* proto */
long getres2(void);
long __stdargs sendpacket(struct MsgPort*,long,);
long dosinhibit(char*,long);
