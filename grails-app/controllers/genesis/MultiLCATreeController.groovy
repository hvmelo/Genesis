package genesis

import biodados.biotools.lca.LCAInfo
import biodados.biotools.lca.LCAType
import grails.converters.JSON
import groovy.json.StringEscapeUtils

import javax.swing.tree.DefaultMutableTreeNode

class MultiLCATreeController {

    def geneOriginService

    def index() {
        String taxIdStr = params.taxid

        def result = geneOriginService.getPositiveAndNegativeListsFromKO("k00226")
        def model = [:]
        if (result) {
            model = [ko: "k00226", positiveList: result.positiveTaxIds.unique().sort().join("\n"), negativeList: result.negativeTaxIds.unique().sort().join("\n")]
        }

        render(view: "/multiLCATree.gsp", model: model)

    }

    def ajaxRenderOrganisms() {
        String ko = params.ko
        def model = [:]
        if (ko) {
            def result = geneOriginService.getPositiveAndNegativeListsFromKO(ko)
            if (result) {
                model = [positiveList: result.positiveTaxIds.unique().sort().join("\n"), negativeList: result.negativeTaxIds.unique().sort().join("\n")]
            }

        }
        render(template: "/organismLists", model: model)
    }

    def multiLCATree () {

        String positiveList = params.positiveList
        String negativeList = params.negativeList

        if (!positiveList || positiveList.trim() == "") {
            flash.message = "Please provide a list of positive tax ids!"
            render(view: "/multiLCATree.gsp")
            return
        }

        List<Integer> positiveTaxIds = positiveList.split("\n").collect{it.toInteger()}

        List<Integer> negativeTaxIds = []

        if (negativeList && negativeList.trim() != "") {
            negativeTaxIds = negativeList.split("\n").collect{it.toInteger()}
        }

        def result = geneOriginService.findMultipleLCAs(positiveTaxIds, negativeTaxIds)

        DefaultMutableTreeNode treeRoot = result.miniLCATree

        JSON json
        String treeJSON = ""

        if (treeRoot) {
            json = mapFromNode(treeRoot, result.lcaSet) as JSON
            treeJSON = json.toString(false)
        }

       render(view: "/multiLCAResults.gsp", model: [positiveCount: positiveTaxIds.size(), negativeCount: negativeTaxIds.size(), lcaSet: result.lcaSet, treeJSON: treeJSON])


    }

    Map mapFromNode(DefaultMutableTreeNode treeNode, Set<LCAInfo> lcaSet) {

        LCAInfo lcaInfo = (LCAInfo) treeNode.userObject
        String taxonName = lcaInfo.taxonEntry.name

        String typeStr = ""

        switch (lcaInfo.type) {
            case LCAType.POSITIVE_GENOME:
                typeStr = "PG"
                break
            case LCAType.POSITIVE:
                typeStr = "P"
                break
            case LCAType.NEGATIVE_GENOME:
                typeStr = "NG"
                break
            case LCAType.NEGATIVE:
                typeStr = "N"
                break
            case LCAType.MIXED:
                typeStr = "M"
                break

        }

        Map returnMap = ["name": (lcaSet.contains(lcaInfo) ? "[LCA] " + taxonName : taxonName), "type": typeStr, "lca": (lcaSet.contains(lcaInfo) ? "Y" : "N")]

        Enumeration<DefaultMutableTreeNode> children = treeNode.children()

        if (children) {
            List childrenList = []

            children.each {DefaultMutableTreeNode childNode ->
                childrenList << mapFromNode(childNode, lcaSet)
            }

            returnMap["children"] = childrenList

        }
        return returnMap;


    }


    def speciesOrigin () {

        String taxIdStr = params.taxid

        if (taxIdStr && taxIdStr.isInteger()) {
            def results = geneOriginService.geneOriginForSpecies(taxIdStr.toInteger())

            if (params.exportKOs) {

                StringBuffer strBuf = new StringBuffer()

                results.koLcas.each { line ->
                    strBuf << "${line[0]}\t${line[1]}\t${line[2]}\t${line[3]}\n"
                }

                println strBuf.toString()

                response.setHeader "Content-disposition", "attachment; filename=${params.taxid}_origin.tab"
                response.contentType = 'text/tab-separated-values'
                response.outputStream << strBuf.toString()
                response.outputStream.flush()
                return

            }

            if (params.exportLateral) {

                StringBuffer strBuf = new StringBuffer()

                results.lateralTransfers.each { line ->
                    strBuf << "${line[0]}\t${line[1]}\t${line[2]}\t${line[3]}\n"
                }

                println strBuf.toString()

                response.setHeader "Content-disposition", "attachment; filename=${params.taxid}_lateral_transfers.tab"
                response.contentType = 'text/tab-separated-values'
                response.outputStream << strBuf.toString()
                response.outputStream.flush()
                return

            }

            if (params.exportLineage) {

                StringBuffer strBuf = new StringBuffer()

                results.levelKoCount.each { key, value ->
                    strBuf << "${key}\t${value}\n"
                }

                println strBuf.toString()

                response.setHeader "Content-disposition", "attachment; filename=${params.taxid}_lineage_origin.tab"
                response.contentType = 'text/tab-separated-values'
                response.outputStream << strBuf.toString()
                response.outputStream.flush()
                return

            }

            render(view: "/speciesResults.gsp", model: [taxid: taxIdStr, speciesName: results.speciesName,
                                                        koLcas: results.koLcas.take(10), totalKOs: results.koLcas.size(),
                                                        levelKoCount: results.levelKoCount, totalLevelKoCount: results.levelKoCount.size(),
                                                        lateralTransfers: results.lateralTransfers, totalLateral: results.lateralTransfers.size()])


        }
        else {
            flash.message = "Please enter a valid species taxid!"
            render(view: "/species.gsp", model: [:])

        }
    }


}
