# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub perror {
    print STDERR "@_: " if @_;
    print STDERR $!,"\n";
}

1;
