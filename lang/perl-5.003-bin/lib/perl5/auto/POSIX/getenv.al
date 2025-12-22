# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getenv {
    usage "getenv(name)" if @_ != 1;
    $ENV{$_[0]};
}

1;
