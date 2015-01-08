my $hostname    = $config->getResolveOrNull( 'site.hostname' );
my $context     = $config->getResolveOrNull( 'appconfig.context' );
my $hiddenpath  = "$context/_";
my $rewriteBase = $config->getResolveOrNull( 'appconfig.contextorslash' );

# Unfortunately, Alias directories cannot be used in .htaccess files

my $ret = <<RET;
#
# Apache config file fragment for app Mediawiki at $hostname$context
#

php_value upload_max_filesize 10M
php_value post_max_size 10M

RewriteEngine on
Options +FollowSymLinks
Options -Indexes
# this does not inhibit index.php, just the subdirectories
DirectoryIndex index.php

RewriteCond %{REQUEST_URI} ^$context/_/ubos-images/logo.png\$
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.\*)\$ _/ubos-images/mediawiki.png

# Don't rewrite again
RewriteCond %{REQUEST_URI} !^$context/index.php
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.\*)\$ index.php?title=\$1 [PT,L,QSA]

RET

$ret;
