package Net::PubSubHubbub::Hub;
use strict;
use HTTP::Request;
use HTTP::Response;
use Net::PubSubHubbub::Hub::SubscriberState::InMemory;
use TheSchwartz;  # job queue

our $VERSION = '0.01';

# Global Hub instance, used for passing the Hub the Schwartz workers.
# Ideally you'd be able to pass a worker instance to TheScwhartz'
# can_do function, instead of a package name, rendering this
# unnecessary, but...
our $HUB;

sub set_hub { shift; $HUB = shift }
sub hub { $HUB }

sub new {
    my ($class, %opts) = @_;
    my $self = bless {}, $class;

    $self->{subscriber_state} = delete $opts{'subscriber_state'};
    $self->{subscriber_state} ||=
	Net::PubSubHubbub::Hub::SubscriberState::InMemory->new;

    $self->{job_queue} = delete $opts{'job_queue'} or
	die "Required 'job_queue' argument missing.";

    die "Unknown options: " . join(", ", sort keys %opts) if %opts;
    return $self;
}

sub subscriber_state {
    my $self = shift;
    return $self->{subscriber_state};
}

sub job_queue {
    my $self = shift;
    return $self->{job_queue};
}

sub debug {
    my ($self, @msg) = @_;
    my $msg = join("", @msg);
    chomp $msg;
    print STDERR $msg, "\n";
}

sub handle_request {
    my ($self, $req) = @_;
    die unless UNIVERSAL::isa($req, "HTTP::Request");

    my %post_args;
    if ($req->method eq "POST" &&
	$req->header("Content-Type") eq "application/x-www-form-urlencoded") {
	foreach my $pair (split(/&/, $req->content)) {
	    my ($k, $v) = map { _durl($_) } split(/=/, $pair, 2)
		or next;
	    push @{$post_args{$k} ||= []}, $v;
	}
    }

    my $mode;
    if ($mode = $post_args{'hub.mode'}) {
	if (scalar @$mode > 1) {
	    return _error(400, "Too many hub.mode parameters");
	}
	$mode = $mode->[0];
    }

    if ($mode eq "publish") {
	return $self->handle_publish($req, \%post_args);
    }

    if ($mode && $mode ne "publish") {
	return _error(400, "Unsupported hub.mode value.");
    }

    my $res = HTTP::Response->new(200);
    $res->header("Content-Type" => "text/html");
    $res->content("Hello from " . __PACKAGE__ . "/$VERSION");
    return $res;
}

sub handle_publish {
    my ($self, $req, $post_args) = @_;
    my @urls = @{ $post_args->{'hub.url'} || [] };
    print "URLS: @urls\n";

    my @subscribed_urls =
	$self->subscriber_state->filter_subscribed_urls(@urls);

    my @jobs;
    foreach my $url ($self->subscriber_state->filter_subscribed_urls(@urls)) {
	my $job = TheSchwartz::Job->new(
	    funcname => "Net::PubSubHubbub::Hub::Worker::FetchFeed",
	    arg => {
		url => $url,
	    });
	push @jobs, $job;
    }

    $self->job_queue->insert_jobs(@jobs) if @jobs;
    print "Subscribed URLS: @subscribed_urls\n";

    my $res = HTTP::Response->new(200);
    $res->header("Content-Type" => "text/html");
    $res->content("Hello, publisher!");
    return $res;
}

sub _durl {
    my $v = $_[0];
    $v =~ tr/+/ /;
    $v =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    return $v;
}

sub _error {
    my ($code, $msg) = @_;
    my $res = HTTP::Response->new($code);
    $res->header("Content-Type" => "text/html");
    $res->content("Error: $msg\n");
    return $res;
}

1;
