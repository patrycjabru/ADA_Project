package body Factory is
   
   subtype Percent is Integer range 0 .. 100;
   
   type Bottle is
      record
         filled: Percent := 0;
         capped: Boolean := false;
      end record;
   
   package Bottle_Fifo is new Fifo(Bottle);
   use Bottle_Fifo;
   Fifo_AB : Fifo_Type;
   bot1, bot2, bot3 : Bottle; --TODO Make a container with bottles
   --bot12: Bottle;
   
   task body Machine_A is
   begin
      accept Start;	
      Put_Line("Machine_A: start");
      Fifo_AB.Push(bot1); --TODO Push from container
   end;
     
   task body Machine_B is 
   begin
      accept Start;
      Put_Line("Machine_B: start"); --TODO Pop from fifo
      --Fifo_AB.Pop(bot12);
      --bot12.filled:=100;
   end;
   
   procedure run is
   begin
      Machine_A.Start;
      Machine_B.Start;
   end;
end Factory;
