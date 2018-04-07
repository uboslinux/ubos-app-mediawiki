#!/usr/bin/perl
#
# Simple test for Mediawiki
#
# Copyright (C) 2014 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

package MediawikiTest1;

use UBOS::WebAppTest;

# The states and transitions for this test

my $TEST = new UBOS::WebAppTest(
    appToTest   => 'mediawiki',
    description => 'Tests whether Mediawiki comes up',
    checks      => [
            new UBOS::WebAppTest::StateCheck(
                    name  => 'virgin',
                    check => sub {
                        my $c = shift;

                        $c->getMustRedirect(   '/', '/Main_Page', undef, 'Front page not redirecting to Main_Page' );
                        $c->getMustContain(    '/Main_Page', 'There is currently no text in this page', undef, 'Wrong front page' );

                        $c->getMustNotContain( '/Main_Page', '<div class="warningbox">' );

                        my $robotsTxt = $c->absGet( '/robots.txt' );
                        $c->mustMatch( $robotsTxt, '(?m)^Disallow:.*' . quotemeta( $c->context() . '/_mediawiki/' ) . '$', 'robots.txt contribution wrong' );

                        return 1;
                    }
            )
    ]
);

$TEST;
