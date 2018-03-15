#!/usr/bin/perl
#
# Symlink logo for this appconfig if applicable.
#
# Copyright (C) 2014 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $ret       = 1;
my $logoFile  = $config->getResolveOrNull( 'installable.customizationpoints.wikilogo.filename', undef, 1 );
my $dir       = $config->getResolveOrNull( 'appconfig.apache2.dir' );
my $localLogo = "$dir/_mediawiki/ubos-images/logo.png";

if( 'deploy' eq $operation ) {
    if( $logoFile && -f $logoFile ) {
        unless( UBOS::Utils::symlink( $logoFile, $localLogo )) {
            error( 'Symlink could not be created:', $localLogo );
        }
    }
}
if( 'undeploy' eq $operation ) {
    if( -l $localLogo || -e $localLogo ) {
        unless( UBOS::Utils::deleteFile( $localLogo )) {
            error( 'Symlink could not be deleted:', $localLogo );
        }
    }
}
$ret;
