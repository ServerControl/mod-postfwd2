#
# (c) Daniel Bäurer <daniel.baeurer@web.de>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Postfwd2;

use strict;
use warnings;

our $VERSION = '0.106';

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Postfwd2::VERSION . "\n";

   printf "  %-30s%s\n", "--name=", "Instance Name";
   printf "  %-30s%s\n", "--path=", "The path where the instance should be created";
   printf "  %-30s%s\n", "--user=", "Postfwd2 User";
   printf "  %-30s%s\n", "--group=", "Postfwd2 Group";
   print  "\n";
   printf "  %-30s%s\n", "--ip=", "Bind Postfwd2 on IP";
   printf "  %-30s%s\n", "--port=", "Postfwd2 listen on Port";
   printf "  %-30s%s\n", "--cacheid=", "CSV-separated list of request attributes to construct the request cache identifier";
   printf "  %-30s%s\n", "--summary=", "Show stats every <i> seconds";
   print  "\n";
   printf "  %-30s%s\n", "--min_servers=", "Spawn at least <i> children";
   printf "  %-30s%s\n", "--max_servers=", "Do not spawn more than <i> children";
   printf "  %-30s%s\n", "--min_spare_servers=", "Minimum idle children";
   printf "  %-30s%s\n", "--max_spare_servers=", "Maximum idle children";
   print  "\n";
   printf "  %-30s%s\n", "--create", "Create the instance";
   printf "  %-30s%s\n", "--start", "Start the instance";
   printf "  %-30s%s\n", "--stop", "Stop the instance";
}

sub start {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);

   my $exec_file     = ServerControl::FsLayout->get_file("Exec", "postfwd2");
   my $conf_file     = ServerControl::FsLayout->get_file("Configuration", "conf");

   my @options = (
      "--user " . ServerControl::Args->get->{"user"},
      "--group " . ServerControl::Args->get->{"group"},
      "--interface " . ServerControl::Args->get->{"ip"},
      "--port " . ServerControl::Args->get->{"port"},
      "--pidfile $path/" . ServerControl::FsLayout->get_directory("Runtime", "pid") . "/$name.pid",
      "--min_servers " . ServerControl::Args->get->{"min_servers"},
      "--max_servers " . ServerControl::Args->get->{"max_servers"},
      "--min_spare_servers " . ServerControl::Args->get->{"min_spare_servers"},
      "--max_spare_servers " . ServerControl::Args->get->{"max_spare_servers"},
      "--cacheid " . ServerControl::Args->get->{"cacheid"},
      "--summary " . ServerControl::Args->get->{"summary"},
      "--logname $name",
   );

   spawn("$path/$exec_file --daemon --file $path/$conf_file " . join(" ", @options));
}

sub stop {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);

   my $exec_file     =  ServerControl::FsLayout->get_file("Exec", "postfwd2");
   my $conf_file     = ServerControl::FsLayout->get_file("Configuration", "conf");

   my @options = (
      "--pidfile $path/" . ServerControl::FsLayout->get_directory("Runtime", "pid") . "/$name.pid",
   );

   spawn("$path/$exec_file --kill --file $path/$conf_file " . join(" ", @options));
}

sub reload {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);

   my $exec_file     = ServerControl::FsLayout->get_file("Exec", "postfwd2");
   my $conf_file     = ServerControl::FsLayout->get_file("Configuration", "conf");

   my @options = (
      "--interface " . ServerControl::Args->get->{"ip"},
      "--port " . ServerControl::Args->get->{"port"},
      "--pidfile $path/" . ServerControl::FsLayout->get_directory("Runtime", "pid") . "/$name.pid",
   );

   spawn("$path/$exec_file --reload --file $path/$conf_file " . join(" ", @options));
}

sub status {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);

   my $exec_file     = ServerControl::FsLayout->get_file("Exec", "postfwd2");
   my $conf_file     = ServerControl::FsLayout->get_file("Configuration", "conf");

   my @options = (
      "--interface " . ServerControl::Args->get->{"ip"},
      "--port " . ServerControl::Args->get->{"port"},
      "--pidfile $path/" . ServerControl::FsLayout->get_directory("Runtime", "pid") . "/$name.pid",
   );

   spawn("$path/$exec_file --dumpstats --file $path/$conf_file " . join(" ", @options));
}
