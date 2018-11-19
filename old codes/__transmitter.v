module transmitter (enable,clk,dataIn,dataOut);  //clk here means ticker
  input clk,enable;
  input [7:0] dataIn;
  output dataOut;
  
  reg [11:0] packet;
  reg [7:0] data_buffer;
  reg busy_flag,packet_ready_flag,i;
  


  initial
  begin
    packet[11:0] <= 12'b111111111111;
    data_buffer[7:0] <=8'b00000000;
    busy_flag <=1'b0;
    packet_ready_flag <=1'b0;
  end


  assign dataOut = packet[0];  // the output is the LSB of the packet shift register
  
always @(posedge clk)
  begin 
  if(enable && ~busy_flag)
    begin 
      data_buffer[7:0] <= dataIn[7:0];
      busy_flag <= 1'b1;     //insures reading the data bus happens once
    end
    
    
  else if (busy_flag && ~packet_ready_flag)
    begin 
      packet <= {2'b11,^data_buffer,data_buffer[7:0],1'b0}; // 2 stop bits and even parity
      packet_ready_flag <= 1'b1;   //insures forming the packet happens once
    end
    
  else if (packet_ready_flag && busy_flag)
    for (i=0;i<12;i=i+1)
      begin
        packet[11] <= 1'b1; // shift in 1's to the MSB
        packet[i] <= packet[i+1]; //shifts the whole packet to the right
      end
      
 
  else if (packet[11:0]==12'b111111111111 && packet_ready_flag && busy_flag) // when the packet is sent and the line is idle
    begin 
      packet_ready_flag <=1'b0;
      busy_flag <=1'b0;
    end
  end
endmodule 
  
  
  

