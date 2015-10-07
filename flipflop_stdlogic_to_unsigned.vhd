LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

entity flipflop_stdlogic_to_unsigned is
  generic (k : integer);
  port   ( clk    : in std_logic;
           resetb : in std_logic;
           D      : in std_logic_vector (k-1 downto 0); 
           Q      : out unsigned (k-1 downto 0)
         );
end flipflop_stdlogic_to_unsigned;

architecture behavioural of flipflop_stdlogic_to_unsigned is
begin

  process(clk, resetb)
    variable R : unsigned (k-1 downto 0);
    begin
    if (resetb = '0') then
       Q<= (others =>'0');
    elsif (rising_edge(clk)) then
      R := unsigned(D);
      Q <= R;

     end if;
   end process;
  
end;

