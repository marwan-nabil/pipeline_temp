module baud_generator(clock,baud_rate,tick,s_tick);
   input clock;
   input [1:0] baud_rate;
   output tick,s_tick; //sampling tick is 16 times the frequency of a normal tick
   
   reg tick,s_tick;
   reg [1:0] baud;
   
   // baud_rate value mapping:
   //     00 == 1200
   //     01 == 2400
   //     10 == 4800
   //     11 == 9600 
   
   
   reg [11:0] counter; //one counter for diffrent baud rates of s_tick
   reg [3:0] tcounter; //tick counter ,modulus 16
   
   initial
   begin
     counter={12*1'b0};
     tcounter={4*1'b0};
     baud=2'b00; //default baud
     s_tick <= 1'b0;
     tick <= 1'b0;
   end
 
 
   always @(baud_rate)
    begin
      baud <= baud_rate;
      s_tick <=1'b0;
      tick <= 1'b0;
      counter<={12*1'b0};
      tcounter<={4*1'b0};
    end
    
    
    
   always @(posedge clock)
     case (baud)
        //baud 1200 
       2'b00: 
        begin
         if (counter==12'h516) //half period
           begin s_tick <= ~s_tick; counter<={12*1'b0}; end
         else counter <= counter+1;
        end
        
        //baud 2400
       2'b01: 
        begin
         if (counter==12'h28B) //half period
           begin s_tick <= ~s_tick; counter<={12*1'b0}; end 
         else counter <= counter+1;
        end
        
        //baud 4800
       2'b10: 
        begin
         if (counter==12'h145) //half period
           begin s_tick <= ~s_tick; counter<={12*1'b0}; end 
         else counter <= counter+1;
        end
        
         //baud 9600
       2'b11: 
        begin
         if (counter==12'hA2) //half period
           begin s_tick <= ~s_tick; counter<={12*1'b0} ; end 
         else counter <= counter+1;
        end
  
       endcase
   
   //tick output from s_tick
   always @ (posedge s_tick)
    begin tcounter <= tcounter+1;
          tick <= tcounter[3]; end 
   
   
 endmodule