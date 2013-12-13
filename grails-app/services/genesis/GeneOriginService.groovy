package genesis

import biodados.biotools.taxonomy.TaxonEntry
import biodados.biotools.taxonomy.TaxonomyTree
import biodados.biotools.taxonomy.TaxonomyDAO

import grails.transaction.Transactional
import org.hibernate.type.StandardBasicTypes

import javax.swing.tree.DefaultMutableTreeNode

@Transactional
class GeneOriginService {

    def sessionFactory

    TaxonomyTree taxonomyTree


    def lcasFromKO(String ko) {

        def session = sessionFactory.getCurrentSession()

        def sqlStr = """
            SELECT *
            FROM multi_ko_lca
            WHERE ko = '${ko}'""".toString()

        Object[] results = session.createSQLQuery(sqlStr).list()

        return results

    }

    def geneOriginForSpecies(Integer taxid) {

        if (!taxonomyTree) {
            TaxonomyDAO dao = new TaxonomyDAO()
            dao.sessionFactory = sessionFactory
            dao.init()

            taxonomyTree = new TaxonomyTree()
            taxonomyTree.dao = dao
            taxonomyTree.mountTaxonomyTree()

        }

        DefaultMutableTreeNode node =  taxonomyTree.findNodeByTaxId(taxid)
        DefaultMutableTreeNode rootNode = taxonomyTree.rootNode

        if (node) {

            while (node != rootNode) {
                TaxonEntry taxonInfo = node.userObject
                println taxonInfo.name
                node = node.parent
            }
        }

    }
}
