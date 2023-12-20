#!/usr/bin/env python3

def get_data(fname = "data.txt"):
    with open(f"year_2023/day_20/{fname}") as f:
        return [l.strip() for l in f]

class Node:
    def __init__(self, line: str):
        self.broadcast = line.startswith("broadcaster")
        self.ff_n_con = not self.broadcast and line[0] == "%"
        line = line.split()
        self.name = line[0][0 if self.broadcast else 1:]
        self.outputs = [o.rstrip(",") for o in line[2:]]

        self.ff_state = False
        self.inputs = {}

    def __repr__(self):
        o = self.name
        if not self.broadcast:
            o += " ff" if self.ff_n_con else " con"
        o += ": "
        o += " ".join(self.outputs)
        o += " ("
        o += " ".join(self.inputs)
        o += ")"
        return o

    def connect(self, inp):
        self.inputs[inp] = False

    def input(self, high_n_low, src) -> tuple[str,bool,str]:#dest,high/low,src
        if self.broadcast:
            out = high_n_low
        elif self.ff_n_con:
            if high_n_low: return []
            self.ff_state = not self.ff_state
            out = self.ff_state
        else:
            self.inputs[src] = high_n_low
            out = not all(self.inputs.values())
            
        return [(o,out,self.name) for o in self.outputs]
    


def setup(data) -> dict[str,Node]:
    nodes = {}
    for line in data:
        nnode = Node(line)
        nodes[nnode.name] = nnode

    for _, node in nodes.items():
        for o in node.outputs:
            if o in nodes:
                nodes[o].connect(node.name)
    return nodes

def main_a(data):
    nodes = setup(data)
    low_count = 0
    high_count = 0
    count = 1000

    for _ in range(count):
        low_count += 1
        signals = nodes["broadcaster"].input(False,"")
        while signals:
            new_signals = []
            for dest,sig,src in signals:
                if sig: high_count+=1
                else: low_count+=1

                #print(src, "high" if sig else "low", dest)

                if dest in nodes:
                    new_signals += nodes[dest].input(sig,src)
            signals = new_signals        

    print(low_count, high_count)

    return high_count * low_count

def visualise(nodes):
    import graphviz
    all_nodes = set(["broadcaster"])
    for node in nodes.values(): 
        for output in node.outputs:
            all_nodes.add(output)

    dot = graphviz.Digraph()
    for n in all_nodes:
        if n=="broadcaster" or n not in nodes:
            c = "orange"
        elif nodes[n].ff_n_con:
            c = "green"
        else:
            c = "red"
        dot.node(n, style="filled",color=c)

    for n in nodes.values():
        for o in n.outputs:
            dot.edge(n.name, o)

    dot.render("output.gv")

from math import lcm

def main_b(data):
    nodes = setup(data)
    #visualise(data)

    #values decided by inspecting graphviz output
    targets = {"th":[0,0], "gh":[0,0], "sv":[0,0], "ch":[0,0]}

    count = 0
    while True:
        count += 1
        signals = nodes["broadcaster"].input(False,"")
        while signals:
            new_signals = []
            for dest,sig,src in signals:
                for t in targets:
                    if sig and t == src:
                        targets[t][1] = targets[t][0] 
                        targets[t][0] = count
   

                if dest in nodes:
                    new_signals += nodes[dest].input(sig,src)
            signals = new_signals        


        l = lcm(*[vnew - vold for vnew, vold in targets.values()])
        if l != 0:
            return l

if __name__ == "__main__":
    data = get_data()
    print(main_a(data))
    data = get_data()
    print(main_b(data))