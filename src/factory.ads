with Ada.Text_IO, fifo;
use Ada.Text_IO;

package Factory is

   task Machine_A is 
      entry Start;
--        entry Stop;
   end Machine_A;
   
   task Machine_B is 
      entry Start;
   end Machine_B;
   
   task Machine_C is 
      entry Start;
   end Machine_C;
   
   task Machine_D is 
      entry Start;
   end Machine_D;

   task GUI is
      entry Start;
   end GUI;
   
   procedure run;
end Factory;
