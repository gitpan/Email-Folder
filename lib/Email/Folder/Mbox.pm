package Email::Folder::Mbox;
use strict;
use Carp;
use IO::File;
use Email::Folder::Reader;
use base 'Email::Folder::Reader';

=head1 NAME

Email::Folder::Mbox - reads raw RFC822 mails from an mbox file

=head1 SYNOPSIS

This isa Email::Folder::Reader - read about its API there.

=head1 DESCRIPTION

Does exactly what it says on the tin - fetches raw RFC822 mails from an
mbox.

The mbox format is described at http://www.qmail.org/man/man5/mbox.html

=cut

# figure out what EOL looks like here
sub _guess_eol {
    my $file = shift;
    my $fh = IO::File->new($file) or return;
    my $match = '';
    while ( $fh->read( my $chunk, 20 ) ) {
        $match .= $chunk;
        return $1 if $match =~ m/(\x0a\x0d|\x0d\x0a|\x0a|\x0d)/;
    }
    return;
}

sub _open_it {
    my $self = shift;
    my $file = $self->{_file};

    # sanity checking
    croak "$file does not exist" unless (-e $file);
    croak "$file is not a file"  unless (-f $file);

    local $/ = $self->{_eol} = _guess_eol $file;

    my $fh = IO::File->new($file) or croak "Cannot open $file";

    my $firstline = <$fh>;
    if ($firstline) {
        croak "$file is not an mbox file" unless $firstline =~ /^From /;
    }

    $self->{_fh} = $fh;
}

sub next_message {
    my $self = shift;

    my $fh = $self->{_fh} || $self->_open_it;
    local $/ = $self->{_eol};

    my $mail = '';
    my $prev = '';
    while (<$fh>) {
        last if /^From /;  # start of the next message
        $mail .= $prev;
        $prev = $_;
    }
    return unless $mail;
    return $mail;
}

1;

__END__

=head1 AUTHOR

Simon Wistow <simon@thegestalt.org>

=head1 COPYING

Copyright 2003, Simon Wistow

Distributed under the same terms as Perl itself.

This software is under no warranty and will probably ruin your life,
kill your friends, burn your house and bring about the apocolapyse.

=head1 SEE ALSO

L<Email::LocalDelivery>, L<Email::Folder>

=cut
