LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

----------------------------------------------------------------------
--
--  This is the top level template for Lab 2.  Use the schematic on Page 3
--  of the lab handout to guide you in creating this structural description.
--  The combinational blocks have already been designed in previous tasks,
--  and the spinwheel block is given to you.  Your task is to combine these
--  blocks, as well as add the various registers shown on the schemetic, and
--  wire them up properly.  The result will be a roulette game you can play
--  on your DE2.
--
-----------------------------------------------------------------------

ENTITY roulette IS
	PORT(   CLOCK_27 : IN STD_LOGIC; -- the fast clock for spinning wheel
		      KEY      : IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
        		SW       : IN STD_LOGIC_VECTOR(17 downto 0);
        		LEDG     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ledg
        		HEX7     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
        		HEX6     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
        		HEX5     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
        		HEX4     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
        		HEX3     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
        		HEX2     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
        		HEX1     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
        		HEX0     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END roulette;


ARCHITECTURE structural OF roulette IS
--component and signal for spinwheel logic block
component spinwheel is
  port (	
       	fast_clock  : IN  STD_LOGIC;  -- This will be a 27 Mhz Clock
		    resetb      : IN  STD_LOGIC;      -- asynchronous reset
        spin_result : OUT UNSIGNED(5 downto 0));  -- current value of the wheel
end component;
  
  component win is
    port(
         spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
         bet1_value : in unsigned(5 downto 0); -- value for bet 1
         bet2_colour : in std_logic;  -- colour for bet 2
         bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
         bet1_wins : out std_logic;  -- whether bet 1 is a winner
         bet2_wins : out std_logic;  -- whether bet 2 is a winner
         bet3_wins : out std_logic); -- whether bet 3 is a winner
  end component;
  
  component digit7seg is
    	port(
          digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 tosome hex/decimal 
          seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));  -- one per segment    
  end component;
  
  component new_balance is
     port(
          money : in unsigned(11 downto 0);  -- Current balance before this spin
          bet1_amount : in unsigned(2 downto 0);  -- Value of bet 1
          bet2_amount : in unsigned(2 downto 0);  -- Value of bet 2
          bet3_amount : in unsigned(2 downto 0);  -- Value of bet 3
          bet1_wins : in std_logic;  -- True if bet 1 is a winner
          bet2_wins : in std_logic;  -- True if bet 2 is a winner
          bet3_wins : in std_logic;  -- True if bet 3 is a winner
          new_money : out unsigned(11 downto 0));  -- balance after adding winning
                                                   -- bets and subtracting losing bets
  end component;
  
  component flipflop_unsigned is
    generic (k : integer);
    port(
         clk    : in std_logic;
         resetb : in std_logic;
         D      : in unsigned (k-1 downto 0);
         Q      : out unsigned (k-1 downto 0));    
  end component;
  
component flipflop_10 is
    port(
         clk    : in std_logic;
         resetb : in std_logic;
         D      : in unsigned (11 downto 0);
         Q      : out unsigned (11 downto 0));    
  end component;
  
  component flipflop_stdlogic is
    port(
         clk    : in std_logic;
         resetb : in std_logic;
         D      : in std_logic;
         Q      : out std_logic);
  end component;
  
  component flipflop_stdlogic_to_unsigned is
    generic (k : integer);
    port ( 
          clk    : in std_logic;
          resetb : in std_logic;
          D      : in std_logic_vector (k-1 downto 0); 
          Q      : out unsigned (k-1 downto 0));
  end component;
  
  component hex_to_dec1 is
    port   ( hex1_bits : in unsigned(5 downto 0);
             dec1_bits : out unsigned(7 downto 0));
  end component;
  
  component hex_to_dec2 is
    port   ( hex2_bits : in unsigned(11 downto 0);
             dec2_bits : out unsigned(15 downto 0));
  end component;
  
