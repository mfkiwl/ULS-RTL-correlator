/**
 * $Id: red_pitaya_scope.v 965 2014-01-24 13:39:56Z matej.oblak $
 *
 * @brief Red Pitaya oscilloscope application, used for capturing ADC data
 *        into BRAMs, which can be later read by SW.
 *
 * @Author Matej Oblak
 *
 * (c) Red Pitaya  http://www.redpitaya.com
 *
 * This part of code is written in Verilog hardware description language (HDL).
 * Please visit http://en.wikipedia.org/wiki/Verilog
 * for more details on the language used herein.
 */
/*
 * 2014-10-15 Nils Roos <doctor@smart.ms>
 * Replaced connection of BRAM to (slow) sys_bus with high performance AXI
 * connection to DDR controller. Added control registers for the DDR buffer
 * operation and location. 
 */


/**
 * GENERAL DESCRIPTION:
 *
 * This is simple data aquisition module, primerly used for scilloscope 
 * application. It consists from three main parts.
 *
 *
 *                /--------\      /-----------\            /-----\      /---
 *   ADC CHA ---> | DFILT1 | ---> | AVG & DEC | ----+----> | BUF | ---> |   
 *                \--------/      \-----------/     |      \-----/      | A 
 *                                                  ˇ         ^         | X 
 *                                              /------\      |         | I 
 *   ext trigger -----------------------------> | TRIG | -----+         | 2 
 *                                              \------/      |         | D 
 *                                                  ^         ˇ         | D 
 *                /--------\      /-----------\     |      /-----\      | R 
 *   ADC CHB ---> | DFILT1 | ---> | AVG & DEC | ----+----> | BUF | ---> |   
 *                \--------/      \-----------/            \-----/      \---
 *
 *
 * Input data is optionaly averaged and decimated via average filter.
 *
 * Trigger section makes triggers from input ADC data or external digital 
 * signal. To make trigger from analog signal schmitt trigger is used, external
 * trigger goes first over debouncer, which is separate for pos. and neg. edge.
 *
 * Data capture buffer is realized with BRAM. Writing into ram is done with 
 * arm/trig logic. With adc_arm_do signal (SW) writing is enabled, this is active
 * until trigger arrives and adc_dly_cnt counts to zero. Value adc_wp_trig
 * serves as pointer which shows when trigger arrived. This is used to show
 * pre-trigger data.
 * 
 */



module red_pitaya_scope_with_dsp
(
   // ADC
   input      [ 14-1: 0] adc_a_i         ,  //!< ADC data CHA
   input      [ 14-1: 0] adc_b_i         ,  //!< ADC data CHB
   input                 adc_clk_i       ,  //!< ADC clock
   input                 adc_rstn_i      ,  //!< ADC reset - active low
   input                 trig_ext_i      ,  //!< external trigger
   input                 trig_asg_i      ,  //!< ASG trigger

  
   // System bus
   input                 sys_clk_i       ,  //!< bus clock
   input                 sys_rstn_i      ,  //!< bus reset - active low
   input      [ 32-1: 0] sys_addr_i      ,  //!< bus saddress
   input      [ 32-1: 0] sys_wdata_i     ,  //!< bus write data
   input      [  4-1: 0] sys_sel_i       ,  //!< bus write byte select
   input                 sys_wen_i       ,  //!< bus write enable
   input                 sys_ren_i       ,  //!< bus read enable
   output     [ 32-1: 0] sys_rdata_o     ,  //!< bus read data
   output                sys_err_o       ,  //!< bus error indicator
   output                sys_ack_o       ,  //!< bus acknowledge signal

    // DDR Dump parameter export
    output      [   32-1:0] ddr_a_base_o    ,   // DDR ChA buffer base address
    output      [   32-1:0] ddr_a_end_o     ,   // DDR ChA buffer end address + 1
    input       [   32-1:0] ddr_a_curr_i    ,   // DDR ChA current write address
    output      [   32-1:0] ddr_b_base_o    ,   // DDR ChB buffer base address
    output      [   32-1:0] ddr_b_end_o     ,   // DDR ChB buffer end address + 1
    input       [   32-1:0] ddr_b_curr_i    ,   // DDR ChB current write address
    input       [    2-1:0] ddr_status_i    ,   // DDR [0,1]: INT pending A/B
    output                  ddr_stat_rd_o   ,   // DDR INT pending was read
    output      [    6-1:0] ddr_control_o   ,   // DDR [0,1]: dump enable flag A/B, [2,3]: reload curr A/B, [4,5]: INT enable A/B

    // Remote ADC buffer readout
    input           adcbuf_clk_i        ,   // clock
    input           adcbuf_rstn_i       ,   // reset
    input  [ 2-1:0] adcbuf_select_i     ,   //
    output [ 4-1:0] adcbuf_ready_o      ,   // buffer ready [0]: ChA 0-1k, [1]: ChA 1k-2k, [2]: ChB 0-1k, [3]: ChB 1k-2k
    input  [ 9-1:0] adcbuf_raddr_i      ,   //
    output [64-1:0] adcbuf_rdata_o      ,   //
    
    //new signal transmitted trigger
    input           inew_signal_trigg   ,
    input    [31:0] itimer  
);

// ID values to be read by the device driver, mapped at 40100ff0 - 40100fff
localparam SYS_ID = 32'h00200002; // ID: 32'hcccvvvvv, c=rp-deviceclass, v=versionnr
localparam SYS_1  = 32'h00000000;
localparam SYS_2  = 32'h00000000;
localparam SYS_3  = 32'h00000000;
genvar CNT;


wire [ 32-1: 0] addr         ;
wire [ 32-1: 0] wdata        ;
wire            wen          ;
wire            ren          ;
reg  [ 32-1: 0] rdata        ;
reg             err          ;
reg             ack          ;
reg             adc_arm_do   ;
reg             adc_rst_do   ;





//---------------------------------------------------------------------------------
//  Input filtering

wire [ 14-1: 0] adc_a_filt_in  ;
wire [ 14-1: 0] adc_a_filt_out ;
wire [ 14-1: 0] adc_b_filt_in  ;
wire [ 14-1: 0] adc_b_filt_out ;
reg  [ 18-1: 0] set_a_filt_aa  ;
reg  [ 25-1: 0] set_a_filt_bb  ;
reg  [ 25-1: 0] set_a_filt_kk  ;
reg  [ 25-1: 0] set_a_filt_pp  ;
reg  [ 18-1: 0] set_b_filt_aa  ;
reg  [ 25-1: 0] set_b_filt_bb  ;
reg  [ 25-1: 0] set_b_filt_kk  ;
reg  [ 25-1: 0] set_b_filt_pp  ;


assign adc_a_filt_out = adc_a_i ;
assign adc_b_filt_out = adc_b_i ;

