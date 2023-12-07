--Driver8
--Lab 6 - seven segment display in 2s complement

LIBRARY ieee;							-- Declare which vhdl libraries I want to use
USE ieee.std_logic_1164.all;		-- and which packages inside those libraries I will use.

--LAB 6

ENTITY driver8 IS
	PORT(
	
	--Input ports
	W, X, Y, Z: IN STD_LOGIC;
	
	--Output ports
	A, B, C, D, E, F, G, H: OUT STD_LOGIC
	
	);
END driver8;

--Architecture section
ARCHITECTURE behavioral of driver8 IS
BEGIN

	A <= (X AND NOT Y AND NOT Z) OR (NOT W AND NOT X AND NOT Y AND Z) OR (W AND X AND Y AND Z);
	B <= (NOT W AND X AND NOT Y AND Z) OR (W AND NOT X AND Y) OR (NOT W AND X AND Y AND NOT Z);
	C <= (NOT W AND NOT X AND Y AND NOT Z) OR (W AND X AND Y AND NOT Z);
	D <= (X AND NOT Y AND NOT Z) OR (NOT X AND NOT Y AND Z) OR (X AND Y AND Z);
	E <= Z OR (X AND NOT Y);
	F <= (NOT X AND NOT Y AND Z) OR (W AND X AND Z) OR (NOT W AND Y AND Z) OR (W AND X AND Y) OR (NOT W AND NOT X AND Y);
	G <= (NOT X AND NOT Y AND Z) OR (X AND Y AND Z) OR (NOT W AND NOT X AND NOT Y);
	H <= NOT W;
	
END behavioral;