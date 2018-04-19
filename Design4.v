/*
Jason Sheetz, David Carlson
Group 2
Design 4
4/19/18

This project outputs a serial sequene of SIG according to M0 and M1, the SYNC line is high on the first bit of every sequence.
the SEQ line is high when the sequence 0110 is output.
*/

module Design4(SIG, SYNC, SEQ, CLK, M0, M1, G0);
output reg SYNC;
output reg SIG;
output reg SEQ;
input CLK, M0, M1, G0;
reg [3:0] SIX = 0110;
reg [3:0] NINE = 1001;
reg [3:0] TEN = 1010;
reg [3:0] FIFTEEN = 1111;
integer counter = 0;
integer flag = 0;
reg M0_capture;
reg M1_capture;

always @(posedge CLK)begin

if(counter == 3) M0_capture <= M0; M1_capture <= M1;

//if the G0 is asserted begin the appropriate sequence
if(G0 == 1'b1)begin
flag = 1;

end else if(G0 == 1'b0) SIG = 1'b0;

	if(flag == 1)begin

	
	
	if(M0_capture == 0 && M1_capture == 0)begin
			
				case (counter)
					0:	SIG <= NINE[counter];
					1:	SIG <= NINE[counter];
					2:	SIG <= NINE[counter];
					3:	SIG <= NINE[counter];
					default: SIG = 0;
				endcase
						
					if(counter == 0)begin
						SYNC = 1'b1;
					end else if(counter > 0 )begin
						SYNC = 1'b0;
					end
					
					//incriment the counter
					counter <= counter + 1;

					//reset the counter if it needs to be
					if(counter == 3)begin
						counter <= 0;
						flag = 0;
						
					end
		
		//end m0 == m1 == 0 if
		end else if(M0_capture == 0 && M1_capture == 1)begin
			
				case (counter)
					0:	SIG <= 1'b0;
					1:	SIG <= 1'b1;
					2:	SIG <= 1'b1;
					3:	SIG <= 1'b0;
					default: SIG = 0;
				endcase
						
					if(counter == 0)begin
						SYNC = 1'b1;
					end else if(counter > 0 )begin
						SYNC = 1'b0;
					end
					
					//incriment the counter
					counter <= counter + 1;

					//reset the counter if it needs to be
					if(counter == 3)begin
						counter <= 0;
						flag = 0;
						
					end
		
		//end m0 == m1 == 0 if
		end else if(M0_capture == 1 && M1_capture == 0)begin
			
				case (counter)
					0:	SIG <= 1'b1;
					1:	SIG <= 1'b0;
					2:	SIG <= 1'b1;
					3:	SIG <= 1'b0;
					default: SIG = 0;
				endcase
						
						if(counter == 0)begin
						SYNC = 1'b1;
					end else if(counter > 0 )begin
						SYNC = 1'b0;
					end
					//incriment the counter
					counter <= counter + 1;

					//reset the counter if it needs to be
					if(counter == 3)begin
						counter <= 0;
						flag = 0;
					end
		
		//end m0 == m1 == 0 if
		end else if(M0_capture == 1 && M1_capture == 1)begin
			
				case (counter)
					0:	SIG <= 1'b1;
					1:	SIG <= 1'b1;
					2:	SIG <= 1'b1;
					3:	SIG <= 1'b1;
					default: SIG = 0;
				endcase
						
						if(counter == 0)begin
						SYNC = 1'b1;
					end else if(counter > 0 )begin
						SYNC = 1'b0;
					end
					
					//incriment the counter
					counter <= counter + 1;

					//reset the counter if it needs to be
					if(counter == 3)begin
						counter <= 0;
						flag = 0;
					end
		
		//end m0 == m1 == 0 if
		end

	//end if g0 enabled
	end

//end always
end


// Define some temparary values/varilables to hold input -- to be evaluated
integer seq_counter = 0;
reg [3:0] seq_match = 0110;
reg[3:0] seq_test = 0000;
integer seq_flag = 0;
integer seq_detect = 0;
always @(posedge CLK)begin // Every clock edge, check for sync

	SEQ = 1'b0;
	
	if(SYNC == 1'b1)begin
		seq_flag = 1; // A value/stream as started, look for match.
	end
	
		if(seq_flag == 1)begin
	
			case(seq_counter)
				0: seq_test[0] <= SIG;
				1: seq_test[1] <= SIG;
				2: seq_test[2] <= SIG;
				3: seq_test[3] <= SIG;
			endcase
						// We have saved 4bits. Lets compare stuff

			seq_counter <= seq_counter + 1;
		
			if(seq_counter == 3)begin
	
				seq_flag = 0;
				seq_counter <= 0;
						// Check for matches to 0110
				if(seq_test[0] == 0)begin
					if(seq_test[1] == 1)begin
						if(seq_test[2] == 1)begin
							if(seq_test[3] == 0)begin
								SEQ = 1'b1;
								// We have a match, output SEQ
							end else if(seq_test[3] != 0)SEQ = 1'b0; // No match, keep SEQ 0;
						end
					end
				end	
			end
		end
	end

endmodule
