With Ada.Text_IO,
Ada.Streams.Stream_IO,
Ada.Text_IO.Text_Streams,
     Ada.IO_Exceptions;
With GNAT.OS_Lib;



package body Factory is
   
   subtype Percent is Integer range 0 .. 100; --measurment of bottle filling
   subtype nonNegative is Integer range 0 .. Integer'Last; -- bottle id type
   type waterType is (regular, sparkling); -- factory provides difffrent types of water
   typeofWater:waterType; 
   capacity:String(1..5);
   subtype x is Character;
   capacity_b: Float; -- chosen capacity of bottles
   water_empty:Boolean with Atomic; -- info about empty water container
   water_filling: Short_Float; -- amount of water in filling machine container
   caps_filling: nonNegative; -- amount of caps in capping machine container
   labels_filling: nonNegative; -- amount of labels in labeling machine container
   inp : Character with Atomic;
   
   type Bottle is
      record
         id : nonNegative;
         filled: Integer := 0;
         capped: Boolean := false;
         labeled: Boolean := false;
      end record;
   type Bottle_access is access Bottle;
   
   procedure Preferences is -- initial set up of the factory
      Use Ada.Text_IO;   
   begin
      Ada.Text_IO.Put("Type 'a' if you choose a sparkling water or 'b' if you prefer regular water:");
      declare
      S1 : String := Ada.Text_IO.Get_Line;
      begin
         Ada.Text_IO.Put_Line (S1);
         if(S1="a") then
         typeofWater:=sparkling;
         else
         typeofWater:=regular;
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
   
   package Bottle_Fifo is new Fifo(Bottle_access); -- creating production lines
   use Bottle_Fifo;
   
   Fifo_init : Fifo_Type;
   Fifo_AB : Fifo_Type;
   Fifo_BC : Fifo_Type;
   Fifo_CD : Fifo_Type;
   Fifo_end : Fifo_Type;
   
   
   task body Machine_A is -- first machine - takes bottles from bottle container and puts them on first line 
      bot : Bottle_access;
   begin
            accept Start;	
            Put_Line("Machine_A: start");
      
            if(typeofWater=sparkling) then
               Put_Line("Production of sparkling water starts!");
            else
               Put_Line("Production of regular water starts:");
            end if;
      
            Put_Line("Capacity:");
            put(capacity);
            new_line;
            Put_Line("Machine's filling: "& water_filling'Img);
      
      loop
         while water_empty loop
            null;
            end loop;
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
     
   task body Machine_B is -- second machine -- takes bottles from first line, fills them and puts them on second line
      bot : Bottle_access;
      fill:Short_Float:=0.0;
      inc: Short_Float;
      S : Character;
      procedure fillContainer is
      begin
         water_empty:=True;
         Put_Line("Filling machine is empty! Type 'a' to fill it or 'q' to abort the process!");
         loop 
            Ada.Text_IO.Get_Immediate(S);
            if S='a' then
               water_filling:=5.0;
               water_empty:=False;
               exit;
            end if;
         end loop;
      end;
        
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
               Put(bot.filled'Img & "%  - ");
               Put(fill'Img);
               Put(" l");
               fill:=fill+inc;
               new_line;
               water_filling:=water_filling-inc;
               
               if(water_filling<=0.0) then                  
                  fillContainer;
                 end if;  
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
   
   task body Machine_C is -- third machine - takes bottles from second line, capps them and puts them on third line
      bot: Bottle_access;
      procedure capBottle is
      begin
         caps_filling := caps_filling - 1; -- exception when negative value!
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
         while water_empty loop
            null;
         end loop;
         Fifo_BC.Pop(bot);
         capBottle;
         Fifo_CD.Push(bot);
         exit when bot = null;
      end loop;
   end;
   
   task body Machine_D is -- forth machine - takse bottles from third line, label them and puts them in final package
      bot: Bottle_access;
      procedure labelBottle is
      begin
         labels_filling := labels_filling - 1; -- exception when negative value!
         bot.labeled := True;
         delay(1.0);
         Put("Bottle ");
         Put(bot.id'Img);
         Put_Line(" labeled!");
      end;
   begin
      accept Start  do
      Put_Line("Machine_D: start");
         loop
         while water_empty loop
            null;
         end loop;
         Fifo_CD.Pop(bot);
         labelBottle;
         Fifo_end.Push(bot);
         Put_Line("Bottle " & bot.id'Img & " packed!");
         exit when bot = null;
      end loop;
      end Start;
   end;
     
--       task body Input is 
--          answer : Character;
--       begin
--          accept Start do
--             while True loop
--             Ada.Text_IO.Get_Immediate(answer);
--             if answer = 'q' then
--                   GNAT.OS_Lib.OS_Exit(0);
--             elsif answer = 'a'then 
--                  inp := answer;
--             end if;
--          end loop;
--          end Start;
--       end;
      
   
   procedure init is -- setting up initial values of containers
   bot : Bottle_access;
   begin
      for I in 0..10 loop
         bot := new Bottle;
         bot.id := I;
         Fifo_init.Push(bot);
      end loop;
      water_filling := 50.0;
      caps_filling := 15;
      labels_filling := 13;
   end;
   
   procedure run is -- starting the production line
   begin
--        Input.Start;
      Preferences;
      init;
      Machine_A.Start;
      delay(5.0);
        Machine_B.Start;
        delay(5.0);
        Machine_C.Start;
        delay(5.0);
        Machine_D.Start;
--          Input.Start;
   end;

end Factory;
