
# process blog_data

graph_data = {
  nodes: [] # contains {nodeName:"Mme. Hucheloup", group:8}
  links:  [] # contains {source:1, target:0, value:1}
}

# blog_data.tags
# blog_data.entries

for post in blog_data.entries
  node =
    nodeName: post.title
    group: post.tags.length
    post: post
    node_id: graph_data.nodes.length

  graph_data.nodes.push node

for node_id_a in [0...graph_data.nodes.length]
  node_a = graph_data.nodes[node_id_a]
  for node_id_b in [node_id_a+1...graph_data.nodes.length]
    node_b = graph_data.nodes[node_id_b]
    for tag in blog_data.tags
      if (tag in node_a.post.tags) and (tag in node_b.post.tags)
        graph_data.links.push
          source: node_id_a
          target: node_id_b
          value: 1

# render graph_data
w = document.body.clientWidth
h = document.body.clientHeight
colors = pv.Colors.category19()

vis = new pv.Panel()
  .width(w)
  .height(h)
  .fillStyle("white")
  .event("mousedown", pv.Behavior.pan())
  .event("mousewheel", pv.Behavior.zoom())

force = vis.add(pv.Layout.Force)
  .nodes(graph_data.nodes)
  .links(graph_data.links)

force.link.add pv.Line

force.node.add(pv.Dot).size((d) -> (d.linkDegree + 4) * Math.pow(@scale, -1.5))
  .fillStyle((d) -> (if d.fix then "brown" else colors(d.group)))
  .strokeStyle(-> @fillStyle().darker())
  .lineWidth(1).title((d) -> d.nodeName)
  .event("mousedown", pv.Behavior.drag())
  .event("drag", force)

vis.render()
