# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub raise {
    usage "raise(sig)" if @_ != 1;
    kill $$, $_[0];	# Is this good enough?
}

1;
