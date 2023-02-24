#!python3
from pprint import pprint
import subprocess
import json
import sys
import tabulate
from datetime import datetime

debug = False

nodes = [
    {"name": "mysql01", "addr": "10.0.2.1"},
    {"name": "mysql02", "addr": "10.0.2.2"},
    {"name": "mysql03", "addr": "10.0.2.3"},
    {"name": "mysql04", "addr": "10.1.2.4"}]


def get_node_view(server):
    cmd_out = subprocess.Popen(
        "ssh %s 'timeout 10 mysql -sre \"SHOW GLOBAL STATUS\"; echo -ne \"date\t\"; date +%%s;' 2>/dev/null" % server, shell=True, stdout=subprocess.PIPE).stdout.readlines()
    data = {}
    for line in cmd_out:
        try:
            name, value = line.decode("utf-8").strip().split("\t")
            data[name] = value
        except Exception as e:
            pass
    return data


raw_data = {}
for node in nodes:
    node_name = node.get("name")
    data_from_node = get_node_view(node.get("addr"))
    raw_data[node_name] = data_from_node

if debug:
    pprint(raw_data)

table = []
headers = ["node", "i\nd",
           "local\nstate", "cluster\nstate",
           "ready", "conn",
           "si\nze", "conf\nid",
           "local\nstate_uuid", "cluster\nstate_uuid",
           "last\ncommit",
           "recv\nqueue", "send\nqueue",
           "recv\ncnt", "repl\ncnt",
           "thrd\nconn",
           "server\ntime"]

for node in nodes:
    node_name = node.get("name")
    node_data = raw_data.get(node_name, {})
    table_row = [node_name]

    table_row.append(node_data.get("wsrep_local_index", "???"))

    table_row.append(node_data.get("wsrep_local_state_comment", "???"))
    table_row.append(node_data.get("wsrep_cluster_status", "???"))

    table_row.append(node_data.get("wsrep_ready", "???"))
    table_row.append(node_data.get("wsrep_connected", "???"))

    table_row.append(node_data.get("wsrep_cluster_size", "???"))
    table_row.append(node_data.get("wsrep_cluster_conf_id", "???"))

    wsrep_local_state_uuid = node_data.get(
        "wsrep_local_state_uuid",   "????????-????-????-????-????????????")
    wsrep_cluster_state_uuid = node_data.get(
        "wsrep_cluster_state_uuid", "????????-????-????-????-????????????")
    table_row.append(wsrep_local_state_uuid.split("-")[-1])
    table_row.append(wsrep_cluster_state_uuid.split("-")[-1])

    table_row.append(node_data.get("wsrep_last_committed", "???"))

    try:
        wsrep_local_recv_queue_avg = float(
            node_data.get("wsrep_local_recv_queue_avg", "???"))
    except Exception as e:
        wsrep_local_recv_queue_avg = node_data.get(
            "wsrep_local_recv_queue_avg", "???")
        print(e)
    table_row.append(wsrep_local_recv_queue_avg)

    try:
        wsrep_local_send_queue_avg = float(
            node_data.get("wsrep_local_send_queue_avg", "???"))
    except Exception as e:
        wsrep_local_send_queue_avg = node_data.get(
            "wsrep_local_send_queue_avg", "???")
        print(e)
    table_row.append(wsrep_local_send_queue_avg)

    table_row.append(node_data.get("wsrep_received", "???"))
    table_row.append(node_data.get("wsrep_replicated", "???"))

    table_row.append(node_data.get("Threads_connected", "???"))

    try:
        server_date = datetime.fromtimestamp(int(node_data.get("date", "???")))
        table_row.append(server_date.isoformat(
            " ")[11:])
    except Exception:
        table_row.append(node_data.get("date", "???"))

    table.append(table_row)

tabulate.MIN_PADDING = 0
print(tabulate.tabulate(table,
                        headers=headers, tablefmt="fancy_grid",  # fancy_grid
                        floatfmt=".5f"
                        ))
