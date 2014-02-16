package genesis

import biodados.biotools.lca.LCAInfo
import biodados.biotools.lca.MultipleLCA
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
    def multipleLCA
    def grailsApplication

    List<Integer> completeGenomeList


    def lcasFromKO(String ko) {

        def session = sessionFactory.getCurrentSession()

        def sqlStr = """
            SELECT *
            FROM multi_lca
            WHERE ko = '${ko}'""".toString()

        Object[] results = session.createSQLQuery(sqlStr).list()

        return results

    }

    def geneOriginForSpecies(Integer taxid) {

        def session = sessionFactory.getCurrentSession()

        def sqlStr = """
            select distinct m.ko, m.ko_desc, m.lca_name, m.lca_txid, m.lca_level from multi_lca m inner join
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


        Map levelKoCount = [:]

        for (int i = 1; i <= lineage.keySet().size(); i++) {
            levelKoCount[lineage[i]] = 0
        }

        koLcas.each {row ->
            Integer level = row[4]
            String name = lineage[level]
            levelKoCount[name] = levelKoCount[name] + 1
        }

        [levelKoCount: levelKoCount, speciesName: speciesName, koLcas: koLcas, lateralTransfers: lateralTransfers]


    }

    def multipleLCAsFromKO(String ko) {

        def session = sessionFactory.getCurrentSession()

        def sqlStr = """
            SELECT distinct taxid
            FROM ueko
            WHERE ko = '${ko}'""".toString()

        List<Object[]> results = session.createSQLQuery(sqlStr).list()

        List<Integer> positiveTaxids = results.collect{ Object[] row ->
            (Integer) row[0]
        }

        findMultipleLCAs(positiveTaxids)

    }

    def getPositiveAndNegativeListsFromKO(String ko) {

        def session = sessionFactory.getCurrentSession()

        def sqlStr = """
            SELECT distinct taxid
            FROM ueko
            WHERE ko = '${ko}'""".toString()

        List<Object[]> results = session.createSQLQuery(sqlStr).list()

        List<Integer> positiveTaxIds = results.collect{ Object[] row ->
            (Integer) row[0]
        }

        if (!completeGenomeList)    {
            InputStream completeGenomeStream = this.class.classLoader.getResourceAsStream(grailsApplication.config.multipleLCA.completeGenomesFileName)
            completeGenomeList = completeGenomeStream.readLines().collect { String value ->
                value.toInteger()
            }
        }

        List<Integer> negativeTaxIds = completeGenomeList - positiveTaxIds

        [positiveTaxIds: positiveTaxIds, negativeTaxIds: negativeTaxIds]


    }

    def findMultipleLCAs(List<Integer> positiveTaxIds) {

        if (!completeGenomeList)    {
            InputStream completeGenomeStream = this.class.classLoader.getResourceAsStream(grailsApplication.config.multipleLCA.completeGenomesFileName)
            completeGenomeList = completeGenomeStream.readLines().collect { String value ->
                value.toInteger()
            }
        }

        List<Integer> negativeTaxIds = completeGenomeList - positiveTaxIds

        findMultipleLCAs(positiveTaxIds, negativeTaxIds)

    }


    def findMultipleLCAs(List<Integer> positiveTaxIds, List<Integer> negativeTaxIds) {

        List<Integer> excludeTaxIds = grailsApplication.config.multipleLCA.excludeNodes
        List<Integer> alwaysShowTaxIds = grailsApplication.config.multipleLCA.alwaysShow

        multipleLCA.findMultipleLCAs(positiveTaxIds, negativeTaxIds, excludeTaxIds, alwaysShowTaxIds, false)

    }


}
