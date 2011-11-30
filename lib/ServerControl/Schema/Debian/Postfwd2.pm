#
# (c) Daniel Bäurer <daniel.baeurer@web.de>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Schema::Debian::Postfwd2;

use strict;
use warnings;

use ServerControl::Schema;
use base qw(ServerControl::Schema::Module);

__PACKAGE__->register(
	'postfwd2'		=> '/usr/sbin/postfwd2',
);

1;
