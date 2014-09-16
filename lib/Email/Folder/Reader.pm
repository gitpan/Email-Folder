use strict;
use warnings;
package Email::Folder::Reader;
# ABSTRACT: reads raw RFC822 mails from a box
$Email::Folder::Reader::VERSION = '0.859';
use Carp;

#pod =head1 SYNOPSIS
#pod
#pod  use Email::Folder::Reader;
#pod  my $box = Email::Folder::Reader->new('somebox');
#pod  print $box->messages;
#pod
#pod or, as an iterator
#pod
#pod  use Email::Folder::Reader;
#pod  my $box = Email::Folder::Reader->new('somebox');
#pod  while ( my $mail = $box->next_message ) {
#pod      print $mail;
#pod  }
#pod
#pod =head1 METHODS
#pod
#pod =head2 new($filename, %options)
#pod
#pod your standard class-method constructor
#pod
#pod =cut

sub new {
    my $class = shift;
    my $file  = shift || croak "You must pass a filename";
    bless { eval { $class->defaults },
            @_,
            _file => $file }, $class;
}

#pod =head2 ->next_message
#pod
#pod returns the next message from the box, or false if there are no more
#pod
#pod =cut

sub next_message {
}

#pod =head2 ->messages
#pod
#pod Returns all the messages in a box
#pod
#pod =cut

sub messages {
    my $self = shift;

    my @messages;
    while (my $message = $self->next_message) {
        push @messages, $message;
    }
    return @messages;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Email::Folder::Reader - reads raw RFC822 mails from a box

=head1 VERSION

version 0.859

=head1 SYNOPSIS

 use Email::Folder::Reader;
 my $box = Email::Folder::Reader->new('somebox');
 print $box->messages;

or, as an iterator

 use Email::Folder::Reader;
 my $box = Email::Folder::Reader->new('somebox');
 while ( my $mail = $box->next_message ) {
     print $mail;
 }

=head1 METHODS

=head2 new($filename, %options)

your standard class-method constructor

=head2 ->next_message

returns the next message from the box, or false if there are no more

=head2 ->messages

Returns all the messages in a box

=head1 AUTHORS

=over 4

=item *

Simon Wistow <simon@thegestalt.org>

=item *

Richard Clamp <richardc@unixbeard.net>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2006 by Simon Wistow.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
