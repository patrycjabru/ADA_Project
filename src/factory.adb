With Ada.Text_IO;

With
Ada.Streams.Stream_IO,
Ada.Text_IO.Text_Streams,
Ada.IO_Exceptions;



package body Factory is
   
   subtype Percent is Integer range 0 .. 100;
   subtype nonNegative is Integer range 0 .. Integer'Last;
   typeofWater:Boolean;
   capacity:String(1..5);
   subtype x is Character;
   
   procedure Preferences is
      Use Ada.Text_IO;
   begin
      Ada.Text_IO.Put("Type 'a' if you choose a sparkling water or 'b' if you prefer regular water:");
      declare
      S1 : String := Ada.Text_IO.Get_Line;
      begin
         Ada.Text_IO.Put_Line (S1);
         
         if(S1="a") then
         typeofWater:=True;
         else
         typeofWater:=False;
         end if;
     
      end;
      
      Ada.Text_IO.Put("Choose bottle capacity. Type 'a' - 500ml, 'b' - 1l, 'c' - 1,5l:");
      declare
      S2 : String := Ada.Text_IO.Get_Line;
      begin
         Ada.Text_IO.Put_Line (S2);
         if(S2="a") then
         capacity:="500ml";
         elsif (S2="b") then
         capacity:="1litr";
         else
         capacity:="1,5 l";    
         end if;
      end;
      
   new_line;
      
   end Preferences;
   
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
      
      if(typeofWater=true) then
        Put_Line("Production of sparkling water starts!");
      else
         Put_Line("Production of regular water starts:");
      end if;
      
      Put_Line("Capacity:");
      put(capacity);
      new_line;
      
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
      Preferences;
      Machine_A.Start;
      delay(5.0);
      Machine_B.Start;
      delay(5.0);
      Machine_C.Start;
   end;

end Factory;
