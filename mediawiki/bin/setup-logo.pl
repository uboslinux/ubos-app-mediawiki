#!/usr/bin/perl
#
# Setup a symlink to the correct logo.
#
# Copyright (C) 2014 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $ret = 1;

my $appConfigDir = $config->getResolve( 'appconfig.apache2.dir' );
my $symLink      = "$appConfigDir/resources/assets/logo.png";

if( 'deploy' eq $operation ) {
    my $logoFile = $config->getResolve( 'installable.customizationpoints.wikilogo.filename' );
    unless( -e $logoFile ) {
        $logoFile = "$appConfigDir/resources/assets/mediawiki.png";
    }
    unless( UBOS::Utils::symlink( $logoFile, $symLink )) {
        error( 'Symlink failed:', $logoFile, $symLink );
        $ret = 0;
    }
}
if( 'undeploy' eq $operation ) {
    unless( UBOS::Utils::deleteFile( $symLink )) {
        error( 'Delete failed:', $symLink );
        $ret = 0;
    }
}

$ret;

