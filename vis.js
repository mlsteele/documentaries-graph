
// process blog_data

// graph_data = {
//   nodes: [] // contains {nodeName:"Mme. Hucheloup", group:8}
//   links:  [] // contains {source:1, target:0, value:1}
// }

// blog_data.tags
// blog_data.entries

// render graph_data

var w = document.body.clientWidth;
var h = document.body.clientHeight;
var colors = pv.Colors.category19();

var vis = new pv.Panel()
  .width(w)
  .height(h)
  .fillStyle("white")
  .event("mousedown", pv.Behavior.pan())
  .event("mousewheel", pv.Behavior.zoom());

var force = vis.add(pv.Layout.Force)
  .nodes(graph_data.nodes)
  .links(graph_data.links);

force.link.add(pv.Line);

force.node.add(pv.Dot)
  .size(function(d) {return (d.linkDegree + 4) * Math.pow(this.scale, -1.5)})
  .fillStyle(function(d) {return d.fix ? "brown" : colors(d.group)})
  .strokeStyle(function() {return this.fillStyle().darker()})
  .lineWidth(1)
  .title(function(d) {return d.nodeName})
  .event("mousedown", pv.Behavior.drag())
  .event("drag", force);

vis.render();
