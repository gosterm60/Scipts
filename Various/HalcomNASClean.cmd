NET USE R: "\\192.168.1.218\backup\directoryname"
R:
cd "R:\directoryname"
Forfiles -p R:\directoryname -s -m *.* -d -21 -c "cmd /c del /q @path"