/*
assign adc_a_filt_in = adc_a_i ;
assign adc_b_filt_in = adc_b_i ;

red_pitaya_dfilt1 i_dfilt1_cha
(
   // ADC
  .adc_clk_i   ( adc_clk_i       ),  // ADC clock
  .adc_rstn_i  ( adc_rstn_i      ),  // ADC reset - active low
  .adc_dat_i   ( adc_a_filt_in   ),  // ADC data
  .adc_dat_o   ( adc_a_filt_out  ),  // ADC data

   // configuration
  .cfg_aa_i    ( set_a_filt_aa   ),  // config AA coefficient
  .cfg_bb_i    ( set_a_filt_bb   ),  // config BB coefficient
  .cfg_kk_i    ( set_a_filt_kk   ),  // config KK coefficient
  .cfg_pp_i    ( set_a_filt_pp   )   // config PP coefficient
);

red_pitaya_dfilt1 i_dfilt1_chb
(
   // ADC
  .adc_clk_i   ( adc_clk_i       ),  // ADC clock
  .adc_rstn_i  ( adc_rstn_i      ),  // ADC reset - active low
  .adc_dat_i   ( adc_b_filt_in   ),  // ADC data
  .adc_dat_o   ( adc_b_filt_out  ),  // ADC data

   // configuration
  .cfg_aa_i    ( set_b_filt_aa   ),  // config AA coefficient
  .cfg_bb_i    ( set_b_filt_bb   ),  // config BB coefficient
  .cfg_kk_i    ( set_b_filt_kk   ),  // config KK coefficient
  .cfg_pp_i    ( set_b_filt_pp   )   // config PP coefficient
);
*/




//---------------------------------------------------------------------------------
//  Decimate input data

reg  [ 16-1: 0] adc_a_dat     ;
reg  [ 16-1: 0] adc_b_dat     ;
reg  [ 32-1: 0] adc_a_sum     ;
reg  [ 32-1: 0] adc_b_sum     ;
reg  [ 17-1: 0] set_dec       ;
reg  [ 17-1: 0] adc_dec_cnt   ;
reg             set_avg_en    ;
reg             adc_dv        ;

// Clock enable for decimated data:
wire            adc_dec_enable;


