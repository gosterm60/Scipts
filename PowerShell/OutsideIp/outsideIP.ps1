 
#Variables 
    # I am defining website url in a variable 
    $url = "http://checkip.dyndns.com"  
    # Creating a new .Net Object names a System.Net.Webclient 
    $webclient = New-Object System.Net.WebClient 
    # In this new webdownlader object we are telling $webclient to download the 
    # url $url  
    $Ip = $webclient.DownloadString($url) 
    # Just a simple text manuplation to get the ipadress form downloaded URL 
    # If you want to know what it contain try to see the variable $Ip 
    $Ip2 = $Ip.ToString() 
    $ip3 = $Ip2.Split(" ") 
    $ip4 = $ip3[5] 
    $ip5 = $ip4.replace("</body>","") 
    $FinalIPAddress = $ip5.replace("</html>","") 
 
#Write Ip Addres to the console 
    $FinalIPAddress 
 
### end of the script..... 