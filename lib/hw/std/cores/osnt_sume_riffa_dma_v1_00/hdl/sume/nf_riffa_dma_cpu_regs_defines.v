//
// Copyright (c) 2015 University of Cambridge
// All rights reserved.
//
//
//  File:
//        nf_riffa_dma_cpu_regs_defines.v
//
//  Module:
//        nf_riffa_dma_cpu_regs_defines
//
//  Description:
//        This file is automatically generated with the registers defintions
//        towards the CPU/Software
//
// This software was developed by Stanford University and the University of
// Cambridge Computer Laboratory under National Science Foundation under Grant
// No. CNS-0855268, the University of Cambridge Computer Laboratory under EPSRC
// INTERNET Project EP/H040536/1 and by the University of Cambridge Computer
// Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"), as part of
// the DARPA MRC research programme.
//
// @NETFPGA_LICENSE_HEADER_START@
//
// Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
// license agreements.  See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.  NetFPGA licenses this
// file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
// "License"); you may not use this file except in compliance with the
// License.  You may obtain a copy of the License at:
//
//   http://www.netfpga-cic.org
//
// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
//
// @NETFPGA_LICENSE_HEADER_END@
//


           `define  REG_ID_BITS				31:0
           `define  REG_ID_WIDTH				32
           `define  REG_ID_DEFAULT			32'h00001FFA
           `define  REG_ID_ADDR				32'h0

           `define  REG_VERSION_BITS				31:0
           `define  REG_VERSION_WIDTH				32
           `define  REG_VERSION_DEFAULT			32'h1
           `define  REG_VERSION_ADDR				32'h4

           `define  REG_RESET_BITS				15:0
           `define  REG_RESET_WIDTH				16
           `define  REG_RESET_DEFAULT			16'h0
           `define  REG_RESET_ADDR				32'h8

           `define  REG_FLIP_BITS				31:0
           `define  REG_FLIP_WIDTH				32
           `define  REG_FLIP_DEFAULT			32'h0
           `define  REG_FLIP_ADDR				32'hC

           `define  REG_DEBUG_BITS				31:0
           `define  REG_DEBUG_WIDTH				32
           `define  REG_DEBUG_DEFAULT			32'h0
           `define  REG_DEBUG_ADDR				32'h10

           `define  REG_RQPKT_BITS				31:0
           `define  REG_RQPKT_WIDTH				32
           `define  REG_RQPKT_DEFAULT			32'h0
           `define  REG_RQPKT_ADDR				32'h14

           `define  REG_RCPKT_BITS				31:0
           `define  REG_RCPKT_WIDTH				32
           `define  REG_RCPKT_DEFAULT			32'h0
           `define  REG_RCPKT_ADDR				32'h18

           `define  REG_CQPKT_BITS				31:0
           `define  REG_CQPKT_WIDTH				32
           `define  REG_CQPKT_DEFAULT			32'h0
           `define  REG_CQPKT_ADDR				32'h1C

           `define  REG_CCPKT_BITS				31:0
           `define  REG_CCPKT_WIDTH				32
           `define  REG_CCPKT_DEFAULT			32'h0
           `define  REG_CCPKT_ADDR				32'h20

           `define  REG_XGETXPKT_BITS				31:0
           `define  REG_XGETXPKT_WIDTH				32
           `define  REG_XGETXPKT_DEFAULT			32'h0
           `define  REG_XGETXPKT_ADDR				32'h24

           `define  REG_XGERXPKT_BITS				31:0
           `define  REG_XGERXPKT_WIDTH				32
           `define  REG_XGERXPKT_DEFAULT			32'h0
           `define  REG_XGERXPKT_ADDR				32'h28

           `define  REG_PCIERQ_BITS				31:0
           `define  REG_PCIERQ_WIDTH				32
           `define  REG_PCIERQ_DEFAULT			32'h0
           `define  REG_PCIERQ_ADDR				32'h2C

           `define  REG_PCIEPHY_BITS				31:0
           `define  REG_PCIEPHY_WIDTH				32
           `define  REG_PCIEPHY_DEFAULT			32'h0
           `define  REG_PCIEPHY_ADDR				32'h30

           `define  REG_PCIECONFIG_BITS				31:0
           `define  REG_PCIECONFIG_WIDTH				32
           `define  REG_PCIECONFIG_DEFAULT			32'h0
           `define  REG_PCIECONFIG_ADDR				32'h34

           `define  REG_PCIECONFIG2_BITS				31:0
           `define  REG_PCIECONFIG2_WIDTH				32
           `define  REG_PCIECONFIG2_DEFAULT			32'h0
           `define  REG_PCIECONFIG2_ADDR				32'h38

           `define  REG_PCIEERROR_BITS				31:0
           `define  REG_PCIEERROR_WIDTH				32
           `define  REG_PCIEERROR_DEFAULT			32'h0
           `define  REG_PCIEERROR_ADDR				32'h3C

           `define  REG_PCIEMISC_BITS				31:0
           `define  REG_PCIEMISC_WIDTH				32
           `define  REG_PCIEMISC_DEFAULT			32'h0
           `define  REG_PCIEMISC_ADDR				32'h40

           `define  REG_PCIETPH_BITS				31:0
           `define  REG_PCIETPH_WIDTH				32
           `define  REG_PCIETPH_DEFAULT			32'h0
           `define  REG_PCIETPH_ADDR				32'h44

           `define  REG_PCIEFC1_BITS				31:0
           `define  REG_PCIEFC1_WIDTH				32
           `define  REG_PCIEFC1_DEFAULT			32'h0
           `define  REG_PCIEFC1_ADDR				32'h48

           `define  REG_PCIEFC2_BITS				31:0
           `define  REG_PCIEFC2_WIDTH				32
           `define  REG_PCIEFC2_DEFAULT			32'h0
           `define  REG_PCIEFC2_ADDR				32'h4C

           `define  REG_PCIEFC3_BITS				31:0
           `define  REG_PCIEFC3_WIDTH				32
           `define  REG_PCIEFC3_DEFAULT			32'h0
           `define  REG_PCIEFC3_ADDR				32'h50

           `define  REG_PCIEINTERRUPT_BITS				31:0
           `define  REG_PCIEINTERRUPT_WIDTH				32
           `define  REG_PCIEINTERRUPT_DEFAULT			32'h0
           `define  REG_PCIEINTERRUPT_ADDR				32'h54

           `define  REG_PCIEMSIDATA_BITS				31:0
           `define  REG_PCIEMSIDATA_WIDTH				32
           `define  REG_PCIEMSIDATA_DEFAULT			32'h0
           `define  REG_PCIEMSIDATA_ADDR				32'h58

           `define  REG_PCIEMSIINT_BITS				31:0
           `define  REG_PCIEMSIINT_WIDTH				32
           `define  REG_PCIEMSIINT_DEFAULT			32'h0
           `define  REG_PCIEMSIINT_ADDR				32'h5C

           `define  REG_PCIEMSIPENDINGSTATUS_BITS				31:0
           `define  REG_PCIEMSIPENDINGSTATUS_WIDTH				32
           `define  REG_PCIEMSIPENDINGSTATUS_DEFAULT			32'h0
           `define  REG_PCIEMSIPENDINGSTATUS_ADDR				32'h60

           `define  REG_PCIEMSIPENDINGSTATUS2_BITS				31:0
           `define  REG_PCIEMSIPENDINGSTATUS2_WIDTH				32
           `define  REG_PCIEMSIPENDINGSTATUS2_DEFAULT			32'h0
           `define  REG_PCIEMSIPENDINGSTATUS2_ADDR				32'h64

           `define  REG_PCIEINTERRUPT2_BITS				31:0
           `define  REG_PCIEINTERRUPT2_WIDTH				32
           `define  REG_PCIEINTERRUPT2_DEFAULT			32'h0
           `define  REG_PCIEINTERRUPT2_ADDR				32'h68
