package Email::Folder::Maildir;

use strict;
use Carp;
use IO::File;


=head1 NAME

Email::Folder::Maildir - reads raw RFC822 mails from a maildir

=head1 SYNOPSIS

	my $class = 'Email::Folder::Email';
	$class->require;
	print map { $_->header('Subject') } $class->messages('somedir');

=head1 DESCRIPTION

Does exactly what it says on the tin - fetches raw RFC822 mails from a maildir.

The maildir format is described at http://www.qmail.org/man/man5/maildir.html

=head1 METHODS

=head2 messages <class> <dir>

Takes a maildir directory, returns a list of B<Email::Simple> 
objects.

=cut

sub messages {
	my $class = shift;
	my $dir   = shift || croak "You must pass a filename";
	
	# sanity checking
	croak "$dir does not exist"    unless (-e $dir);
	croak "$dir is not a maildir"  unless (-d $dir);
	croak "$dir is not a maildir"  unless (-e "$dir/cur" && -d "$dir/cur");
	croak "$dir is not a maildir"  unless (-e "$dir/cur" && -d "$dir/new");
	
	my @messages = ();
	# ignore the tmp directory although the spec
	# says to delete anything in tmp/ that is older than 36 hours
	for my $sub (qw(new cur)) {
		opendir(DIR,"$dir/$sub") or croak "Could not open '$dir/$sub'";
		foreach my $file (readdir DIR)
		{
			next if $file =~ /^\./; # as suggested by DJB
			open FILE, "$dir/$sub/$file" or croak "Couldn't open file $dir/$sub/$file for reading";
			# I'm also wondering whether I should set X-headers for the various flags
			push @messages, join '', <FILE>;
		}
	}

	return @messages;
	
}

=head1 AUTHOR

Simon Wistow <simon@thegestalt.org>

=head1 COPYING

(C)opyright 2003, Simon Wistow

Distributed under the same terms as Perl itself.

This software is under no warranty and will probably ruin your life, kill your friends, burn your house and brin$

=head1 SEE ALSO

L<Email::LocalDelivery>, L<Email::Folder>

=cut

1;
