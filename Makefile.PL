#!/usr/bin/perl
use strict;
use ExtUtils::MakeMaker;

WriteMakefile( NAME            => 'Net::PubSubHubbub::Hub',
               VERSION_FROM    => 'lib/Net/PubSubHubbub/Hub.pm',
               EXE_FILES       => [ 'pubsubhubbub-hub' ],
               PREREQ_PM       => {
                   'LWP::UserAgent' => 0,
		   'HTTP::Daemon' => 0,
		   'TheSchwartz' => '1.07',
		   'DBD::SQLite' => 0,  # just for 'pubsubhubbub-hub' demo hub
               },
               ABSTRACT_FROM => 'lib/Net/PubSubHubbub/Hub.pm',
               AUTHOR     => 'Brad Fitzpatrick <brad@danga.com>',
    );
