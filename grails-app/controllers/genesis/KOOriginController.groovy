package genesis

class KOOriginController {

    def geneOriginService

    def origin() {

        String ko = params.ko

        if (!ko) {
            flash.message = "Please enter a KO number."
            render(view: "/index.gsp", model: [from: "ko", ko: ko])
            return
        }

        //def result = geneOriginService.multipleLCAsFromKO(ko)
        Object[] results = geneOriginService.lcasFromKO(ko)

        if (!results) {
            flash.message = "Cannot find a KO with number '${ko}'!"
            render(view: "/index.gsp", model: [from: "ko", ko: ko])
            return
        }

        if (params.export) {

            StringBuffer strBuf = new StringBuffer()

            results.each { line ->
                strBuf << "${line[2]}\t${line[3]}\t${line[5]}\t${line[8]}\n"
            }

            println strBuf.toString()

            response.setHeader "Content-disposition", "attachment; filename=${params.ko}_origin.tab"
            response.contentType = 'text/tab-separated-values'
            response.outputStream << strBuf.toString()
            response.outputStream.flush()
            return
        }

        def description = results ? results[0][1] : null


        [ko: ko, koDescription: description, results: results]


    }


}
