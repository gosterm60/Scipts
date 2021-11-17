NET USE N: "\\192.168.10.29\backup"
N:
cd "N:\toNAS"
cd "N:\toNAS\7dni"
Forfiles -p N:\toNAS\7dni -s -m *.* -d -7 -c "cmd /c del /q @path"