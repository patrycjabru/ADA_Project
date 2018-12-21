package body Factory is
   
   subtype Percent is Integer range 0 .. 100;
   subtype nonNegative is Integer range 0 .. Integer'Last;
   
   type Bottle is
      record
         id : nonNegative;
         filled: Percent := 0;
         capped: Boolean := false;
      end record;
   type Bottle_access is access Bottle;
   
   package Bottle_Fifo is new Fifo(Bottle_access);
   use Bottle_Fifo;
   
   Fifo_init : Fifo_Type;
   Fifo_AB : Fifo_Type;
   Fifo_BC : Fifo_Type;
   
   task body Machine_A is
      bot : Bottle_access;
   begin
      accept Start;	
      Put_Line("Machine_A: start");
      loop
         Fifo_init.Pop(bot);
         Fifo_AB.Push(bot);
         Put("Bottle ");
         Put(bot.id'Img);
         Put_Line(" put on line!");
         delay(1.0);
         exit when bot = null;
      end loop;
      Put_Line("Empty bottle container!");
   end;
     
   task body Machine_B is 
      bot : Bottle_access;
      procedure fillBottle is
      begin
         while bot.filled < 100 loop
            bot.filled := bot.filled + 1;
            delay(0.01);
         end loop;
         Put("Bottle ");
         Put(bot.id'Img);
         Put_Line(" filled!");
      end;
   begin
      accept Start;
      Put_Line("Machine_B: start");
      loop
         Fifo_AB.Pop(bot);
         fillBottle;
         Fifo_BC.Push(bot);
         exit when bot = null;
      end loop;
   end;
   
   task body Machine_C is
      bot: Bottle_access;
      procedure capBottle is
      begin
         bot.capped := True;
         delay(1.0);
         Put("Bottle ");
         Put(bot.id'Img);
         Put_Line(" capped!");
      end;
   begin
      accept Start;
      Put_Line("Machine_C: start");
      loop
         Fifo_BC.Pop(bot);
         capBottle;
         exit when bot = null;
      end loop;
   end;
   
   procedure init is
   bot : Bottle_access;
   begin
      for I in 0..10 loop
         bot := new Bottle;
         bot.id := I;
         Fifo_init.Push(bot);
      end loop;
   end;
   
   procedure run is
   begin
      init;
      Machine_A.Start;
      delay(5.0);
      Machine_B.Start;
      delay(5.0);
      Machine_C.Start;
   end;

end Factory;
