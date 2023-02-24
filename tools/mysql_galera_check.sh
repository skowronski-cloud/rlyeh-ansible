#!/bin/bash
function check_node() {
    echo -ne "$1,"
    
    wsrep_cluster_size="???"
    wsrep_connected="???"
    wsrep_ready="???"
    wsrep_local_state_comment="???"

    globs="`ssh mysql01.rlyeh.ds 'mysql -e "SHOW GLOBAL STATUS"' 2>/dev/null  || echo '???'`"

    wsrep_cluster_size=`echo "$globs" | grep wsrep_cluster_size || echo -e "wsrep_cluster_size\n??"`
    wsrep_connected=`echo "$globs" | grep wsrep_connected || echo -e "wsrep_cluster_size\n???"`
    wsrep_ready=`echo "$globs" | grep wsrep_ready || echo -e "wsrep_cluster_size\n??>"`
    wsrep_local_state_comment=`echo "$globs" | grep wsrep_local_state_comment || echo -e "wsrep_cluster_size\n???????"`

    echo -ne "`echo $wsrep_cluster_size | awk '{print $2}'`,"
    echo -ne "`echo $wsrep_connected | awk '{print $2}'`,"
    echo -ne "`echo $wsrep_ready | awk '{print $2}'`,"
    echo -ne "`echo $wsrep_local_state_comment | awk '{print $2}'`"

    echo
}

function check_all() {
    echo "hostname,size,conn,ready,state"
    check_node mysql01.rlyeh.ds
    check_node mysql02.rlyeh.ds
    check_node mysql03.rlyeh.ds
    check_node mysql04.ulthar.ds
}

check_all | csvlook
