use Nmap::Parser;

      #PARSING
my $np = new Nmap::Parser;

$nmap_exe = '/usr/bin/nmap';
$np->parsescan($nmap_exe,'-sT -p1-1023', @ips);

#or

$np->parsefile('nmap_output.xml'); #using filenames

      #GETTING SCAN INFORMATION

print "Scan Information:\n";
$si = $np->get_scaninfo();
#get scan information by calling methods
print
'Number of services scanned: '.$si->num_of_services()."\n",
'Start Time: '.$si->start_time()."\n",
'Scan Types: ',(join ' ',$si->scan_types())."\n";

      #GETTING HOST INFORMATION

print "Hosts scanned:\n";
for my $host_obj ($np->get_host_objects()){
  print
  'Hostname  : '.$host_obj->hostname()."\n",
  'Address   : '.$host_obj->ipv4_addr()."\n",
  'OS match  : '.$host_obj->os_match()."\n",
  'Open Ports: '.(join ',',$host_obj->tcp_ports('open'))."\n";
       #... you get the idea...
}

#frees memory--helpful when dealing with memory intensive scripts
$np->clean();
