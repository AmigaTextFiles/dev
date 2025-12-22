# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getlogin {
    usage "getlogin()" if @_ != 0;
    getlogin();
}

1;
