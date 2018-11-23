
*SET PATHS
global path "U:/dissertation/stata"
global rawdata "$path/ipehd_complete/Data"
global data "$path/stata data"
global output "$path/output"
global logs "$path/logs"
global dofiles "$path/do-files"

!mkdir "$path/ADO"
!mkdir "$path/ADO/PLUS"
!mkdir "$path/ADO/PERSONAL"

sysdir set PLUS "$path/ADO/PLUS"
sysdir set PERSONAL "$path/ADO/PERSONAL"

ssc install estout
