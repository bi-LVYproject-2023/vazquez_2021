library(ape)
library(dplyr)

## Path to mammalian tree, insert yours path to file
MPATH <- ''
## Path to afrotherian tree, insert yours path to file
APATH <- ''
## upload the Bininda-Emmonds tree
bininda <- treeio::read.nexus(
  file.path(
    MPATH
  )
)

## get the name of the Bininda's afrotherian node
bininda$mammalST_bestDates$node.label %>% grep('Afro')
bininda$mammalST_bestDates$tip.label

## upload the Puttick's tree
puttick <- phytools::read.newick(
  file.path(
    APATH
  )
)
puttick$root.edge <- 0

## get the number of shared and distinct afrotherian species between the tress
bininda_afros <- extract.clade(bininda$mammalST_bestDates, 6387)
bininda_afros_tips <- bininda_afros$tip.label
bininda_afros_tips[bininda_afros_tips %in% puttick$tip.label] %>% 
  length()
bininda_afros_tips[!(bininda_afros_tips %in% puttick$tip.label)] %>% 
  length()
puttick$tip.label[puttick$tip.label %in% bininda_afros_tips] %>% length()
puttick$tip.label[!(puttick$tip.label %in% bininda_afros_tips)] %>% length()

## get the sister clade to afrotherians in the Bininda-Emmonds tree
bininda_sister_to_afros <- RRphylo::getSis(bininda$mammalST_bestDates, 1877 + 4510, FALSE)

## add a dummy leaf to graft the Puttick's tree by
bininda_to_paste <- TreeTools::AddTip(
  bininda$mammalST_bestDates,
  where = bininda_sister_to_afros,
  label = "NA"
)

## prune the afrotherian clade from the Bininda-Emmmonds' tree
bininda_pruned <- ape::drop.tip(
  phy=bininda_to_paste,
  tip=bininda_afros$tip.label,
  collapse.singles=FALSE
)


## adjust the root length of the Puttick's tree's branches to those of the Bininda's tree 
puttick$root.edge  <- phytools::nodeheight(bininda_pruned, 1) - phytools::nodeheight(
  pasted,
  which(bininda_pruned$tip.label == "NA")
)

## and repeat
pasted <- phytools::paste.tree(
  bininda_pruned,
  puttick
)

## visualize the results
ggtree::ggtree(pasted, layout='circular') + 
  ggtree::geom_highlight(node=RRphylo::getSis(pasted, 4561, FALSE))
  
## and save them
treeio::write.tree(
  pasted,
  'bininda+puttick.newick'
)

test_upload <- phytools::read.newick(
  'bininda+puttick.newick'
) ## tooo slow


  pasted,
  which(pasted$tip.label == "Loxodonta_africana")
)
species_nums <- phytools::getDescendants(pasted, parent) %>% .[. < 4554]
species <- pasted$tip.label[species_nums]
while (length(setdiff(stable_spec, species))) {
  parent <- phytools::getParent(pasted, parent)
  species_nums <- phytools::getDescendants(pasted, parent) %>% .[. < 4554]
  species <- pasted$tip.label[species_nums]
}

