package genesis

class SpeciesController {

    def geneOriginService


    def speciesOrigin() {

        String taxIdStr = params.taxid

        if (taxIdStr) {
            geneOriginService.geneOriginForSpecies(taxIdStr.toInteger())
        }

    }
}
