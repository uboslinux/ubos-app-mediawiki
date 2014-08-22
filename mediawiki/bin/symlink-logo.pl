#!/usr/bin/perl
#
# Symlink logo for this appconfig if applicable.
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $ret       = 1;
my $logoFile  = $config->getResolveOrNull( 'installable.customizationpoints.wikilogo.filename', undef, 1 );
my $dir       = $config->getResolveOrNull( 'appconfig.apache2.dir' );
my $localLogo = "$dir/_/ubos-images/logo.png";

if( 'install' eq $operation ) {
    if( $logoFile && -f $logoFile ) {
        unless( UBOS::Utils::symlink( $logoFile, $localLogo )) {
            error( 'Symlink could not be created:', $localLogo );
        }
    }
}
if( 'uninstall' eq $operation ) {
    if( -l $localLogo || -e $localLogo ) {
        unless( UBOS::Utils::deleteFile( $localLogo )) {
            error( 'Symlink could not be deleted:', $localLogo );
        }
    }
}
$ret;
