@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto b37dca8e053b489db69f3fad255baf3d -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot contador_pessoas_tb_behav xil_defaultlib.contador_pessoas_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
