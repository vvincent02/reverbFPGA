// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
// $Revision: #7 $
// $Date: 2010/08/05 $
// $Author: klong $
//-----------------------------------------------------------------------------
// =head1 NAME
// altera_conduit_bfm
// =head1 SYNOPSIS
// Bus Functional Model (BFM) for a Standard Conduit BFM
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// This is a Bus Functional Model (BFM) for a Standard Conduit Master.
// This BFM sampled the input/bidirection port value or driving user's value to 
// output ports when user call the API.  
// This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
// Generation parameters:
// output_name:                                       reverbFPGA_Qsys_hps_0_hps_io_border_hps_io
// role:width:direction:                              hps_io_uart0_inst_RX:1:input,hps_io_uart0_inst_TX:1:output,hps_io_i2c0_inst_SDA:1:bidir,hps_io_i2c0_inst_SCL:1:bidir,hps_io_gpio_inst_GPIO00:1:bidir,hps_io_gpio_inst_GPIO48:1:bidir
// 0
//-----------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module reverbFPGA_Qsys_hps_0_hps_io_border_hps_io
(
   sig_hps_io_uart0_inst_RX,
   sig_hps_io_uart0_inst_TX,
   sig_hps_io_i2c0_inst_SDA,
   sig_hps_io_i2c0_inst_SCL,
   sig_hps_io_gpio_inst_GPIO00,
   sig_hps_io_gpio_inst_GPIO48
);

   //--------------------------------------------------------------------------
   // =head1 PINS 
   // =head2 User defined interface
   //--------------------------------------------------------------------------
   input sig_hps_io_uart0_inst_RX;
   output sig_hps_io_uart0_inst_TX;
   inout wire sig_hps_io_i2c0_inst_SDA;
   inout wire sig_hps_io_i2c0_inst_SCL;
   inout wire sig_hps_io_gpio_inst_GPIO00;
   inout wire sig_hps_io_gpio_inst_GPIO48;

   // synthesis translate_off
   import verbosity_pkg::*;
   
   typedef logic ROLE_hps_io_uart0_inst_RX_t;
   typedef logic ROLE_hps_io_uart0_inst_TX_t;
   typedef logic ROLE_hps_io_i2c0_inst_SDA_t;
   typedef logic ROLE_hps_io_i2c0_inst_SCL_t;
   typedef logic ROLE_hps_io_gpio_inst_GPIO00_t;
   typedef logic ROLE_hps_io_gpio_inst_GPIO48_t;

   logic [0 : 0] sig_hps_io_uart0_inst_RX_in;
   logic [0 : 0] sig_hps_io_uart0_inst_RX_local;
   reg sig_hps_io_uart0_inst_TX_temp;
   reg sig_hps_io_uart0_inst_TX_out;
   logic sig_hps_io_i2c0_inst_SDA_oe;
   logic sig_hps_io_i2c0_inst_SDA_oe_temp = 0;
   reg sig_hps_io_i2c0_inst_SDA_temp;
   reg sig_hps_io_i2c0_inst_SDA_out;
   logic [0 : 0] sig_hps_io_i2c0_inst_SDA_in;
   logic [0 : 0] sig_hps_io_i2c0_inst_SDA_local;
   logic sig_hps_io_i2c0_inst_SCL_oe;
   logic sig_hps_io_i2c0_inst_SCL_oe_temp = 0;
   reg sig_hps_io_i2c0_inst_SCL_temp;
   reg sig_hps_io_i2c0_inst_SCL_out;
   logic [0 : 0] sig_hps_io_i2c0_inst_SCL_in;
   logic [0 : 0] sig_hps_io_i2c0_inst_SCL_local;
   logic sig_hps_io_gpio_inst_GPIO00_oe;
   logic sig_hps_io_gpio_inst_GPIO00_oe_temp = 0;
   reg sig_hps_io_gpio_inst_GPIO00_temp;
   reg sig_hps_io_gpio_inst_GPIO00_out;
   logic [0 : 0] sig_hps_io_gpio_inst_GPIO00_in;
   logic [0 : 0] sig_hps_io_gpio_inst_GPIO00_local;
   logic sig_hps_io_gpio_inst_GPIO48_oe;
   logic sig_hps_io_gpio_inst_GPIO48_oe_temp = 0;
   reg sig_hps_io_gpio_inst_GPIO48_temp;
   reg sig_hps_io_gpio_inst_GPIO48_out;
   logic [0 : 0] sig_hps_io_gpio_inst_GPIO48_in;
   logic [0 : 0] sig_hps_io_gpio_inst_GPIO48_local;

   //--------------------------------------------------------------------------
   // =head1 Public Methods API
   // =pod
   // This section describes the public methods in the application programming
   // interface (API). The application program interface provides methods for 
   // a testbench which instantiates, controls and queries state in this BFM 
   // component. Test programs must only use these public access methods and 
   // events to communicate with this BFM component. The API and module pins
   // are the only interfaces of this component that are guaranteed to be
   // stable. The API will be maintained for the life of the product. 
   // While we cannot prevent a test program from directly accessing internal
   // tasks, functions, or data private to the BFM, there is no guarantee that
   // these will be present in the future. In fact, it is best for the user
   // to assume that the underlying implementation of this component can 
   // and will change.
   // =cut
   //--------------------------------------------------------------------------
   
   event signal_input_hps_io_uart0_inst_RX_change;
   event signal_input_hps_io_i2c0_inst_SDA_change;
   event signal_input_hps_io_i2c0_inst_SCL_change;
   event signal_input_hps_io_gpio_inst_GPIO00_change;
   event signal_input_hps_io_gpio_inst_GPIO48_change;
   
   function automatic string get_version();  // public
      // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
      string ret_version = "23.1";
      return ret_version;
   endfunction

   // -------------------------------------------------------
   // hps_io_uart0_inst_RX
   // -------------------------------------------------------
   function automatic ROLE_hps_io_uart0_inst_RX_t get_hps_io_uart0_inst_RX();
   
      // Gets the hps_io_uart0_inst_RX input value.
      $sformat(message, "%m: called get_hps_io_uart0_inst_RX");
      print(VERBOSITY_DEBUG, message);
      return sig_hps_io_uart0_inst_RX_in;
      
   endfunction

   // -------------------------------------------------------
   // hps_io_uart0_inst_TX
   // -------------------------------------------------------

   function automatic void set_hps_io_uart0_inst_TX (
      ROLE_hps_io_uart0_inst_TX_t new_value
   );
      // Drive the new value to hps_io_uart0_inst_TX.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_uart0_inst_TX_temp = new_value;
   endfunction

   // -------------------------------------------------------
   // hps_io_i2c0_inst_SDA
   // -------------------------------------------------------
   function automatic ROLE_hps_io_i2c0_inst_SDA_t get_hps_io_i2c0_inst_SDA();
   
      // Gets the hps_io_i2c0_inst_SDA input value.
      $sformat(message, "%m: called get_hps_io_i2c0_inst_SDA");
      print(VERBOSITY_DEBUG, message);
      return sig_hps_io_i2c0_inst_SDA_in;
      
   endfunction

   function automatic void set_hps_io_i2c0_inst_SDA (
      ROLE_hps_io_i2c0_inst_SDA_t new_value
   );
      // Drive the new value to hps_io_i2c0_inst_SDA.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_i2c0_inst_SDA_temp = new_value;
   endfunction
   
   function automatic void set_hps_io_i2c0_inst_SDA_oe (
      bit enable
   );
      // bidir port hps_io_i2c0_inst_SDA will work as output port when set to 1.
      // bidir port hps_io_i2c0_inst_SDA will work as input port when set to 0.
      
      $sformat(message, "%m: method called arg0 %0d", enable); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_i2c0_inst_SDA_oe_temp = enable;
   endfunction

   // -------------------------------------------------------
   // hps_io_i2c0_inst_SCL
   // -------------------------------------------------------
   function automatic ROLE_hps_io_i2c0_inst_SCL_t get_hps_io_i2c0_inst_SCL();
   
      // Gets the hps_io_i2c0_inst_SCL input value.
      $sformat(message, "%m: called get_hps_io_i2c0_inst_SCL");
      print(VERBOSITY_DEBUG, message);
      return sig_hps_io_i2c0_inst_SCL_in;
      
   endfunction

   function automatic void set_hps_io_i2c0_inst_SCL (
      ROLE_hps_io_i2c0_inst_SCL_t new_value
   );
      // Drive the new value to hps_io_i2c0_inst_SCL.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_i2c0_inst_SCL_temp = new_value;
   endfunction
   
   function automatic void set_hps_io_i2c0_inst_SCL_oe (
      bit enable
   );
      // bidir port hps_io_i2c0_inst_SCL will work as output port when set to 1.
      // bidir port hps_io_i2c0_inst_SCL will work as input port when set to 0.
      
      $sformat(message, "%m: method called arg0 %0d", enable); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_i2c0_inst_SCL_oe_temp = enable;
   endfunction

   // -------------------------------------------------------
   // hps_io_gpio_inst_GPIO00
   // -------------------------------------------------------
   function automatic ROLE_hps_io_gpio_inst_GPIO00_t get_hps_io_gpio_inst_GPIO00();
   
      // Gets the hps_io_gpio_inst_GPIO00 input value.
      $sformat(message, "%m: called get_hps_io_gpio_inst_GPIO00");
      print(VERBOSITY_DEBUG, message);
      return sig_hps_io_gpio_inst_GPIO00_in;
      
   endfunction

   function automatic void set_hps_io_gpio_inst_GPIO00 (
      ROLE_hps_io_gpio_inst_GPIO00_t new_value
   );
      // Drive the new value to hps_io_gpio_inst_GPIO00.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_gpio_inst_GPIO00_temp = new_value;
   endfunction
   
   function automatic void set_hps_io_gpio_inst_GPIO00_oe (
      bit enable
   );
      // bidir port hps_io_gpio_inst_GPIO00 will work as output port when set to 1.
      // bidir port hps_io_gpio_inst_GPIO00 will work as input port when set to 0.
      
      $sformat(message, "%m: method called arg0 %0d", enable); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_gpio_inst_GPIO00_oe_temp = enable;
   endfunction

   // -------------------------------------------------------
   // hps_io_gpio_inst_GPIO48
   // -------------------------------------------------------
   function automatic ROLE_hps_io_gpio_inst_GPIO48_t get_hps_io_gpio_inst_GPIO48();
   
      // Gets the hps_io_gpio_inst_GPIO48 input value.
      $sformat(message, "%m: called get_hps_io_gpio_inst_GPIO48");
      print(VERBOSITY_DEBUG, message);
      return sig_hps_io_gpio_inst_GPIO48_in;
      
   endfunction

   function automatic void set_hps_io_gpio_inst_GPIO48 (
      ROLE_hps_io_gpio_inst_GPIO48_t new_value
   );
      // Drive the new value to hps_io_gpio_inst_GPIO48.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_gpio_inst_GPIO48_temp = new_value;
   endfunction
   
   function automatic void set_hps_io_gpio_inst_GPIO48_oe (
      bit enable
   );
      // bidir port hps_io_gpio_inst_GPIO48 will work as output port when set to 1.
      // bidir port hps_io_gpio_inst_GPIO48 will work as input port when set to 0.
      
      $sformat(message, "%m: method called arg0 %0d", enable); 
      print(VERBOSITY_DEBUG, message);
      
      sig_hps_io_gpio_inst_GPIO48_oe_temp = enable;
   endfunction

   assign sig_hps_io_uart0_inst_RX_in = sig_hps_io_uart0_inst_RX;
   assign sig_hps_io_uart0_inst_TX = sig_hps_io_uart0_inst_TX_temp;
   assign sig_hps_io_i2c0_inst_SDA_oe = sig_hps_io_i2c0_inst_SDA_oe_temp;
   assign sig_hps_io_i2c0_inst_SDA = (sig_hps_io_i2c0_inst_SDA_oe == 1)? sig_hps_io_i2c0_inst_SDA_temp:'z;
   assign sig_hps_io_i2c0_inst_SDA_in = (sig_hps_io_i2c0_inst_SDA_oe == 0)? sig_hps_io_i2c0_inst_SDA:'z;
   assign sig_hps_io_i2c0_inst_SCL_oe = sig_hps_io_i2c0_inst_SCL_oe_temp;
   assign sig_hps_io_i2c0_inst_SCL = (sig_hps_io_i2c0_inst_SCL_oe == 1)? sig_hps_io_i2c0_inst_SCL_temp:'z;
   assign sig_hps_io_i2c0_inst_SCL_in = (sig_hps_io_i2c0_inst_SCL_oe == 0)? sig_hps_io_i2c0_inst_SCL:'z;
   assign sig_hps_io_gpio_inst_GPIO00_oe = sig_hps_io_gpio_inst_GPIO00_oe_temp;
   assign sig_hps_io_gpio_inst_GPIO00 = (sig_hps_io_gpio_inst_GPIO00_oe == 1)? sig_hps_io_gpio_inst_GPIO00_temp:'z;
   assign sig_hps_io_gpio_inst_GPIO00_in = (sig_hps_io_gpio_inst_GPIO00_oe == 0)? sig_hps_io_gpio_inst_GPIO00:'z;
   assign sig_hps_io_gpio_inst_GPIO48_oe = sig_hps_io_gpio_inst_GPIO48_oe_temp;
   assign sig_hps_io_gpio_inst_GPIO48 = (sig_hps_io_gpio_inst_GPIO48_oe == 1)? sig_hps_io_gpio_inst_GPIO48_temp:'z;
   assign sig_hps_io_gpio_inst_GPIO48_in = (sig_hps_io_gpio_inst_GPIO48_oe == 0)? sig_hps_io_gpio_inst_GPIO48:'z;


   always @(sig_hps_io_uart0_inst_RX_in) begin
      if (sig_hps_io_uart0_inst_RX_local != sig_hps_io_uart0_inst_RX_in)
         -> signal_input_hps_io_uart0_inst_RX_change;
      sig_hps_io_uart0_inst_RX_local = sig_hps_io_uart0_inst_RX_in;
   end
   
   always @(sig_hps_io_i2c0_inst_SDA_in) begin
      if (sig_hps_io_i2c0_inst_SDA_oe == 0) begin
         if (sig_hps_io_i2c0_inst_SDA_local != sig_hps_io_i2c0_inst_SDA_in)
            -> signal_input_hps_io_i2c0_inst_SDA_change;
         sig_hps_io_i2c0_inst_SDA_local = sig_hps_io_i2c0_inst_SDA_in;
      end
   end
   
   always @(sig_hps_io_i2c0_inst_SCL_in) begin
      if (sig_hps_io_i2c0_inst_SCL_oe == 0) begin
         if (sig_hps_io_i2c0_inst_SCL_local != sig_hps_io_i2c0_inst_SCL_in)
            -> signal_input_hps_io_i2c0_inst_SCL_change;
         sig_hps_io_i2c0_inst_SCL_local = sig_hps_io_i2c0_inst_SCL_in;
      end
   end
   
   always @(sig_hps_io_gpio_inst_GPIO00_in) begin
      if (sig_hps_io_gpio_inst_GPIO00_oe == 0) begin
         if (sig_hps_io_gpio_inst_GPIO00_local != sig_hps_io_gpio_inst_GPIO00_in)
            -> signal_input_hps_io_gpio_inst_GPIO00_change;
         sig_hps_io_gpio_inst_GPIO00_local = sig_hps_io_gpio_inst_GPIO00_in;
      end
   end
   
   always @(sig_hps_io_gpio_inst_GPIO48_in) begin
      if (sig_hps_io_gpio_inst_GPIO48_oe == 0) begin
         if (sig_hps_io_gpio_inst_GPIO48_local != sig_hps_io_gpio_inst_GPIO48_in)
            -> signal_input_hps_io_gpio_inst_GPIO48_change;
         sig_hps_io_gpio_inst_GPIO48_local = sig_hps_io_gpio_inst_GPIO48_in;
      end
   end
   


// synthesis translate_on

endmodule

