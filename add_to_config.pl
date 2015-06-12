#This file should take in the following files:
#1) The current config file
#2) up-to-date taxon authority files
#3) The list of names (either all the names to be input, or the names intended to be input. The names needed for input could be determined by validating the name list against the current config file in FIMS, but that would require more manual work)

#Load authnames from authority files into an array AUTH
#Load noauth names from authority files into an array NOAUTH
#for each authname and noauthname, also need to key it to the refname. Put this in one REFNAME hash
#ALSO NEED TO KEY THE AUTHNAMES TO THE CORRESPONDING NOAUTHNAMES
###maybe key noauthnames to authnames then key authname to refname, then can indirectly key noauthnames to refnames if needed

#load CDATA contents of the config file into an array CONF

#finally, load the names from the current input and process line by line

if () { #if the input name matches the auth_name
#pass the auth_name along to compare to the config file
}

elsif () { #if the input matches the noauth_name
#log: "noauthname match: please change $input_name to $auth_name
next;
####NOTE: if we're matching the noauthname, we still need to get the authname because that's what CSpace shows
}

elsif () { #elsif name matches the start of the string of an auth name
#log: "partial name match: suggested to change $input_name to $auth_name
next;
}

else { #else the name does not match and needs to be added to CSpace
#print to log file "$input_name\tapparently not in CSpace\n";
next;
}


#now, once the name is confirmed as in CSpace and the input matches the auth name, check if the name is already in the config file
if { #if $input_name matches an item in the CONF array
# &log ("$input_name\talready in config file; no action required");
}

else { #else the name is not in the config file and needs to be added
#print to output $refname + $authname in the right format, so it can just be pasted in
}


###Script should be re-run until the only messages received are "name in config: no action required" or "name must be added to CSpace"
###Once all names are added to CSpace then then iterate until the only message received is "no action required"
###Then continue with the process
