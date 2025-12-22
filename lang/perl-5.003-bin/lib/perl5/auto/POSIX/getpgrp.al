# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getpgrp {
    usage "getpgrp()" if @_ != 0;
    getpgrp($_[0]);
}

1;
