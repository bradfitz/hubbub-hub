package Net::PubSubHubbub::Hub::Worker::FetchFeed;

use strict;
use base 'TheSchwartz::Worker';
use Data::Dumper;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
    my $arg = $job->arg;
    unless (ref $arg eq "HASH" && $arg->{'url'}) {
        $job->completed;
        return;
    }
    my $url = $arg->{'url'};

    my $hub = Net::PubSubHubbub::Hub->hub;
    print "HUB=$hub, URL=$url\n";

    $job->completed;
}

1;

