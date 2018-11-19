module UART_top (baud,inputDataBus,outputDataBus,errorBus,Rx,Tx,clk,host_interrupt,send,host_aknowledged)
  input Rx,send,clk,host_aknowledged;
  input [1:0] baud;
  input [7:0] inputDataBus;
  
  output [7:0] outputDataBus;
  output host_interrupt,Tx;
  output [2:0] err;
    
  
  //Baud generator connection
  wire ticker,overSampler;
  baud_generator2 gen (.clock(clk),.baud_rate(baud),.tick(ticker),.s_tick(overSampler));
  
  //Tx connection
  transmitter tran (.enable(send),.clk(ticker),.dataIn(inputDataBus),.dataOut(Tx));
  
  //Rx connection
  receiver rec (.dataIn(Rx),.dataOut(outputDataBus),.overSampler(overSampler),.err(err),.host_interrupt(host_interrupt),.host_aknowledged(host_aknowledged));
  
endmodule


