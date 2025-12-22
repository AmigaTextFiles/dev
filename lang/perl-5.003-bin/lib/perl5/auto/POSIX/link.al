# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub link {
    usage "link(oldfilename, newfilename)" if @_ != 2;
    link($_[0], $_[1]);
}

1;
