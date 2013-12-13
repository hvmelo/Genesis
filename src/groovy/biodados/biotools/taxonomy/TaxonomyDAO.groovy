package biodados.biotools.taxonomy

import groovy.sql.Sql
import org.apache.log4j.Logger

import javax.sql.DataSource

public class TaxonomyDAO {

    def sessionFactory


    static Logger logger = Logger.getLogger(TaxonomyDAO.class)


    private Sql sql

    def init() {
        logger.trace "Connecting to Taxonomy Db..."
        sql = new Sql(sessionFactory.currentSession.connection())
        logger.trace "Successfully connected to Taxonomy Db."
    }

    def findAllTaxonEntries() {

        logger.trace "Retrieving all nodes."

        def session = sessionFactory.getCurrentSession()


        def taxonMap = [:] as TreeMap

        Object[] result = session.createSQLQuery("""SELECT nd.tax_id, nd.parent_id, nm.name_txt, nd.rank
                        FROM tax_nodes nd INNER JOIN tax_names nm ON nd.tax_id = nm.tax_id
                        WHERE nm.name_class = 'scientific name'""".toString()).list()
        result.each {
                    row ->
                    def entry = new TaxonEntry(taxId: row[0], parentId: row[1],
                            name: row[2], rank: row[3])
                    taxonMap[row[0]] = entry

                }

        logger.trace "Taxon map sucessfully created."

        return taxonMap;
    }

    def buildMergedMap() {
        logger.trace "Building merged map..."

        def mergedMap = [:]

        def session = sessionFactory.getCurrentSession()

        Object[] result = session.createSQLQuery("SELECT old_tax_id, new_tax_id FROM tax_nodes_merged ORDER BY new_tax_id").list()

        result.each { row ->
            if (!mergedMap[row[1]]) {
                mergedMap[row[1]] = []
            }

            mergedMap[row[1]] << row[0]
        }

        return mergedMap
    }


}

