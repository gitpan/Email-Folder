use strict;
package Email::Folder;
use Carp;
use IO::File;
use Email::Simple;
use Email::FolderType qw/folder_type/;

use vars qw($VERSION);
$VERSION = "0.6";

=head1 NAME

Email::Folder - read all the messages from a folder.

=head1 SYNOPSIS

 use Email::Folder;

 my $folder = Email::Folder->new("some_file");

 print join "\n", map { $_->header("Subject") }, $folder->messages();

=head1 METHODS

=head2 new($folder)

Takes the name of a folder;

=cut


sub new {
    my $class  = shift;
    my $folder = shift || carp "Must provide a folder name\n";
    my %self = @_;

    my $reader = "Email::Folder::".folder_type($folder);
    eval "require $reader" or die $@;

    $self{_folder} = $reader->new($folder);

    return bless \%self, $class;
}

=head2 bless_message($message)

Takes a raw RFC822 message and blesses it into a class.

By default this is an Email::Simple object but could be overwritten.

=cut

sub bless_message {
    my $self    = shift;
    my $message = shift || die "You must pass a message\n";

    return Email::Simple->new($message);
}


=head2 messages

Returns a list containing all the messages in a folder

=cut

sub messages {
    my $self = shift;

    my @messages = $self->{_folder}->messages;
    my @ret;
    while (my $body = shift @messages) {
        push @ret, $self->bless_message( $body );
    }
    return @ret;
}

=head2 next_message

acts as an iterator.  reads the next message from a folder.  returns
false at the end of the folder

=cut

sub next_message {
    my $self = shift;

    my $body = $self->{_folder}->next_message or return;
    $self->bless_message( $body );
}

1;

__END__

=head1 AUTHOR

Simon Wistow <simon@thegestalt.org>

=head1 COPYING

Copyright 2003, Simon Wistow

Distributed under the same terms as Perl itself.

This software is under no warranty and will probably ruin your life,
kill your friends, burn your house and bring about the doobie brothers.


=head1 SEE ALSO

L<Email::LocalDelivery>, L<Email::FolderType>, L<Email::Simple>

=cut
