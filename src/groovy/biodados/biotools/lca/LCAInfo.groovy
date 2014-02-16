package biodados.biotools.lca

import biodados.biotools.taxonomy.TaxonEntry

import javax.swing.tree.DefaultMutableTreeNode

enum LCAType {
    POSITIVE, NEGATIVE, MIXED, POSITIVE_GENOME, NEGATIVE_GENOME
}


class LCAInfo {

    LCAType type
    TaxonEntry taxonEntry
    Integer positiveGenomeCount = 0
    Integer negativeGenomeCount = 0
    Integer unknownGenomeCount = 0


    Map<DefaultMutableTreeNode, TaxonEntry> positiveProofMap
    Map<DefaultMutableTreeNode, TaxonEntry> negativeProofMap

    Map<DefaultMutableTreeNode, Integer> positiveGenomeCountMap
    Map<DefaultMutableTreeNode, Integer> negativeGenomeCountMap



    public boolean equals(Object obj) {
        LCAInfo other = (LCAInfo) obj
        if (other.taxonEntry.taxId == this.taxonEntry.taxId) {
            return true
        }

        return false
    }

    public String toString() {
        return taxonEntry.toString() + " " + type
    }
}
