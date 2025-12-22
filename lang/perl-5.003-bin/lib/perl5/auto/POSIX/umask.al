# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub umask {
    usage "umask(mask)" if @_ != 1;
    umask($_[0]);
}

1;
