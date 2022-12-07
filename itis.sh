#!/bin/bash
GREEN='\033[1;32m'
WHITE='\033[0m'
SQLITE="sqlite3 database/ITIS.sqlite"

KINGDOM() {
  LIST=`$SQLITE "select kingdom_id, kingdom_name from kingdoms"`
  SPECIES_COUNT="$SQLITE 'SELECT COUNT(*) from taxonomic_units where kingdom_id={1}'| sed -e 's/:/ /g'"
  SPECIES_TOTAL_COUNT="$SQLITE 'SELECT COUNT(*) from taxonomic_units'"

  SPECIES_NB="printf \"Number of species ${GREEN}\"; $SPECIES_COUNT ;printf \"${WHITE}\";"
  SPECIES_PROPORTION="printf \"Species quantity proportion: ${GREEN}\"; $SPECIES_TOTAL_COUNT ; printf \"${WHITE}\""

  PREVIEW_KINGDOM="window {2}; $SPECIES_NB ; $SPECIES_PROPORTION"
  echo -e $LIST | sed -e "s/ /\n/g" | sed -e "s/|/ /g" | fzf --preview "$PREVIEW_KINGDOM" --preview-window=right,47% 
}

SPECIE() {
  LIST=`$SQLITE "select complete_name from taxonomic_units where kingdom_id=$1"`
  PREV="window "
  echo -e $LIST | sed -e "s/ /\n/g" | fzf --preview "$PREV {}" --preview-window=right,47%;
}

SELECTED_KINGDOM=`KINGDOM`
SPECIE $SELECTED_KINGDOM

# sqlite3 database/ITIS.sqlite\
#  -csv\
#  -separator " "\
#  "select kingdom_id, kingdom_name from kingdoms" | fzf --preview "pandoc {2}.md --from=html --to=markdown | bat --color=always" --preview-window=right,90%
# --bind "enter:reload(./kingdomUnit.sh {1})+change-preview(./kingdomUnitPreview.sh {})"
# TABLES
# HierarchyToRank    geographic_div     publications       taxonomic_units
# change_comments    hierarchy          reference_links    tu_comments_links
# change_operations  jurisdiction       reviews            vern_ref_links
# change_tracks      kingdoms           strippedauthor     vernaculars
# chg_operation_lkp  longnames          synonym_links
# comments           nodc_ids           taxon_authors_lkp
# experts            other_sources      taxon_unit_types


