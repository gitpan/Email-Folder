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

We attempt to read an mbox as through it's the mboxcl2 variant,
falling back to regular mbox mode if there is no C<Content-Length>
header to be found.

=head2 OPTIONS

The new constructor takes one extra option, C<eol>.  This indicates
what the line-ending style is to be.  The default is C<"\n">, but for
say handling files with mac line-endings you would specify C<eol => "\x0d">

=cut

sub defaults {
    ( eol => "\n")
}

sub _open_it {
    my $self = shift;
    my $file = $self->{_file};

    # sanity checking
    croak "$file does not exist" unless (-e $file);
    croak "$file is not a file"  unless (-f $file);

    local $/ = $self->{eol};
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
    local $/ = $self->{eol};

    my $mail = '';
    my $prev = '';
    my $inheaders = 1;
    while (<$fh>) {
        if ($_ eq $/ && $inheaders) { # end of headers
            $inheaders = 0; # stop looking for the end of headers
            # look for a content length header, and follow that
            if ($mail =~ m/^Content-Length: (\d+)$/mi) {
                my $length = $1;
                my $read = '';
                while (<$fh>) {
                    last if length $read == $length;
                    $read .= $_;
                }
                # grab the next line (should be /^From / or undef)
                my $next = <$fh>;
                die "Content-Length assertion failed"
                  unless !defined $next || $next =~ /^From /;
                return "$mail$/$read";
            }
        }
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
