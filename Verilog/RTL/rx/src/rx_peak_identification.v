/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
* rx_peak_identification.v v0.00                                              *
*                                                                             *
* @Author  Joao Miguel Fernandes Magalhaes                                    *
* @Contact up201305379@fe.up.fe                                               *
* @Date    08/03/2018 17:17:01 GMT                                            *
*                                                                             *
* This part of code is written in Verilog hardware description language (HDL).*
* Please visit http://en.wikipedia.org/wiki/Verilog (or some proper source)   *
* for more details on the language used herein.                               *
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


/**
 * GENERAL DESCRIPTION:
 *
 *
 * CONSTRAINTS:
 *
 *
 */

module rx_peak_identification(
  input  wire               crx_clk               ,  //clock signal
  input  wire               rrx_rst               ,  //reset signal
  input  wire               erx_en                ,  //enable signal

  input  wire        [32:0] icurrent_time         , 
   
  input  wire signed [15:0] isample_filtered      ,  //output of band_pass filter
                                                     //used to identify when a symbol
                                                     //has been received
  
  input wire                inew_samle_trigger    ,

  //Result of the correlation of the received samples
  //by each of the possible 16 pseudo-random binary sequences
  input  wire signed [15:0] isample_correlation_0 ,
  input  wire signed [15:0] isample_correlation_1 ,
  input  wire signed [15:0] isample_correlation_2 ,
  input  wire signed [15:0] isample_correlation_3 ,
  input  wire signed [15:0] isample_correlation_4 ,
  input  wire signed [15:0] isample_correlation_5 ,
  input  wire signed [15:0] isample_correlation_6 ,
  input  wire signed [15:0] isample_correlation_7 ,
  input  wire signed [15:0] isample_correlation_8 ,
  input  wire signed [15:0] isample_correlation_9 ,
  input  wire signed [15:0] isample_correlation_10,
  input  wire signed [15:0] isample_correlation_11,
  input  wire signed [15:0] isample_correlation_12,
  input  wire signed [15:0] isample_correlation_13,
  input  wire signed [15:0] isample_correlation_14,
  input  wire signed [15:0] isample_correlation_15,

  output reg  signed [15:0] o_sample_arm          ,  //Peak Value
  output reg          [3:0] o_received_seq        ,
  output reg         [15:0] o_time_arm            ,  //Timestamp
  output reg                o_trigger_arm            //Trigger
  );

  integer x;
  
  //Counts the number of clocks after a trigger
  reg [13:0] rpos_trigger_counter;

  reg signed [15:0] rhighest_sample [15:0];
  reg        [15:0] rtimestamp      [15:0];

  reg [3:0] rcounter_4bit;
  reg       rstart_comparing_seqs;

  wire signed [15:0] wsample_correlation [15:0];
  

  wire wtrigger_threshold;

  assign wtrigger_threshold = isample_filtered > 100 ? 1 : 0;

  //Counts the number of clocks after a trigger
  always @(posedge crx_clk) begin
    if (rrx_rst) begin
      rpos_trigger_counter <= 0;
    end else begin
      if (!erx_en) begin
        rpos_trigger_counter <= 0;
      end else begin
        if (wtrigger_threshold || (rpos_trigger_counter > 0)) begin
          rpos_trigger_counter <= rpos_trigger_counter + 1;
        end
      end
    end
  end

  
  //Compare incoming sample from correlation with the one alredy stored
  generate
    genvar i;
    for (i = 0; i < 16; i = i + 1) begin
      always @(posedge crx_clk) begin
        if (rrx_rst) begin
          rhighest_sample[i] <= 0;
        end else begin
          if (!erx_en) begin
            rhighest_sample[i] <= 0;
          end else begin
            if (wtrigger_threshold && rpos_trigger_counter == 0) begin
              rhighest_sample[i] <= 0;
            end else begin
              if (inew_samle_trigger) begin
                if (rhighest_sample[i] < wsample_correlation[i]) begin
                  //Replace sample by new highest sample
                  rhighest_sample[i] <= wsample_correlation[i];
                end
              end
            end
          end
        end 
      end
    end
  endgenerate


  //Assign isample_correlation_X to wires in vector for
  //Easier to use in privious genvar block
  assign wsample_correlation[0]  = isample_correlation_0 ;
  assign wsample_correlation[1]  = isample_correlation_1 ;
  assign wsample_correlation[2]  = isample_correlation_2 ;
  assign wsample_correlation[3]  = isample_correlation_3 ;
  assign wsample_correlation[4]  = isample_correlation_4 ;
  assign wsample_correlation[5]  = isample_correlation_5 ;
  assign wsample_correlation[6]  = isample_correlation_6 ;
  assign wsample_correlation[7]  = isample_correlation_7 ;
  assign wsample_correlation[8]  = isample_correlation_8 ;
  assign wsample_correlation[9]  = isample_correlation_9 ;
  assign wsample_correlation[10] = isample_correlation_10;
  assign wsample_correlation[11] = isample_correlation_11;
  assign wsample_correlation[12] = isample_correlation_12;
  assign wsample_correlation[13] = isample_correlation_13;
  assign wsample_correlation[14] = isample_correlation_14;
  assign wsample_correlation[15] = isample_correlation_15;


  //Signal to start comparing the highest values of the 16 correlations
  always @(posedge crx_clk) begin
    if (rrx_rst) begin
      rstart_comparing_seqs <= 0;
    end else begin
      if (!erx_en) begin
        rstart_comparing_seqs <= 0;
      end else begin
        if (rpos_trigger_counter > 16368) begin
          rstart_comparing_seqs  <= 1;
        end else begin
          rstart_comparing_seqs <= 0;
        end
      end
    end
  end


  //4bit counter, starts counting when rstart_comparing_seqs == 1
  always @(posedge crx_clk) begin
    if (rrx_rst) begin
      rcounter_4bit <= 0;
    end else begin
      if (!erx_en) begin
        rcounter_4bit <= 0;
      end else begin
        if (rstart_comparing_seqs) begin
          rcounter_4bit <= rcounter_4bit + 1;
        end else begin
          rcounter_4bit <= 0;
        end
      end
    end
  end


  //Compares the 16 highest samples from the 16 correlation and outputs the highest
  always @(posedge crx_clk) begin
    if (rrx_rst) begin
      o_sample_arm   <= 0;
      o_time_arm     <= 0;
      o_received_seq <= 0;
    end else begin
      if (!erx_en) begin
        o_sample_arm   <= 0;
        o_time_arm     <= 0;
        o_received_seq <= 0;
      end else begin
        if (rstart_comparing_seqs) begin
          if (rhighest_sample[rcounter_4bit] > o_sample_arm) begin
            o_sample_arm   <= rhighest_sample[rcounter_4bit];
            o_time_arm     <= rhighest_sample[rcounter_4bit];
            o_received_seq <= rcounter_4bit                 ;
          end
        end
      end
    end
  end


  //Final trigger
  always @(posedge crx_clk) begin
    if (rrx_rst) begin
      o_trigger_arm <= 0;
    end else begin
      if (!erx_en) begin
        o_trigger_arm <= 0;
      end else begin
        if (rcounter_4bit == 15) begin
          o_trigger_arm  <= 1;
        end else begin
          o_trigger_arm  <= 1;
        end
      end
    end
  end


endmodule


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\
*                                                                             *
*              @Copyright (C) 2018, #1Nadal, All Rights Reserved              *
*                                                                             *
\* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */