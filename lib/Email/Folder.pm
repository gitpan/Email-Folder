package Email::Folder;

use strict;
use Carp;
use IO::File;
use Email::Simple;
use Email::FolderType qw/folder_type/;

use vars qw($VERSION);
$VERSION = "0.2";

=head1 NAME

Email::Folder -

=head1 SYNOPSIS

 use Email::Folder;

 my $folder = Email::Folder->new("some_file");

 print join "\n", map { $_->header("Subject") }, $folder->messages();

=head1 METHODS

=head2 new <folder>

Takes the name of a folder;

=cut


sub new {
    my $class  = shift;
    my $folder = shift || carp "Must provide a folder name\n";
    my %self   = @_;

    carp "'$folder' does not exist\n" unless (-e $folder);

    $self{_folder} = $folder;
    $self{_type}   = folder_type($folder);

    return bless \%self, $class;
}

=head2 bless_message <message>

Takes a raw RFC822 message and blesses it into a class.

By default this is an Email::Simple object but could be overwritten.

=cut

sub bless_message {
    my $self    = shift;
    my $message = shift || die "You must pass a message\n";

    return Email::Simple->new($message);
}


=head2 messages

Returns a list of all the messages in a folder

=cut

sub messages {
    my $self = shift;
    return @{$self->{_messages}} if defined $self->{_messages};

    my $type = $self->{_type};
    my $class = "Email::Folder::$type";
    eval "require $class";
    $class->can('messages') || croak "$class does not have method 'messages'";

    my @messages = map { $self->bless_message($_) } $class->messages($self->{_folder});
    $self->{_messages} = \@messages;

    return @{$self->{_messages}};
}

=head1 AUTHOR

Simon Wistow <simon@thegestalt.org>

=head1 COPYING

Copyright 2003, Simon Wistow

Distributed under the same terms as Perl itself.

This software is under no warranty and will probably ruin your life, kill your friends, burn your house and brin$


=head1 SEE ALSO

L<Email::LocalDelivery>, L<Email::Folder>, L<Email::Simple>

=cut

1;