assign adc_dec_enable = ( adc_dec_cnt == 17'd1 );

always @(posedge adc_clk_i) begin
   if (adc_rstn_i == 1'b0) begin
      adc_a_sum   <= 32'h0 ;
      adc_b_sum   <= 32'h0 ;
      adc_dec_cnt <= 17'h0 ;
      adc_dv      <=  1'b0 ;
   end
   else begin
      if ((adc_dec_cnt >= set_dec) || adc_arm_do) begin // start again or arm
         adc_dec_cnt <= 17'h1                   ;
         adc_a_sum   <= $signed(adc_a_filt_out) ;
         adc_b_sum   <= $signed(adc_b_filt_out) ;
      end
      else begin
         adc_dec_cnt <= adc_dec_cnt + 17'h1 ;
         adc_a_sum   <= $signed(adc_a_sum) + $signed(adc_a_filt_out) ;
         adc_b_sum   <= $signed(adc_b_sum) + $signed(adc_b_filt_out) ;
      end

      adc_dv <= (adc_dec_cnt >= set_dec) ;

        case (set_dec & {17{set_avg_en}})
        17'h0:      begin   adc_a_dat <= {adc_a_filt_out,2'b00};    adc_b_dat <= {adc_b_filt_out,2'b00};    end
        17'h1:      begin   adc_a_dat <= {adc_a_sum[ 0+:14],2'b00}; adc_b_dat <= {adc_b_sum[ 0+:14],2'b00}; end
        17'h2:      begin   adc_a_dat <= {adc_a_sum[ 0+:15],1'b0};  adc_b_dat <= {adc_b_sum[ 0+:15],1'b0};  end
        17'h4:      begin   adc_a_dat <=  adc_a_sum[ 0+:16];        adc_b_dat <=  adc_b_sum[ 0+:16];        end
        17'h8:      begin   adc_a_dat <=  adc_a_sum[ 1+:16];        adc_b_dat <=  adc_b_sum[ 1+:16];        end
        17'h10:     begin   adc_a_dat <=  adc_a_sum[ 2+:16];        adc_b_dat <=  adc_b_sum[ 2+:16];        end
        17'h20:     begin   adc_a_dat <=  adc_a_sum[ 3+:16];        adc_b_dat <=  adc_b_sum[ 3+:16];        end
        17'h40:     begin   adc_a_dat <=  adc_a_sum[ 4+:16];        adc_b_dat <=  adc_b_sum[ 4+:16];        end
        17'h80:     begin   adc_a_dat <=  adc_a_sum[ 5+:16];        adc_b_dat <=  adc_b_sum[ 5+:16];        end
        17'h100:    begin   adc_a_dat <=  adc_a_sum[ 6+:16];        adc_b_dat <=  adc_b_sum[ 6+:16];        end
        17'h200:    begin   adc_a_dat <=  adc_a_sum[ 7+:16];        adc_b_dat <=  adc_b_sum[ 7+:16];        end
        17'h400:    begin   adc_a_dat <=  adc_a_sum[ 8+:16];        adc_b_dat <=  adc_b_sum[ 8+:16];        end
        17'h800:    begin   adc_a_dat <=  adc_a_sum[ 9+:16];        adc_b_dat <=  adc_b_sum[ 9+:16];        end
        17'h1000:   begin   adc_a_dat <=  adc_a_sum[10+:16];        adc_b_dat <=  adc_b_sum[10+:16];        end
        17'h2000:   begin   adc_a_dat <=  adc_a_sum[11+:16];        adc_b_dat <=  adc_b_sum[11+:16];        end
        17'h4000:   begin   adc_a_dat <=  adc_a_sum[12+:16];        adc_b_dat <=  adc_b_sum[12+:16];        end
        17'h8000:   begin   adc_a_dat <=  adc_a_sum[13+:16];        adc_b_dat <=  adc_b_sum[13+:16];        end
        17'h10000:  begin   adc_a_dat <=  adc_a_sum[14+:16];        adc_b_dat <=  adc_b_sum[14+:16];        end
        default:    begin   adc_a_dat <= {adc_a_sum[ 0+:14],2'b00}; adc_b_dat <= {adc_b_sum[ 0+:14],2'b00}; end
        // TODO put some magical tricks in default case to decimate with non-power-of-two factors
        endcase

   end
end

reg  [ 16-1: 0] adc_a_dat_sync;
reg  [ 16-1: 0] adc_b_dat_sync;


always @(posedge adc_clk_i) begin

	if (adc_rstn_i == 1'b0) begin		
		adc_a_dat_sync <= 0;
		adc_b_dat_sync <= 0;

	end
	else    
	if (adc_dec_enable) begin
		adc_a_dat_sync <= adc_a_dat;
		adc_b_dat_sync <= adc_b_dat;

	end
   
end
//---------------------------------------

// wire [14-1:0] adc_a_scope_in, adc_b_scope_in;
wire [16-1:0] dsp_a_scope_in, dsp_b_scope_in;

wire [16-1:0] ab_out_a, ab_out_b; // outputs from the DSP block

reg select_scope_in;

reg [32-1:0] config_WL_S_L_a;
reg [32-1:0] config_WL_S_H_a;
reg [32-1:0] config_WL_S_L_b;
reg [32-1:0] config_WL_S_H_b;
reg [32-1:0] config_N_ZEROS;
reg [32-1:0] config_WAITING_TIME;
reg [32-1:0] config_MAX_DELAY;
reg [32-1:0] config_RESET_TIME_AMPLITUDE;
wire [31:0] delay_out[3:0];
wire [31:0] delay_counter[3:0];
wire [31:0] amplitude_1;
wire [31:0] amplitude_2;
reg  [31:0] reset_dsp;
wire [31:0] start_amplitude_1;
wire [31:0] start_amplitude_2;


reg          [31:0] res_acquired;

wire signed [31:0] wpeak_value  ;
wire         [3:0] wreceived_seq;
wire        [31:0] wtimestamp   ;
wire               wseq_trigger ;
wire signed [31:0] wcorrelation_result [15:0];

wire wcorrelation_trigger; 

reg rcorrelation_trigger_aux;


//necessary connections to read from correlator_buff.v
reg rnext_s_from_buff_trigg ;
reg rall_s_acq_from_buff    ;
wire signed [31:0] wcorr_sample_from_buff ;
wire               wcorr_s_ready_from_buff;

reg rcorr_s_ready_from_buff;



/*************************************************************/
//buffered for timing reasons
reg signed [31:0] rwcorr_sample_from_buff ; 
reg               rwcorr_s_ready_from_buff;
always @(posedge adc_clk_i) begin
  if (reset_dsp[0]) begin
    rwcorr_sample_from_buff  <= 0;
    rwcorr_s_ready_from_buff <= 0;
  end else begin
    rwcorr_sample_from_buff  <= wcorr_sample_from_buff ;
    rwcorr_s_ready_from_buff <= wcorr_s_ready_from_buff;
  end
end
/*************************************************************/

rx_top_level rx_top_level_0(
  .crx_clk                 (adc_clk_i              ),  //clock signal
  .rrx_rst                 (reset_dsp[0]           ),  //reset signal
  .erx_en                  (1'b1                   ),  //enable signal

  .itimer                  (itimer                 ),  //Number of clocks since trigger
  
  .inew_signal_trigg       (inew_signal_trigg      ),  //new signal transmitted trigger

  .iresult_acquired_arm    (res_acquired[0]        ),
 
  .inew_sample             (adc_a_dat_sync         ),  //new sample in

  .inext_sample_trigg_buff (rnext_s_from_buff_trigg),  //signal corr buffer to put out the next sample
  .iall_acquired_buff_trigg(rall_s_acq_from_buff   ),  //signal buffer that all 128 samples have been acquired

  .o_correlator_0_arm      (wcorrelation_result[0] ),  //outputs of the 16 correlators
  .o_correlator_1_arm      (wcorrelation_result[1] ),
  .o_correlator_2_arm      (wcorrelation_result[2] ),
  .o_correlator_3_arm      (wcorrelation_result[3] ),
  .o_correlator_4_arm      (wcorrelation_result[4] ),
  .o_correlator_5_arm      (wcorrelation_result[5] ),
  .o_correlator_6_arm      (wcorrelation_result[6] ),
  .o_correlator_7_arm      (wcorrelation_result[7] ),
  .o_correlator_8_arm      (wcorrelation_result[8] ),
  .o_correlator_9_arm      (wcorrelation_result[9] ),
  .o_correlator_10_arm     (wcorrelation_result[10]),
  .o_correlator_11_arm     (wcorrelation_result[11]),
  .o_correlator_12_arm     (wcorrelation_result[12]),
  .o_correlator_13_arm     (wcorrelation_result[13]),
  .o_correlator_14_arm     (wcorrelation_result[14]),
  .o_correlator_15_arm     (wcorrelation_result[15]),

  .o_correlator_trigg      (wcorrelation_trigger    ),

  .o_sample_arm            (wpeak_value             ),  //Peak Value
  .o_received_seq          (wreceived_seq           ),
  .o_time_arm              (wtimestamp              ),  //Timestamp
  .o_trigger_arm           (wseq_trigger            ),  //Trigger

  .ocorr_sample_buff       (wcorr_sample_from_buff  ),  //sample stored in buffer
  .ocorr_sample_ready_buff (wcorr_s_ready_from_buff )   //signal from buffer every time a new sample has been outputed
);

always @(posedge adc_clk_i) begin
  if (reset_dsp[0]) begin
    rcorrelation_trigger_aux <= 0;
  end else begin
    if ((addr[19:0] == 20'h00300) && (rcorrelation_trigger_aux == 1) && (wen)) begin
      rcorrelation_trigger_aux <= wdata[0];
    end else begin
      if (rcorrelation_trigger_aux == 0) begin
        rcorrelation_trigger_aux <= wcorrelation_trigger;
      end
    end
  end
end

//request next sample from buffer
always @(posedge adc_clk_i) begin
  if (reset_dsp[0]) begin
    rnext_s_from_buff_trigg <= 0;
  end else begin
    if ((addr[19:0] == 20'h00200) && (rnext_s_from_buff_trigg == 0) && (wen)) begin
      rnext_s_from_buff_trigg <= wdata[0];
    end else begin
      rnext_s_from_buff_trigg <= 0;
    end
  end
end

//signal buffer that all samples have been acquired
always @(posedge adc_clk_i) begin
  if (reset_dsp[0]) begin
    rall_s_acq_from_buff <= 0;
  end else begin
    if ((addr[19:0] == 20'h0020C) && (rall_s_acq_from_buff == 0) && (wen)) begin
      rall_s_acq_from_buff <= wdata[0];
    end else begin
      rall_s_acq_from_buff <= 0;
    end
  end
end

//sample ready to be read by arm
always @(posedge adc_clk_i) begin
  if (reset_dsp[0]) begin
    rcorr_s_ready_from_buff <= 0;
  end else begin
    if (rwcorr_s_ready_from_buff) begin
      rcorr_s_ready_from_buff <= 1;
    end else begin
      if (rnext_s_from_buff_trigg) begin
        rcorr_s_ready_from_buff <= 0;
      end
    end
  end
end

         
// Muxes to select the input top the scope path:
assign dsp_a_scope_in = ( select_scope_in ) ? ab_out_a : adc_a_dat ;         
assign dsp_b_scope_in = ( select_scope_in ) ? ab_out_b : adc_b_dat ;         




//---------------------------------------



//---------------------------------------------------------------------------------
//  ADC buffer RAM

wire [63:0] buf_a_data_o;
wire [63:0] buf_b_data_o;
reg  [10:0] adc_buf_wp;

localparam RSZ = 14 ;  // RAM size 2^RSZ

reg   [  14-1: 0] adc_a_buf [0:(1<<RSZ)-1] ;
reg   [  14-1: 0] adc_b_buf [0:(1<<RSZ)-1] ;
reg   [  14-1: 0] adc_a_rd      ;
reg   [  14-1: 0] adc_b_rd      ;
reg   [ RSZ-1: 0] adc_wp        ;
(* ASYNC_REG="true" *)  reg   [ RSZ-1: 0] adc_raddr     ;
reg   [ RSZ-1: 0] adc_a_raddr   ;
reg   [ RSZ-1: 0] adc_b_raddr   ;
(* ASYNC_REG="true" *)  reg   [   4-1: 0] adc_rval      ;
wire              adc_rd_dv     ;
reg               adc_we        ;
reg               adc_trig      ;

reg   [ RSZ-1: 0] adc_wp_trig   ;
reg   [ RSZ-1: 0] adc_wp_cur    ;
reg   [  32-1: 0] set_dly       ;
reg   [  32-1: 0] adc_dly_cnt   ;
reg               adc_dly_do    ;
/*
BRAM_SDP_MACRO #(
    .BRAM_SIZE("36Kb"),             // Target BRAM, "18Kb" or "36Kb" 
    .DEVICE("7SERIES"),             // Target device: "7SERIES" 
    .WRITE_WIDTH(16),               // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    .READ_WIDTH(64),                // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    .DO_REG(0),                     // Optional output register (0 or 1)
    .INIT_FILE("NONE"),
    .SIM_COLLISION_CHECK("ALL"),    // Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
    .SRVAL(72'h000000000000000000), // Set/Reset value for port output
    .INIT(72'h000000000000000000),  // Initial values on output port
    .WRITE_MODE("WRITE_FIRST"),     // "READ_FIRST" for same clock or synchronous clocks, "WRITE_FIRST" for asynchronous clocks on ports
    // why don't these have built-in defaults ?
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),    
    // The next set of INIT_xx are valid when configured as 36Kb
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),    
    // The next set of INITP_xx are for the parity bits
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),    
    // The next set of INITP_xx are valid when configured as 36Kb
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000)
) adc_a_buffer (
    .DO     (buf_a_data_o       ),  // Output read data port, width defined by READ_WIDTH parameter
    .DI     (dsp_a_scope_in     ),  // Input write data port, width defined by WRITE_WIDTH parameter
    .RDADDR (adcbuf_raddr_i     ),  // Input read address, width defined by read port depth
    .RDCLK  (adcbuf_clk_i       ),  // 1-bit input read clock
    .RDEN   (adcbuf_select_i[0] ),  // 1-bit input read port enable
    .REGCE  (1'b0               ),  // 1-bit input read output register enable
    .RST    (!adcbuf_rstn_i     ),  // 1-bit input reset      
    .WE     ({2{adc_we}}        ),  // Input write enable, width defined by write port depth
    .WRADDR (adc_buf_wp         ),  // Input write address, width defined by write port depth
    .WRCLK  (adc_clk_i          ),  // 1-bit input write clock
    .WREN   (adc_dv             )   // 1-bit input write port enable
);

BRAM_SDP_MACRO #(
    .BRAM_SIZE("36Kb"),             // Target BRAM, "18Kb" or "36Kb" 
    .DEVICE("7SERIES"),             // Target device: "7SERIES" 
    .WRITE_WIDTH(16),               // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    .READ_WIDTH(64),                // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    .DO_REG(0),                     // Optional output register (0 or 1)
    .INIT_FILE("NONE"),
    .SIM_COLLISION_CHECK("ALL"),    // Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
    .SRVAL(72'h000000000000000000), // Set/Reset value for port output
    .INIT(72'h000000000000000000),  // Initial values on output port
    .WRITE_MODE("WRITE_FIRST"),     // "READ_FIRST" for same clock or synchronous clocks, "WRITE_FIRST" for asynchronous clocks on ports
    // why don't these have built-in defaults ?
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),    
    // The next set of INIT_xx are valid when configured as 36Kb
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),    
    // The next set of INITP_xx are for the parity bits
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),    
    // The next set of INITP_xx are valid when configured as 36Kb
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000)
) adc_b_buffer (
    .DO     (buf_b_data_o       ),  // Output read data port, width defined by READ_WIDTH parameter
    .DI     (dsp_b_scope_in     ),  // Input write data port, width defined by WRITE_WIDTH parameter
    .RDADDR (adcbuf_raddr_i     ),  // Input read address, width defined by read port depth
    .RDCLK  (adcbuf_clk_i       ),  // 1-bit input read clock
    .RDEN   (adcbuf_select_i[1] ),  // 1-bit input read port enable
    .REGCE  (1'b0               ),  // 1-bit input read output register enable
    .RST    (!adcbuf_rstn_i     ),  // 1-bit input reset      
    .WE     ({2{adc_we}}        ),  // Input write enable, width defined by write port depth
    .WRADDR (adc_buf_wp         ),  // Input write address, width defined by write port depth
    .WRCLK  (adc_clk_i          ),  // 1-bit input write clock
    .WREN   (adc_dv             )   // 1-bit input write port enable
);
*/
assign adcbuf_rdata_o = {64{(adcbuf_select_i == 2'b01)}} & buf_a_data_o |
                        {64{(adcbuf_select_i == 2'b10)}} & buf_b_data_o;

(* ASYNC_REG="true" *)  reg     [2:0]   addr_sync;

always @(posedge adcbuf_clk_i) begin
    if (!adcbuf_rstn_i) begin
        addr_sync <= 3'b000;
    end else begin
        addr_sync <= {addr_sync[1:0],adc_buf_wp[10]};
    end
end

assign adcbuf_ready_o[0] = !addr_sync[2] &  addr_sync[1];
assign adcbuf_ready_o[1] =  addr_sync[2] & !addr_sync[1];
assign adcbuf_ready_o[2] = !addr_sync[2] &  addr_sync[1];
assign adcbuf_ready_o[3] =  addr_sync[2] & !addr_sync[1];

always @(posedge adc_clk_i) begin
    if (!adc_rstn_i) begin
        adc_buf_wp  <= 11'h000;
    end else begin
        if (adc_rst_do) begin
            adc_buf_wp <= 11'h000;
        end else if (adc_we & adc_dv) begin
            adc_buf_wp <= adc_buf_wp + 11'h001;
        end
    end
end


// Write
always @(posedge adc_clk_i) begin
   if (adc_rstn_i == 1'b0) begin
      adc_wp      <= {RSZ{1'b0}};
      adc_we      <=  1'b0      ;
      adc_wp_trig <= {RSZ{1'b0}};
      adc_wp_cur  <= {RSZ{1'b0}};
      adc_dly_cnt <= 32'h0      ;
      adc_dly_do  <=  1'b0      ;
   end
   else begin
      if (adc_arm_do)
         adc_we <= 1'b1 ;
      else if (((adc_dly_do || adc_trig) && (adc_dly_cnt == 32'h0)) || adc_rst_do) //delayed reached or reset
         adc_we <= 1'b0 ;


      if (adc_rst_do)
         adc_wp <= {RSZ{1'b0}};
      else if (adc_we && adc_dv)
         adc_wp <= adc_wp + 1'b1 ;

      if (adc_rst_do)
         adc_wp_trig <= {RSZ{1'b0}};
      else if (adc_trig && !adc_dly_do)
         adc_wp_trig <= adc_wp_cur ; // save write pointer at trigger arrival

      if (adc_rst_do)
         adc_wp_cur <= {RSZ{1'b0}};
      else if (adc_we && adc_dv)
         adc_wp_cur <= adc_wp ; // save current write pointer


      if (adc_trig)
         adc_dly_do  <= 1'b1 ;
      else if ((adc_dly_do && (adc_dly_cnt == 32'b0)) || adc_rst_do || adc_arm_do) //delayed reached or reset
         adc_dly_do  <= 1'b0 ;

      if (adc_dly_do && adc_we && adc_dv)
         adc_dly_cnt <= adc_dly_cnt + {32{1'b1}} ; // -1
      else if (!adc_dly_do)
         adc_dly_cnt <= set_dly ;

   end
end

always @(posedge adc_clk_i) begin
   if (adc_we && adc_dv) begin
      adc_a_buf[adc_wp] <= dsp_a_scope_in[16-1:2];
      adc_b_buf[adc_wp] <= dsp_b_scope_in[16-1:2];
   end
end

// Read
always @(posedge adc_clk_i) begin
   if (adc_rstn_i == 1'b0)
      adc_rval <= 4'h0 ;
   else
      adc_rval <= {adc_rval[2:0], (ren || wen)};
end
assign adc_rd_dv = adc_rval[3];

always @(posedge adc_clk_i) begin
   adc_raddr   <= addr[RSZ+1:2] ; // address synchronous to clock
   adc_a_raddr <= adc_raddr     ; // double register 
   adc_b_raddr <= adc_raddr     ; // otherwise memory corruption at reading
   adc_a_rd    <= adc_a_buf[adc_a_raddr] ;
   adc_b_rd    <= adc_b_buf[adc_b_raddr] ;
end





//---------------------------------------------------------------------------------
//
//  Trigger source selector

reg               adc_trig_ap      ;
reg               adc_trig_an      ;
reg               adc_trig_bp      ;
reg               adc_trig_bn      ;
reg               adc_trig_sw      ;
reg   [   4-1: 0] set_trig_src     ;
wire              ext_trig_p       ;
wire              ext_trig_n       ;
wire              asg_trig_p       ;
wire              asg_trig_n       ;


always @(posedge adc_clk_i) begin
   if (adc_rstn_i == 1'b0) begin
      adc_arm_do    <= 1'b0 ;
      adc_rst_do    <= 1'b0 ;
      adc_trig_sw   <= 1'b0 ;
      set_trig_src  <= 4'h0 ;
      adc_trig      <= 1'b0 ;
   end
   else begin
      adc_arm_do  <= wen && (addr[19:0]==20'h0) && wdata[0] ; // SW ARM
      adc_rst_do  <= wen && (addr[19:0]==20'h0) && wdata[1] ;
      adc_trig_sw <= wen && (addr[19:0]==20'h4) ; // SW trigger

      if (wen && (addr[19:0]==20'h4))
         set_trig_src <= wdata[3:0] ;
      else if (((adc_dly_do || adc_trig) && (adc_dly_cnt == 32'h0)) || adc_rst_do) //delayed reached or reset
         set_trig_src <= 4'h0 ;

      case (set_trig_src)
          4'd1 : adc_trig <= adc_trig_sw   ; // manual
          4'd2 : adc_trig <= adc_trig_ap   ; // A ch rising edge
          4'd3 : adc_trig <= adc_trig_an   ; // A ch falling edge
          4'd4 : adc_trig <= adc_trig_bp   ; // B ch rising edge
          4'd5 : adc_trig <= adc_trig_bn   ; // B ch falling edge
          4'd6 : adc_trig <= ext_trig_p    ; // external - rising edge
          4'd7 : adc_trig <= ext_trig_n    ; // external - falling edge
          4'd8 : adc_trig <= asg_trig_p    ; // ASG - rising edge
          4'd9 : adc_trig <= asg_trig_n    ; // ASG - falling edge
       default : adc_trig <= 1'b0          ;
      endcase
   end
end




//---------------------------------------------------------------------------------
//
//  Trigger created from input signal

reg  [  2-1: 0] adc_scht_ap  ;
reg  [  2-1: 0] adc_scht_an  ;
reg  [  2-1: 0] adc_scht_bp  ;
reg  [  2-1: 0] adc_scht_bn  ;
reg  [ 14-1: 0] set_a_tresh  ;
reg  [ 14-1: 0] set_a_treshp ;
reg  [ 14-1: 0] set_a_treshm ;
reg  [ 14-1: 0] set_b_tresh  ;
reg  [ 14-1: 0] set_b_treshp ;
reg  [ 14-1: 0] set_b_treshm ;
reg  [ 14-1: 0] set_a_hyst   ;
reg  [ 14-1: 0] set_b_hyst   ;
/*
always @(posedge adc_clk_i) begin
   if (adc_rstn_i == 1'b0) begin
      adc_scht_ap  <=  2'h0 ;
      adc_scht_an  <=  2'h0 ;
      adc_scht_bp  <=  2'h0 ;
      adc_scht_bn  <=  2'h0 ;
      adc_trig_ap  <=  1'b0 ;
      adc_trig_an  <=  1'b0 ;
      adc_trig_bp  <=  1'b0 ;
      adc_trig_bn  <=  1'b0 ;
   end
   else begin
      set_a_treshp <= set_a_tresh + set_a_hyst ; // calculate positive
      set_a_treshm <= set_a_tresh - set_a_hyst ; // and negative treshold
      set_b_treshp <= set_b_tresh + set_b_hyst ;
      set_b_treshm <= set_b_tresh - set_b_hyst ;

      if (adc_dv) begin
              if ($signed(dsp_a_scope_in[16-1:2]) >= $signed(set_a_tresh ))      adc_scht_ap[0] <= 1'b1 ;  // treshold reached
         else if ($signed(dsp_a_scope_in[16-1:2]) <  $signed(set_a_treshm))      adc_scht_ap[0] <= 1'b0 ;  // wait until it goes under hysteresis
              if ($signed(dsp_a_scope_in[16-1:2]) <= $signed(set_a_tresh ))      adc_scht_an[0] <= 1'b1 ;  // treshold reached
         else if ($signed(dsp_a_scope_in[16-1:2]) >  $signed(set_a_treshp))      adc_scht_an[0] <= 1'b0 ;  // wait until it goes over hysteresis

              if ($signed(dsp_b_scope_in[16-1:2]) >= $signed(set_b_tresh ))      adc_scht_bp[0] <= 1'b1 ;
         else if ($signed(dsp_b_scope_in[16-1:2]) <  $signed(set_b_treshm))      adc_scht_bp[0] <= 1'b0 ;
              if ($signed(dsp_b_scope_in[16-1:2]) <= $signed(set_b_tresh ))      adc_scht_bn[0] <= 1'b1 ;
         else if ($signed(dsp_b_scope_in[16-1:2]) >  $signed(set_b_treshp))      adc_scht_bn[0] <= 1'b0 ;
      end

      adc_scht_ap[1] <= adc_scht_ap[0] ;
      adc_scht_an[1] <= adc_scht_an[0] ;
      adc_scht_bp[1] <= adc_scht_bp[0] ;
      adc_scht_bn[1] <= adc_scht_bn[0] ;

      adc_trig_ap <= adc_scht_ap[0] && !adc_scht_ap[1] ; // make 1 cyc pulse 
      adc_trig_an <= adc_scht_an[0] && !adc_scht_an[1] ;
      adc_trig_bp <= adc_scht_bp[0] && !adc_scht_bp[1] ;
      adc_trig_bn <= adc_scht_bn[0] && !adc_scht_bn[1] ;
   end
end

*/



//---------------------------------------------------------------------------------
//
//  External trigger

(* ASYNC_REG="true" *)  reg  [  3-1: 0] ext_trig_in    ;
reg  [  2-1: 0] ext_trig_dp    ;
reg  [  2-1: 0] ext_trig_dn    ;
reg  [ 20-1: 0] ext_trig_debp  ;
reg  [ 20-1: 0] ext_trig_debn  ;
(* ASYNC_REG="true" *)  reg  [  3-1: 0] asg_trig_in    ;
reg  [  2-1: 0] asg_trig_dp    ;
reg  [  2-1: 0] asg_trig_dn    ;
reg  [ 20-1: 0] asg_trig_debp  ;
reg  [ 20-1: 0] asg_trig_debn  ;

/*
always @(posedge adc_clk_i) begin
   if (adc_rstn_i == 1'b0) begin
      ext_trig_in   <=  3'h0 ;
      ext_trig_dp   <=  2'h0 ;
      ext_trig_dn   <=  2'h0 ;
      ext_trig_debp <= 20'h0 ;
      ext_trig_debn <= 20'h0 ;
      asg_trig_in   <=  3'h0 ;
      asg_trig_dp   <=  2'h0 ;
      asg_trig_dn   <=  2'h0 ;
      asg_trig_debp <= 20'h0 ;
      asg_trig_debn <= 20'h0 ;
   end
   else begin
      //----------- External trigger
      // synchronize FFs
      ext_trig_in <= {ext_trig_in[1:0],trig_ext_i} ;

      // look for input changes
      if ((ext_trig_debp == 20'h0) && (ext_trig_in[1] && !ext_trig_in[2]))
         ext_trig_debp <= 20'd62500 ; // ~0.5ms
      else if (ext_trig_debp != 20'h0)
         ext_trig_debp <= ext_trig_debp - 20'd1 ;

      if ((ext_trig_debn == 20'h0) && (!ext_trig_in[1] && ext_trig_in[2]))
         ext_trig_debn <= 20'd62500 ; // ~0.5ms
      else if (ext_trig_debn != 20'h0)
         ext_trig_debn <= ext_trig_debn - 20'd1 ;

      // update output values
      ext_trig_dp[1] <= ext_trig_dp[0] ;
      if (ext_trig_debp == 20'h0)
         ext_trig_dp[0] <= ext_trig_in[1] ;

      ext_trig_dn[1] <= ext_trig_dn[0] ;
      if (ext_trig_debn == 20'h0)
         ext_trig_dn[0] <= ext_trig_in[1] ;




      //----------- ASG trigger
      // synchronize FFs
      asg_trig_in <= {asg_trig_in[1:0],trig_asg_i} ;

      // look for input changes
      if ((asg_trig_debp == 20'h0) && (asg_trig_in[1] && !asg_trig_in[2]))
         asg_trig_debp <= 20'd62500 ; // ~0.5ms
      else if (asg_trig_debp != 20'h0)
         asg_trig_debp <= asg_trig_debp - 20'd1 ;

      if ((asg_trig_debn == 20'h0) && (!asg_trig_in[1] && asg_trig_in[2]))
         asg_trig_debn <= 20'd62500 ; // ~0.5ms
      else if (asg_trig_debn != 20'h0)
         asg_trig_debn <= asg_trig_debn - 20'd1 ;

      // update output values
      asg_trig_dp[1] <= asg_trig_dp[0] ;
      if (asg_trig_debp == 20'h0)
         asg_trig_dp[0] <= asg_trig_in[1] ;

      asg_trig_dn[1] <= asg_trig_dn[0] ;
      if (asg_trig_debn == 20'h0)
         asg_trig_dn[0] <= asg_trig_in[1] ;
   end
end
*/

assign ext_trig_p = (ext_trig_dp == 2'b01) ;
assign ext_trig_n = (ext_trig_dn == 2'b10) ;
assign asg_trig_p = (asg_trig_dp == 2'b01) ;
assign asg_trig_n = (asg_trig_dn == 2'b10) ;





//---------------------------------------------------------------------------------
//
//  System bus connection

reg  [  32-1:0] ddr_a_base;     // DDR ChA buffer base address
reg  [  32-1:0] ddr_a_end;      // DDR ChA buffer end address + 1
reg  [  32-1:0] ddr_b_base;     // DDR ChB buffer base address
reg  [  32-1:0] ddr_b_end;      // DDR ChB buffer end address + 1
reg  [   6-1:0] ddr_control;    // DDR [0,1]: dump enable flag A/B, [2,3]: reload curr A/B, [4,5]: INT enable A/B

assign ddr_a_base_o  = ddr_a_base;
assign ddr_a_end_o   = ddr_a_end;
assign ddr_b_base_o  = ddr_b_base;
assign ddr_b_end_o   = ddr_b_end;
assign ddr_control_o = ddr_control;
assign ddr_stat_rd_o = ren & (addr[19:0] == 20'h0011c);

always @(posedge adc_clk_i) begin
   if (adc_rstn_i == 1'b0) begin
      set_a_tresh   <=  14'd5000   ;
      set_b_tresh   <= -14'd5000   ;
      set_dly       <=  32'd0      ;
      set_dec       <=  17'd128    ; //alterei era 17'd1
      set_a_hyst    <=  14'd20     ;
      set_b_hyst    <=  14'd20     ;
      set_avg_en    <=   1'b1      ;
      set_a_filt_aa <=  18'h0      ;
      set_a_filt_bb <=  25'h0      ;
      set_a_filt_kk <=  25'hFFFFFF ;
      set_a_filt_pp <=  25'h0      ;
      set_b_filt_aa <=  18'h0      ;
      set_b_filt_bb <=  25'h0      ;
      set_b_filt_kk <=  25'hFFFFFF ;
      set_b_filt_pp <=  25'h0      ;
        ddr_a_base  <= 32'h00000000;
        ddr_a_end   <= 32'h00000000;
        ddr_b_base  <= 32'h00000000;
        ddr_b_end   <= 32'h00000000;
        ddr_control <= 6'b000000;

        //++++++++++++++++++++++++++ CONNECTIONS FOR RX_TOP_LEVEL ++++++++++++++++++++++++++++++++++\\
        res_acquired             <= 0;
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\\
   end
   else begin
      if (wen) begin
         if (addr[19:0]==20'h8)    set_a_tresh <= wdata[14-1:0] ;
         if (addr[19:0]==20'hC)    set_b_tresh <= wdata[14-1:0] ;
         if (addr[19:0]==20'h10)   set_dly     <= wdata[32-1:0] ;
         if (addr[19:0]==20'h14)   set_dec     <= wdata[17-1:0] ;
         if (addr[19:0]==20'h20)   set_a_hyst  <= wdata[14-1:0] ;
         if (addr[19:0]==20'h24)   set_b_hyst  <= wdata[14-1:0] ;
         if (addr[19:0]==20'h28)   set_avg_en  <= wdata[     0] ;

         if (addr[19:0]==20'h30)   set_a_filt_aa <= wdata[18-1:0] ;
         if (addr[19:0]==20'h34)   set_a_filt_bb <= wdata[25-1:0] ;
         if (addr[19:0]==20'h38)   set_a_filt_kk <= wdata[25-1:0] ;
         if (addr[19:0]==20'h3C)   set_a_filt_pp <= wdata[25-1:0] ;
         if (addr[19:0]==20'h40)   set_b_filt_aa <= wdata[18-1:0] ;
         if (addr[19:0]==20'h44)   set_b_filt_bb <= wdata[25-1:0] ;
         if (addr[19:0]==20'h48)   set_b_filt_kk <= wdata[25-1:0] ;
         if (addr[19:0]==20'h4C)   set_b_filt_pp <= wdata[25-1:0] ;

        if (addr[19:0] == 20'h100)  ddr_control <= wdata[5:0];
        if (addr[19:0] == 20'h104)  ddr_a_base  <= wdata;
        if (addr[19:0] == 20'h108)  ddr_a_end   <= wdata;
        if (addr[19:0] == 20'h10c)  ddr_b_base  <= wdata;
        if (addr[19:0] == 20'h110)  ddr_b_end   <= wdata;

    // Control of the DSP modules:            
        /*if (addr[19:0] == 20'h00200)  select_scope_in <= wdata[0];
        if (addr[19:0] == 20'h00204)  config_WL_S_L_a <= wdata;
        if (addr[19:0] == 20'h00208)  config_WL_S_H_a <= wdata;
        if (addr[19:0] == 20'h0020c)  config_N_ZEROS <= wdata;
        if (addr[19:0] == 20'h00210)  config_WAITING_TIME <= wdata;
        if (addr[19:0] == 20'h00214)  reset_dsp <= wdata;
        if (addr[19:0] == 20'h00218)  config_WL_S_L_b <= wdata;
        if (addr[19:0] == 20'h0021c)  config_WL_S_H_b <= wdata;
        if (addr[19:0] == 20'h00220)  config_MAX_DELAY <= wdata;
        if (addr[19:0] == 20'h00224)  config_RESET_TIME_AMPLITUDE <= wdata;*/

        //++++++++++++++++++++++++++ CONNECTIONS FOR RX_TOP_LEVEL ++++++++++++++++++++++++++++++++++\\
        if (addr[19:0] == 20'h002F0)  reset_dsp    <= wdata;
        if (addr[19:0] == 20'h00414)  res_acquired <= wdata;
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\\
                    

      end
   end
end





always @(*) begin
   err <= 1'b0 ;

   casez (addr[19:0])
     20'h00004 : begin ack <= 1'b1;  rdata <= {{32- 4{1'b0}}, set_trig_src}       ; end 

     20'h00008 : begin ack <= 1'b1;  rdata <= {{32-14{1'b0}}, set_a_tresh}        ; end
     20'h0000C : begin ack <= 1'b1;  rdata <= {{32-14{1'b0}}, set_b_tresh}        ; end
     20'h00010 : begin ack <= 1'b1;  rdata <= {               set_dly}            ; end
     20'h00014 : begin ack <= 1'b1;  rdata <= {{32-17{1'b0}}, set_dec}            ; end

     20'h00018 : begin ack <= 1'b1;  rdata <= {{32-RSZ{1'b0}}, adc_wp_cur}        ; end
     20'h0001C : begin ack <= 1'b1;  rdata <= {{32-RSZ{1'b0}}, adc_wp_trig}       ; end

     20'h00020 : begin ack <= 1'b1;  rdata <= {{32-14{1'b0}}, set_a_hyst}         ; end
     20'h00024 : begin ack <= 1'b1;  rdata <= {{32-14{1'b0}}, set_b_hyst}         ; end

     20'h00028 : begin ack <= 1'b1;  rdata <= {{32- 1{1'b0}}, set_avg_en}         ; end

     20'h00030 : begin ack <= 1'b1;  rdata <= {{32-18{1'b0}}, set_a_filt_aa}      ; end
     20'h00034 : begin ack <= 1'b1;  rdata <= {{32-25{1'b0}}, set_a_filt_bb}      ; end
     20'h00038 : begin ack <= 1'b1;  rdata <= {{32-25{1'b0}}, set_a_filt_kk}      ; end
     20'h0003C : begin ack <= 1'b1;  rdata <= {{32-25{1'b0}}, set_a_filt_pp}      ; end
     20'h00040 : begin ack <= 1'b1;  rdata <= {{32-18{1'b0}}, set_b_filt_aa}      ; end
     20'h00044 : begin ack <= 1'b1;  rdata <= {{32-25{1'b0}}, set_b_filt_bb}      ; end
     20'h00048 : begin ack <= 1'b1;  rdata <= {{32-25{1'b0}}, set_b_filt_kk}      ; end
     20'h0004C : begin ack <= 1'b1;  rdata <= {{32-25{1'b0}}, set_b_filt_pp}      ; end

    20'h00100:  begin   ack <= 1'b1; rdata <= {{32-6{1'b0}},ddr_control};  end
    20'h00104:  begin   ack <= 1'b1; rdata <= ddr_a_base;   end
    20'h00108:  begin   ack <= 1'b1; rdata <= ddr_a_end;    end
    20'h0010c:  begin   ack <= 1'b1; rdata <= ddr_b_base;   end
    20'h00110:  begin   ack <= 1'b1; rdata <= ddr_b_end;    end
    20'h00114:  begin   ack <= 1'b1; rdata <= ddr_a_curr_i; end
    20'h00118:  begin   ack <= 1'b1; rdata <= ddr_b_curr_i; end
    20'h0011c:  begin   ack <= 1'b1; rdata <= {{32-2{1'b0}},ddr_status_i};  end
    
    // Read DSP configuration registers:
    /*20'h00200:  begin   ack <= 1'b1; rdata <= { 31'b0,select_scope_in };  end
    20'h00204:  begin   ack <= 1'b1; rdata <= config_WL_S_L_a;  end
    20'h00208:  begin   ack <= 1'b1; rdata <= config_WL_S_H_a;  end
    20'h0020c:  begin   ack <= 1'b1; rdata <= config_N_ZEROS;  end
    20'h00210:  begin   ack <= 1'b1; rdata <= config_WAITING_TIME;  end
    20'h00214:  begin   ack <= 1'b1; rdata <= reset_dsp;  end
    20'h00218:  begin   ack <= 1'b1; rdata <= config_WL_S_L_b;  end
    20'h0021c:  begin   ack <= 1'b1; rdata <= config_WL_S_H_b;  end
    20'h00220:  begin   ack <= 1'b1; rdata <= config_MAX_DELAY;  end
    20'h00224:  begin   ack <= 1'b1; rdata <= config_RESET_TIME_AMPLITUDE;  end*/
    
    //20'h00300:  begin   ack <= 1'b1; rdata <= delay_out[0];  end
    //20'h00304:  begin   ack <= 1'b1; rdata <= delay_out[1];  end
    //20'h00308:  begin   ack <= 1'b1; rdata <= delay_out[2];  end
    //20'h0030c:  begin   ack <= 1'b1; rdata <= delay_out[3];  end
    //20'h00310:  begin   ack <= 1'b1; rdata <= delay_counter[0];  end  
    //20'h00314:  begin   ack <= 1'b1; rdata <= delay_counter[1];  end  
    //20'h00318:  begin   ack <= 1'b1; rdata <= delay_counter[0];  end  
    //20'h0031c:  begin   ack <= 1'b1; rdata <= delay_counter[1];  end  
    //20'h00320:  begin   ack <= 1'b1; rdata <= amplitude_1;  end  
    //20'h00324:  begin   ack <= 1'b1; rdata <= amplitude_2;  end  
    //20'h00328:  begin   ack <= 1'b1; rdata <= start_amplitude_1;  end  
    //20'h0032c:  begin   ack <= 1'b1; rdata <= start_amplitude_2;  end  
     
    
    // Read my ID & timestamp:
    20'h00400:  begin   ack <= 1'b1; rdata <= 32'h05121731;   end

    //++++++++++++++++++++++++++ CONNECTIONS FOR RX_TOP_LEVEL ++++++++++++++++++++++++++++++++++\\
    20'h00204:  begin   ack <= 1'b1; rdata <= rcorr_s_ready_from_buff; end
    20'h00208:  begin   ack <= 1'b1; rdata <= rwcorr_sample_from_buff; end
    
    
    20'h00404:  begin   ack <= 1'b1; rdata <= wpeak_value           ; end
    20'h00408:  begin   ack <= 1'b1; rdata <= {28'd0, wreceived_seq}; end
    20'h0040C:  begin   ack <= 1'b1; rdata <= wtimestamp            ; end
    20'h00410:  begin   ack <= 1'b1; rdata <= {31'd0, wseq_trigger }; end

    20'h00300:  begin   ack <= 1'b1; rdata <= {31'd0, rcorrelation_trigger_aux};  end

    20'h00304:  begin   ack <= 1'b1; rdata <= wcorrelation_result[0] ; end
    20'h00308:  begin   ack <= 1'b1; rdata <= wcorrelation_result[1] ; end
    20'h0030C:  begin   ack <= 1'b1; rdata <= wcorrelation_result[2] ; end
    20'h00310:  begin   ack <= 1'b1; rdata <= wcorrelation_result[3] ; end
    20'h00314:  begin   ack <= 1'b1; rdata <= wcorrelation_result[4] ; end
    20'h00318:  begin   ack <= 1'b1; rdata <= wcorrelation_result[5] ; end
    20'h0031C:  begin   ack <= 1'b1; rdata <= wcorrelation_result[6] ; end
    20'h00320:  begin   ack <= 1'b1; rdata <= wcorrelation_result[7] ; end
    20'h00324:  begin   ack <= 1'b1; rdata <= wcorrelation_result[8] ; end
    20'h00328:  begin   ack <= 1'b1; rdata <= wcorrelation_result[9] ; end
    20'h0032C:  begin   ack <= 1'b1; rdata <= wcorrelation_result[10]; end
    20'h00330:  begin   ack <= 1'b1; rdata <= wcorrelation_result[11]; end
    20'h00334:  begin   ack <= 1'b1; rdata <= wcorrelation_result[12]; end
    20'h00338:  begin   ack <= 1'b1; rdata <= wcorrelation_result[13]; end
    20'h0033C:  begin   ack <= 1'b1; rdata <= wcorrelation_result[14]; end
    20'h00340:  begin   ack <= 1'b1; rdata <= wcorrelation_result[15]; end
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\\

    20'h00ff0:  begin   ack <= 1'b1; rdata <= SYS_ID;       end
    20'h00ff4:  begin   ack <= 1'b1; rdata <= SYS_1;        end
    20'h00ff8:  begin   ack <= 1'b1; rdata <= SYS_2;        end
    20'h00ffc:  begin   ack <= 1'b1; rdata <= SYS_3;        end

     20'h1???? : begin ack <= adc_rd_dv;     rdata <= {16'h0, 2'h0,adc_a_rd}              ; end
     20'h2???? : begin ack <= adc_rd_dv;     rdata <= {16'h0, 2'h0,adc_b_rd}              ; end

       default : begin ack <= 1'b1;          rdata <=  32'h0                              ; end
   endcase
end





// bridge between ADC and sys clock
bus_clk_bridge i_bridge_scope
(
   .sys_clk_i     (  sys_clk_i      ),
   .sys_rstn_i    (  sys_rstn_i     ),
   .sys_addr_i    (  sys_addr_i     ),
   .sys_wdata_i   (  sys_wdata_i    ),
   .sys_sel_i     (  sys_sel_i      ),
   .sys_wen_i     (  sys_wen_i      ),
   .sys_ren_i     (  sys_ren_i      ),
   .sys_rdata_o   (  sys_rdata_o    ),
   .sys_err_o     (  sys_err_o      ),
   .sys_ack_o     (  sys_ack_o      ),

   .clk_i         (  adc_clk_i      ),
   .rstn_i        (  adc_rstn_i     ),
   .addr_o        (  addr           ),
   .wdata_o       (  wdata          ),
   .wen_o         (  wen            ),
   .ren_o         (  ren            ),
   .rdata_i       (  rdata          ),
   .err_i         (  err            ),
   .ack_i         (  ack            )
);






endmodule

