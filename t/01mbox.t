#!perl -w
my @boxes;
BEGIN { @boxes = qw( t/testmbox t/testmbox.mac t/testmbox.dos ) }
use Test::More tests => 3 + 3 * @boxes;
use strict;

use_ok("Email::Folder");

for my $box (@boxes) {
    my $folder;
    ok($folder = Email::Folder->new($box), "opened $box");

    my @messages = $folder->messages;
    is(@messages, 10, "grabbed 10 messages");

    my @subjects = sort map { $_->header('Subject') }  @messages;

    my @known = (
                 'R: [p5ml] karie kahimi binge...help needed',
                 'RE: [p5ml] Re: karie kahimi binge...help needed',
                 'Re: January\'s meeting',
                 'Re: January\'s meeting',
                 'Re: January\'s meeting',
                 'Re: [p5ml] karie kahimi binge...help needed',
                 'Re: [p5ml] karie kahimi binge...help needed',
                 'Re: [rt-users] Configuration Problem',
                 '[p5ml] Re: karie kahimi binge...help needed',
                 '[rt-users] Configuration Problem',
                );

    is_deeply(\@subjects, \@known, "they're the messages we expected");
}


my $folder;
ok($folder = Email::Folder->new('t/testmbox.empty'), "opened testmbox.empty");


is($folder->messages, 0);


