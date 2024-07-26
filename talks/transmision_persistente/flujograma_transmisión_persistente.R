
## original ####
DiagrammeR::grViz("digraph {
                  # graph definitions
  graph [layout = dot, rankdir = TB]
  
  # node definitions
  node [shape = rectangle, 
  style = filled, 
  color = grey, 
  nodesep = .5,
  fixedsize = true, 
  width = 2.5] 
  
  # edge definition
  edge [color = grey, arrowhead = normal, arrowtail = dot]
  
  ##### epidemiological data
  
  epi [label = 'Vigilancia Epidemiológica',  fillcolor =  '#DB4437', color = 'white', fontcolor = 'white']
  data_historic [label = 'Transmision Persistente',  fillcolor =  'gray', color = 'white', fontcolor = 'white']
  data_datos_actuales [label = 'Transmisión Reciente',  fillcolor =  'gray', color = 'white', fontcolor = 'white']
  data_acumulados [label = 'Transmisión Reciente',  fillcolor =  'gray', color = 'white', fontcolor = 'white']
  data_trans_activa [label = 'Transmisión Activa',  fillcolor =  'gray', color = 'white', fontcolor = 'white']
  
  
  ##### Spatial Data
  
  areal [label = 'Areal Data',  fillcolor =  '#0F9D58', color = 'white', fontcolor = 'white']
  pp_data [label = 'Point Pattern Data',  fillcolor =  ' #0F9D58', color = 'white', fontcolor = 'white']
  
  
 
 # Análisis 
 hotspots [label = 'Hotspots Analysis',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 cadenas [label = 'Cadenas de Transmisión',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 cluster_ana [label = 'Cluster Analysis',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 lgcp [label = 'Spatial LGCP',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 
 heatmap [label = 'Mapas de Calor',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 
 
 # software
 
 geoda [label = 'Geoda',  fillcolor =  'DodgerBlue', color = 'white', fontcolor = 'white']
 cluster_s [label = 'ClusterSeer',  fillcolor =  'DodgerBlue', color = 'white', fontcolor = 'white']
 satscan [label = 'SatScan',  fillcolor =  'DodgerBlue', color = 'white', fontcolor = 'white']
 
 r_rstudio [label = 'R & RStudio',  fillcolor =  'DodgerBlue', color = 'white', fontcolor = 'white']

  denhotspot [label = 'denhotspots Package',  fillcolor =  'DodgerBlue', color = 'white', fontcolor = 'white'] 
 
 ##### define the relation
 
 epi -> {data_historic  data_datos_actuales}
 data_historic -> areal -> hotspots -> geoda
 data_datos_actuales -> {data_acumulados, data_trans_activa} -> pp_data -> {cadenas lgcp cluster_ana heatmap}
 cadenas -> cluster_s
 cluster_ana -> satscan
 
 {geoda cluster_s satscan lgcp} -> r_rstudio -> denhotspot
 
}", heigh = "700px",
                  width = "800px")








## modify ####
DiagrammeR::grViz("digraph {
                  # graph definitions
  graph [layout = dot, rankdir = TB]
  
  # node definitions
  node [shape = rectangle, 
  style = filled, 
  color = grey, 
  nodesep = .5,
  fixedsize = true, 
  width = 2.5] 
  
  # edge definition
  edge [color = grey, arrowhead = normal, arrowtail = dot]
  
  ##### epidemiological data
  
  epi [label = 'Vigilancia Epidemiológica',  fillcolor =  '#DB4437', color = 'white', fontcolor = 'white']
  den [label = 'DENGUE 2008-2023',  fillcolor =  '#DB4437', color = 'white', fontcolor = 'white']
  
  data_historic [label = 'Transmision Persistente',  fillcolor =  'gray', color = 'white', fontcolor = 'black']
  data_trans_activa [label = 'Transmisión Activa',  fillcolor =  'gray', color = 'white', fontcolor = 'black']
  
  
  ##### Spatial Data
  
  areal [label = 'Areal Data',  fillcolor =  '#0F9D58', color = 'white', fontcolor = 'white']
  pp_data [label = 'Point Pattern Data',  fillcolor =  ' #0F9D58', color = 'white', fontcolor = 'white']
  
  
 
 # Análisis 
 hotspots [label = 'Hotspots Analysis',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 cadenas [label = 'Cadenas de Transmisión',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 cluster_ana [label = 'Cluster Analysis',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 lgcp [label = 'Spatial LGCP',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 
 heatmap [label = 'Mapas de Calor',  fillcolor =  'orange', color = 'white', fontcolor = 'black']
 
 
 # software
 
 r_rstudio [label = 'R & RStudio',  fillcolor =  'DodgerBlue', color = 'white', fontcolor = 'white']
 denhotspot [label = 'denhotspots pkg',  fillcolor =  'DodgerBlue', color = 'white', fontcolor = 'white'] 
 
 ##### define the relation
 
 epi -> den -> {data_historic  data_trans_activa}
 data_historic -> areal -> hotspots -> r_rstudio
 data_trans_activa -> pp_data -> {cadenas lgcp 
 cluster_ana heatmap} -> r_rstudio

  r_rstudio -> denhotspot
 
}", heigh = "1000px",
    width = "1000px")





