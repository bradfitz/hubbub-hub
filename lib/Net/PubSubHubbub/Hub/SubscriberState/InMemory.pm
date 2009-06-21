package Net::PubSubHubbub::Hub::SubscriberState::InMemory;
use strict;
use base 'Net::PubSubHubbub::Hub::SubscriberState';

sub new {
    my ($class) = @_;
    return bless {
	'subscribers' => {},  # Topic URL -> [ $subscription, .... ]
    }, $class;
}

sub filter_subscribed_urls {
    my ($self, @urls) = @_;
    return grep { $self->{subscribers}{$_} } @urls;
}

sub add_subscription {
    my ($self, $subscr) = @_;
    push @{$self->{'subscribers'}{$subscr->topic_url} ||= []}, $subscr;
}

1;
