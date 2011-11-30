use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-Postfwd2',
   VERSION_FROM => 'lib/ServerControl/Module/Postfwd2.pm',
   PREREQ_PM => {'ServerControl' => '0.105'},
   LICENSE => 'bsd'
);

