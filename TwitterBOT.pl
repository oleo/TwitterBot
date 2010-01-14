#!/usr/bin/perl
#
use Net::Twitter::Lite;
use Data::Dumper;
use WWW::Mechanize;

my $user = "user01";
my $password = "Secret"
my $interval = 180;
my $nt = Net::Twitter::Lite->new(
		username => $user,
		password => $password,
		);

while(1) {
	
	# Get direct messages
	my $dirmsgs = $nt->direct_messages();

	# Handle commands
	foreach my $msg ( @$dirmsgs ) {
		
		# Handle if we recognize commands
		if($msg->{text} =~ m/^homeip/) {
			$nt->new_direct_message($msg->{sender_screen_name},&current_ip);
			print localtime(time)." : Handled ".$msg->{text}." from .".$msg->{sender_screen_name}."\n";
		}
	
		# remove message
		$nt->destroy_direct_message($msg->{id});
	}

	# Wait for next round
	sleep $interval;
}
exit;

sub current_ip {
	my $www = WWW::Mechanize->new();
	# Get our current IP-address
	$www->get("http://fff.sliter.nu/cgi-bin/whoami");
	my $curr_ip = $www->content(format=>"text");
	return $curr_ip;
}
