//
// Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
// Junior University
// Copyright (c) 2016 University of Cambridge
// Copyright (c) 2016 Jong Hun Han
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
 *        inter_packet_delay.v
 *
 *  Author:
 *        Muhammad Shahbaz
 *
 *  Description:
 */

module inter_packet_delay
#(
    //Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH   = 256,
    parameter C_S_AXIS_DATA_WIDTH   = 256,
    parameter C_M_AXIS_TUSER_WIDTH  = 128,
    parameter C_S_AXIS_TUSER_WIDTH  = 128,
    parameter C_S_AXI_DATA_WIDTH    = 32,
		parameter C_TUSER_TIMESTAMP_POS = 32
)
(
    // Global Ports
    input                                      axi_aclk,
    input                                      axi_aresetn,

    // Master Stream Ports (interface to data path)
    output reg [C_M_AXIS_DATA_WIDTH-1:0]       m_axis_tdata,
    output reg [((C_M_AXIS_DATA_WIDTH/8))-1:0] m_axis_tstrb,
    output reg [C_M_AXIS_TUSER_WIDTH-1:0]      m_axis_tuser,
    output reg                                 m_axis_tvalid,
    input                                      m_axis_tready,
    output reg                                 m_axis_tlast,

    // Slave Stream Ports (interface to RX queues)
    input [C_S_AXIS_DATA_WIDTH-1:0]            s_axis_tdata,
    input [((C_S_AXIS_DATA_WIDTH/8))-1:0]      s_axis_tstrb,
    input [C_S_AXIS_TUSER_WIDTH-1:0]           s_axis_tuser,
    input                                      s_axis_tvalid,
    output reg                                 s_axis_tready,
    input                                      s_axis_tlast,

	// Misc
    input                                      sw_rst,
    input                                      ipd_en,
    input                                      use_reg_val,
    input [C_S_AXI_DATA_WIDTH-1:0]             delay_reg_val
);

  // -- Local Functions
    function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
    endfunction

  // -- Internal Parameters
  parameter IN_PKT_HEADER = 0;
  parameter IN_PKT_BODY   = 1;

  // -- Signals
  reg                               state;
  reg                               next_state;

  reg                               in_fifo_rd_en;
  reg                               in_fifo_wr_en;
  wire                              in_fifo_nearly_full;
  wire                              in_fifo_empty;
  wire  [C_M_AXIS_DATA_WIDTH-1:0]   in_fifo_tdata;
  wire  [C_M_AXIS_TUSER_WIDTH-1:0]  in_fifo_tuser;
  wire  [C_M_AXIS_DATA_WIDTH/8-1:0] in_fifo_tstrb;
  wire                              in_fifo_tlast;

  reg   [63:0]                      timer_ticks;
  reg   [63:0]                      delay_val;
  reg   [63:0]                      delay_val_c;



  // -- Modules and Logic

  fallthrough_small_fifo #(.WIDTH(C_S_AXIS_DATA_WIDTH+C_S_AXIS_TUSER_WIDTH+C_S_AXIS_DATA_WIDTH/8+1), .MAX_DEPTH_BITS(2))
    input_fifo
      ( .din         ({s_axis_tlast, s_axis_tuser, s_axis_tstrb, s_axis_tdata}),
        .wr_en       (in_fifo_wr_en),
        .rd_en       (in_fifo_rd_en),
        .dout        ({in_fifo_tlast, in_fifo_tuser, in_fifo_tstrb, in_fifo_tdata}),
        .full        (),
        .prog_full   (),
        .nearly_full (in_fifo_nearly_full),
        .empty       (in_fifo_empty),
        .reset       (!axi_aresetn || sw_rst),
        .clk         (axi_aclk)
      );


  // ---- Primary State Machine [Combinational]
  always @ * begin
    next_state = IN_PKT_HEADER;

    in_fifo_rd_en = 0;
    in_fifo_wr_en = 0;

    delay_val_c = delay_val;

    m_axis_tdata  = {C_M_AXIS_DATA_WIDTH{1'b0}};
    m_axis_tstrb  = {C_M_AXIS_DATA_WIDTH/8{1'b0}};
    m_axis_tuser  = {C_M_AXIS_TUSER_WIDTH{1'b0}};
    m_axis_tvalid = 0;
    s_axis_tready = 0;
    m_axis_tlast = 0;

    if (!ipd_en) begin
  	  m_axis_tdata  = s_axis_tdata;
      m_axis_tstrb  = s_axis_tstrb;
      m_axis_tuser  = s_axis_tuser;
      m_axis_tvalid = s_axis_tvalid;
      s_axis_tready = m_axis_tready;
      m_axis_tlast  = s_axis_tlast;
    end
    else begin
      s_axis_tready = !in_fifo_nearly_full;
      in_fifo_wr_en = s_axis_tready && s_axis_tvalid;
	  
	  	m_axis_tdata  = in_fifo_tdata;
      m_axis_tstrb  = in_fifo_tstrb;
      m_axis_tuser  = in_fifo_tuser;

      case (state)
        IN_PKT_HEADER: begin
          if (!in_fifo_empty && (timer_ticks >= delay_val)) begin
            m_axis_tvalid = 1;

            if (m_axis_tready) begin
	          	// Get the delay value for the next packet
              delay_val_c = timer_ticks + ((use_reg_val) ? delay_reg_val
                                                         : in_fifo_tuser[C_TUSER_TIMESTAMP_POS+32-1:C_TUSER_TIMESTAMP_POS]); 
              in_fifo_rd_en = 1;

              if (!in_fifo_tlast)
                next_state   = IN_PKT_BODY;
			  			else
		        		m_axis_tlast = 1;
            end
          end
        end
		
        IN_PKT_BODY: begin
          next_state   = IN_PKT_BODY;
          if (!in_fifo_empty) begin
            m_axis_tvalid = 1;

            if (m_axis_tready) begin
              in_fifo_rd_en = 1;

              if (in_fifo_tlast) begin
			    			m_axis_tlast = 1;
                next_state = IN_PKT_HEADER;
			  			end
            end
          end
        end
      endcase
    end
  end

  // ---- Primary State Machine [Sequential]
  always @ (posedge axi_aclk) begin
    if(!axi_aresetn || sw_rst) begin
      state       <= IN_PKT_HEADER;
      timer_ticks <= {64{1'b0}};
      delay_val   <= {64{1'b0}};
    end
    else begin
      state       <= next_state;
      timer_ticks <= timer_ticks + 1;
      delay_val   <= delay_val_c;
    end
  end

endmodule

