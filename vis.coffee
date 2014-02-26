
# process blog_data

# graph_data = {
#   nodes: [] // contains {nodeName:"Mme. Hucheloup", group:8}
#   links:  [] // contains {source:1, target:0, value:1}
# }

# blog_data.tags
# blog_data.entries

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
