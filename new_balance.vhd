LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;
--------------------------------------------------------------
--
-- Skeleton file for new_balance subblock.  This block is purely
-- combinational (think Pattern 1 in the slides) and calculates the
-- new balance after adding winning bets and subtracting losing bets.
--
---------------------------------------------------------------
ENTITY new_balance IS
  PORT(money : in unsigned(11 downto 0);  -- Current balance before this spin
       bet1_amount : in unsigned(2 downto 0);  -- Value of bet 1
       bet2_amount : in unsigned(2 downto 0);  -- Value of bet 2
       bet3_amount : in unsigned(2 downto 0);  -- Value of bet 3
       bet1_wins : in std_logic;  -- True if bet 1 is a winner
       bet2_wins : in std_logic;  -- True if bet 2 is a winner
       bet3_wins : in std_logic;  -- True if bet 3 is a winner
       new_money : out unsigned(11 downto 0));  -- balance after adding winning
                                                -- bets and subtracting losing bets
END new_balance;
ARCHITECTURE behavioural OF new_balance IS
BEGIN

  process(all)
    variable balance          : unsigned(11 downto 0);
    variable thirtyfive_multi : unsigned(11 downto 0); -- 35 multiplyer place holder
    variable two_multi        : unsigned(11 downto 0); -- 2 multiplier place holder
    begin
      -- Putting money into balance
      balance := money;
     
      -- bet1 logic
      if (bet1_wins = '1') then -- when bet1 has won
        thirtyfive_multi := to_unsigned(35,9)*bet1_amount; --converts 35 to the correct length and type while multiplying 35 by our bet value
        balance := balance + thirtyfive_multi; -- adds the betted value*the odds
     else --when we lose, subtract betted value
--        if (balance-bet1_amount < balance) then
          balance := balance - bet1_amount;
      end if;
      
      -- bet3 logic
      if (bet3_wins = '1') then -- when bet3 has won
        two_multi := to_unsigned(2,9)*bet3_amount; -- converts 2 to the correct length and type while multiplying 2 to our bet value
        balance := balance + two_multi; -- adds the betted value*the odds
      else -- when we lose subtract the betted value from the balance
        balance := balance - bet3_amount;
      end if;
      
      -- bet 2 logic
      if (bet2_wins = '1') then -- when bet2 has won
        balance := balance + bet2_amount; -- add the bet value to the balance
      else -- when we lose, subtract the bet value from the balance
        balance := balance - bet2_amount;
      end if;
      
      --updating the money with new_money
      new_money <= balance;
      
      -- if balance will be less than zero then do not update balance to the new value but instead make it zero.
      
      end process;
END;