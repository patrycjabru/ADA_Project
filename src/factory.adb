With Ada.Text_IO,
Ada.Streams.Stream_IO,
Ada.Text_IO.Text_Streams,
     Ada.IO_Exceptions,
JEWL.Windows;
With GNAT.OS_Lib,JEWL.Windows;



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
--     inp : Character with Atomic;
   
   type Command_Code is (Quit, Load, Save);
   package My_Windows is new JEWL.Windows (Command_Code);
   use My_Windows;
   
   My_Frame : Frame_Type := Frame (660, 480, "Water Factory", Quit);
   ilosc_butelek : nonNegative := 0;
   ilosc_butelek_s : String := "Ilosc butelek: ";
   Main_label: Label_Type := Label (My_Frame, (0,20), 0, 20, "Ilosc butelek: ", Centre);
   --Type_label: Label_Type := Label (My_Frame, (0,50), 0, 20, "Rodzaj wody: ", Centre);

   Label_A: Label_Type := Label (My_Frame, (20,110), 0, 20, "label_A", Left);
   Log_A1: Label_Type := Label (My_Frame, (20,150), 0, 20, "", Left);
   Log_A2: Label_Type := Label (My_Frame, (20,190), 0, 20, "", Left);
   Log_A3: Label_Type := Label (My_Frame, (20,230), 0, 20, "", Left);
   Log_A4: Label_Type := Label (My_Frame, (20,270), 0, 20, "", Left);
   
   Label_B: Label_Type := Label (My_Frame, (200,110), 0, 20, "label_B", Left);
   Log_B1: Label_Type := Label (My_Frame, (200,150), 0, 20, "", Left);
   Log_B2: Label_Type := Label (My_Frame, (200,190), 0, 20, "", Left);
   Log_B3: Label_Type := Label (My_Frame, (200,230), 0, 20, "", Left);
   Log_B4: Label_Type := Label (My_Frame, (200,270), 0, 20, "", Left);
   
   Label_C: Label_Type := Label (My_Frame, (350,110), 0, 20, "label_C", Left);
   Log_C1: Label_Type := Label (My_Frame, (350,150), 0, 20, "", Left);
   Log_C2: Label_Type := Label (My_Frame, (350,190), 0, 20, "", Left);
   Log_C3: Label_Type := Label (My_Frame, (350,230), 0, 20, "", Left);
   Log_C4: Label_Type := Label (My_Frame, (350,270), 0, 20, "", Left);
   
   Label_D: Label_Type := Label (My_Frame, (512,110), 0, 20, "label_D", Left);	
   Log_D1: Label_Type := Label (My_Frame, (512,150), 0, 20, "", Left);
   Log_D2: Label_Type := Label (My_Frame, (512,190), 0, 20, "", Left);
   Log_D3: Label_Type := Label (My_Frame, (512,230), 0, 20, "", Left);
   Log_D4: Label_Type := Label (My_Frame, (512,270), 0, 20, "", Left);
   
   
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
         -- Type_label.Set_Text("Rodzaj wody: "& typeofWater'Img);
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
   
    protected type UpdateGUI is 
      procedure UpdateLabelA(text : in String);
      procedure UpdateLabelB(text : in String);
      procedure UpdateLabelC(text : in String);
      procedure UpdateLabelD(text : in String);
      procedure UpdateMainLabel(text : in String);
      procedure UpdateLogA(text : in String);
      procedure UpdateLogB(text : in String);
      procedure UpdateLogC(text : in String);
      procedure UpdateLogD(text : in String);
      procedure Refresh;
   private 
        Sem : Boolean := True; 
   end UpdateGUI;
   
   protected body UpdateGUI is 
      
      procedure Refresh is
         begin
             Label_A.Set_Text(Label_A.Get_Text);
             Label_B.Set_Text(Label_B.Get_Text);
             Label_C.Set_Text(Label_C.Get_Text);
             Label_D.Set_Text(Label_D.Get_Text);
             Log_A3.Set_Text(Log_A3.Get_Text);
             Log_A2.Set_Text(Log_A2.Get_Text);
             Log_A1.Set_Text(Log_A1.Get_Text);
             Log_B3.Set_Text(Log_B3.Get_Text);
             Log_B2.Set_Text(Log_B2.Get_Text);
             Log_B1.Set_Text(Log_B1.Get_Text);
             Log_C3.Set_Text(Log_C3.Get_Text);
             Log_C2.Set_Text(Log_C2.Get_Text);
             Log_C1.Set_Text(Log_C1.Get_Text);
             Log_D3.Set_Text(Log_D3.Get_Text);
             Log_D2.Set_Text(Log_D2.Get_Text);
             Log_D1.Set_Text(Log_D1.Get_Text);
         
         end Refresh;
      procedure UpdateLabelA(text : in String) is
         begin
         if  (Sem = True) then
             Sem := False;
             Label_A.Set_Text(text);
             Label_B.Set_Text(Label_B.Get_Text);
             Label_C.Set_Text(Label_C.Get_Text);
             Label_D.Set_Text(Label_D.Get_Text);
             Sem := True;
         end if;
      end UpdateLabelA;
      
   procedure UpdateLabelB(text : in String) is 
      begin
         if (Sem = True) then 
             Sem := False;
             Label_B.Set_Text(text);
             Label_C.Set_Text(Label_C.Get_Text);
             Label_D.Set_Text(Label_D.Get_Text);
             Sem := True;
         end if;
      end UpdateLabelB;
      
   procedure UpdateLabelC(text : in String) is
       begin
         if  (Sem = True) then
            Sem := False;
            Label_C.Set_Text(text);
            Label_D.Set_Text(Label_D.Get_Text);
            Sem := True;
         end if;
   end UpdateLabelC;
      
   procedure UpdateLabelD(text : in String) is
        begin
         if  (Sem = True) then      
               Sem := False;
               Label_D.Set_Text(text);
               Sem := True;
         end if;
      end UpdateLabelD;
      
     procedure UpdateMainLabel(text : in String) is
       begin
         if  (Sem = True) then 
               Sem := False;
               Main_label.Set_Text(text);
               Sem := True;
         end if;
     end UpdateMainLabel;
      
  procedure UpdateLogA(text : in String) is
     begin
        if  (Sem = True) then 
           Sem := False;
           Log_A3.Set_Text(Log_A2.Get_Text);
           Log_A2.Set_Text(Log_A1.Get_Text);
           Log_A1.Set_Text(text);
           Sem := True;
        end if;
      end UpdateLogA;
      
  procedure UpdateLogB(text : in String) is
     begin
        if  (Sem = True) then 
           Sem := False;
           Log_B3.Set_Text(Log_B2.Get_Text);
           Log_B2.Set_Text(Log_B1.Get_Text);
           Log_B1.Set_Text(text);
           Sem := True;
        end if;
      end UpdateLogB;
   
  procedure UpdateLogC(text : in String) is
     begin
        if  (Sem = True) then 
           Sem := False;
           Log_C3.Set_Text(Log_C2.Get_Text);
           Log_C2.Set_Text(Log_C1.Get_Text);
           Log_C1.Set_Text(text);
           Sem := True;
        end if;
      end UpdateLogC;

  procedure UpdateLogD(text : in String) is
     begin
        if  (Sem = True) then 
           Sem := False;
           Log_D3.Set_Text(Log_D2.Get_Text);
           Log_D2.Set_Text(Log_D1.Get_Text);
           Log_D1.Set_Text(text);
           Sem := True;
        end if;
      end UpdateLogD;
end UpdateGUI;
   
   update : UpdateGUI;
      
   
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
         update.UpdateLabelA(bot.id'Img);
         update.Refresh;
               Fifo_AB.Push(bot);
               Put_Line("Bottle " & bot.id'Img & " put on line!");
         update.UpdateLogA("Bottle " & bot.id'Img & " put on line!");
         
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
               --update.UpdateLogB(bot.filled'Img & "%  - " & fill'Img & " l");
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
         update.UpdateLogB("Bottle "& bot.id'Img &" filled!");
      end;
   begin
      accept Start;
      delay(5.25);
      Put_Line("Machine_B: start");
      loop
         Fifo_AB.Pop(bot);
         update.UpdateLabelB(bot.id'Img);
         update.Refresh;
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
         update.UpdateLogC("Bottle " & bot.id'Img & " capped!");
      end;
   begin
      accept Start;
      delay(10.5);
      Put_Line("Machine_C: start");
      loop
         while water_empty loop
            null;
         end loop;
         Fifo_BC.Pop(bot);
         update.UpdateLabelC(bot.id'Img);
         update.Refresh;
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
         update.UpdateLogD("Bottle " & bot.id'Img & " labeled!");
      end;
   begin
      accept Start  do
      delay(15.75);
      Put_Line("Machine_D: start");
         loop
         while water_empty loop
            null;
         end loop;
            Fifo_CD.Pop(bot);
            update.UpdateLabelD(bot.id'Img);
            update.Refresh;
            labelBottle;
            Fifo_end.Push(bot);
            ilosc_butelek := ilosc_butelek + 1;
            update.UpdateMainLabel(ilosc_butelek_s & ilosc_butelek'Img);
            update.Refresh;
            Put_Line("Bottle " & bot.id'Img & " packed!");
         exit when bot = null;
      end loop;
      end Start;
   end;
   
   
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
 
   
   task body GUI is
      procedure my_program is 
      begin
         Main_label.Set_Text(ilosc_butelek_s);
         Label_A.Set_Text("Label_A");
         Label_B.Set_Text("Label_B");
         Label_C.Set_Text("Label_C");
         Label_D.Set_Text("Label_D");
         while Valid(My_Frame) loop
            case Next_Command is
            when Quit => GNAT.OS_Lib.OS_Exit(0);
            when others => null;
            end case;
         end loop;
      end my_program;
      begin
      accept Start  do
         my_program;
      end Start;
   end;
   

   
   procedure run is -- starting the production line
   begin
      --        Input.Start;
      
      Preferences;
      init;
      Machine_A.Start;
      Machine_B.Start;
      Machine_C.Start;
      Machine_D.Start;
      GUI.Start;
--          Input.Start;
   end run;

   
end Factory;
