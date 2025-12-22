# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getgroups {
    usage "getgroups()" if @_ != 0;
    my %seen;
    grep(!$seen{$_}++, split(' ', $) ));
}

1;
