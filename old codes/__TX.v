
module TX (bd_rate,d_num,s_num,par,set_param,clk,data_in,data_out,enable);
  input d_num,s_num,set_param,clk,enable ;
  input [7:0] data_in;  //input data has width 8
  input [1:0] bd_rate,par;
  output data_out;
  
  reg datan,stopn,data_out,i,busy_flag,parity_vlaue,parity_ready_flag;
  reg [1:0] baud,parity;
  wire[3:0] number_of_ones; //used to count how many 1's in a data word : max is 8
  reg [7:0] data_buffer;
  reg [11:0] packet;
  wire ticker;   //ticks with the selected baud
  
  
  initial
  begin
    datan <= 1'b1; //8 bit default data width
    stopn <=1'b1; //2 default stop bits
    baud <=2'b11; //9600 default baud
    parity <= 2'b10;//default even parity
    data_buffer <= 8'h00; //buffer is reset
    busy_flag <=1'b0;
    packet <={12*1'b1};
    number_of_ones<=4'b0000;
    parity_vlaue<=1'b0;
    parity_ready_flag<=1'b0;
  end
  
  always @ (posedge clk) //setting UART parameters externally
  if (~set_param)//active low
  begin
    datan<=d_num; baud<=bd_rate ;stopn <= s_num ; parity <= par;
  end
  
  
  always @ (posedge clk)
  if (~enable && ~busy_flag)  //insures data is sampled once during an enable pulse
    begin
      data_buffer<=data_in;
      busy_flag<=1'b1;
    end

                
/*                
  
  always @(posedge clk)//parity bit calculator for different parities
  case (parity)
  2'b00: begin parity_value <= 1'b0 ; parity_ready_flag<=1'b1; end  //no parity case 
  2'b01: //odd parity case
        begin 
          if(number_of_ones % 2 ==0) parity_value <= 1'b1;
           else parity_value <= 1'b0;
             parity_ready_flag<=1'b1; 
        end
  2'b10: //even parity case
        begin
          if(number_of_ones % 2 ==0) parity_value <= 1'b0;
            else parity_value <= 1'b1;
          parity_ready_flag<=1'b1; 
        end
  default: begin parity_value <= 1'b0 ; parity_ready_flag<=1'b1; end  //like in no parity case   
  endcase       
                
  */
  
      
  
  always @ (posedge clk)
  if(busy_flag && parity_ready_flag)
    begin
      if(datan && stopn) //8 data bits and 2 stop bits
        case(parity)
        00: packet[11:0]<={3'b111,data_buffer[7:0],1'b0};
        01: packet[11:0]<={2'b111,,data_buffer[7:0],1'b0};
        10:
        default:
      
      
      
      else if(datan && ~stopn)//8 data bits and 1 stop bit
      begin end
      else if(~datan && stopn)//7 data bits and 2 stop bits
      begin end
      else if(~datan && ~stopn)//7 data bits and 1 stop bit
      begin end
      
      
      
    end
  
   
 endmodule
 
