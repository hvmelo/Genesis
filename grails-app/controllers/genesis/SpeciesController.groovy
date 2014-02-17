package genesis

class SpeciesController {

    def geneOriginService

    def index() {
        String taxIdStr = params.taxid

        render(view: "/species.gsp", model: [taxid: taxIdStr])



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
            flash.message = "Please enter a valid species tax id!"
            render(view: "/species.gsp", model: [:])

        }
    }


}
