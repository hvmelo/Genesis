import biodados.biotools.taxonomy.TaxonomyDAO
import biodados.biotools.taxonomy.TaxonomyTree


// Place your Spring DSL code here
beans = {

    taxonomyDao(TaxonomyDAO) { bean ->
    }

    taxonomyTree(TaxonomyTree) { bean ->
        //bean.initMethod = 'mountTaxonomyTree'
        dao = ref("taxonomyDao")
    }


}
