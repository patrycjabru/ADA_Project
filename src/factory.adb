With Ada.Text_IO,
     Ada.Streams.Stream_IO,
     Ada.Text_IO.Text_Streams,
     Ada.IO_Exceptions,
     JEWL.Windows,
     Ada.Task_Identification,
     GNAT.OS_Lib,JEWL.Windows;
use Ada.Task_Identification;


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
   caps_empty:Boolean with Atomic;
   caps_filling: nonNegative; -- amount of caps in capping machine container
   labels_empty:Boolean with Atomic;
   labels_filling: nonNegative; -- amount of labels in labeling machine container
   Start_Production: Boolean:=False with Atomic;
   
   type Command_Code is (Quit, 'C', 'L', 'W', '1', '2', '3', '4', '5', '6');
   package My_Windows is new JEWL.Windows (Command_Code);
   use My_Windows;
   
   My_Frame : Frame_Type := Frame (660, 480, "Water Factory", Quit);
   ilosc_butelek : nonNegative := 0;
   ilosc_butelek_s : String := "Packed bottles: ";
   Main_label: Label_Type := Label (My_Frame, (0,80), 0, 20, "Packed bottles: ", Centre);
   --Error_Info: Label_Type := Label (My_Frame, (0,400), 0, 20, "", Centre);
   --Type_label: Label_Type := Label (My_Frame, (0,50), 0, 20, "Rodzaj wody: ", Centre);

   Label_A: Label_Type := Label (My_Frame, (20,110), 0, 20, "X", Left);
   Log_A1: Label_Type := Label (My_Frame, (20,150), 0, 20, "", Left);
   Log_A2: Label_Type := Label (My_Frame, (20,190), 0, 20, "", Left);
   Log_A3: Label_Type := Label (My_Frame, (20,230), 0, 20, "", Left);
   Log_A4: Label_Type := Label (My_Frame, (20,270), 0, 20, "", Left);
   
   Label_B: Label_Type := Label (My_Frame, (200,110), 0, 20, "X", Left);
   Log_B1: Label_Type := Label (My_Frame, (200,150), 0, 20, "", Left);
   Log_B2: Label_Type := Label (My_Frame, (200,190), 0, 20, "", Left);
   Log_B3: Label_Type := Label (My_Frame, (200,230), 0, 20, "", Left);
   Log_B4: Label_Type := Label (My_Frame, (200,270), 0, 20, "", Left);
   
   Label_C: Label_Type := Label (My_Frame, (350,110), 0, 20, "X", Left);
   Log_C1: Label_Type := Label (My_Frame, (350,150), 0, 20, "", Left);
   Log_C2: Label_Type := Label (My_Frame, (350,190), 0, 20, "", Left);
   Log_C3: Label_Type := Label (My_Frame, (350,230), 0, 20, "", Left);
   Log_C4: Label_Type := Label (My_Frame, (350,270), 0, 20, "", Left);
   
   Label_D: Label_Type := Label (My_Frame, (512,110), 0, 20, "X", Left);	
   Log_D1: Label_Type := Label (My_Frame, (512,150), 0, 20, "", Left);
   Log_D2: Label_Type := Label (My_Frame, (512,190), 0, 20, "", Left);
   Log_D3: Label_Type := Label (My_Frame, (512,230), 0, 20, "", Left);
   Log_D4: Label_Type := Label (My_Frame, (512,270), 0, 20, "", Left);
   
   Caps_Button : Button_Type := Button (My_Frame, (350,300), 80, 25, "Fill caps", 'C');
   Water_Button : Button_Type := Button (My_Frame, (200,300), 80, 25, "Fill water", 'W');
   Label_Button : Button_Type := Button (My_Frame, (512,300), 80, 25, "Fill labels", 'L');
   
   Caps_Empty_Label : Label_Type := Label (My_Frame, (350,330), 0, 20, "", Left);
   Water_Empty_Label : Label_Type := Label (My_Frame, (200,330), 0, 20, "", Left);
   Labels_Empty_Label : Label_Type := Label (My_Frame, (512,330), 0, 20, "", Left);

   Button1 : Button_Type := Button (My_Frame, (0,0), 110,25, "Regular 0,5l", '1'); 
   Button2 : Button_Type := Button (My_Frame, (110,0), 110,25, "Regular 1,0l", '2'); 
   Button3 : Button_Type := Button (My_Frame, (220,0), 110,25, "Regular 1,5l", '3'); 
   Button4 : Button_Type := Button (My_Frame, (330,0), 110,25, "Sparkling 0,5l", '4'); 
   Button5 : Button_Type := Button (My_Frame, (440,0), 110,25, "Sparkling 1,0l", '5'); 
   Button6 : Button_Type := Button (My_Frame, (550,0), 110,25, "Sprkling 1,5l", '6'); 
   
   type Bottle is
      record
         id : nonNegative;
         filled: Integer := 0;
         capped: Boolean := false;
         labeled: Boolean := false;
      end record;
   type Bottle_access is access Bottle;
   
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
      
