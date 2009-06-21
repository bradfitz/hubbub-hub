package Net::PubSubHubbub::Hub;
use strict;
use HTTP::Request;
use HTTP::Response;

our $VERSION = '0.01';

sub new {
    my ($class, %opts) = @_;
    my $self = bless {}, $class;
    return $self;
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

    my $res = HTTP::Response->new(200);
    $res->header("Content-Type" => "text/html");
    $res->content("Hello from " . __PACKAGE__ . "/$VERSION");
    return $res;
}

1;
