# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub chmod {
    usage "chmod(mode, filename)" if @_ != 2;
    chmod($_[0], $_[1]);
}

1;
