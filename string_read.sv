// CSE141L   Win 2018   J Eldon
// read strings into a hex array
// machine code: 4-bit ALU opcode, followed by 5-bit address pointer
module string_read;
													  
string       line;
logic[7:0]   line_hex[16];
logic[7:0]   char[16];
logic[4:0]   arg;
logic        r,i;
string       charw;
typedef enum {add,lds,xor,brn,gst,lsb,msb,sft,set,eqr,eq1,nop= 'b1111} inst;
inst         mach;
initial begin  :iloop
  static integer field_id  = $fopen("lab17.txt","r");
  static integer mach_code = $fopen("mach_code.txt","w");
  if (!field_id) 
    $display("rats - can't open");
  else forever begin	 :floop
    while(!$feof(field_id)) 
      #10ns if($fgets(line, field_id)) begin
        $write(line);
		for(int j=0; j<7; j++) 
		  char[j] = line.getc(j);
		  // 47: slash; 32: space; 10: line feed
		if(char[0]!=47) begin  :non_comment_line
		  case({char[0],char[1],char[2]})
		    	24'h61_64_64:     mach = add;
		    	24'h6c_64_73:     mach = lds;
		    	24'h78_6F_72:     mach = xor;
			    24'h62_72_6E:     mach = brn;
			    24'h67_73_74:     mach = gst;
			    24'h6C_74_62:     mach = lsb;
			    24'h6D_73_62:     mach = msb;
			    24'h73_66_74:     mach = sft;
			    24'h73_65_74:     mach = set;
			    24'h65_71_72:     mach = eqr;
			    24'h65_71_31:     mach = eq1;
			    default:          mach = nop;
		  endcase
		  if((char[4]==36) && (char[5]==114)) begin   // detects $r 
		    arg = char[6]-48;
			r   = 1;
			i   = 0;
		  end
		  else if (char[4]<58) begin
		    arg = char[4]-48;
			r   = 0;
			i   = 1; 
	      end
		  else begin
		    arg = 0;
			r   = 0;
			i   = 0;
		  end
          if(r && (arg<10)) $fdisplay(mach_code,"%b_%b  // %s $r %d",mach[3:0],arg,mach,arg);
          else if(r) case(arg)
		    49: $fdisplay(mach_code,"%b_%b  // %s $r  a",mach[3:0],arg-6'd39,mach);
			50:	$fdisplay(mach_code,"%b_%b  // %s $r  b",mach[3:0],arg-6'd39,mach);
			default: $fdisplay(mach_code,"gup");
		  endcase
          else if(i)
            $fdisplay(mach_code,"%b_%b  // %s %d",mach[3:0],arg,mach,arg); 
          else
          	$fdisplay(mach_code,"%b_%b  // %s ",mach[3:0],arg,mach);
        end		  :non_comment_line
		else $display("char[0]==47");
	  end
	#10ns;
	$fclose(field_id);
	$fclose(mach_code);
//	$fclose(mach);
	$stop;
  end		:floop
end		    :iloop
endmodule