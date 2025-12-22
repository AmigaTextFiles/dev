# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub geteuid {
    usage "geteuid()" if @_ != 0;
    $> + 0;
}

1;
