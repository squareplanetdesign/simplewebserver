#!/usr/local/bin/perl

use HTTP::Daemon;
use HTTP::Status;
use Pod::Simple::HTML;
use Data::Dumper;
 
my $file = shift;
die "File $file not found" unless -e $file;

my $d = HTTP::Daemon->new || die;
print "Please contact me at: <URL:", $d->url, ">\n";
while (my $c = $d->accept) {
 while (my $r = $c->get_request) {
   if ($r->method eq 'GET') {
     my $rs = new HTTP::Response(RC_OK);
     my $html = "";

     my $p = Pod::Simple::HTML->new;
     $p->output_string(\$html);
     $p->parse_file($file);
     
     print  Dumper($html);
     $rs->content( $html );
     $c->send_response($rs);
   } else {
     $c->send_error(RC_FORBIDDEN)
   }
 }
 $c->close;
 undef($c);
}