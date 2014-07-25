#!/usr/bin/perl
# that_day.pl
#
# This software must be redistributed under the terms of Artistic License 2.0
#
# (c) 2014 Carlos Peñas San José
#

use strict;

use Nagios::Plugin;
use Date::Manip;

my $n_plugin = Nagios::Plugin->new (
    shortname => 'SYSDAY',
    version => '0.1',
    license => 'artistic 2.0',
    usage => 'Usage: %s [-w|-c]',
);

$n_plugin->add_arg(
    spec => 'warning|w',
    help => "-w, --warning\n Returns WARNING condition",
    required => 0,
);

$n_plugin->add_arg(
    spec => 'critical|c',
    help => "-c, --critical\n Returns CRITICAL condition",
    required => 0,
);
$n_plugin->getopts;

sub debug {
    my ($message,$level) = @_;
    $level = 1 unless $level;
    if ($n_plugin->opts->verbose >= $level){
        print STDERR "debug:($level):$message\n";
    }
}

my $begin_sysday = UnixDate(ParseDateString("last friday of july at 00:01"),"%s");
my $end_sysday = UnixDate(ParseDateString("last friday of july at 23:59"),"%s");
my $today = UnixDate(ParseDateString("now"),"%s");

debug ("begin $begin_sysday");
debug ("end $end_sysday");
debug ("today $today");

my $is_sysday = ($today > $begin_sysday) && ($today < $end_sysday);

if ($is_sysday) {
  if ($n_plugin->opts->critical) {
    $n_plugin->nagios_exit(CRITICAL,'Today is Sysadmin Appreciation Day');
  } else {
    $n_plugin->nagios_exit(WARNING,'Today is Sysadmin Appreciation Day');
  }
}

$n_plugin->nagios_exit(OK,'Today is just another day');
