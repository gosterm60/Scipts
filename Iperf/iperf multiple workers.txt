On the server
iperf3 -s -V

On the client
10 parallel TCP streams: iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -P 10 -t 30
20 parallel TCP streams: iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -P 20 -t 30
30 parallel TCP streams: iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -P 30 -t 30

200 Mbps UDP test: iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -u -b 200M -t 30
500 Mbps UDP test: iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -u -b 500M -t 30
1 Gbps UDP test: iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -u -b 1G -t 30

Window size 128K: iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -w 128K -t 30 Window size 512K: 
iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -w 512K -t 30 Window size 1024K:
 iperf3 -c <Private/Public IP of EC2 instance or On-Prem host> -w 1024K -t 30

