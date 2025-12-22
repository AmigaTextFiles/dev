#	Font.pm
#
#	a SDL perl extension for SFont support
#
#	Copyright (C) David J. Goehrig 2000,2002
#

package SDL::Font;
use strict;
use SDL;
use SDL::Surface;

use vars qw(@ISA $CurrentFont );
	    

@ISA = qw(SDL::Surface);


sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	$self->{-fontname} = shift;
	$self->{-surface} = SDL::NewFont($self->{-fontname});
	bless $self,$class;
	return $self;	
}

sub DESTROY {
	my $self = shift;
	SDL::FreeSurface($self->{-surface});
}

sub use ($) {
	my $self = shift;
	$CurrentFont = $self;
	if ( $self->isa('SDL::Font')) {
		SDL::UseFont($self->{-surface});
	}	
}

1;

__END__;

=head1 NAME

SDL::Font - a SDL perl extension

=head1 SYNOPSIS

  $font = new Font "Font.png";
  $font->use();
	
=head1 DESCRIPTION



=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

perl(1) SDL::Surface(3)

=cut
