package genesis

class SpeciesController {

    def geneOriginService

    def index() {
        String taxIdStr = params.taxid

        render(view: "/species.gsp", model: [taxid: taxIdStr])



    }

    def speciesOrigin () {

        String taxIdStr = params.taxid

        if (taxIdStr) {
            def results = geneOriginService.geneOriginForSpecies(taxIdStr.toInteger())

            if (params.exportKOs) {

            }

            render(view: "/speciesResults.gsp", model: [taxid: taxIdStr, speciesName: results.speciesName,
                                                        koLcas: results.koLcas.take(10), totalKOs: results.koLcas.size(),
                                                        lateralTransfers: results.lateralTransfers, totalLateral: results.lateralTransfers.size()])


        }
        else {
            render(view: "/species.gsp", model: [:])

        }
    }


}
