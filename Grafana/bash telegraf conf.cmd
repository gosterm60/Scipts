
[[inputs.exec]]
interval = "60s"
  ##Commands array/appcom/telegraf/collect_iostat.sh",
  commands = ["bash /usr/share/telegraf/snmpwalkWalixLJ.sh"]
  timeout='5s'
  ##Suffix for measurements
  name_suffix = "geniljwallix01Sessions"
  data_format = "value"

