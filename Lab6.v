module Lab6(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX6);
    input [0:0] KEY;  // Clock
    input [17:0] SW;  // E = SW[3], NL = SW[2], EL = SW[1], W = SW[0], Reset = SW[17]
    output [6:0] HEX3;  // ETL
    output [6:0] HEX2;  // NLTL
    output [6:0] HEX1;  // ELTL
    output [6:0] HEX0;  // WTL
    output [6:0] HEX6;  // Least Significant Digit of Timer
    
    
    
    TrafficController disp(
    .Reset(SW[17]), .Clock(KEY[0]), .E(SW[3]), .NL(SW[2]), .EL(SW[1]), .W(SW[0]), .ETL(HEX3), .NLTL(HEX2), .ELTL(HEX1), .WTL(HEX0), .timer(HEX6));
    
    
endmodule
    
    
    