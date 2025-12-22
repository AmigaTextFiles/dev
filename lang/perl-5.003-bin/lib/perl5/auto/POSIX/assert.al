# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub assert {
    usage "assert(expr)" if @_ != 1;
    if (!$_[0]) {
	croak "Assertion failed";
    }
}

1;
