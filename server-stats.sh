#!/bin/bash 



# Script Name: server-stats.sh
# Description: Analyzes core server/system performance metrics (CPU, RAM, Disk, Top processes) and displays OS system information.
# Usage:       ./server-stats.sh
# Note:        Run with 'sudo ./server-stats.sh' to correctly count failed SSH logins.




check_failed_logins() {
    echo -e "---- Failed Log Ins ----"
    if [ -f /var/log/auth.log ]; then
        grep -c "Failed password" /var/log/auth.log 2>/dev/null || echo "0 ( or requires sudo)"
    elif [ -f /var/log/secure ]; then 
        grep -c "Failed password" /var/log/secure 2>/dev/null || echo "0 ( or requires sudo)"
    else 
        echo "Log file not found"
    fi
}


echo -e "-----System Statistics:------\n"

cpu_used=$(top -bn1 | grep "Cpu(s)" | awk '{ print 100-$8 "%"}')
echo "Total CPU used : $cpu_used"

#memory stats
echo -e "-----Memory Statistics:------\n"

memory_stats=$(free -m| grep Mem | awk '{printf "Total: %s MB| Used: %s MB| Free : %s MB(%.2f%% Used) ", $2,$3,$4,$3/$2*100 }')
echo -e "Memory stats: \n$memory_stats"

#disk stats 
echo -e "-----Disk Statistics:------\n"

disk_stats=$(df -h --total | grep "total" | awk '{printf "Total: %s | Used : %s(%s) | Available : %s ",$2,$3,$5,$4}'
)

echo -e "Disk Statistcis: \n$disk_stats"


#top cpu processes 
echo -e "-----Processes Statistics:------\n"

cpu_processes=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6
)
echo -e "----Top 5 Processes by CPU usage:----\n$cpu_processes\n "



#processes by memory usage 
memory_processes=$(ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -n 6
)
echo -e "----Top 5 Processes by memory usage:----\n$memory_processes\n"


echo -e "-----System Information:------\n"
os=$(grep -i "pretty_name" /etc/os-release | awk -F '"' '{print $2}')
echo -e "OS version: $os\n"

uptime=$(uptime -p)
echo -e "Uptime: $uptime\n"

cpu_cores=$(nproc)
echo -e "CPU Cores: $cpu_cores\n"

load_avg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
echo -e "Load Average: $load_avg\n"

logged_users=$(who | wc -l)
echo -e "Total Logged In users: $logged_users\n"

check_failed_logins


