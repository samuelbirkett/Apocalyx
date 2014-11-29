@echo off

Echo Building...
lua lng=en make_hh.lua
Echo .
pause

Echo Preparing...
move wb_*.hhp ..
move wb_*.hhc ..
cd ..
move download download.old
Echo .
pause

Echo Compiling...
hhc wb_en.hhp
Echo .
pause     

Echo Finishing...     
move wb_*.hhp wb_hh
move wb_*.hhc wb_hh
move download.old download
move /y iup_en.chm download/iup.chm
cd wb_hh
Echo .

Echo Done.
