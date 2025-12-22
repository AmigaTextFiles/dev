# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub setuid {
    usage "setuid(uid)" if @_ != 1;
    $< = $_[0];
}

1;
