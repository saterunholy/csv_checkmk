#!/usr/bin/perl
#

my $debug = 0;


sub get_percentage {
        my ($num,$div) = @_;
        if ($num == 0 ) { return 100.00; }
        else { return ((($num*100)/$div)/100); }
};

my %hash_mult = (
        "ms" => "0.001",
        "B" => "1",
        "KB" => "1000",
        "kB" => "1000",
        "MB" => "1000000",
        "mB" => "1000000",
        "GiB" => "1000000000",
        "Gbit" => "1000000000",
        "gB" => "1000000000",
        "TB" => "1000000000000",
        "tB" => "1000000000000"
);
while ($line=<STDIN>) {
        $line=~s/\n//g;
        if ($line =~ /(\d+);(.*);(.*);(.*);(.*)/) {
                $timestamp=$1;
                $hostname=$2;
                $metric=$3;
                $state=$4;
                $output=$5;
                if ($debug == 1) {
                        print "\n$timestamp|$hostname|$metric|$output\n";
                }

                if ($metric =~ /CPU load/) {
                        $value = $output;
                        $value =~ s/.*load ([0-9.]+)/$1/g;
                        print "$timestamp|$hostname|$metric|$state|$value\n";
                }
                if ($metric =~ /CPU utilization/) {
                        $value = $output;
                        #                       if ($output =~ /.*user: ([0-9.]+)%, system: ([0-9.]+)%, wait: ([0-9.]+)%, steal: ([0-9.]+)%, guest: ([0-9.]+)%, total: ([0-9.]+)%/)
                        if ($output =~ /Total CPU: ([0-9.]+)%/)
                        {
                                $user=$1;
                                $system=$2;
                                $wait=$3;
                                $steal=$4;
                                $guest=$5;
                                $total=$6;
                                #print "{\"timestamp\":$timestamp,\"hostname\":\"$hostname\",\"metric\":\"$metric\",\"cpu.utilization.state\":$state,\"cpu.utilization.user\":$user,\"cpu.utilization.system\":$system,\"cpu.utilization.wait\":$wait,\"cpu.utilization.steal\":$steal,\"cpu.utilization.guest\":$guest,\"cpu.utilization.total\":$total}\n";
                        print "$timestamp|$hostname|$metric|$state|$user\n";
                        }
                }

                if ($metric =~ /Memory/) {
                        #                       if ($output =~ /(\w+)\s+-\s+RAM used:\s+([0-9.]+)\s+([MKGTmk]*B)\s+of\s+([0-9.]+)\s+([MKGTmk]*B),\s+Swap used:\s+([0-9.]+)\s+([MKGTmk]*B)\s+of\s+([0-9.]+)\s+([MKGTmk]*B),\s+Total virtual memory used:\s+([0-9.]+)\s+([MKGTmk]*B)\s+of\s+([0-9.]+)\s+([MKGTmk]*B).*/) {
                         if ($output =~ /Total\s+.RAM\s+.\s+Swap+.:\s+([0-9.]+)%\s+-\s+([0-9.]+)\s([MKGiTmk]*B)\s+of\s+([0-9.]+)\s+([MKGiTmk]*B)\s+RAM,\s+RAM:\s+([0-9.]+)%\s+-\s+([0-9.]+)\s+([MKGiTmk]*B)\s+of\s+([0-9.]+)\s+([MKGiTmk]*B)/) {
                                $swapusedperc=$1;
                                $swapusedval=($2*$hash_mult{$3});
                                $swapusedtotal=($4*$hash_mult{$5});
                                $rampercentage=$6;
                                $ramused=($7*$hash_mult{$8});
                                $ramtotal=($9*$hash_mult{$10});
                                #                               print "{\"timestamp\":$timestamp,\"hostname\":\"$hostname\",\"metric\":\"$metric\",\"memory.ram.used\":$ramusedval,\"memory.ram.total\":$ramusedtotal,\"memory.ram.percentage\":$ramusedperc,\"memory.swap.used\":$swapusedval,\"memory.swap.total\":$swapusedtotal,\"memory.swap.percentage\":$swapusedperc,\"memory.virtual.used\":$totvirusval,\"memory.virtual.total\":$totvirustot,\"memory.virtual.percentage\":$totvirtperc}\n";
                                                print "$timestamp|$hostname|$metric|$swapusedperc|$swapusedval|$swapusedtotal|$rampercentage|$ramused|$ramtotal\n";
                        }
                 if ($output =~ /RAM:\s+([0-9.]+)%\s+-\s+([0-9.]+)\s([MKGiTmk]*B)\s+of\s+([0-9.]+)\s+([MKGiTmk]*B)/) {
                        #       $status=$1;
                                $rampercentage=$1;
                                $ramused=($2*$hash_mult{$3});
                                $ramtotal=($4*$hash_mult{$5});
                        print "$timestamp|$hostname|$metric|$rampercentage|$ramused|$ramtotal\n";
                        }
                 if ($output =~ /Total virtual memory:\s+([0-9.]+)%\s+-\s+([0-9.]+)\s([MKGiTmk]*B)\s+of\s+([0-9.]+)\s+([MKGiTmk]*B)/) {
                        #       $status=$1;
                                $totvirtperc=$1;
                                $totvirusval=($2*$hash_mult{$3});
                                $totvirustot=($4*$hash_mult{$5});
                        print "$timestamp|$hostname|$metric|$metric|$totvirtperc|$totvirusval|$totvirustot\n";
                        }
                }

                if ($metric =~ /Check_MK/) {
                                        print "$timestamp|$hostname|$metric|$state|$output\n";
                        }
                if ($metric =~ /Check_MK\s+Discovery/) {
                                        print "$timestamp|$hostname|$metric|$state|$status|$output\n";
                        }       

                if ($metric =~ /Disk\s+IO\s+(.*)/) {
                         $diskmount=$1;
                        #if ($output =~ /(\w+)\s+-\s+Utilization:\s+([0-9.]+)\%,\s+Read:\s+([0-9.]+)\s+([MKGTmk]*B)\/s,\s+Write:\s+([0-9.]+)\s+([MKGTmk]*B)\/s,\s+Average Wait:\s+([0-9.]+)\s+(ms|s),\s+Average Read Wait:\s+([0-9.]+)\s+(ms|s),\s+Average Write Wait:\s+([0-9.]+)\s+(ms|s),\s+Latency:\s+([0-9.]+)\s+(ms|s),\s+Average Queue Length:\s+([0-9.]+)/) {
                        if ($output =~ /[[0-9]]+,\s+Read:\s+([0-9.]+)\s+([MKGTmk]*B)\/s,\s+Write:\s+([0-9.]+)\s+([MKGTmk]*B)\/s,\s+Read operations:\s+([0-9.]+)\s+(1)\/s,\s+Write operations:\s+([0-9.]+)\s+(1)\/s/) {
                                #$ioutilization=$1;
                                $ioread=$2;
                                $iowrite=$3;
                                $iorop=($5*$hash_mult{$6});
                                $iowop=($7*$has_mult{$8});
                                #$ioavgww=($11*$hash_mult{$12});
                                #$latency=($13*$hash_mult{$13});
                                #$ioavgql=$15;
                                print "$timestamp|$hostname|$metrics|$state|$diskmount|$ioread|$iowrite|$iorop|$iowop\n";
                        }
                }

                if ($metric =~ /Filesystem\s+(.*)/) {
                        $mountpoint=$1;
                        if ($output =~ /([0-9.]+)%\s+used\s+\(([0-9.]+)\s+of\s+([0-9.]+)\s+([MKGTmk]*B)\),/) {
                                $prcused=$1;
                                $used=$2;
                                $total=($3*$hash_mult{$4});
                                print "$timestamp|$hostname|$metric|$state|$prcused|$mountpoint|$used|$total\n";
                        }
                }

                if ($metric =~ /Kernel (.*)/ ) {
                        $metric2=lc($1);
                        $metric2=~s/ /_/g;
                        if ($output =~ /(\w+)\s+-\s+([0-9.]+)\/s/) {
                                $status=$1;
                                $kervalue=$2;
                                print "$timestamp|$hostname|$metric|$state|$status|$kervalue\n";
                        }
                }

                if ($metric =~ /Interface (.*)/) {
                        #       if ($output =~ /(\w+)\s+-\s+\[(.*)\]\s+\((\w+)\)\s+MAC:\s+(.*),\s+(\w+)\s+([MKGTmk]bit)\/s,\s+in:\s+([0-9.]+)\s+([MKGTmk]*B)\/s\(([0-9.]+)\%\),\s+out:\s+([0-9.]+)\s+([MKGTmk]*B)\/s\(([0-9.]+)\%\)/)
                        if ($output =~ /(.*),\s+(.*),\s+MAC:\s+(.*),\s+Speed:\s+(.*),\s+In:\s+([0-9.]+)\s+([MKGTmk]*B)\/s,\s+Out:\s+([0-9.]+)\s+([MKGTmk]*B)\/s/) {
                                #$status=$1;
                                $intname=$1;
                                $intstatus=$2;
                                $intmac=$3;
                                $intspeed=$4;
                                $in=($5*$hash_mult{$6});
                                $out=($7*$has_mult{$8});
                                print "$timestamp|$hostname|$metric|$state|$intname|$intstatus|$intmac|$intspeed|$in|$out\n";
                        }
                }

                if ($metric =~ /Number of threads/) {
                        #if ($output =~ /(\w+)\s+-\s+(\d+)\s+threads/) {
                        if ($output =~ /Count:\s+([0-9.]+)\s+threads,\s+Usage:\s+([0-9.]+)\%/) {
                                $threads = $1;
                                $usage = $2;
                                print "$timestamp|$hostname|$metric|$threads|$usage\n";
                        }
                }
                                if ($metric =~ /SNMP Info/) {
                        if ($output =~ /(\w+)\s+(.*)\s+(.*)\s+#(\d)\s+(\w+\s+\w+\s\w+\s+\d+\s+\d\d:\d\d:\d\d\s+\w+\s+\d*+\s+\w+),\s+(.*),\s+(\w+)\s+(.*),\s+(\w+)\s+(.*)/) {
                                $os=$1;
                                $host=$2;
                                $arch=$3;
                                $version=$4;
                                $date=$5;
                                $host2=$6;
                                $user1=$7;
                                $path1=$8;
                                $user2=$9;
                                $path2=$10;
                                print "$timestamp|$hostname|$metric|$state|$os|$host|$arch|$version|$date|$host2|$user1|$path1|$user2|$path2\n";
                        }
                }

                if ($metric =~ /TCP Connections/) {
                        #if ($output =~ /(\w+)\s+-\s+ESTABLISHED:\s+(\d+),\s+TIME_WAIT:\s+(\d+),\s+LISTEN:\s+(\d+)/) {
                        if ($output =~ /Established:\s+(\d+)/) {
                                $establ = $1;
                                #$timew = $3;
                                #$listen = $4;
                                print "$timestamp|$hostname|$metric|$state|$establ|$timew|$listen\n";
                        }
                }
                 
                if ($metric =~ /NTP Time/) {
                        #if ($output =~ /(\w+)\s+-\s+\w+\s+since (.*)/) {
                        if ($output =~ /Offset:\s+([0-9.]+)\s+ms,\s+Stratum:\s+(\d),\sTime since last sync:\s(.*)/) {
                                $offset = $1;
                                $stratum = $2;
                                $last_sync = $3;
                                print "$timestamp|$hostname|$metric|$state|$offset|$stratum|$last_sync\n";
                        }
                }

                if ($metric =~ /Mount options of\s+(.*)/) {
                                print "$timestamp|$hostname|$metric|$state|$output\n";
                        }

                 if ($metric =~ /System Time/) {
                        if ($output =~ /Offset:\s+(.*)/) {
                                $offset = $1;
                                print "$timestamp|$hostname|$metric|$state|$offset\n";
                        }
                }

                if ($metric =~ /Service Summary/) {
                        if ($output =~ /Autostart services:\s+(.*),\sStopped services:\s+(.*)/) {
                                $startservices = $1;
                                $stopservices = $2;
                                print "$timestamp|$hostname|$metric|$state|$offset|$stopservices\n";
                        }
                }

                if ($metric =~ /Processor Queue/) {
                        if ($output =~ /15 min load:\s(.*)/) {
                                $load = $1;
                                print "$timestamp|$hostname|$metric|$state|$load\n";
                        }
                }

                if ($metric =~ /Site Health_Check_MK statistics/) {
                        #if ($output =~ /(\w+)\s+-\s+\w+\s+since (.*)/) {
                        if ($output =~ /Total hosts:\s+(.*),\s+Problem hosts:\s+(.*),\s+Total services:\s+(.*),\sProblem services:\s+(.*)/) {
                                $totalhosts = $1;
                                $problemhosts = $2;
                                $totalservices = $3;
                                $problemservices = $4;
                                print "$timestamp|$hostname|$metric|$state|$totalhosts|$problemhosts|$totalservices|$problemservices\n";
                        }
                }

                if ($metric =~ /Uptime/) {
                        #if ($output =~ /(\w+)\s+-\s+\w+\s+since (.*)/) {
                        if ($output =~ /Up\s+since\s+(.*),\s+Uptime:\s+(.*)/) {
                                $since = $1;
                                $time = $2;
                                print "$timestamp|$hostname|$metric|$state|$since|$time\n";
                        }
                }
                if ($metric =~ /PING/) {
                        if ($output =~ /(\w+)\s+-\s+(\d+\.\d+\.\d+\.\d+):\s+rta\s+([0-9.]+)([ms]+),\s+lost\s+(\d+)\%/) {
                                print "$timestamp|$hostname|$metric|$state|$output\n";
                        }
                }
                if ($metric =~ /PING/) {
                        if ($output =~ /(\w+)\s+-\s+(\d+\.\d+\.\d+\.\d+):\s+rta\s+([nan]+),\s+lost\s+(\d+)\%/) {
                                print "$timestamp|$hostname|$metric|$state|$output\n";
                        }
                }

        }
}

