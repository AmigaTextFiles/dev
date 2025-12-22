
        PMDis v0.06 - a disassembler for Pokemon-Mini
                  (c) 2004 Jouni 'Mr.Spiv' Korhonen


What?


Why?


How?
        If you are familiar with Rossi Monitor which was a popular
        monitor for Amiga then you will find PMDis very similar in
        spirit and usage.

        PMDis has a couple of command line options:

        <!-- begin example --!>

        tromax:pmdis$ ./pmdis
        Usage: ./pmdis [-<options>] rom-file
        Options:
          -l n        List n lines
          -b address  ROM base address in hex
          -s n        Add n bytes of empty space
          -S address  Start address for dump disassembly
          -E address  End address for dump disassembly


        <!-- end example --!>

        -l will define the number of lines that are displayed during
           disassembly or memory dump. Default is 20 lines.

        -b sets the base address for loaded rom-file.

        -s defines how much extra space is added at the end of loaded
           rom-file. This is useful when, for example, patching
           existing roms and you need to write your own code at the
           end of rom. PMDis does not allow accessing memory areas
           autside the loaded rom-file. The default is 0.

        -S and -E are used in so called dump mode. The dump mode
           allows you to disassemble the entire rom at once. For
           example if you want to disassemle PM's code
           starting from 0x2100 then use options like:
           tromax:pmdis$ ./pmdis -b 0 -S 2100 -E 8000 tp-party.min > dump.txt

           -S defaults to the start of the rom-file (i.e. base address)
           and -E defaults to the end of  the rom-file.


        At the moment PMDis has few usable command during the
        interactive usage. An example:

        <!-- begin example --!>

        tromax:pmdis$ ./pmdis tp-party.min 

        Pokemon-Mini aware Disassembler v0.06
           (c) 2004 Jouni 'Mr.Spiv' Korhonen

        Loaded 524288 (80000h) bytes. Extra space is 0 bytes.

        -> h

        Quick Command Reference

        <CRLF>             -> repeat some previous commands without parameters
        : address bytes .. -> poke bytes into memory
        D                  -> disasseble starting from previous address
        d [address]        -> disasseble starting from address
        h                  -> print short command manual
        help               -> print short command manual
        m [address]        -> dump memory starting from address
        r name start [len]  -> read file into rom starting from start
        rom                -> print PM rom info
        w name start end   -> save rom between start and end
        x                  -> exit
        ->

        <!-- end example --!>

        : pokes bytes/shorts/longs into the rom. like:
           -> : 10 22 _22 1af 123d5 

          would write following bytes starting from 0x10:
          0x22 0x16 0x01 0xaf 0x00 0x01 0x23 0xd5

          Note if the number starts with an underscore then PMDis
          handles it as a decimal. This rule applies to all numbers
          and addresses.

        d disassembles nn lines of code starting from address. If you
          leave the address out the disassembly continues from where the
          disassembly stopped last time.

        D re-disassembles the previous disassembly.

        m dumps nn lines of memory in hexadecimals and in ascii
          formats. If you leave the address out the the dump continues
          from where the dump stopped last time.

        <CRLF> if you press enter/return after 'd' and 'm' commands
          it is handled as 'd' and 'm' commands without the address
          field.

        h and help displays a short help page.

        r reads data file named 'name' into the rom-file starting from
          start with optional max length.

        rom displays the rom-file information. If the rom-file is a
          NGP cart rom then the header structure information get
          displayed.

        x exits the PMDis.

        w writes rom data between start and end addresses to a file
          named 'name'.


Contact:
        jouni.korhonen@sonera.inet.fi
		http://www.deadcoderssociety.tk

ToDo:


Copyright & Distribution:
        PMDis is freeware! You go and do what ever you want with these
        sources. If you use them for your own projects, please, give
        me a credit.

        If you happen to e.g. add new commands, please, support the
        Pokemon-Mini scene and send them to me and other developers.

History:

















