#!/usr/bin/perl
#
# Create a MediaWiki admin user.
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $ret = 1;

if( 'install' eq $operation ) {
    my $appConfigDir = $config->getResolveOrNull( 'appconfig.apache2.dir' );
    my $adminName    = $config->getResolveOrNull( 'site.admin.userid' );
    my $adminPass    = $config->getResolveOrNull( 'site.admin.credential' );

    if( $adminName && $adminPass ) {
        my $cmd = "cd '$appConfigDir';";
        $cmd .= " TERM=vt100";
        $cmd .= " php";
        $cmd .= " -d open_basedir='$appConfigDir:/usr/share/:/tmp'"; # would be nice if this was stricter, but accessories!
        $cmd .= " /usr/share/mediawiki/mediawiki/maintenance/createAndPromote.php";
        $cmd .= " --quiet";
        $cmd .= " --force"; # continue even if user exists already
        $cmd .= " --conf '${appConfigDir}/LocalSettings.php'";
        $cmd .= " --bureaucrat";
        $cmd .= " --sysop";
        $cmd .= " '$adminName'";
        $cmd .= " '$adminPass'";

        my $out = '';
        my $err = '';

        if( UBOS::Utils::myexec( $cmd, undef, \$out, \$err ) != 0 && $err !~ /account exists/ ) {
            error( "Creating MediaWiki admin user failed: $err\n $out" );
            $ret = 0;
        }
    }
}

$ret;