--        procedure CloseGUI is
--        begin
--            when 'Quit' =>
--        Close (My_Frame);
--        exit;
--        end CloseGUI;   
      
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
             Refresh;
             Sem := True;
         end if;
      end UpdateLabelA;
      
   procedure UpdateLabelB(text : in String) is 
      begin
         if (Sem = True) then 
             Sem := False;
             Label_B.Set_Text(text);
             Refresh;
             Sem := True;
         end if;
      end UpdateLabelB;
      
   procedure UpdateLabelC(text : in String) is
       begin
         if  (Sem = True) then
            Sem := False;
            Label_C.Set_Text(text);
             Refresh;
            Sem := True;
         end if;
   end UpdateLabelC;
      
   procedure UpdateLabelD(text : in String) is
        begin
         if  (Sem = True) then      
               Sem := False;
            Label_D.Set_Text(text);
             Refresh;
               Sem := True;
         end if;
      end UpdateLabelD;
      
     procedure UpdateMainLabel(text : in String) is
       begin
         if  (Sem = True) then 
               Sem := False;
            Main_label.Set_Text(text);
             Refresh;
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
             Refresh;
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
             Refresh;
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
             Refresh;
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
             Refresh;
           Sem := True;
        end if;
      end UpdateLogD;
end UpdateGUI;
   
   update : UpdateGUI;
      
   
   task body Machine_A is -- first machine - takes bottles from bottle container and puts them on first line 
      bot : Bottle_access;
   begin
            accept Start;	
      
            if(typeofWater=sparkling) then
               Put_Line("Production of sparkling water starts!");
            else
               Put_Line("Production of regular water starts:");
            end if;
      
            Put_Line("Capacity:");
            put(capacity);
            Put_Line("Machine's filling: "& water_filling'Img);
      
      loop
         while water_empty or caps_empty or labels_empty loop
            null;
            end loop;
               Fifo_init.Pop(bot);
               update.UpdateLabelA(bot.id'Img);
               Fifo_AB.Push(bot);
               update.UpdateLogA("Bottle " & bot.id'Img & " put on line!");
               delay(1.0);
               exit when bot = null;
            end loop;
      --Error_Info.Set_Text("Empty bottle container!");
      exception
         when Empty_Error => Abort_Task(Current_Task);
         when others => GNAT.OS_Lib.OS_Exit(1);
   end;
     
   task body Machine_B is -- second machine -- takes bottles from first line, fills them and puts them on second line
      bot : Bottle_access;
      fill:Short_Float:=0.0;
      inc: Short_Float;
      S : Character;
      procedure fillContainer is
      begin
         water_empty:=True;
         Water_Empty_Label.Set_Text("Empty!");
         while water_empty loop
            null;
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
         while bot.filled <= 100 loop
            if(bot.filled mod 50=0) then
               fill:=fill+inc;
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
      loop
         while caps_empty or labels_empty loop
            null;
         end loop;
         Fifo_AB.Pop(bot);
         update.UpdateLabelB(bot.id'Img);
         fillBottle;
         Fifo_BC.Push(bot);
         exit when bot = null;
      end loop;
      exception
         when Empty_Error => Abort_Task(Current_Task);
         when others => GNAT.OS_Lib.OS_Exit(2);
   end;
   
   task body Machine_C is -- third machine - takes bottles from second line, capps them and puts them on third line
      bot: Bottle_access;
      procedure fillContainer is
      begin
         caps_empty:=true;
         Caps_Empty_Label.Set_Text("Empty!");
         while caps_empty loop
            null;
         end loop;
      end;
      procedure capBottle is
      begin
         if caps_filling=0 then
            fillContainer;
         end if;
         caps_filling := caps_filling - 1; -- exception when negative value!
         bot.capped := True;
         delay(1.0);
         update.UpdateLogC("Bottle " & bot.id'Img & " capped!");
      end;
   begin
      accept Start;
      delay(10.5);
      loop
         while water_empty or labels_empty loop
            null;
         end loop;
         Fifo_BC.Pop(bot);
         update.UpdateLabelC(bot.id'Img);
         capBottle;
         Fifo_CD.Push(bot);
         exit when bot = null;
      end loop;
      exception
         when Empty_Error => Abort_Task(Current_Task);
         when others => GNAT.OS_Lib.OS_Exit(3);
   end;
   
   task body Machine_D is -- forth machine - takse bottles from third line, label them and puts them in final package
      bot: Bottle_access;
      procedure fillContainer is
      begin
         labels_empty:=true;
         Labels_Empty_Label.Set_Text("Empty!");
         while labels_empty loop
            null;
         end loop;
      end;
      
      procedure labelBottle is
      begin
         if labels_filling=0 then
            fillContainer;
         end if; 
         labels_filling := labels_filling - 1; -- exception when negative value!
         bot.labeled := True;
         delay(1.0);
         update.UpdateLogD("Bottle " & bot.id'Img & " labeled!");
      end;
   begin
      accept Start;
      delay(15.75);
         loop
         while water_empty or caps_empty loop
            null;
         end loop;
            Fifo_CD.Pop(bot);
            update.UpdateLabelD(bot.id'Img);
            labelBottle;
            Fifo_end.Push(bot);
            ilosc_butelek := ilosc_butelek + 1;
            update.UpdateMainLabel(ilosc_butelek_s & ilosc_butelek'Img);
         exit when bot = null;
      end loop;
      exception
         when Empty_Error => Abort_Task(Current_Task);
         when others => GNAT.OS_Lib.OS_Exit(4);
   end;
   
   
   procedure init is -- setting up initial values of containers
   bot : Bottle_access;
   begin
      for I in 0..10 loop
         bot := new Bottle;
         bot.id := I;
         Fifo_init.Push(bot);
      end loop;
      water_filling := 5.0;
      caps_filling := 3;
      labels_filling := 3;
   end;
 
   
   task body GUI is
      procedure fillCaps is
      begin
         caps_filling := caps_filling + 5;
         caps_empty := False;
         Caps_Empty_Label.Set_Text("");
      end fillCaps;
      
      procedure fillWater is
      begin
         water_filling := water_filling + 5.0;
         water_empty := False;
         Water_Empty_Label.Set_Text("");
      end fillWater;
      
      procedure fillLabels is
      begin
         labels_filling := labels_filling + 5;
         labels_empty := False;
         Labels_Empty_Label.Set_Text("");
      end fillLabels;
      
      procedure blockButtons is
      begin
         Button1.Disable;
         Button2.Disable;
         Button3.Disable;
         Button4.Disable;
         Button5.Disable;
         Button6.Disable;
         Start_Production := True;
      end;
      
      procedure setProp1 is
      begin
         typeofWater:=regular;
         capacity_b:=0.5;
         blockButtons;
      end;
      
      procedure setProp2 is
      begin
         typeofWater:=regular;
         capacity_b:=1.0;
         blockButtons;
      end;
      
      procedure setProp3 is
      begin
         typeofWater:=regular;
         capacity_b:=1.5;
         blockButtons;
      end;
      
      procedure setProp4 is
      begin
         typeofWater:=sparkling;
         capacity_b:=0.5;
         blockButtons;
      end;
      
      procedure setProp5 is
      begin
         typeofWater:=sparkling;
         capacity_b:=1.0;
         blockButtons;
      end;
      
      procedure setProp6 is
      begin
         typeofWater:=sparkling;
         capacity_b:=1.5;
         blockButtons;
      end;
      
      procedure my_program is 
      begin
         Main_label.Set_Text(ilosc_butelek_s);
         while Valid(My_Frame) loop
            case Next_Command is
            when Quit => GNAT.OS_Lib.OS_Exit(0);
            when 'C' => fillCaps;
            when 'W' => fillWater;
            when 'L' => fillLabels;
            when '1' => setProp1;
            when '2' => setProp2;
            when '3' => setProp3;
            when '4' => setProp4;
            when '5' => setProp5;
            when '6' => setProp6;
            when others => null;
            end case;
         end loop;
      end my_program;
      begin
      accept Start;
      my_program;
      exception
         when others => GNAT.OS_Lib.OS_Exit(5);
   end;
   
   procedure run is -- starting the production line
   begin
       GUI.Start;
       init;
       while Start_Production=False loop
         delay(0.1);
       end loop;
       Machine_A.Start;
       Machine_B.Start;
       Machine_C.Start;
       Machine_D.Start;
   end run;

   
end Factory;
