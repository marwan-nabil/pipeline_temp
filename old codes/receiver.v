module receiver (dataIn,dataOut,overSampler,err,host_interrupt,host_aknowledged);
  input dataIn,overSampler,host_acknowledged;
  output [7:0] dataOut;
  output [2:0] err;
  output host_interrupt;
  
  
  
  assign dataOut = buffer_reg[7:0]
  
  always @ (posedge overSampler)//first stage,phase locking the overSampler with the middle of the start bit
  if(counter==7 && ~start_flag)
      start_flag<=1'b1;  //ensures that the first stage occurs one time only
      input_reg[11] <= dataIn;    // start bit entered the shift register
      bit_counter <= bit_counter + 1;
      counter <=0;
    else if(~dataIn && ~start_flag)  
      counter <= counter+1;
      
  always @(posedge overSampler)
    if(bit_counter==12)
      data_ready_flag <=1'b1; //this stage would be stuck here until the counter is reset by the next stage
    
    else if(start_flag && counter<16)
      counter <= counter+1; 
      
    else if(start_flag && counter==16)
      for(i=0;i<11;i=i+1) //shifts the register to the right
        input_reg[i] <=input_reg[i+1];      
      input_reg[11]<=dataIn;  //shift in the new MSB
      bit_counter <= bit_counter+1;
      counter<=0;
   
  always @(posedge overSampler)
    if (data_ready_flag) //this stage won't start until this flag is set
      buffer_reg[7:0] <= input_reg[8:1];
      bit_counter <= 0; //allowing the previous stage to start again
      start_flag <= 0;  //allowing the first stage to start again
      host_interrupt <=1'b1; //interrupting the host processor to fetch the data word 
      data_ready_flag <= 0; //ensuring this stage occurs only once
      err[2]<= ^input_reg[8:1]; //signals a parity error, even parity is considered here
      
      
      
  always@(posedge overSampler)//data overrun error detection
  if (host_interrupt && host_acknowledged_flag)
    host_interrupt <= 0;
    host_aknowledged_flag <=0 ;
  else if(host_interrupt && data_ready_flag)//the next data word is ready and the host hasn't aknowledged the previous one
    err[0]<=1'b1; // data overrun ,host failed to fetch in time
  
  
  always@(posedge host_aknowledged)//the host processor sends a pulse aknowledging the arrival of data
    host_aknowledged_flag<=1'b;
  
  
  
  //error table
  //1--  parity error
  //-1-  framing error
  //--1  data overrun error
  
  
endmodule
  
      