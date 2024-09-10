module TrafficController(Reset, Clock, E, NL, EL, W, ETL, NLTL, ELTL, WTL, timer);
    input Reset;
    input Clock;
    input E;
    input NL;
    input EL;
    input W;
    
    output reg [6:0] ETL;
    output reg [6:0] NLTL;
    output reg [6:0] ELTL;
    output reg [6:0] WTL;
    
    output wire [6:0] timer;
    reg counter_reset;
    reg [3:0] state;  // Current state
    reg [3:0] nextState;   // Next state
    reg [1:0] timerC;
    reg [1:0] counter;
    reg [6:0] LUT[3:0];
	 
	 
	 
	 wire AS;
	 assign AS = ~E & ~W & ~NL & ~EL;
	 

  
    
    
    parameter Green = 7'b0010000;   // Lowercase g
    parameter Yellow = 7'b0010001;  // Lowercase y
    parameter Red = 7'b0101111;     // Lowercase r

    parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011,
    S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111,
    S8 = 4'b1000;
    
    
    always @* begin
        case (state)
            S0: 
                if ((E & W & ~NL & ~EL) | counter < 3) nextState = S0;
                else if ((NL | AS) & counter >= 3) nextState = S3;  
                else if (EL & ~NL & counter >= 3) nextState = S8;
                else nextState = S0;
            
            S1: 
                if ((E & NL & ~EL & ~W) | counter < 3) nextState = S1;
                else if (W & ~EL & counter >= 3) nextState = S4;
                else if ((EL | AS) & counter >= 3) nextState = S5;
                else  nextState = S1;
            
            S2: 
                if ((EL & ~NL & ~W & ~E)  | counter < 3) nextState = S2;
                else if ((NL & ~E & ~W) & counter >= 3) nextState = S6;
                else if ((E | W | AS) & counter >= 3) nextState = S7;
                else  nextState = S2;
            
            S3: 
                 nextState = S1;
            
            S4: 
                nextState = S0;
            
            S5: 
                 nextState = S2;
            
            S6: 
                 nextState = S1;
            
            S7: 
				if(E & NL & EL & ~W) nextState = S1;
				else
                 nextState = S0;
            
            S8: 
                nextState = S2;
        endcase
    end
    
    
    always @* begin
        case (state)
            S0: begin
                ETL = Green; WTL = Green;  // ETL, WTL = Green
                NLTL = Red; ELTL = Red;      // NLTL, ELTL = Red
                counter_reset = 0;
            end
            S1: begin
                ETL = Green;
                WTL = Red;
                NLTL = Green;
                ELTL = Red;
                counter_reset = 0;
            end
            S2: begin
                ETL = Red;
                NLTL = Red;
                ELTL = Green;
                WTL = Red;
                counter_reset = 0;
            end
            S3: begin
                ETL = Green;
                NLTL = Red;
                ELTL = Red;
                WTL = Yellow;
                counter_reset = 1;
            end
            S4: begin
                ETL = Green; NLTL = Yellow; ELTL = Red; WTL = Red;
                counter_reset = 1;
            end
            S5: begin
                ETL = Yellow; NLTL = Yellow; ELTL = Red; WTL = Red;
                counter_reset = 1;
            end
            S6: begin
                ETL = Red; NLTL = Red; ELTL = Yellow; WTL = Red;
                counter_reset = 1;
            end
            S7: begin
                ETL = Red; NLTL = Red; ELTL = Yellow; WTL = Red;
                counter_reset = 1;
            end
            S8: begin
                ETL = Yellow; NLTL = Red; ELTL = Red; WTL = Yellow;
                counter_reset = 1;
            end
        endcase
    end
	 
always@(posedge Clock) begin
	if (Reset) begin
	state <= S0;
	counter <= 0;
	end else begin
	state <= nextState;
	
	if(counter_reset)
		counter <= 0;
	else if (counter < 3)
		counter <= counter + 1;
	end
	timerC = 3 - counter;
end
    

// Load the look-up table
	initial begin
	LUT[2'b00] = 7'b1000000;
	LUT[2'b01] = 7'b1111001;
	LUT[2'b10] = 7'b0100100;
	LUT[2'b11] = 7'b0110000;
	end
    assign timer = LUT[timerC];
    

    
    
    
endmodule
    
