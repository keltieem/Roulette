LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

entity hex_to_dec2 is
  port   ( hex2_bits : in unsigned(11 downto 0);
           dec2_bits : out unsigned(15 downto 0) -- will output the binary 0-9
         );
end hex_to_dec2;

architecture behavioural of hex_to_dec2 is
  signal thousands : unsigned(11 downto 0);
  signal hundreds  : unsigned(11 downto 0);
  signal tens      : unsigned(11 downto 0);
  signal ones      : unsigned(11 downto 0);
  signal temp1     : unsigned(11 downto 0);
  signal temp2     : unsigned(11 downto 0);
  signal thou_bits: std_logic_vector(3 downto 0);
  signal hund_bits: std_logic_vector(3 downto 0);
  signal tens_bits: std_logic_vector(3 downto 0);
  signal ones_bits: std_logic_vector(3 downto 0);
begin
  --logic for the thousands digit place
  thousands <= hex2_bits / 1000; -- value digit divided by 1000 (which will be a value between 4-0)
  thou_bits <= std_logic_vector(thousands(3 downto 0)); -- takes only the relevent bits

  --logic for the tens digit place
  temp1 <= hex2_bits mod 1000; -- value modulo 1000 (which will be a value between 999-0)
  hundreds <= temp1 / 100; -- value divided by 100 (which will be a value between 9-0)
  hund_bits <= std_logic_vector(hundreds(3 downto 0)); -- takes only the relevent bits

  --logic for the tens digit place
  temp2 <= hex2_bits mod 100; -- value modulo 100 (which will be a value between 99-0
  tens <= temp2 / 10; -- value digit divided by 10
  tens_bits <= std_logic_vector(tens(3 downto 0)); -- takes only the relevent bits

  --logic for the ones digit place
  ones <= hex2_bits mod 10; -- value modulo 10 to give remainder
  ones_bits <= std_logic_vector(ones(3 downto 0)); -- takes only the relevant bits
  
  -- concatenates relevant bits to a single output
  dec2_bits <= unsigned(thou_bits) & unsigned(hund_bits) & unsigned(tens_bits) & unsigned(ones_bits);
end;


