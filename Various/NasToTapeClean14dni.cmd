NET USE N: "\\192.168.10.29\backup"
N:
cd "N:\toNAS\"
cd "N:\toNAS\14dni"
Forfiles -p N:\toNAS\14dni -s -m *.* -d -14 -c "cmd /c del /q @path"