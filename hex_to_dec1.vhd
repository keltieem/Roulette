LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

entity hex_to_dec1 is
  port   ( hex1_bits : in unsigned(5 downto 0);
           dec1_bits : out unsigned(7 downto 0) -- will output the binary 0-9
         );
end hex_to_dec1;

architecture behavioural of hex_to_dec1 is
  signal tens : unsigned(5 downto 0);
  signal ones : unsigned(5 downto 0);
--  signal ten  : unsigned(3 downto 0); 
  signal tens_bits: std_logic_vector(3 downto 0);
  signal ones_bits: std_logic_vector(3 downto 0);
begin
  --logic for the tens digit place
--  ten <= "1010"; -- binary for 10
  tens <= hex1_bits / 10; -- value digit divided by 10
  tens_bits <= std_logic_vector(tens(3 downto 0)); -- takes only the relevent bits

  --logic for the ones digit place
  ones <= hex1_bits mod 10; -- value modulo 10 to give remainder
  ones_bits <= std_logic_vector(ones(3 downto 0)); -- takes only the relevant bits
  
  -- concatenates relevant bits to a single output
  dec1_bits <= unsigned(tens_bits) & unsigned(ones_bits);
end;
