    use ExtUtils::MakeMaker;
    WriteMakefile
      ('DISTNAME' => 'Email-Folder',
       'VERSION' => '0.8',
       'PL_FILES' => {},
       'PREREQ_PM' => {
			'Test::More' => '0',
			'Email::Simple' => '0',
			'Email::FolderType' => '0',

		      },
      );
