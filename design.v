// Code your design here
module VerySimpleCPU(clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);

	input clk, rst;
  	output reg wrEn;
   input [31:0] data_fromRAM;
  	output reg [31:0] data_toRAM;
   output reg [13:0] addr_toRAM;
  	
  	reg [31:0] IW, IWN;	
  	reg [13:0] PC, PCN;
  	reg [2:0] st, stN;
  	reg [31:0] R1, R2, R1N, R2N;
  
  	always @(posedge clk) begin
      PC <= PCN;
      IW<= IWN; 
      R1<= R1N;
      R2<= R2N;
      st <= stN;
  	end
   
  	always @ * begin
      R1N = 32'hX;
      R2N = 32'hX;
      IWN = IW;
      PCN = PC;
      wrEn = 1'b0;
      stN = 3'hX;
      addr_toRAM = 14'hXXXX;
      data_toRAM = 32'dX;
      if (rst) begin
      	stN = 3'd0;
         PCN= 14'd0;
      end
      else begin       
        case (st)
          3'd0: begin
            addr_toRAM = PC;
            stN = 3'd1;
          end
          3'd1: begin
            IWN = data_fromRAM;
            if (data_fromRAM[31:28] == 4'b0001) begin //ADDi
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;        
            end
				if (data_fromRAM[31:28] == 4'b0000) begin //ADD
					addr_toRAM = data_fromRAM[27:14];
					stN = 3'd2;
				end
            if (data_fromRAM[31:28] == 4'b1000) begin //CP
              addr_toRAM = data_fromRAM[13:0];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b1001) begin //CPi
              addr_toRAM = data_fromRAM[13:0];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b1010) begin //CPI
              addr_toRAM = data_fromRAM[13:0];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b1011) begin //CPIi
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b0010) begin //NAND
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b0011) begin //NANDi
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b0100) begin //SRL
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b0101) begin //SRLi
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b0110) begin //LT
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b0111) begin //LTi
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b1110) begin //MUL
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:28] == 4'b1111) begin //MULi
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
            if (data_fromRAM[31:29] == 3'b110) begin //BZJ or BZJi
              addr_toRAM = data_fromRAM[27:14];
              stN = 3'd2;
            end
          end
          3'd2: begin
            if (IW[31:28] == 4'b0001) begin // ADDi
          		wrEn = 1'b1;
            	addr_toRAM = IW[27:14];
            	data_toRAM = data_fromRAM + IW[13:0];
            	PCN = PC + 14'd1;
            	stN = 3'd0;  
            end
            if (IW[31:28] == 4'b1111) begin // MULi
          		wrEn = 1'b1;
            	addr_toRAM = IW[27:14];
            	data_toRAM = data_fromRAM * IW[13:0];
            	PCN = PC + 14'd1;
            	stN = 3'd0;  
            end
            if (IW[31:28] == 4'b0000) begin // ADD
              	R1N = data_fromRAM;
              	addr_toRAM = IW[13:0];           	
            	stN = 3'd3;  
            end
            if (IW[31:28] == 4'b1110) begin //MUL
              	R1N = data_fromRAM;
              	addr_toRAM = IW[13:0];
              	stN = 3'd3;
            end
            if (IW[31:28] == 4'b0010) begin // NAND
              	R1N = data_fromRAM;
              	addr_toRAM = IW[13:0];
              	stN = 3'd3;
            end
            if (data_fromRAM[31:28] == 4'b0011) begin //NANDi
              	wrEn = 1'b1;
              	addr_toRAM = IW[27:14];
              	data_toRAM = ~(data_fromRAM & IW[13:0]);
              	PCN = PC + 14'd1;
              	stN = 3'd0;
            end
            if (data_fromRAM[31:28] == 4'b0100) begin //SRL
              	R1N = data_fromRAM;
              	addr_toRAM = IW[13:0];
              	stN = 3'd3;
            end
            if (data_fromRAM[31:28] == 4'b0101) begin //SRLi
              	wrEn = 1'b1;
              	addr_toRAM = IW[27:14];
              if(IW[13:0] < 32) begin 
                data_toRAM = (data_fromRAM >> IW[13:0]);
					 PCN = PC + 14'd1;
              	 stN = 3'd0;
              end
              else begin
                data_toRAM = (data_fromRAM << (IW[13:0]-32));
					 PCN = PC + 14'd1;
              	 stN = 3'd0;
              end
            end
            if (data_fromRAM[31:28] == 4'b0110) begin //LT
              	R1N = data_fromRAM;
              	addr_toRAM = IW[13:0];
              	stN = 3'd3;
            end
            if (IW[31:28] == 4'b0111) begin //LTi
				   wrEn = 1'b1;
               addr_toRAM = IW[27:14];
               if( data_fromRAM < IW[13:0]) begin
                 data_toRAM = 32'd1;
					  PCN = PC + 14'd1;
					  stN = 3'd0;
					end
               else begin
                 data_toRAM = 32'd0;
					  PCN = PC + 14'd1;
					  stN = 3'd0;
					end
				end
            if (IW[31:28] == 4'b1000) begin //CP
          		wrEn = 1'b1;
            	addr_toRAM = IW[27:14];
            	data_toRAM = data_fromRAM;
            	PCN = PC + 14'd1;
            	stN = 3'd0;  
            end
            if (IW[31:28] == 4'b1001) begin //CPi
          		wrEn = 1'b1;
            	addr_toRAM = IW[27:14];
              	data_toRAM = data_fromRAM;
            	PCN = PC + 14'd1;
            	stN = 3'd0;  
            end
            if (IW[31:28] == 4'b1010) begin //CPI
          		R1N = data_fromRAM;
              	addr_toRAM = data_fromRAM;
              	stN = 3'd3;
            end
            if (IW[31:28] == 4'b1011) begin //CPIi
          		R1N = data_fromRAM;
              	addr_toRAM = IW[13:0];
              	stN = 3'd3;
            end
            if (IW[31:28] == 4'b1100) begin // BZJ
              R1N = data_fromRAM;
              addr_toRAM = IW[13:0]; 
              stN = 3'd3;                        
            end 
            if (IW[31:28] == 4'b1101) begin // BZJi
              PCN = data_fromRAM + IW[13:0];
              stN = 3'd0;                        
            end          
          end
          3'd3: begin
            if (IW[31:28] == 4'b1100) begin // BZJ
              if (data_fromRAM == 0) 
                PCN = R1;
              else
                PCN = PC + 14'd1;
              stN = 3'd0;          
          	end
            if (IW[31:28] == 4'b1010) begin //CPI
          		wrEn = 1'b1;
            	addr_toRAM = IW[27:14];
              	data_toRAM = data_fromRAM;
            	PCN = PC + 14'd1;
            	stN = 3'd0;  
            end
            if (IW[31:28] == 4'b1011) begin //CPIi
          		wrEn = 1'b1;
            	addr_toRAM = R1;
              	data_toRAM = data_fromRAM;
            	PCN = PC + 14'd1;
            	stN = 3'd0;  
            end
            if (IW[31:28] == 4'b0000) begin // ADD
              	wrEn = 1'b1;
              	addr_toRAM = IW [27:14];
              	data_toRAM = R1 + data_fromRAM;
              	PCN = PC + 14'd1;
            	stN = 3'd0;  
            end
            if (IW[31:28] == 4'b1110) begin //MUL
              	wrEn = 1'b1;
              	addr_toRAM = IW [27:14];
              	data_toRAM = R1 * data_fromRAM;
              	PCN = PC + 14'd1;
            	stN = 3'd0;
            end
            if (data_fromRAM[31:28] == 4'b0110) begin //LT
              	wrEn = 1'b1;
              	addr_toRAM = IW [27:14];
              	if(R1 < data_fromRAM) begin
                  data_toRAM = 32'd1;
                  PCN = PC + 14'd1;
                  stN = 3'd0;
                end
              	else begin
                  data_toRAM = 32'd0;
                  PCN = PC + 14'd1;
                  stN = 3'd0;
                end
            end
            if (IW[31:28] == 4'b0010) begin // NAND
              	wrEn = 1'b1;
              	addr_toRAM = IW [27:14];
              	data_toRAM = ~(R1 & data_fromRAM);
              	PCN = PC + 14'd1;
              	stN = 3'd0;
            end
            if (data_fromRAM[31:28] == 4'b0100) begin //SRL
              	wrEn = 1'b1;
              	addr_toRAM = IW[27:14];
              if (data_fromRAM < 32) begin
                data_toRAM = (R1 >> data_fromRAM);
              	 PCN = PC + 14'd1;
              	 stN = 3'd0;
              end
              else begin
                data_toRAM = (R1 << data_fromRAM - 32);
					 PCN = PC + 14'd1;
              	 stN = 3'd0;
              end
            end
          end   
        endcase
        
      end
    end
  
  
endmodule


