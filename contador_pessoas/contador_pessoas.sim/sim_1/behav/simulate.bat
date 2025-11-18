@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xsim contador_pessoas_tb_behav -key {Behavioral:sim_1:Functional:contador_pessoas_tb} -tclbatch contador_pessoas_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
