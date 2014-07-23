#!/usr/bin/perl
#
# Symlink logo for this appconfig if applicable.
#

use strict;

use IndieBox::Logging;
use IndieBox::Utils;

my $ret       = 1;
my $logoFile  = $config->getResolveOrNull( 'installable.customizationpoints.wikilogo.filename', undef, 1 );
my $dir       = $config->getResolveOrNull( 'appconfig.apache2.dir' );
my $localLogo = "$dir/_/indie-images/logo.png";

if( 'install' eq $operation ) {
    if( $logoFile && -f $logoFile ) {
        unless( IndieBox::Utils::symlink( $logoFile, $localLogo )) {
            error( 'Symlink could not be created:', $localLogo );
        }
    }
}
if( 'uninstall' eq $operation ) {
    if( -l $localLogo || -e $localLogo ) {
        unless( IndieBox::Utils::deleteFile( $localLogo )) {
            error( 'Symlink could not be deleted:', $localLogo );
        }
    }
}
$ret;
