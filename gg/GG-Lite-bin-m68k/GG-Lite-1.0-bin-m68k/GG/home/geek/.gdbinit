#
# .gdbinit (Customizing the debugger)
# by William B. Zimmerly (bill@zimmerly.com)
#

#
# This disables readline  editing. It is necessary on the  Amiga cus there
# is something wrong with termcap/terminfo  being unable to  interpret key
# presses while using native keymap!
#
set editing off

#
# Breakpoint aliases. It's a well-known fact that many of the GDB commands
# are  too verbose. Even  though they can be  abbreviated, the  GDB  macro
# language allows for even greater simplifications.
#
define cls
shell clear
end
document cls
Clears the screen with a simple command.
end

define bpl
info breakpoints
end
document bpl
List breakpoints
end

define bp
set $SHOW_CONTEXT = 1
break * $arg0
end
document bp
Set a breakpoint on address
Usage: bp addr
end

define bpc
clear $arg0
end
document bpc
Clear breakpoint at function/address
Usage: bpc addr
end

define bpe
enable $arg0
end
document bpe
Enable breakpoint #
Usage: bpe num
end

define bpd
disable $arg0
end
document bpd
Disable breakpoint #
Usage: bpd num
end

define bpt
set $SHOW_CONTEXT = 1
tbreak $arg0
end
document bpt
Set a temporary breakpoint on address
Usage: bpt addr
end

define bpm
set $SHOW_CONTEXT = 1
awatch $arg0
end
document bpm
Set a read/write breakpoint on address
Usage: bpm addr
end

#
# Hexadecimal and  ASCII dumping commands. The  next set of definitions to
# incorporate  into the .gdbinit file  includes enhanced  hexadecimal  and
# ASCII dump functions.
#
define ascii_char
set $_c=*(unsigned char *)($arg0)
if ( $_c < 0x20 || $_c > 0x7E )
printf "."
else
printf "%c", $_c
end
end
document ascii_char
Print the ASCII value of arg0 or '.' if value is unprintable
end

define hex_quad
printf "%02X %02X %02X %02X  %02X %02X %02X %02X",                          \
               *(unsigned char*)($arg0), *(unsigned char*)($arg0 + 1),      \
               *(unsigned char*)($arg0 + 2), *(unsigned char*)($arg0 + 3),  \
               *(unsigned char*)($arg0 + 4), *(unsigned char*)($arg0 + 5),  \
               *(unsigned char*)($arg0 + 6), *(unsigned char*)($arg0 + 7)
end
document hex_quad
Print eight hexadecimal bytes starting at arg0
end

define hexdump
printf "%08X : ", $arg0
hex_quad $arg0
printf " - "
hex_quad ($arg0+8)
printf " "

ascii_char ($arg0)
ascii_char ($arg0+1)
ascii_char ($arg0+2)
ascii_char ($arg0+3)
ascii_char ($arg0+4)
ascii_char ($arg0+5)
ascii_char ($arg0+6)
ascii_char ($arg0+7)
ascii_char ($arg0+8)
ascii_char ($arg0+9)
ascii_char ($arg0+0xA)
ascii_char ($arg0+0xB)
ascii_char ($arg0+0xC)
ascii_char ($arg0+0xD)
ascii_char ($arg0+0xE)
ascii_char ($arg0+0xF)

printf "\n"
end
document hexdump
Display a 16-byte hex/ASCII dump of arg0
end

define ddump
printf "[%04X:%08X]------------------------", $ds, $data_addr
printf "---------------------------------[ data]\n"
set $_count=0
while ( $_count < $arg0 )
set $_i=($_count*0x10)
hexdump ($data_addr+$_i)
set $_count++
end
end
document ddump
Display $arg0 lines of hexdump for address $data_addr
end

define dd
if ( ($arg0 & 0x40000000) || ($arg0 & 0x08000000) || ($arg0 & 0xBF000000) )
set $data_addr=$arg0
ddump 0x10
else
printf "Invalid address: %08X\n", $arg0
end
end
document dd
Display 16 lines of a hex dump for $arg0
end
