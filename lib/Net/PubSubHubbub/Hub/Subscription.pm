package Net::PubSubHubbub::Hub::Subscription;
use strict;

sub new {
    my ($class, %opts) = @_;
    # topic, callback, expiration
    return bless \%opts, $class;
}

sub topic_url {
    my ($self) = @_;
    return $self->{topic};
}

1;
