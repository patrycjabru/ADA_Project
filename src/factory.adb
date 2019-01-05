With Ada.Text_IO;

With
Ada.Streams.Stream_IO,
Ada.Text_IO.Text_Streams,
     Ada.IO_Exceptions;
With GNAT.OS_Lib;



package body Factory is
   
   subtype Percent is Integer range 0 .. 100;
   subtype nonNegative is Integer range 0 .. Integer'Last;
   typeofWater:Boolean;
   capacity:String(1..5);
   subtype x is Character;
   capacity_b: Float; --wybrana pojemnosc butelki
   mach_empty:Boolean; --info czy maszyna to nalewania jest pusta
   mach_filling: Short_Float:=5.0; --zawartosc maszyny wypelniajacej
   
 type Bottle is
      record
         id : nonNegative;
         filled: Integer := 0;
         capped: Boolean := false;
      end record;
   type Bottle_access is access Bottle;
   
  
   
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
            capacity:="0,5 l";
            capacity_b:=0.5;
         elsif (S2="b") then
            capacity:="1,0 l";
            capacity_b:=1.0;
         else
            capacity:="1,5 l";  
            capacity_b:=1.5;
         end if;
      end;
      
   new_line;
      
   end Preferences;
   
   
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
      Put_Line("Machine's filling: "& mach_filling'Img);
      
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
      Use Ada.Text_IO;
      
      bot : Bottle_access;
      fill:Short_Float:=0.0;
      inc: Short_Float;
      
      procedure fillBottle is
      begin
         
          if(capacity_b=0.5) then
            inc:=0.25;
         elsif (capacity_b=1.0) then
            inc:=0.5;
         else
            inc:=0.75;
         end if;
         
         new_line;
         Put_Line("Filling process....");
         while bot.filled <= 100 loop
            if(bot.filled mod 50=0) then
               Put(bot.filled'Img & "%  - " & fill'Img & " l");
               fill:=fill+inc;
               new_line;
               mach_filling:=mach_filling-inc;
               
              -- if(mach_filling<=0.0) then
                --  declare
                  --   S : String := Ada.Text_IO.Get_Line;
                  --begin
                    -- Put_Line("Filling machine is empty! Type 'a' to fill it or 'b' to abort the process!");
                    -- Ada.Text_IO.Put_Line (S);
                     --if(S="a") then
                       -- mach_filling:=5.0;
                     --else   
                       -- GNAT.OS_Lib.OS_Exit (0);
                     --end if;   
                  --end;
               
               --end if;  
            end if;   
            bot.filled := bot.filled + 1;
            delay(0.01);
         end loop;
         fill:=0.0;
         Put_Line("Bottle "& bot.id'Img &" filled!");
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
