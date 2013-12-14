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

        Object[] results = geneOriginService.lcasFromKO(ko)

        if (!results) {
            flash.message = "Cannot find a KO with number '${ko}'!"
            render(view: "/index.gsp", model: [from: "ko", ko: ko])
            return
        }

        if (params.export) {

            StringBuffer strBuf = new StringBuffer()

            results.each { line ->
                strBuf << "${line[1]}\t${line[2]}\t${line[4]}\t${line[7]}\n"
            }

            println strBuf.toString()

            response.setHeader "Content-disposition", "attachment; filename=${params.ko}_origin.tab"
            response.contentType = 'text/tab-separated-values'
            response.outputStream << strBuf.toString()
            response.outputStream.flush()
            return
        }

        def description = new URL("http://rest.kegg.jp/find/ko/${ko}").getText().split("\t")[1]


        [ko: ko, koDescription: description, results: results]


    }


}
