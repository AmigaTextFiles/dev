# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strstr {
    usage "strstr(big, little)" if @_ != 2;
    index($_[0], $_[1]);
}

1;
