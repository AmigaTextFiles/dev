                 ** Unofficial Release **
			Bing 1.1.3


Table of Contents
-----------------

1. What is bing ?
2. Infos on bing
3. Installing bing
   1. Installing bing on Unix systems
   2. Installing bing on Windows systems
4. How to use bing
5. Measurement problems
6. Packet loss evaluation
7. Ethernet devices measurement
8. Possible NTP influence
9. Possible enhancements

1. What is bing ?
-----------------

Bing is a point-to-point bandwidth measurement tool (hence the
'b'), based on ping.

Bing determines the real (raw, as opposed to available or average)
throughput on a link by measuring ICMP echo requests roundtrip times
for different packet sizes for each end of the link.

Suppose we are on host A and want to know the throughput between
L1 and L2, two extremities of a point-to-point link.

	A ----( the Internet )--- L1 --- L2

If we know the rtt (roundtrip time) between A and L1, and the rtt
between A and L2, we can deduce the rtt between L1 and L2.

If we do that for two different packet sizes, we can compute the
raw capacity (bps) of the link.

Note that bing can also be used to have an idea of ethernet cards
performance.

Many thanks to the following people for their help, hints, support,
and real beers :

	Marc Baudoin		<babafou@ensta.fr>
	Fran‡ois Berjon		<fcb@gwynedd.frmug.fr.net>
	Julien Boissinot	<jb@spia.freenix.fr>
	St‰phane Bortzmeyer	<bortzmeyer@cnam.fr>
	Jacques Caron		<jcaron@pressimage.net>
	Laurent Chemla		<laurent@brasil.frmug.fr.net>
	Ren‰ Cougnenc		<rene@renux.frmug.fr.net>
	Nat Makarevitch		<nat@nataa.frmug.fr.net>
	Jean-Philippe Nicaise	<nicky@fdn.fr>
	Christian Perrier	<perrier@onera.fr>
	Bertrand Petit		<elrond@imladris.frmug.fr.net>
	Philippe Regnauld	<regnauld@tetard.freenix.fr>
	Ollivier Robert		<roberto@keltia.freenix.fr>
	Herv‰ Schauer		<herve@hsc.fr.net>
	Christophe Wolfhugel	<wolf@pasteur.fr>

Send virtual beers, bug reports, enhancements and flames to :

	Pierre Beyssac		<pb@fasterix.freenix.fr>

2. Infos on bing
----------------

You can subscribe to the "bing-users" mailing list by sending a
mail containing :

	subscribe bing-users

to <majordomo@freenix.fr>.

The posting address is <bing-users@freenix.fr>

3. Installing bing
------------------

The provided source has been compiled and run on :

	Linux 2.0.28
	SunOS 4.1.3
	SunOS 5		(Solaris 2.5)
	AIX 2		(BOSX 2 actually)
	OSF1 V2.0	(DEC Alpha)
	Windows 95
	Windows NT 3.51 and 4.0 on i386

It is expected to compile and run with minor changes in the Makefile on 
many more platforms.

3.1. Installing bing on Unix systems
------------------------------------

You should first edit the Makefile to adjust it to your system. There are 
few options and if your host is in the list above the lines to uncomment 
are already listed. If this is not the case you will have to make a few tries but it should not be very difficult. Send me the options that you had to change together with your "uname -s -r" so that I can add it to the list.

Then (on all systems) :
	$ make
	$ su root
	# make install

bing, like ping, needs to be installed setuid root to be able to
make its own ICMP packets.

3.2. Installing bing on Windows systems
---------------------------------------

To compile bing you must also get the icmp package. This is a 
package which provides the required include files and libraries 
to send and receive ICMP messages.

You may also have to modify the file makefile.nt so that ICMP_DIR points to the place where you have put the ICMP package.

Then the command below should be enough:
	nmake -f makefile.nt

There are options you may add to this command line to customise the result. 
All options are disabled by default:
  - DLL=1
    Links bing with the Dll C library rather. This makes bing much smaller 
    but may require that you ship the Dll with it.

  - DEBUG=1
    Builds a debug version.

  - BROWSER=1
    Generates Visual C++'s "browser" database.

and commands
  - all or <nothing>
    Builds bing.

  - clean
    Removes the generated files.

  - help
    Describes the makefile options.

4. How to use bing
------------------

	1) using 'traceroute', find the IP adresses of the endpoints
	   of the link you want to measure.

	2) try :

		bing -v point1 point2

	   where 'point1' is the nearest endpoint.
	   Option '-v' is useful to be warned of any routing problems.

	3) wait a little for the measure to stabilize.

	4) if after a while, the measurement looks weird (typically,
	   negative or amazing throughputs) have a look at the indicated
	   roundtrip times. If they are too small (below a few milliseconds),
	   try to rerun bing with a bigger packet size :

		bing -S 1000 -v point1 point2

	   CAUTION : do not increase packet size too much, because this
		     could trigger IP fragmentation/reassembly on
		     the link to measure *or* on intermediate links,
		     which messes up the measures completely.

		     If you stay below 1400 bytes, you should be safe
		     (except on SLIP links where you should not go over
		     1000). This depends on the MTU (maximum transmit unit)
		     of the link.

	5) if, after increasing packet size, you still can't get stable
	   results, try to use the -z option. This option fills packets
	   will random data, defeating compressed links.

	6) if you still can't get anything reasonnable, the link you're
	   trying to measure is probably a high-throughput link too far
	   away (network- and throughput-wise) from you, or some weird
	   animal (IP over X25, Frame Relay, ATM, satellite...).

	   You can try to run bing from a better connected machine
	   (with respect to the target link). If you can't, you
	   can always try to think of a way (I'm sure there are)
	   of improving bing to make it work anyway :-).

	   Probably the best solution is to find something else to
	   do (I leave it to your choice entirely, suggestions are :
	   go for a walk, eat, drink, be elected).

