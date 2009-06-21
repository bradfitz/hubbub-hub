#!/usr/bin/perl
use strict;
use ExtUtils::MakeMaker;

WriteMakefile( NAME            => 'Net::PubSubHubbub::Hub',
               VERSION_FROM    => 'lib/Net/PubSubHubbub/Hub.pm',
               EXE_FILES       => [ 'pubsubhubbub-hub' ],
               PREREQ_PM       => {
                   'LWP::UserAgent' => 0,
               },
               ABSTRACT_FROM => 'lib/Net/PubSubHubbub/Hub.pm',
               AUTHOR     => 'Brad Fitzpatrick <brad@danga.com>',
    );
