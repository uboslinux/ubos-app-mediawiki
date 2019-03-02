#!/usr/bin/perl
#
# Generate a .htaccess file
#
# Copyright (C) 2014 and later, Indie Computing Corp. All rights reserved. License: see package.
#

my $hostname    = $config->getResolveOrNull( 'site.hostname' );
my $appConfigId = $config->getResolveOrNull( 'appconfig.appconfigid' );
my $context     = $config->getResolveOrNull( 'appconfig.context' );
my $dir         = $config->getResolveOrNull( 'appconfig.apache2.dir' );
my $cachedir    = $config->getResolveOrNull( 'appconfig.cachedir' );

# Unfortunately, Alias directories cannot be used in .htaccess files

my $ret = <<RET;
#
# Apache config file fragment for app Mediawiki at $hostname$context
#

<Location "$context/">
  php_value upload_max_filesize 10M
  php_value post_max_size 10M
  php_admin_value open_basedir $dir/:/ubos/share/:/tmp/:/ubos/tmp/:$cachedir/:/ubos/lib/ubos/appconfigpars/$appConfigId/

  RewriteEngine on
  Options +FollowSymLinks
  Options -Indexes
# this does not inhibit index.php, just the subdirectories
  DirectoryIndex index.php

  RewriteCond %{REQUEST_URI} ^$context\$
  RewriteRule ^(.*)\$ $context/ [L]

# Don't rewrite again
  RewriteCond %{REQUEST_URI} !^$context/index.php
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.\*)\$ index.php?title=\$1 [PT,L,QSA]
</Location>

RET

$ret;
