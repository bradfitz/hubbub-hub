package Net::PubSubHubbub::Hub;
use strict;
use HTTP::Request;
use HTTP::Response;

our $VERSION = '0.01';

sub new {
    my ($class, %opts) = @_;
    my $self = bless {}, $class;

    $self->{ico_filename} ||= "hub.ico";
    if (-e $self->{ico_filename}) {
	$self->debug("ICO file $self->{ico_filename} exists.");
	if (open(my $fh, $self->{ico_filename})) {
	    $self->{ico_data} = do { local $/; <$fh>; };
	}
    }
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

    if ($req->method eq "GET" && $req->uri eq "/favicon.ico") {
	if ($self->{ico_data}) {
	    my $res = HTTP::Response->new(200);
	    $res->header("Content-Type" => "image/x-icon");
	    $res->content($self->{ico_data});
	    return $res;
	} else {
	    return HTTP::Response->new(404);
	}
    }

    my $res = HTTP::Response->new(200);
    $res->header("Content-Type" => "text/html");
    $res->content("Hello from " . __PACKAGE__ . "/$VERSION");
    print $res->as_string, "\n";
    return $res;
}

1;
