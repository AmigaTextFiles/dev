##   ____ __  __       _        
##  / ___|  \/  | __ _| | _____ 
##  \___ \ |\/| |/ _` | |/ / _ \
##   ___) ||  | | (_| |   <  __/
##  |____/_|  |_|\__,_|_|\_\___|
##                             
##  SMake -- Makefile generator
##
##  SMake is a powerful mechanism to generate standard Makefiles out
##  of skeleton Makefiles which only provide the essential parts.
##  The missing stuff gets automatically filled in by shared include
##  files. A great scheme to create a huge Makefile hierarchy and to
##  keep it consistent for the time of development.  The trick is
##  that it merges the skeleton and the templates in a
##  priority-driven way. The idea is taken from X Consortiums Imake,
##  but the goal here is not inherited system independency, the goal
##  is consistency and power without the need of manually maintaining
##  a Makefile hierarchy. 
##
##  Copyright (C) 1994-1999 Ralf S. Engelschall, <rse@engelschall.com>
##
##  This program is free software; it may be redistributed and/or
##  modified only under the terms of the GNU General Public License,
##  which may be found in the SMake source distribution.  Look at the
##  file COPYING. 
##  
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##  General Public License for more details.
## 
##  smake_getopts.pl -- own getopts() function
##


#   this subroutine is derived from getopts.pl with the enhancement
#   of the "+" metacharater at the format string to allow a list to
#   be build by subsequent occurance of the same option.

sub Getopts {
    my ($argumentative) = @_;
    my (@args, $first, $rest);
    my ($errs) = 0;
    local ($[) = 0;

    @args = split( / */, $argumentative );
    while(@ARGV && ($_ = $ARGV[0]) =~ /^-(.)(.*)/) {
        ($first,$rest) = ($1,$2);
        $pos = index($argumentative,$first);
        if($pos >= $[) {
            if($args[$pos+1] eq ':') {
                shift(@ARGV);
                if($rest eq '') {
                    ++$errs unless @ARGV;
                    $rest = shift(@ARGV);
                }
                eval "\$opt_$first = \$rest;";
            }
            elsif ($args[$pos+1] eq '+') {
                shift(@ARGV);
                if($rest eq '') {
                    ++$errs unless @ARGV;
                    $rest = shift(@ARGV);
                }
                eval "push(\@opt_$first, \$rest);";
            }
            else {
                eval "\$opt_$first = 1";
                if($rest eq '') {
                    shift(@ARGV);
                }
                else {
                    $ARGV[0] = "-$rest";
                }
            }
        }
        else {
            print STDERR "Unknown option: $first\n";
            ++$errs;
            if($rest ne '') {
                $ARGV[0] = "-$rest";
            }
            else {
                shift(@ARGV);
            }
        }
    }
    $errs == 0;
}

1;

#EOF#
