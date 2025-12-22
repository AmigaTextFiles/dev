
AgletM2PPC Release Apr 5, 2011

This is an update to Feb 28, 2010 release of a native PPC Modula-2 compiler for Amiga
OS4. AgletM2PPC v3.1 beta implements much of the ISO Modula-2 base standard.

  ------------------------------------------------------------------
  I make no representations about the suitability of this software
  for any purpose. It is provided "as is" without express or implied warranty.
  ------------------------------------------------------------------

This is copyrighted freeware being distributed "as-is".  I hope it can be useful
for anyone interested in developing new generation Amiga software with a
Wirthian language.

  ------------------------------------------------------------------
  release Apr 5, 2011
       - Fixes some compiler code generation errors.
       - Supports Annotate as an associated editor in M2IDE.
       - Updates some Amiga library interfaces to SDK 53.20.        
       - Fixes bugs in REAL I/O in ISO support library.
       - Extends Aglet support modules:
           > AmigaTimer adds "waituntil" and "entropy" features.
           > PipeIO is more efficient and adds a timeout feature.
           > OsRun is a little more filled out.
           > SimpleGraphics can be used for a type of double buffered
             animation.         
  ------------------------------------------------------------------

Even though this is a Beta release, I believe the package is in a fairly
usable condition. I have successfully built a number of non-trivial programs
with it:

 > The pre-Linker used for building programs
 > The M2IDE development environment that comes with it
 > IDLTm2, an IDLTool analogue for producing Interface DEFINITION modules
 > A test generator program, tgM2, for Modula-2
 > The GuideMaker program on OS4Depot
 > The LoggerWindow program on OS4Depot
 > The compiler compiles itself.
 > The Capture Challenge for programmers.
 
It goes without saying the compiler is not competitive with GCC for PPC code
optimization, but it does a good job of creating correct machine code for a
correct Modula-2 program.

Modula-2 is certainly a relatively "obscure" (at least in the U.S)
language, but far from a dead one. A number of compilers are available without
cost for different platforms. There is an ISO standard and most newer compilers,
including AgletM2PPC, cleave closely enough to the standard to achieve good
portability.

It does offer some things you don't get with GNU C:

A better approach to building modular software - You don't have to spend 50% of
your development time figuring out why your "make" file does not work.     :)

A cleaner, simpler language than C, offering a better type system, more rational
array handling, much better design for modular programming supporting Abstract
Data Types and much greater opportunity to change module implementations without
propagating complexity and uncertainty.

Included Amiga oriented support modules designed to enable you to effectively
start using Intuition, Reaction, etc, without having to become an expert in all
the details - Direct calls to all Amiga Libraries are available, but
intermediate modules from Aglet like "SimpleGUI", "SimpleRequesters",
"SimpleImageHander", "SimpleRexx", and "AmigaTimer" expose a straightforward
interface to common needs.

If you do have a the GoldEd (and the Cubic package), do visit OS4 Depot and 
download Frank Ruthe's materials for a very nice extended integration of M2 
into GoldEd 8. Filed as "development/ide/agletm2cubic.lha" It includes a 
very detailed description of how to setup the various features of GoldEd for
this purpose, and also some nice M2 icons.
URL: http://os4depot.net/share/development/ide/agletm2cubic_lha.readme.







