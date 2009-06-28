package Net::PubSubHubbub::Hub::Worker::FetchFeed;

use strict;
use base 'TheSchwartz::Worker';
use Data::Dumper;

sub work {
    my TheSchwartz::Job $job = shift;
    my $arg = $job->arg;
    print Dumper($arg);
    $job->completed;
}

1;

