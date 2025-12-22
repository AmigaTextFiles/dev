# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strerror {
    usage "strerror(errno)" if @_ != 1;
    local $! = $_[0];
    $! . "";
}

1;
