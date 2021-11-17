NET USE U: "\\192.168.1.218\backup\directorySync"
U:
cd "U:\SubdirectorySync"
Forfiles -p U:\SubdirectorySync -s -m *.* -d -17 -c "cmd /c del /q @path"