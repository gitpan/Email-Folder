use Test::More tests => 4;

use_ok("Email::Folder");

my $folder;
ok($folder = Email::Folder->new('t/testmaildir'));

my @messages;
ok(@messages = $folder->messages());

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


is_deeply(\@subjects, \@known);