-- all 13 signals from the diagram
signal dec1_bits           : unsigned(7 downto 0); -- output of hex2dec1
signal dec2_bits           : unsigned(15 downto 0); -- output of hex2dec2
signal clk                 : std_logic;
signal resetb              : std_logic;
signal spin_result         : unsigned(5 downto 0); -- between 1&2
signal spin_result_latched : unsigned(5 downto 0); -- between 2&6 and 2&16 and 2&15
signal bet1_value          : unsigned(5 downto 0); -- between 3&6
signal bet2_colour         : std_logic; -- between 4&6
signal bet3_dozen          : unsigned (1 downto 0); -- between 5&6
signal bet1_wins           : std_logic; -- between 6&11
signal bet2_wins           : std_logic; -- between 6&11
signal bet3_wins           : std_logic; -- between 6&11
signal money               : unsigned(11 downto 0);  -- between 10&11
signal bet1_amount         : unsigned(2 downto 0); -- between 7&11
signal bet2_amount         : unsigned(2 downto 0); -- between 8&11
signal bet3_amount         : unsigned(2 downto 0); -- between 9&11
signal new_money           : unsigned(11 downto 0); -- between 11&10 and 11&12 and 11&13 and 11&14
signal bits_to_hex7        : std_logic_vector (3 downto 0);



BEGIN
--  HEX3 <= "1111111";
  HEX4 <= "1111111";
  HEX5 <= "1111111";
  LEDG(2) <= bet3_wins;
  LEDG(1) <= bet2_wins;
  LEDG(0) <= bet1_wins;
  clk <= KEY(0);
  resetb <= KEY(1);


SPINWHEEL_1   : spinwheel port map (  CLOCK_27, 
                                      resetb, 
                                      spin_result);
REG6BIT_2     : flipflop_unsigned generic map (6) port map ( clk,
                                                             resetb,
                                                             spin_result,
                                                             spin_result_latched);
REG6BIT_3     : flipflop_stdlogic_to_unsigned generic map (6) port map ( clk,
                                                         resetb,
                                                         SW(8 downto 3),
                                                         bet1_value);
DFF1BIT_4     : flipflop_stdlogic port map ( clk,
                                             resetb,
                                             SW(12),
                                             bet2_colour);
REG2BIT_5     : flipflop_stdlogic_to_unsigned generic map (2) port map ( clk,
                                                             resetb,
                                                             SW(17 downto 16),
                                                             bet3_dozen);
WIN_6         : win port map (spin_result_latched, 
                              bet1_value, 
                              bet2_colour,
                              bet3_dozen,
                              bet1_wins,
                              bet2_wins,
                              bet3_wins);
REG3BIT_7     : flipflop_stdlogic_to_unsigned generic map (3) port map ( clk,
                                                             resetb,
                                                             SW(2 downto 0),
                                                             bet1_amount);
REG3BIT_8     : flipflop_stdlogic_to_unsigned generic map (3) port map ( clk,
                                                             resetb,
                                                             SW(11 downto 9),
                                                             bet2_amount);
REG3BIT_9     : flipflop_stdlogic_to_unsigned generic map (3) port map ( clk,
                                                             resetb,
                                                             SW(15 downto 13),
                                                             bet3_amount);
REG12BIT_10   : flipflop_10 port map( clk,
                                                             resetb,
                                                             new_money,
                                                             money);

                                                             
NEWBALANCE_11 : new_balance port map (  money,
                                        bet1_amount,
                                        bet2_amount,
                                        bet3_amount,
                                        bet1_wins,
                                        bet2_wins,
                                        bet3_wins,
                                        new_money);
                                        
-- logic block that converts spin_result_latched to a decimal of the same length
HEX2DEC1 : hex_to_dec1 port map ( spin_result_latched(5 downto 0),
                                  dec1_bits(7 downto 0));
HEX2DEC2 : hex_to_dec2 port map (new_money(11 downto 0),
                                 dec2_bits(15 downto 0));          
                        
-- don't need this no more because converting to dec
-- bits_to_hex7 <= "00" & std_logic_vector(spin_result_latched(5 downto 4));

--money value
DIGI7SEG_12   : digit7seg port map (dec2_bits(11 downto 8), HEX2);
DIGI7SEG_13   : digit7seg port map (dec2_bits(7 downto 4), HEX1);
DIGI7SEG_14   : digit7seg port map (dec2_bits(3 downto 0), HEX0);
--added HEX for thousands digit
DIGI7SEG_17   : digit7seg port map (dec2_bits(15 downto 12), HEX3);
-- spin value  
DIGI7SEG_15   : digit7seg port map (dec1_bits(3 downto 0), HEX6);
DIGI7SEG_16   : digit7seg port map (dec1_bits(7 downto 4), HEX7);






END;

