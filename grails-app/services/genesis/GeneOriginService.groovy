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

    def taxonomyTree
    def taxonomyDao


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

        def session = sessionFactory.getCurrentSession()

        def sqlStr = """
            select distinct m.ko, m.ko_desc, m.lca_name, m.lca_txid from multi_lca m inner join
            ueko u on m.ko = u.ko where u.taxid = ${taxid} and m.lca_order = 1""".toString()

        Map<Integer, String> lineage = [:]

        DefaultMutableTreeNode node =  taxonomyTree.findNodeByTaxId(taxid)
        String speciesName = node.userObject.name
        DefaultMutableTreeNode rootNode = taxonomyTree.rootNode

        Set<Integer> lineageSet = [] as Set

        if (node) {
            while (node != rootNode) {
                TaxonEntry taxonInfo = node.userObject
                lineage[taxonInfo.level] = taxonInfo.name
                lineageSet << taxonInfo.taxId
                node = node.parent
            }
        }

        List<Object[]> koLcas = session.createSQLQuery(sqlStr).list()


        //Pick up lateral transfers
        List<Object[]> lateralTransfers = koLcas.findAll { Object[] row ->
            !lineageSet.contains(row[3])
        }

        koLcas = koLcas.minus(lateralTransfers)

        [speciesName: speciesName, koLcas: koLcas, lateralTransfers: lateralTransfers]


    }
}