5. Measurement problems
-----------------------

There are many cases in which the measurements may not be accurate
(read:  "plain wrong") :

	- links attained through a link of much lower throughput
	  (typically, don't expect to measure a 34Mbps backbone
	  link through your V32bis dialup account). You can
	  expect to measure links about 15 to 30 times faster than
	  the slower link in your path to them, i.e. up to 512kbps
	  through a V32bis modem, up to 2Mbps through a 64kbps
	  link, and so on.

	- saturated links. bing works by measuring the minimal rtts.
	  The more saturated links there are in the measure path,
	  the more time it takes to get a packet through all of
	  them with minimal delay.

	- IP/X25 connections. Due to encapsulation in small packets,
	  it is very difficult to know the "raw" bit capacity
	  because the overhead by IP packet is not fixed and varies
	  with the packet size. However, a clever bing could be
	  able to find out about the encapsulating size by slowly
	  increasing the strobe packet size and detecting steps in
	  the rtt increase.  Maybe one day ;-)

	- more generally, what you might call "hidden multi-hop" links can
	  give strange results. This includes IP over X25, Frame Relay,
	  as well as probably any IP encapsulation over a switched
	  packet network.

	- padding. On many links, the smallest packet size is bigger than
	  the smallest possible IP packet size and padding occurs. For
	  example it happens on ethernet. It tends to give optimistic
	  results.

	- non symmetrical routing : 

		     -----------------<---
		     |			 |
		     |			( somewhere )
		     |			 ^
		     |			 |
	A ---( the Internet )--> L1 ---> L2

	  If the routings are set in such a way that the ICMP echo
	  replies from L2 don't cross the L1-L2 link, bing can't
	  reliably compute the link capacity.

	  It generally happens, at least in France, on links crossing
	  ASs (autonomous systems) between different providers.
	  Sadly, these links happen to be the most interesting to
	  measure, to be able to check providers claims regarding
	  their connection with the rest of the world...

	  I don't think there's an easy way around (this is the
	  same problem as traceroute not being able to report
	  network return paths).

I have been objected that high-bandwidth links with dedicated
routers might be impossible to measure, due to the way these devices
work.

Fast routers are designed in such a way that, when receiving a
packet, they decode the header as soon as possible, even before
the packet is completely received. They can thus decide on an
outgoing route for the packet and might even (I'm not sure about
that) begin resending it before receiving it completely.

This should not directly interfere with ICMP ECHO_REQUEST packets
because these packets must be locally processed and this is generally
done entirely by software at a lower priority when the packet has
been completely received.

Moreover, since bing only considers minimal round-trip times in
its throughput calculations, you only have to expect that some ICMP
ECHO_REQUESTs will be processed by the router as soon as they are
received, which should happen often enough if the router is not
saturated.

6. Packet loss evaluation
-------------------------

Knowing the packet losses on A-L1 and on A-L2, it should be possible
to compute the loss between L1 and L2 :

	A --- L1 --- L2
	   a      b

	A-L1 packet loss = a
	A-L2 packet loss = ab
	L1-L2 packet loss = ab / a

Bing attempts to calculate it, but the results are generally not significant.

7. Ethernet devices measurement
-------------------------------

This might sound surprising, since ethernet throughput is known to
be 10Mbps !

By running bing between two machines on an ethernet, you can evaluate
the CPU overhead induced by memory copies and polled I/O.

For example, between two Sparc 2 running SunOS 4.1.3, I generally
get around 9Mbps. Between two PCs running FreeBSD with NE2000
clones, expect around 4 or 5Mbps (or a little more depending on
processor speed). Between two PCs with 3C509 cards, I get about
7Mbps.

8. Possible NTP influence
-------------------------

Though I never got any evidence of it, it is possible that running
bing on a NTP-synchronized machine introduces a bias in the
measurements, when the NTP daemon makes a small correction while
bing is waiting for an echo reply packet (almost all the time).

I suppose this should mainly have an effect when measuring fast
and far away links, which are difficult or impossible to measure
anyway.

9. Possible enhancements
------------------------

 * It should be possible to measure mono-directional throughput by
varying the packet size only for one of the packets, the sent packet or
the received packet.

For example, sending variable-sized ICMP ECHO_REPLY packets with a 
small TTL should elicit fixed-size "ttl exceeded" replies.

 * Another interesting extension would be a mechanism trying to
determine the optimal big packet size in such a way that the
measurement is accurate enough yet fast.

 * Bing derives from ping and it shows. Its structure could probably be 
enhanced, modularised and simplified. Also many options that were 
significant for ping are not significant for bing and could be removed.

 * Most of the IP options are not supported by the icmp part of the 
Win32 version. While they may not really be needed it they could be 
by building the IP options by hand.

 * The Win32 error reporting needs to be fixed. It reflects more what
could have happened on Unix that what actually happened and the error
codes are usually incorrect.

 * The makefile is probably too Visual C++ centric. I'd be interested in a 
makefile for Borland or Watcom or other.

 * An option to disable the "smart" display of the measured bandwidth could
ease the parsing of the results by a script.
