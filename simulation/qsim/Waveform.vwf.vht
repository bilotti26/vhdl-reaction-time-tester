-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/29/2023 15:08:25"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          top
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY top_vhd_vec_tst IS
END top_vhd_vec_tst;
ARCHITECTURE top_arch OF top_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clock : STD_LOGIC;
SIGNAL deltaT : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL playerA : STD_LOGIC;
SIGNAL playerB : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
SIGNAL winner : STD_LOGIC;
COMPONENT top
	PORT (
	clock : IN STD_LOGIC;
	deltaT : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0);
	playerA : IN STD_LOGIC;
	playerB : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	winner : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : top
	PORT MAP (
-- list connections between master ports and signals
	clock => clock,
	deltaT => deltaT,
	playerA => playerA,
	playerB => playerB,
	reset => reset,
	winner => winner
	);

-- clock
t_prcs_clock: PROCESS
BEGIN
LOOP
	clock <= '0';
	WAIT FOR 500 ps;
	clock <= '1';
	WAIT FOR 500 ps;
	IF (NOW >= 4000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clock;

-- playerA
t_prcs_playerA: PROCESS
BEGIN
	playerA <= '1';
WAIT;
END PROCESS t_prcs_playerA;

-- playerB
t_prcs_playerB: PROCESS
BEGIN
	playerB <= '0';
	WAIT FOR 2380000 ps;
	playerB <= '1';
	WAIT FOR 10000 ps;
	playerB <= '0';
WAIT;
END PROCESS t_prcs_playerB;

-- reset
t_prcs_reset: PROCESS
BEGIN
	reset <= '0';
WAIT;
END PROCESS t_prcs_reset;
END top_arch;
