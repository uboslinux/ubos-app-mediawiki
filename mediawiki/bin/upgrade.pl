#!/usr/bin/perl
#
# Upgrade Mediawiki installation.
#
# Copyright (C) 2014 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $ret = 1;

if( 'upgrade' eq $operation ) {
    my $appConfigDir = $config->getResolveOrNull( 'appconfig.apache2.dir' );

    my $cmd = "cd '$appConfigDir';";
    $cmd .= " TERM=vt100";
    $cmd .= " php";
    $cmd .= " -d open_basedir='$appConfigDir:/ubos/share/:/tmp/:/ubos/tmp/'"; # would be nice if this was stricter, but accessories!
    $cmd .= " /ubos/share/mediawiki/mediawiki/maintenance/update.php";
    $cmd .= " --conf '$appConfigDir/LocalSettings.php'";
    $cmd .= " --quick";

    my $out = '';
    my $err = '';

    # pipe PHP in from stdin
    trace( 'About to execute PHP:', $cmd );

    if( UBOS::Utils::myexec( $cmd, undef, \$out, \$err ) != 0 ) {
        error( "Upgrading MediaWiki failed: $err\n $out" );
        $ret = 0;
    }
}

$ret;
