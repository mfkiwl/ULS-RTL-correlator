
�
Command: %s
53*	vivadotcl2P
<synth_design -top rx_samples_organizer -part xc7z010clg400-12default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7z0102default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7z0102default:defaultZ17-349h px� 
�
%s*synth2�
�Starting Synthesize : Time (s): cpu = 00:00:08 ; elapsed = 00:00:08 . Memory (MB): peak = 1250.859 ; gain = 73.996 ; free physical = 7434 ; free virtual = 18501
2default:defaulth px� 
�
synthesizing module '%s'638*oasys2(
rx_samples_organizer2default:default2\
F/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_samples_organizer.v2default:default2
222default:default8@Z8-638h px� 
�
synthesizing module '%s'638*oasys2*
rx_self_controled_BRAM2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
222default:default8@Z8-638h px� 
d
%s
*synth2L
8	Parameter MEMORY_LENGTH bound to: 510 - type: integer 
2default:defaulth p
x
� 
�
synthesizing module '%s'638*oasys2
rx_BRAM2default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
42default:default8@Z8-638h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
rx_BRAM2default:default2
12default:default2
12default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
42default:default8@Z8-256h px� 
�
Pwidth (%s) of port connection '%s' does not match port width (%s) of module '%s'689*oasys2
162default:default2
dob2default:default2
182default:default2
rx_BRAM2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-689h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2*
rx_self_controled_BRAM2default:default2
22default:default2
12default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
222default:default8@Z8-256h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2(
rx_samples_organizer2default:default2
32default:default2
12default:default2\
F/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_samples_organizer.v2default:default2
222default:default8@Z8-256h px� 
�
!design %s has unconnected port %s3331*oasys2*
rx_self_controled_BRAM2default:default2
erx_en2default:defaultZ8-3331h px� 
�
%s*synth2�
�Finished Synthesize : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1292.391 ; gain = 115.527 ; free physical = 7447 ; free virtual = 18513
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1292.391 ; gain = 115.527 ; free physical = 7447 ; free virtual = 18513
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Loading part: xc7z010clg400-1
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1300.395 ; gain = 123.531 ; free physical = 7447 ; free virtual = 18513
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
Loading part %s157*device2#
xc7z010clg400-12default:defaultZ21-403h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2$
rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
rram_cycle_counter_reg2default:default2\
F/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_samples_organizer.v2default:default2
612default:default8@Z8-6014h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1316.410 ; gain = 139.547 ; free physical = 7437 ; free virtual = 18504
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      9 Bit       Adders := 40    
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      5 Bit       Adders := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               18 Bit    Registers := 20    
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                9 Bit    Registers := 40    
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                5 Bit    Registers := 1     
2default:defaulth p
x
� 
8
%s
*synth2 
+---RAMs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               9K Bit         RAMs := 20    
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      9 Bit        Muxes := 40    
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit        Muxes := 21    
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Y
%s
*synth2A
-Start RTL Hierarchical Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Hierarchical RTL Component report 
2default:defaulth p
x
� 
I
%s
*synth21
Module rx_samples_organizer 
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      5 Bit       Adders := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                5 Bit    Registers := 1     
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit        Muxes := 1     
2default:defaulth p
x
� 
<
%s
*synth2$
Module rx_BRAM 
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               18 Bit    Registers := 1     
2default:defaulth p
x
� 
8
%s
*synth2 
+---RAMs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               9K Bit         RAMs := 1     
2default:defaulth p
x
� 
K
%s
*synth23
Module rx_self_controled_BRAM 
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      9 Bit       Adders := 2     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                9 Bit    Registers := 2     
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      9 Bit        Muxes := 2     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit        Muxes := 1     
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
[
%s
*synth2C
/Finished RTL Hierarchical Component Statistics
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2j
VPart Resources:
DSPs: 80 (col length:40)
BRAMs: 120 (col length: RAMB18 40 RAMB36 20)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_0/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_1/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_2/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_3/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_4/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_5/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_6/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_7/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_8/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2=
)rx_self_controled_BRAM_9/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_10/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_11/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_12/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_13/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_14/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_15/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_16/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_17/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_18/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2>
*rx_self_controled_BRAM_19/rrd_addr_RAM_reg2default:default2^
H/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_self_controled_BRAM.v2default:default2
442default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2*
rram_cycle_counter_reg2default:default2\
F/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/rx_samples_organizer.v2default:default2
612default:default8@Z8-6014h px� 
�
!design %s has unconnected port %s3331*oasys2(
rx_samples_organizer2default:default2
erx_en2default:defaultZ8-3331h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_0/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_1/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_2/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_3/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_4/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_5/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_6/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_7/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_8/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys29
%rx_self_controled_BRAM_9/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_10/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_11/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_12/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_13/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_14/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_15/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_16/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_17/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_18/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
�
RFound unconnected internal register '%s' and it is trimmed from '%s' to '%s' bits.3455*oasys2:
&rx_self_controled_BRAM_19/rRAM/dob_reg2default:default2
182default:default2
162default:default2]
G/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/src/simple_dual_one_clock.v2default:default2
292default:default8@Z8-3936h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:20 ; elapsed = 00:00:36 . Memory (MB): peak = 1461.793 ; gain = 284.930 ; free physical = 7257 ; free virtual = 18331
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP and Shift Register Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
e
%s*synth2M
9
Block RAM: Preliminary Mapping  Report (see note below)
2default:defaulth px� 
�
%s*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth px� 
�
%s*synth2�
�|Module Name | RTL Object | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
2default:defaulth px� 
�
%s*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

2default:defaulth px� 
�
%s*synth2�
�Note: The tale above is a preliminary report that shows the Block RAMs at the current stage of the synthesis flow. Some Block RAMs may be reimplemented as non Block RAM primitives later in the synthesis flow. Multiple instantiated Block RAMs are reported only once. 
2default:defaulth px� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP and Shift Register Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:00:20 ; elapsed = 00:00:36 . Memory (MB): peak = 1461.793 ; gain = 284.930 ; free physical = 7258 ; free virtual = 18332
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP and Shift Register Reporting
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
N
%s
*synth26
"
Block RAM: Final Mapping  Report
2default:defaulth p
x
� 
�
%s
*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|Module Name | RTL Object | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|rx_BRAM:    | ram_reg    | 512 x 18(READ_FIRST)   | W |   | 512 x 18(WRITE_FIRST)  |   | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

2default:defaulth p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP and Shift Register Reporting
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_0/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_1/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_2/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_3/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_4/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_5/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_6/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_7/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_8/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys29
%rx_self_controled_BRAM_9/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_10/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_11/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_12/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_13/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_14/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_15/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_16/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_17/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_18/rRAM/ram_reg2default:defaultZ8-4480h px� 
�
�The timing for the instance %s (implemented as a block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
3630*oasys2:
&rx_self_controled_BRAM_19/rRAM/ram_reg2default:defaultZ8-4480h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:00:21 ; elapsed = 00:00:36 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7255 ; free virtual = 18329
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7254 ; free virtual = 18328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
D
%s
*synth2,

Report Check Netlist: 
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
u
%s
*synth2]
I|      |Item              |Errors |Warnings |Status |Description       |
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
u
%s
*synth2]
I|1     |multi_driven_nets |      0|        0|Passed |Multi driven nets |
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7254 ; free virtual = 18328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7254 ; free virtual = 18328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7254 ; free virtual = 18328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7254 ; free virtual = 18328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7254 ; free virtual = 18328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
| |BlackBox name |Instances |
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|      |Cell     |Count |
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|1     |BUFG     |     1|
2default:defaulth px� 
F
%s*synth2.
|2     |LUT1     |     1|
2default:defaulth px� 
F
%s*synth2.
|3     |LUT2     |    22|
2default:defaulth px� 
F
%s*synth2.
|4     |LUT3     |    81|
2default:defaulth px� 
F
%s*synth2.
|5     |LUT4     |   221|
2default:defaulth px� 
F
%s*synth2.
|6     |LUT5     |   121|
2default:defaulth px� 
F
%s*synth2.
|7     |LUT6     |   141|
2default:defaulth px� 
F
%s*synth2.
|8     |RAMB18E1 |    20|
2default:defaulth px� 
F
%s*synth2.
|9     |FDRE     |   365|
2default:defaulth px� 
F
%s*synth2.
|10    |IBUF     |    19|
2default:defaulth px� 
F
%s*synth2.
|11    |OBUF     |   320|
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
E
%s
*synth2-

Report Instance Areas: 
2default:defaulth p
x
� 
t
%s
*synth2\
H+------+----------------------------+--------------------------+------+
2default:defaulth p
x
� 
t
%s
*synth2\
H|      |Instance                    |Module                    |Cells |
2default:defaulth p
x
� 
t
%s
*synth2\
H+------+----------------------------+--------------------------+------+
2default:defaulth p
x
� 
t
%s
*synth2\
H|1     |top                         |                          |  1312|
2default:defaulth p
x
� 
t
%s
*synth2\
H|2     |  rx_self_controled_BRAM_0  |rx_self_controled_BRAM    |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|3     |    rRAM                    |rx_BRAM_37                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|4     |  rx_self_controled_BRAM_1  |rx_self_controled_BRAM_0  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|5     |    rRAM                    |rx_BRAM_36                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|6     |  rx_self_controled_BRAM_10 |rx_self_controled_BRAM_1  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|7     |    rRAM                    |rx_BRAM_35                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|8     |  rx_self_controled_BRAM_11 |rx_self_controled_BRAM_2  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|9     |    rRAM                    |rx_BRAM_34                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|10    |  rx_self_controled_BRAM_12 |rx_self_controled_BRAM_3  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|11    |    rRAM                    |rx_BRAM_33                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|12    |  rx_self_controled_BRAM_13 |rx_self_controled_BRAM_4  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|13    |    rRAM                    |rx_BRAM_32                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|14    |  rx_self_controled_BRAM_14 |rx_self_controled_BRAM_5  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|15    |    rRAM                    |rx_BRAM_31                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|16    |  rx_self_controled_BRAM_15 |rx_self_controled_BRAM_6  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|17    |    rRAM                    |rx_BRAM_30                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|18    |  rx_self_controled_BRAM_16 |rx_self_controled_BRAM_7  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|19    |    rRAM                    |rx_BRAM_29                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|20    |  rx_self_controled_BRAM_17 |rx_self_controled_BRAM_8  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|21    |    rRAM                    |rx_BRAM_28                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|22    |  rx_self_controled_BRAM_18 |rx_self_controled_BRAM_9  |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|23    |    rRAM                    |rx_BRAM_27                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|24    |  rx_self_controled_BRAM_19 |rx_self_controled_BRAM_10 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|25    |    rRAM                    |rx_BRAM_26                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|26    |  rx_self_controled_BRAM_2  |rx_self_controled_BRAM_11 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|27    |    rRAM                    |rx_BRAM_25                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|28    |  rx_self_controled_BRAM_3  |rx_self_controled_BRAM_12 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|29    |    rRAM                    |rx_BRAM_24                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|30    |  rx_self_controled_BRAM_4  |rx_self_controled_BRAM_13 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|31    |    rRAM                    |rx_BRAM_23                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|32    |  rx_self_controled_BRAM_5  |rx_self_controled_BRAM_14 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|33    |    rRAM                    |rx_BRAM_22                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|34    |  rx_self_controled_BRAM_6  |rx_self_controled_BRAM_15 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|35    |    rRAM                    |rx_BRAM_21                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|36    |  rx_self_controled_BRAM_7  |rx_self_controled_BRAM_16 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|37    |    rRAM                    |rx_BRAM_20                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|38    |  rx_self_controled_BRAM_8  |rx_self_controled_BRAM_17 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|39    |    rRAM                    |rx_BRAM_19                |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H|40    |  rx_self_controled_BRAM_9  |rx_self_controled_BRAM_18 |    48|
2default:defaulth p
x
� 
t
%s
*synth2\
H|41    |    rRAM                    |rx_BRAM                   |     2|
2default:defaulth p
x
� 
t
%s
*synth2\
H+------+----------------------------+--------------------------+------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7254 ; free virtual = 18328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
s
%s
*synth2[
GSynthesis finished with 0 errors, 0 critical warnings and 46 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.801 ; gain = 292.938 ; free physical = 7256 ; free virtual = 18330
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:21 ; elapsed = 00:00:37 . Memory (MB): peak = 1469.809 ; gain = 292.938 ; free physical = 7256 ; free virtual = 18330
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
f
-Analyzing %s Unisim elements for replacement
17*netlist2
392default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
352default:default2
462default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
synth_design: 2default:default2
00:00:242default:default2
00:00:392default:default2
1583.8282default:default2
420.3402default:default2
72332default:default2
183072default:defaultZ17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
m/home/joao/Documents/ULS-RTL/Verilog/RTL/rx/vivado_2017_4/vivado_2017_4.runs/synth_1/rx_samples_organizer.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
~Executing : report_utilization -file rx_samples_organizer_utilization_synth.rpt -pb rx_samples_organizer_utilization_synth.pb
2default:defaulth px� 
�
�report_utilization: Time (s): cpu = 00:00:00.09 ; elapsed = 00:00:00.12 . Memory (MB): peak = 1607.840 ; gain = 0.000 ; free physical = 7232 ; free virtual = 18307
*commonh px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Mon Apr  2 20:08:54 20182default:defaultZ17-206h px� 


End Record