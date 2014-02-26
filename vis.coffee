
# process blog_data

graph_data = {
  nodes: [] # contains {nodeName:"Mme. Hucheloup", group:8}
  links:  [] # contains {source:1, target:0, value:1}
}

# blog_data.tags
# blog_data.entries

posts_with_tag = (tag) ->
  post for post in blog_data.entries when tag in post.tags

intersection = (list_a, list_b) ->
  a for a in list_a when a in list_b

for tag in blog_data.tags
  node =
    nodeName: tag
    tag: tag
    group: posts_with_tag(tag).length
    node_id: graph_data.nodes.length

  graph_data.nodes.push node

for node_id_a in [0...graph_data.nodes.length]
  node_a = graph_data.nodes[node_id_a]
  for node_id_b in [node_id_a+1...graph_data.nodes.length]
    node_b = graph_data.nodes[node_id_b]

    posts_a = posts_with_tag(node_a.tag)
    posts_b = posts_with_tag(node_b.tag)
    postnames_a = (post.title for post in posts_a)
    postnames_b = (post.title for post in posts_b)
    common_postnames = intersection postnames_a, postnames_b

    if common_postnames.length > 0
      graph_data.links.push
        source: node_id_a
        target: node_id_b
        value: common_postnames.length * 10


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
  .springLength 330

force.link.add pv.Line
force.label.add(pv.Label)
  .visible(-> true)
  .font("20px sans-serif")
  .textBaseline("bottom")
  .textAlign("right")

force.node.add(pv.Dot)
  .size((d) -> (d.group * 40 + 40) * Math.pow(@scale, -1.5))
  .fillStyle((d) -> (if d.fix then "brown" else colors(d.group)))
  .strokeStyle(-> @fillStyle().darker())
  .lineWidth(2)
  .title((d) -> d.nodeName)
  .event("mousedown", pv.Behavior.drag())
  .event("drag", force)

vis.render()
