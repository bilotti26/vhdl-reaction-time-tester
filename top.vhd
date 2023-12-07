------------
--
--  VHDL Template for a Finite State Machine (FSM)
-- 	Final Project
--
------------
--	Rubric:
-- 		The project should be primarily designed in VHDL using the FSM template discussed in class.
-- 			MET
--  	In general, the design should include multiple inputs and outputs with at least five distinct states.
-- 			MET (s0-s5)


LIBRARY ieee;
USE ieee.std_logic_1164.all;			-- For IEEE data types
USE ieee.std_logic_unsigned.all;		-- For + and - operations
USE ieee.math_real.all;					-- For real number operations
use ieee.numeric_std.all;				-- For weird integer to vector conversions

-- Entity Declaration
--Clock will be 1khz (1000hz, T = 1ms)
ENTITY top IS
	PORT (
		clockIN, reset, playerA, playerB	:	IN STD_LOGIC; -- Player A and Player B are the buttons they press respectively
		z									:	OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		winner, buzzerOut					: 	OUT STD_LOGIC	:= '0'; -- Winner is 0 for A and 1 for B
		HEX0, HEX1, HEX2, HEX3				:	OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END top;



--  Architecture Section

ARCHITECTURE arch OF top IS

-- Build an enumerated type for the state machine
-- The states declared here come directly from the state diagram

COMPONENT driver8 IS
	PORT(
	
	--Input ports
	W, X, Y, Z: IN STD_LOGIC;
	
	--Output ports
	A, B, C, D, E, F, G, H: OUT STD_LOGIC
	
	);
END COMPONENT;

TYPE state_type IS (s0, s1, s2, s3, s4, s5);

-- Create a register to hold teh present and next states
SIGNAL clock 					: STD_LOGIC						:=	'0';
SIGNAL tempClockCount			: INTEGER						:= 0;
SIGNAL winningTime				: INTEGER range 0 to 9999		:= 0;

SIGNAL pr_state, nx_state	: state_type 					:= s0;
SIGNAL count 				: INTEGER range 0 to 99999		:= 0; -- Counter for clock cycles
SIGNAL time_till_reaction	: INTEGER						:= 2500;
SIGNAL maxTime				: INTEGER						:= 6500;

SIGNAL outputDigit1,outputDigit2,outputDigit3,outputDigit4  	: INTEGER range 0 to 9;
SIGNAL outputVector1,outputVector2,outputVector3,outputVector4 : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL playerACountWins, playerBCountWins		: INTEGER range 0 to 9 := 0;

-- Begin the architecture section...
BEGIN

----------------------- PRESENT STATE SECTION (REGISTER) --------------------------------------------
--
--  The function of this section is to assign the next state to the present state at the active clock edge.
--  An asynchronous reset signal should be included to initialize the system to the default first state of the system. 
--  This section is implemented with sequential (behavioral) VHDL code with a PROCESS.
--

	--Clock divider code
	PROCESS(clockIN, reset)
	
	BEGIN
		
		IF (reset = '1') THEN
			clock <= '0';
			tempClockCount <= 0;
		ELSIF (clockIN'EVENT AND clockIN = '1') THEN

			tempClockCount <= tempclockCount + 1;

			-- We have a 50 MHz internal clock and want to count every ms, so we wait for 50000 cycles
			IF tempClockCount = 25000 THEN
				clock <= NOT clock; -- Toggle the clock every 25000 cycles for a 1 kHz output
				tempClockCount <= 0;
			END IF;

		END IF;
	
	END PROCESS;

	PROCESS(clock, reset, pr_state)

	BEGIN

		IF (reset = '1') THEN
			pr_state <= s0;
			count <= 0;

		ELSIF (clock'EVENT AND clock = '1') THEN
			pr_state <= nx_state;
			count <= count + 1;
			IF (count > maxTime + time_till_reaction + 1) THEN
				count <= 0;
			END IF;
		END IF;

	END PROCESS;

----------------------- OUTPUT LOGIC SECTION ---------------------------------------------------------
--
--  The function of this section is to generate the outputs of the system: 
--  		Determine the output based on current input and present state.
--  This section is implemented with concurrent VHDL code with conditional assignment statements.
--

	WITH pr_state SELECT z <=
		"0001" WHEN s0,
		"0010" WHEN s1,
		"0100" WHEN s2,
		"1000" WHEN s3,
		"1111" WHEN s4,
		"0000" WHEN s5;

	
	--Process to split each digit from the display into 4 seperate numbers
	PROCESS(winningTime)
		VARIABLE tempNumber 		: INTEGER range 0 to 9999;
	BEGIN
		tempNumber := winningTime;

		outputDigit1 <= tempNumber / 1000;         -- Get thousands digit
		tempNumber := tempNumber mod 1000;
		
		outputDigit2 <= tempNumber / 100;          -- Get hundreds digit
		tempNumber := tempNumber mod 100;
		
		outputDigit3 <= tempNumber / 10;           -- Get tens digit
		tempNumber := tempNumber mod 10;
		
		outputDigit4 <= tempNumber;                -- Get units digit
	end process;

	--Convert each digit to 4-bit vector
	outputVector1 <= std_logic_vector(to_unsigned(outputDigit1, 4));
	outputVector2 <= std_logic_vector(to_unsigned(outputDigit2, 4));
	outputVector3 <= std_logic_vector(to_unsigned(outputDigit3, 4));
	outputVector4 <= std_logic_vector(to_unsigned(outputDigit4, 4));

	--Display each digit on the 7-segment display
	
	--rightmost segment
	display_3: driver8 PORT MAP(
		outputVector4(3),
		outputVector4(2),
		outputVector4(1),
		outputVector4(0),
		HEX0(0), HEX0(1), HEX0(2), HEX0(3), HEX0(4), HEX0(5), HEX0(6)
	);
	display_2: driver8 PORT MAP(
		outputVector3(3),
		outputVector3(2),
		outputVector3(1),
		outputVector3(0),
		HEX1(0), HEX1(1), HEX1(2), HEX1(3), HEX1(4), HEX1(5), HEX1(6)
	);
	display_1: driver8 PORT MAP(
		outputVector2(3),
		outputVector2(2),
		outputVector2(1),
		outputVector2(0),
		HEX2(0), HEX2(1), HEX2(2), HEX2(3), HEX2(4), HEX2(5), HEX2(6)
	);
	display_0: driver8 PORT MAP(
		outputVector1(3),
		outputVector1(2),
		outputVector1(1),
		outputVector1(0),
		HEX3(0), HEX3(1), HEX3(2), HEX3(3), HEX3(4), HEX3(5), HEX3(6)
	);

	

----------------------- NEXT STATE LOGIC SECTION ---------------------------------------------------------
--
--  The function of this section is to establish the next state of the system: 
--  		Determine the next state based on current input and present state.
--  		This section comes directly from following the transitions in the state diagram.
--  This section is implemented with behavioral (sequential) VHDL code with a PROCESS.
--

	PROCESS (pr_state, reset)
		
	BEGIN
		
		IF (reset = '1') THEN
			winner <= '0';
			winningTime <= 0;
			buzzerOut <= '0';
		ELSE
			IF (count > maxTime + time_till_reaction) THEN
				-- Reset after time
				buzzerOut <= '0';
				nx_state <= s0;
				winner <= '0';
				winningTime <= 0;
			ELSIF (count > 3000 + time_till_reaction) THEN
				-- Future code to play a buzzer for 1 seconds then reset
				IF (pr_state = s5) THEN
					IF (count mod 100 = 0) THEN
						--play buzzer
						buzzerOut <= '1';
					ELSE buzzerOut <= '0';
					END IF;
				ELSE
					-- STUPID BUZZER HACK for 500 mhz, play every even second
					IF (count mod 2 = 0) THEN
						--play buzzer
						buzzerOut <= '1';
					ELSE buzzerOut <= '0';
					END IF;
				END IF;
			ELSIF (count > time_till_reaction) THEN
				CASE pr_state IS

					WHEN s0 =>
						nx_state <= s4;

					WHEN s1 =>
						nx_state <= s4;
						
					WHEN s2 =>
						nx_state <= s4;
						
					WHEN s3 =>
						nx_state <= s4;

					WHEN s4 =>
						if playerA = '0' THEN
							winner <= '0';
							playerACountWins <= playerACountWins + 1;
							winningTime <= count - time_till_reaction;
							nx_state <= s5;
						ELSIF playerB = '0' THEN 
							winner <= '1';
							playerBCountWins <= playerBCountWins + 1;
							winningTime <= count - time_till_reaction;
							nx_state <= s5;
						ELSE
							winningTime <= count - time_till_reaction;
							nx_state <= s4;
						END IF;

					WHEN s5 =>
						nx_state <= s5;
					
					WHEN OTHERS =>
						nx_state <= s0;

				END CASE;
				
			ELSE
				
				IF (count mod 500 = 0) THEN -- Hack to make the numbers change only every 500ms
					CASE pr_state IS

						WHEN s0 =>
							nx_state <= s1;

						WHEN s1 =>
							nx_state <= s2;
							
						WHEN s2 =>
							nx_state <= s3;
							
						when s3 =>
							nx_state <= s0;

					WHEN OTHERS =>
							nx_state <= s0;
							
					END CASE;
				ELSE
					nx_state <= pr_state;
				END IF;
				
			END IF;
		END IF;
		
	END PROCESS;

END arch;
