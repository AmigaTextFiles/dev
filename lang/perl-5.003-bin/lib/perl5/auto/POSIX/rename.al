# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub rename {
    usage "rename(oldfilename, newfilename)" if @_ != 2;
    rename($_[0], $_[1]);
}

1;
