#	Cdrom.pm
#
#	a SDL cdrom manipluation module
#
#	Copyright (C) 2000,2002 David J. Goehrig
#

package SDL::Cdrom;
use strict;
use SDL;

BEGIN {
	use Exporter();
	use vars qw(@ISA @EXPORT);
	@ISA = qw(Exporter);
	@EXPORT = qw/ &CD_NUM_DRIVES /;
}

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	$self->{-number} = shift;
	$self->{-cdrom} = SDL::CDOpen($self->{-number});
	die SDL::GetError() if ( SDL::CD_ERROR() eq SDL::CDStatus($self->{-cdrom}));
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::CDClose($self->{-cdrom});
}

sub CD_NUM_DRIVES {
	return SDL::CDNumDrives();
}

sub name ($) {
	my $self = shift;
	return SDL::CDName($self->{-cdrom});
}

sub status ($) {
	my $self = shift;
	return SDL::sdlpl::sdl_cd_status($self->{-cdrom});
}

sub play ($$$;$$) {
	my ($self,$start,$length,$fs,$fl) = @_;
	return SDL::CDPlayTracks($self->{-cdrom},$start,$length,$fs,$fl);
}

sub pause ($) {
	my $self = shift;
	return SDL::CDPause($self->{-cdrom});
}

sub resume ($) {
	my $self = shift;
	return SDL::CDResume($self->{-cdrom});
}

sub stop ($) {
	my $self = shift;
	return SDL::CDStop($self->{-cdrom});
}

sub eject ($) {
	my $self = shift;
	return SDL::CDEject($self->{-cdrom});
}

sub id ($) {
	my $self = shift;
	return SDL::CDId($self->{-cdrom});
}

sub num_tracks ($) {
	my $self = shift;
	return SDL::CDNumTracks($self->{-cdrom});
}

my $buildtrack = sub {
	my $ptr = shift;
	my %track = ();
	$track{-id} = SDL::CDTrackId($ptr);
	$track{-type} = SDL::CDTrackType($ptr);
	$track{-length} = SDL::CDTrackLength($ptr);
	$track{-offset} = SDL::CDTrackOffset($ptr);
	return \%track;
};

sub track {
	my $self = shift;
	my $number = shift;
	return &$buildtrack(SDL::CDTrack($self->{-cdrom},$number));
}

sub current {
	my $self = shift;
	return $self->track(SDL::CDCurTrack($self->{-cdrom}));
}

sub current_frame {
	my $self = shift;
	return SDL::CDCurFrame($self->{-cdrom});
}

1;

__END__;

=head1 NAME

SDL::Cdrom - a SDL perl extension for managing CD-ROM drives

=head1 SYNOPSIS

	use SDL::Cdrom;
	$cdrom = SDL::Cdrom->new(0);
	$cdrom->play();

=head1 EXPORTS

C<SDL::Cdrom> exports by default only one symbol: C<CD_NUM_DRIVES>.

=head1 DESCRIPTION

=head1 METHODS

=head2 new()

	use SDL::Cdrom;
	my $drive => SDL::Cdrom->new($id);

Create a new SDL::Cdrom object. The passed $id is the number of the drive,
whereas 0 is the first drive etc.

=head2 CD_NUM_DRIVES()

Returns the number of CD-ROM drives present.

=head2 name()

	my $name = $drive->name();

Returns the system dependent name of the CD-ROM device.

=head2 status()

Return the status of the drive.

=head2 play()

	$drive->play ($start,$length,$fs,$fl);

Play a track.

=head2 pause()

Pause the playing.

=head2 resume()

Resume the playing.

=head2 stop()

Stop the playing.

=head2 eject()

Eject the medium in the drive.

=head2 id()

Return the ID of the drive.

=head2 num_tracks()

Return the number of tracks on the medium.

=head2 track()

	$drive->track($number);

=head2 current()

Return the current played track number.

=head2 current_frame()

Return the current frame.

=head1 AUTHORS

 David J. Goehrig
 Documentation by Tels <http://bloodgate.com/>.

=head1 SEE ALSO

See perl(1), L<SDL::Mixer> and L<SDL::App>.

=cut
