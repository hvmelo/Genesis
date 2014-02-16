import biodados.biotools.taxonomy.TaxonomyDAO
import biodados.biotools.taxonomy.TaxonomyTree
import biodados.biotools.lca.LCA
import biodados.biotools.lca.MultipleLCA

import javax.swing.tree.DefaultMutableTreeNode


// Place your Spring DSL code here
beans = {

    taxonomyDao(TaxonomyDAO) { bean ->
    }

    taxonomyTree(TaxonomyTree) { bean ->
        //bean.initMethod = 'mountTaxonomyTree'
        dao = ref("taxonomyDao")
    }

    lca(LCA) { bean ->
        tree = ref("taxonomyTree")
    }

    multipleLCA(MultipleLCA) { bean ->
        tree = ref("taxonomyTree")
        lcaFinder = ref("lca")

    }


}
