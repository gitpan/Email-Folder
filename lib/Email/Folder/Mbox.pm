package Email::Folder::Mbox;

use strict;
use Carp;
use IO::File;


=head1 NAME

Email::Folder::Mbox - reads raw RFC822 mails from an mbox file

=head1 SYNOPSIS

        my $class = 'Email::Folder::Mbox';
        $class->require;
        print map { $_->header('Subject') } $class->messages('somembox');

=head1 DESCRIPTION

Does exactly what it says on the tin - fetches raw RFC822 mailsfrom an mbox.

The mbox format is described at http://www.qmail.org/man/man5/mbox.html

=head1 METHODS

=head2 messages <class> <dir>

Takes the name of an mbox file, returns a list of B<Email::Simple>
objects.

Should really only be called from B<Email::Folder>.

=cut

sub messages {
	my $class = shift;
	my $file  = shift || croak "You must pass a filename";
	
	# sanity checking
	croak "$file does not exist" unless (-e $file);
	croak "$file is not a file"  unless (-f $file);
	

	my $fh = IO::File->new($file) or croak "Cannot open $file";

	# is this a mbox file?
	croak "$file is not an mbox file" unless ($fh->getline()  =~ /^From /);

	my $message;
	my $lastline;	
	my @messages;
	while (<$fh>) {
		# start of a new message?
		if (/^From /) {
			# then create a new Email::Simple object
			push @messages, $message;
			# reset the message
			$message = "";
			# dump the last line (it was blank)
			$lastline = "";
			# and continue where we left off
			next;
		}
		# it wasn't, so we stick it on the end of the message
		$message  .= $lastline;
		# and store this line
		$lastline  = $_;
	}	
	# grab the last message (without last, blank, line)
	push @messages, $message;
	
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
