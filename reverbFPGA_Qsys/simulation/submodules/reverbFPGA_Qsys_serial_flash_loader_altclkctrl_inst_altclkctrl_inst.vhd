--altclkctrl CBX_SINGLE_OUTPUT_FILE="ON" CLOCK_TYPE="AUTO" DEVICE_FAMILY="Cyclone V" ENA_REGISTER_MODE="falling edge" USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION="OFF" ena inclk outclk
--VERSION_BEGIN 23.1 cbx_altclkbuf 2023:11:29:19:36:39:SC cbx_cycloneii 2023:11:29:19:36:39:SC cbx_lpm_add_sub 2023:11:29:19:36:39:SC cbx_lpm_compare 2023:11:29:19:36:39:SC cbx_lpm_decode 2023:11:29:19:36:39:SC cbx_lpm_mux 2023:11:29:19:36:37:SC cbx_mgl 2023:11:29:19:36:47:SC cbx_nadder 2023:11:29:19:36:39:SC cbx_stratix 2023:11:29:19:36:39:SC cbx_stratixii 2023:11:29:19:36:39:SC cbx_stratixiii 2023:11:29:19:36:39:SC cbx_stratixv 2023:11:29:19:36:39:SC  VERSION_END


-- Copyright (C) 2023  Intel Corporation. All rights reserved.
--  Your use of Intel Corporation's design tools, logic functions 
--  and other software and tools, and any partner logic 
--  functions, and any output files from any of the foregoing 
--  (including device programming or simulation files), and any 
--  associated documentation or information are expressly subject 
--  to the terms and conditions of the Intel Program License 
--  Subscription Agreement, the Intel Quartus Prime License Agreement,
--  the Intel FPGA IP License Agreement, or other applicable license
--  agreement, including, without limitation, that your use is for
--  the sole purpose of programming logic devices manufactured by
--  Intel and sold by Intel or its authorized distributors.  Please
--  refer to the applicable agreement for further details, at
--  https://fpgasoftware.intel.com/eula.



 LIBRARY cyclonev;
 USE cyclonev.all;

--synthesis_resources = cyclonev_clkena 1 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst_sub IS 
	 PORT 
	 ( 
		 ena	:	IN  STD_LOGIC := '1';
		 inclk	:	IN  STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
		 outclk	:	OUT  STD_LOGIC
	 ); 
 END reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst_sub;

 ARCHITECTURE RTL OF reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst_sub IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL  wire_sd1_outclk	:	STD_LOGIC;
	 SIGNAL  clkselect	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 COMPONENT  cyclonev_clkena
	 GENERIC 
	 (
		clock_type	:	STRING := "Auto";
		disable_mode	:	STRING := "low";
		ena_register_mode	:	STRING := "always enabled";
		ena_register_power_up	:	STRING := "high";
		test_syn	:	STRING := "high";
		lpm_type	:	STRING := "cyclonev_clkena"
	 );
	 PORT
	 ( 
		ena	:	IN STD_LOGIC := '1';
		enaout	:	OUT STD_LOGIC;
		inclk	:	IN STD_LOGIC := '1';
		outclk	:	OUT STD_LOGIC
	 ); 
	 END COMPONENT;
 BEGIN

	clkselect <= (OTHERS => '0');
	outclk <= wire_sd1_outclk;
	sd1 :  cyclonev_clkena
	  GENERIC MAP (
		clock_type => "Auto",
		ena_register_mode => "falling edge"
	  )
	  PORT MAP ( 
		ena => ena,
		inclk => inclk(0),
		outclk => wire_sd1_outclk
	  );

 END RTL; --reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst_sub
--VALID FILE -- (C) 2001-2023 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel FPGA IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.




LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst IS
    PORT
    (
        ena       : IN STD_LOGIC  := '1';
        inclk       : IN STD_LOGIC;
        outclk       : OUT STD_LOGIC
    );
END reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst;


ARCHITECTURE RTL OF reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst IS

    SIGNAL sub_wire0    : STD_LOGIC ;
    SIGNAL sub_wire1    : STD_LOGIC ;
    SIGNAL sub_wire2    : STD_LOGIC_VECTOR  (3 DOWNTO 0);
    SIGNAL sub_wire3_bv : BIT_VECTOR (2 DOWNTO 0);
    SIGNAL sub_wire3    : STD_LOGIC_VECTOR  (2 DOWNTO 0);


    COMPONENT  reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst_sub
    PORT (
            ena : IN STD_LOGIC;
            inclk   : IN STD_LOGIC_VECTOR  (3 DOWNTO 0);
            outclk  : OUT STD_LOGIC
    );
    END COMPONENT;


BEGIN
    outclk     <= sub_wire0;
    sub_wire1     <= inclk;
    sub_wire2     <= sub_wire3 &  sub_wire1;
    sub_wire3_bv(2 DOWNTO 0)  <= "000";
    sub_wire3   <= To_stdlogicvector(sub_wire3_bv);

    reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst_sub_component : reverbFPGA_Qsys_serial_flash_loader_altclkctrl_inst_altclkctrl_inst_sub
    PORT MAP (
        ena => ena,
        inclk => sub_wire2,
        outclk => sub_wire0
    );



END RTL;