package Net::PubSubHubbub::Hub::SubscriberState;
use strict;
use Carp qw(confess);
use Net::PubSubHubbub::Hub::Subscription;

=head1 SYNOPSIS

Abstract base class for storage of subscriber state.

=cut

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub filter_subscribed_urls {
    my ($self, @urls) = @_;
    confess "Unimplemented: filter_subscribed_urls in $self.";
}

sub add_subscription {
    my ($self, $subscription) = @_;
    confess "Unimplemented: add_subscription in $self.";
}

1;
