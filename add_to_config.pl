use warnings;
use strict;

#This file should take in the following files:
#1) The current config file
#2) up-to-date taxon authority files
#3) The list of all names in the specimen batch, i.e. the input (The script will check whether it needs to be added or not)

my $authority_file;
my $config_file;
my $input_names;
$authority_file = "auth_file.txt";
$config_file = "ucjeps_fims.xml";
$input_names = "input_names.txt";

my %REF;
my %AUTH;
my @authnames;
my @noauthnames;

open(IN, "$authority_file") || die "could not open authority file $authority_file\n";
while(<IN>){
	chomp;
	my ($csid,
	$author_name,
	$ref_name,
	$no_author_name,
	$major_group
	) = split (/\t/);

#is there a way to do it besides loading all author_names and noauthor_names into two different arrays?
#i.e. could the checking be done using the hash files?
#if so, the hash files would have to differentiate between author_names and noauthor_names
	push @authnames, "$author_name";
	if ("$no_author_name") { #not all entries will have no_author_names
		push @noauthnames, "$no_author_name";
	}

	$REF{$author_name} = $ref_name; #key the author_names to the refname
	$REF{$no_author_name} = $ref_name; #also key the noauthor name to the refname
	$AUTH{$no_author_name} = $author_name; #key authname to the noauthorname

}
close(IN);

####these tests could be done by doing a line count on the authority input files
####and making sure these print outs have an expected number of lines based on the input
#foreach(keys(%REF)){
#	print "$_: $REF{$_}\n";
#}
#foreach(keys(%AUTH)){
#	print "$_\t$AUTH{$_}\n";
#}
#foreach (@authnames){
#	print "$_\n";
#}
#foreach (@noauthnames){
#	print "$_\n";
#}

my @names_in_config;

open(IN, "$config_file") || die "could not open config file $config_file\n";
while(my $line = <IN>){
	chomp $line;
	#because we are matching complex strings, use Q\...E\
	#Q\ means "disable metacharacters until \E
	next unless ($line =~ /^\Q<field uri="urn:cspace:ucjeps.cspace.berkeley.edu:taxonomyauthority:name(taxon):item:name\E/); 
	#print "$line\n";
	if ($line =~ /.*\[CDATA\[(.*)\]\]/){ #if the line has a CDATA tag with content
#		print "$1\n";
		push @names_in_config, "$1";
	}
}
close(IN);

#foreach (@names_in_config){
#	print "$_\n";
#}
###The number of items in the @names_in_config array should equal the number of lines after the next unless


#finally, load the names from the current input and process line by line
open(IN, "$input_names") || die "could not open name list file $input_names\n";
while(my $input_name = <IN>){
	chomp $input_name;
	print "$input_name\n";


#if () { #if the input name matches the auth_name
#pass the auth_name along to compare to the config file
#}

#elsif () { #if the input matches the noauth_name
##log: "noauthname match: please change input name $input_name to $auth_name";
#next;
####NOTE: if we're matching the noauthname, we still need to get the authname because that's what CSpace shows
#}

#elsif () { #elsif name matches the start of the string of an auth name
##log: "partial name match: suggested to change input name $input_name to $auth_name";
#next;
#}

#else { #else the name does not match and needs to be added to CSpace
##print to log file "$input_name\tapparently not in CSpace\n";
#next;
#}


##now, once the name is confirmed as in CSpace and the input matches the auth name, check if the name is already in the config file
#if { #if $input_name matches an item in the CONF array
## &log ("$input_name\talready in config file; no action required");
#}

#else { #else the name is not in the config file and needs to be added
##print to output $refname + $authname in the right format, so it can just be pasted in
#}


}

die;

###Script should be re-run until the only messages received are "name in config: no action required" or "name must be added to CSpace"
###Once all names are added to CSpace then then iterate until the only message received is "no action required"
###Then continue with the process


###############These were some notes about the authority hash setup that might have already been addressed. Delete if so
#for each authname and noauthname, also need to key it to the refname. Put this in one REFNAME hash
#ALSO NEED TO KEY THE AUTHNAMES TO THE CORRESPONDING NOAUTHNAMES
###maybe key noauthnames to authnames then key authname to refname, then can indirectly key noauthnames to refnames if needed

