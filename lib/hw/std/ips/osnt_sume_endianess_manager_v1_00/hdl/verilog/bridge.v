//
// Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
// Junior University
// Copyright (c) 2016 University of Cambridge
// All rights reserved.
//
// This software was developed by University of Cambridge Computer Laboratory
// under the ENDEAVOUR project (grant agreement 644960) as part of
// the European Union's Horizon 2020 research and innovation programme.
//
// @NETFPGA_LICENSE_HEADER_START@
//
// Licensed to NetFPGA Open Systems C.I.C. (NetFPGA) under one or more
// contributor license agreements. See the NOTICE file distributed with this
// work for additional information regarding copyright ownership. NetFPGA
// licenses this file to you under the NetFPGA Hardware-Software License,
// Version 1.0 (the License); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at:
//
// http://www.netfpga-cic.org
//
// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// @NETFPGA_LICENSE_HEADER_END@
/*******************************************************************************
 *  File:
 *        bridge.v
 *
 *  Author:
 *        Gianni Antichi
 *
 *  Description:
 *        little endian to big endian bridge
 */


module bridge
#(
    parameter C_AXIS_DATA_WIDTH = 256,
    parameter C_AXIS_TUSER_WIDTH = 128,
    parameter NUM_QUEUES = 8,
    parameter NUM_QUEUES_WIDTH = log2(NUM_QUEUES)
)
(
    // Global Ports
    input clk,
    input reset,

    // little endian signals
    input [C_AXIS_DATA_WIDTH-1:0] s_axis_tdata,
    input [(C_AXIS_DATA_WIDTH/8)-1:0] s_axis_tstrb,
    input [C_AXIS_TUSER_WIDTH-1:0] s_axis_tuser,
    input  s_axis_tvalid,
    output reg s_axis_tready,
    input  s_axis_tlast,

    // big endian signals
    output reg [C_AXIS_DATA_WIDTH-1:0] m_axis_tdata,
    output reg[(C_AXIS_DATA_WIDTH/8)-1:0] m_axis_tstrb,
    output reg [C_AXIS_TUSER_WIDTH-1:0] m_axis_tuser,
    output reg  m_axis_tvalid,
    input m_axis_tready,
    output reg  m_axis_tlast

);



    function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
    endfunction


genvar i;


  always @(*) begin
    if (reset) begin
      m_axis_tuser = {C_AXIS_TUSER_WIDTH{1'b0}};
      m_axis_tvalid = 0;
      m_axis_tlast = 0;
      s_axis_tready = 0;
    end
    else begin
      m_axis_tuser = s_axis_tuser;
      m_axis_tvalid = s_axis_tvalid;
      m_axis_tlast = s_axis_tlast;
      s_axis_tready = m_axis_tready;
    end
  end



 generate
  for (i=0; i<(C_AXIS_DATA_WIDTH/8); i=i+1) begin: conversion
    always @(*) begin
     if (reset) begin
        m_axis_tdata[(i+1)*8-1:i*8] = 0;
        m_axis_tstrb[i] = 0;
      end
else begin
m_axis_tdata[(i+1)*8-1:i*8] = s_axis_tdata[((C_AXIS_DATA_WIDTH/8)-i)*8-1:((C_AXIS_DATA_WIDTH/8)-(i+1))*8];
        m_axis_tstrb[i] = s_axis_tstrb[(C_AXIS_DATA_WIDTH/8)-i-1];
end
    end
  end
  endgenerate

endmodule

