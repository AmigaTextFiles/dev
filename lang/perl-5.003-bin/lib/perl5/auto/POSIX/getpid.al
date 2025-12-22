# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getpid {
    usage "getpid()" if @_ != 0;
    $$;
}

1;
