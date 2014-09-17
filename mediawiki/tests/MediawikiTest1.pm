#!/usr/bin/perl
#
# Simple test for Mediawiki
#
# (C) 2012-2014 Indie Computing Corp.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use warnings;

package MediawikiTest1;

use UBOS::WebAppTest;

# The states and transitions for this test

my $TEST = new UBOS::WebAppTest(
    appToTest   => 'mediawiki',
    description => 'Tests whether Mediawiki comes up',
    testContext => '/wiki',
    hostname    => 'mediawiki-test',
    checks      => [
            new UBOS::WebAppTest::StateCheck(
                    name  => 'virgin',
                    check => sub {
                        my $c = shift;

                        $c->getMustRedirect(   '/', 'http://mediawiki-test/wiki/Main_Page', undef, 'Front page not redirecting to Main_Page' );
                        $c->getMustContain(    '/Main_Page', 'There is currently no text in this page', undef, 'Wrong front page' );

                        return 1;
                    }
            )
    ]
);

$TEST;
