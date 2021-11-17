NET USE T: "\\192.168.1.218\backup\LjSync"
T:
cd "T:\EA2016"
Forfiles -p T:\EA2016 -s -m *.* -d -21 -c "cmd /c del /q @path"