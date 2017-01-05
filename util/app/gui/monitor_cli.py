#
# Copyright (c) 2016 University of Cambridge
# Copyright (c) 2016 Jong Hun Han
# All rights reserved.
#
# This software was developed by University of Cambridge Computer Laboratory
# under the ENDEAVOUR project (grant agreement 644960) as part of
# the European Union's Horizon 2020 research and innovation programme.
#
# @NETFPGA_LICENSE_HEADER_START@
#
# Licensed to NetFPGA Open Systems C.I.C. (NetFPGA) under one or more
# contributor license agreements. See the NOTICE file distributed with this
# work for additional information regarding copyright ownership. NetFPGA
# licenses this file to you under the NetFPGA Hardware-Software License,
# Version 1.0 (the License); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at:
#
# http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@
################################################################################

import os, sys, math, argparse
from lib.axi import *
from time import gmtime, strftime, sleep
from monitor import *

time_f = open("record_ts.txt", "w")

class InitCli:
    def __init__(self):
        self.osnt_monitor_filter = OSNTMonitorFilter()
        self.osnt_monitor_stats = OSNTMonitorStats()
        self.osnt_monitor_cutter = OSNTMonitorCutter()
        self.osnt_monitor_timer = OSNTMonitorTimer()

        # Initialize
        self.osnt_monitor_cutter.disable_cut()
        self.time_index = 0
        self.init_value = 0
        self.time_old = 0
        self.cut_size = 0
        self.pkt_cnt_old = [0]*4
        self.byte_cnt_old = [0]*4
        self.vlan_cnt_old = [0]*4
        self.ip_cnt_old = [0]*4
        self.udp_cnt_old = [0]*4
        self.tcp_cnt_old = [0]*4
        self.pktps_old = [0]*4
        self.byteps_old = [None]*4

# Start program
initcli = InitCli()

def cli_display_stats():
    if (initcli.time_old == 0):
        initcli.time_old = 0
    initcli.osnt_monitor_stats.get_stats()
    time_high = int(initcli.osnt_monitor_stats.time_high, 16)
    time_low = int(initcli.osnt_monitor_stats.time_low, 16)
    time_low = ((time_low * 1000000000) >> 32)/float(1000000000)
    time_new = time_high + time_low
    time_elapsed = time_new - initcli.time_old
    os.system('clear')
    print "\n OSNT Monitor Stats (SUME-NetFPGA)\n"
    for i in range(4):
        if (initcli.pkt_cnt_old[i] == 0):
            initcli.pkt_cnt_old[i] = 0
        initcli.pkt_cnt_old[i] = int(initcli.pkt_cnt_old[i])
        pkt_cnt_new = int(initcli.osnt_monitor_stats.pkt_cnt[i], 16)
        if pkt_cnt_new >= initcli.pkt_cnt_old[i]:
            pkt_cnt = pkt_cnt_new - initcli.pkt_cnt_old[i];
        else:
            pkt_cnt = pkt_cnt_new + ((1<<32) - initcli.pkt_cnt_old[i]);

        initcli.pktps_old[i] = translateRate(pkt_cnt/time_elapsed)
        if (initcli.byte_cnt_old[i] == 0):
            initcli.byte_cnt_old[i] = 0
        initcli.byte_cnt_old[i] = int(initcli.byte_cnt_old[i])
        byte_cnt_new = int(initcli.osnt_monitor_stats.byte_cnt[i], 16)
        if byte_cnt_new >= initcli.byte_cnt_old[i]:
            byte_cnt = byte_cnt_new - initcli.byte_cnt_old[i];
        else:
            byte_cnt = byte_cnt_new + ((1<<32) - initcli.byte_cnt_old[i]);

        initcli.byteps_old[i] = translateRate((8*byte_cnt+32*pkt_cnt)/time_elapsed)
        initcli.pkt_cnt_old[i] = int(initcli.osnt_monitor_stats.pkt_cnt[i], 16)
        initcli.byte_cnt_old[i] = int(initcli.osnt_monitor_stats.byte_cnt[i], 16)
        initcli.vlan_cnt_old[i] = int(initcli.osnt_monitor_stats.vlan_cnt[i], 16)
        initcli.ip_cnt_old[i] = int(initcli.osnt_monitor_stats.ip_cnt[i], 16)
        initcli.udp_cnt_old[i] = int(initcli.osnt_monitor_stats.udp_cnt[i], 16)
        initcli.tcp_cnt_old[i] = int(initcli.osnt_monitor_stats.tcp_cnt[i], 16)
        print " nf%1d =>" %(i)
        print "   Packet No :%8d       Byte No :%8d" %(initcli.pkt_cnt_old[i], initcli.byte_cnt_old[i])
        print "   VLAN No   :%8d       IP No   :%8d       UDP No :%8d      TCP No :%8d"\
            %(initcli.vlan_cnt_old[i], initcli.ip_cnt_old[i], initcli.udp_cnt_old[i], initcli.tcp_cnt_old[i])
        print "   ================================="
        print "   Pkt/Sec   :%s        Byte/Sec :%s\n" %(initcli.pktps_old[i], initcli.byteps_old[i])

    if (initcli.cut_size == 0):
        print "\n OSNT TimsStamp Counter: %10.6f sec.   Cutter size : Disabled\n" % (time_new)
    else:
        print "\n OSNT TimsStamp Counter: %10.6f sec.   Cutter size : %d\n" % (time_new, initcli.cut_size)

    sleep(1)
    initcli.time_old = float(time_new)


input_arg = argparse.ArgumentParser()
input_arg.add_argument("--load_filter", type=str, help="OSNT monitor load a rule of filter. eg. --load_filter <filter file name>")
input_arg.add_argument("--cut_size", type=int, help="OSNT monitor packet cutter size in byte. --cut_size <byte size>")
input_arg.add_argument("--clear", type=str, help="OSNT monitor clear stats and time. --clear <any value>")
    
args = input_arg.parse_args()

if (args.clear):
    initcli.osnt_monitor_filter.clear_rules()
    initcli.osnt_monitor_stats.reset()
    initcli.osnt_monitor_cutter.disable_cut()
    initcli.osnt_monitor_timer.reset_time()
    print "Cleared pcap replay. Stop ..."

# Setting cut size
if (args.cut_size):
    initcli.cut_size = args.cut_size
    if (initcli.cut_size != 0):
        initcli.osnt_monitor_cutter.enable_cut(initcli.cut_size)

# Load filter rule
if (args.load_filter):
    with open("./filter.cfg", 'r') as f:
        for line in f:
          line = line.lstrip()
          if len(line) > 0 and line[0] != '#':
             rule = line.split()
             entry = int(rule[0])
             initcli.osnt_monitor_filter.src_ip_table[entry] = ip2hex(rule[1])
             initcli.osnt_monitor_filter.src_ip_mask_table[entry] = ip2hex(rule[2])
             initcli.osnt_monitor_filter.dst_ip_table[entry] = ip2hex(rule[3])
             initcli.osnt_monitor_filter.dst_ip_mask_table[entry] = ip2hex(rule[4])
             initcli.osnt_monitor_filter.l4ports_table[entry] = rule[5]
             initcli.osnt_monitor_filter.l4ports_mask_table[entry] = rule[6]
             initcli.osnt_monitor_filter.proto_table[entry] = rule[7]
             initcli.osnt_monitor_filter.proto_mask_table[entry] = rule[8]

    initcli.osnt_monitor_filter.synch_rules()

while True :
    cli_display_stats()