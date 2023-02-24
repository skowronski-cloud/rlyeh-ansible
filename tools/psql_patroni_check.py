#!python3
from pprint import pprint
import subprocess
import json
import tabulate
from datetime import datetime

debug = False

nodes = [
    {"idx": "1", "name": "psql01", "addr": "10.0.3.1"},
    {"idx": "2", "name": "psql02", "addr": "10.0.3.2"},
    {"idx": "3", "name": "psql03", "addr": "10.0.3.3"},
    {"idx": "4", "name": "psql04", "addr": "10.1.3.4"},
    {"idx": "5", "name": "psql05", "addr": "10.1.3.5"}]


def get_node_view(server):
    cmd_out = subprocess.Popen(
        "ssh %s 'timeout 3 patronictl -d etcd://127.0.0.1:2379 list patroni_psql0x -fjson||echo {}; echo {\\\"date\\\":\\\"'`date +%%s`'\\\"}' 2>/dev/null" % server, shell=True, stdout=subprocess.PIPE).stdout.readlines()

    data = {"members": [], "date": "???"}
    try:
        data["members"] = json.loads(cmd_out[0])
        data["date"] = json.loads(cmd_out[1])["date"]
    except Exception as e:
        pass
    return data


nodes_string = ""
raw_data = {}
for node in nodes:
    node_name = node.get("name")
    data_from_node = get_node_view(node.get("addr"))
    raw_data[node_name] = data_from_node
    nodes_string += node.get("idx")

if debug:
    pprint(raw_data)

data = {}
for node in nodes:
    node_name = node.get("name")
    node_data = {"role": {}, "state": {},
                 "tl": {}, "lag": {}, "own_date": "???"}

    dummy_dict = {}
    for dummy in nodes:
        dummy_dict[dummy.get("name")] = "???"
    node_data["role"] = dummy_dict.copy()
    node_data["state"] = dummy_dict.copy()
    node_data["tl"] = dummy_dict.copy()
    node_data["lag"] = dummy_dict.copy()

    for giver, raw_opinion in raw_data.items():
        opinion = raw_opinion.get("members")
        member_info = list(
            filter(lambda o: o["Member"] == node_name, opinion))
        if len(member_info) > 0:
            node_data["role"][giver] = member_info[0].get("Role", "???")
            node_data["state"][giver] = member_info[0].get("State", "???")
            node_data["tl"][giver] = member_info[0].get("TL", -1)
            node_data["lag"][giver] = member_info[0].get("Lag in MB", -1)
        node_data["own_date"] = raw_opinion.get("date")
    data[node_name] = node_data

table = []
headers = ["node", "role\nlocal", "state\nlocal", "roles\n"+nodes_string,
           "state\n"+nodes_string, "TL\nloc", "TL\navg", "lag\nloc", "lag\navg", "server\ntime"]
for node in nodes:
    node_name = node.get("name")
    table_row = [node_name]

    role = ""
    own_role = "???"
    for key, node_role in data.get(node_name).get("role").items():
        if key == node_name:
            own_role = node_role
        role += node_role[0:1]
    if role == "":
        role = "?"*len(nodes)

    state = ""
    own_state = "???"
    for key, node_state in data.get(node_name).get("state").items():
        if key == node_name:
            own_state = node_state
        state += node_state[0:1]
    if state == "":
        state = "?"*len(nodes)

    own_tl = -1
    sum_tl = 0
    cnt_tl = 0
    for key, node_tl in data.get(node_name).get("tl").items():
        if node_tl == "???":
            continue
        if key == node_name:
            own_tl = node_tl
        sum_tl += node_tl
        cnt_tl += 1

    own_lag = -100
    sum_lag = 0
    cnt_lag = 0
    for key, node_lag in data.get(node_name).get("lag").items():
        if node_lag == "???":
            continue
        if key == node_name:
            own_lag = node_lag
        if node_lag != "unknown":
            sum_lag += node_lag
            cnt_lag += 1

    table_row.append(own_role)
    table_row.append(own_state)

    table_row.append(role)
    table_row.append(state)

    if own_tl < 0:
        table_row.append("???")
    else:
        table_row.append(own_tl)

    if cnt_tl > 0:
        table_row.append(sum_tl/cnt_tl)
    else:
        table_row.append("???")

    if own_lag == -100:
        table_row.append("???")
    elif own_lag == -1:
        table_row.append("---")
    else:
        table_row.append(own_lag)

    if sum_lag < 0:
        table_row.append("---")
    elif cnt_lag > 0:
        table_row.append(sum_lag/cnt_lag)
    else:
        table_row.append("???")

    try:
        server_date = datetime.fromtimestamp(
            int(data.get(node_name).get("own_date", "???")))
        table_row.append(server_date.isoformat(
            " ")[11:])
    except Exception:
        table_row.append(data.get(node_name).get("own_date", "???"))

    table.append(table_row)

tabulate.MIN_PADDING = 0
print(tabulate.tabulate(table, headers=headers, tablefmt="fancy_grid"))
