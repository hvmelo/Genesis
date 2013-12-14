<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="main"/>
    <title>Genesis - The origin of genes</title>


</head>

<body>



<div class="container">

    <div class="row">
        <div class="box">
            <div class="col-lg-12">
                <hr>
                <h4 class="text-center">RESULTS FOR <strong>${speciesName}</strong></h4>
                <h6 class="text-center"> TAX ID <strong>${taxid}</strong></h6>
                <hr>

                <p class="text-center">
                    <g:if test="${koLcas}">
                        <h5 class="text-left text-info">GENE ORIGINS</h5>
                        <table class="table table-striped ajax" style="background-color: aliceblue">
                            <thead>
                            <tr>
                                <g:sortableColumn property="ko" title="KO" />
                                <g:sortableColumn property="ko_description" title="KO Description" />
                                <g:sortableColumn property="lca_name" title="Gene Origin" />
                                <g:sortableColumn property="lca_txid" title="Tax ID" />
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${koLcas}" status="i" var="row">
                                <tr>
                                    <td>${row[0]}</td>
                                    <td>${row[1]}</td>
                                    <td>${row[2]}</td>
                                    <td>${row[3]}</td>
                                </tr>
                            </g:each>

                            </tbody>
                        </table>
                        <div class="row">

                            <div class="col-xs-8 text-left">
                                   <h5>Showing ${koLcas.size()} of ${totalKOs} rows</h5>
                            </div>

                            <div class="col-xs-4 text-right">
                                <g:form controller="species" action="speciesOrigin">
                                    <input name="taxid" type="hidden" value="${taxid}">
                                    <input name="exportKOs" type="hidden" value="1">
                                    <button type="submit" class="btn btn-primary ">
                                        <span class="glyphicon glyphicon-download"></span> Download Full Report
                                    </button>
                                </g:form>
                            </div>

                        </div>
                    </g:if>
                </p>
                <p class="text-center">
                    <g:if test="${lateralTransfers}">
                        <br><br>
                        <h5 class="text-left text-info"><strong>CANDIDATE LATERAL TRANSFERS</strong></h5>
                        <table class="table table-striped ajax" style="background-color: seashell">
                            <thead>
                            <tr>
                                <g:sortableColumn property="ko" title="KO" />
                                <g:sortableColumn property="ko_description" title="KO Description" />
                                <g:sortableColumn property="lca_name" title="Gene Origin" />
                                <g:sortableColumn property="lca_txid" title="Tax ID" />
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${lateralTransfers}" status="i" var="row">
                                <tr>
                                    <td>${row[0]}</td>
                                    <td>${row[1]}</td>
                                    <td>${row[2]}</td>
                                    <td>${row[3]}</td>
                                </tr>
                            </g:each>

                            </tbody>
                        </table>
                        <div class="row">

                            <div class="col-xs-8 text-left">
                                <h5>Showing ${lateralTransfers.size()} of ${totalLateral} rows</h5>
                            </div>

                            <div class="col-xs-4 text-right">
                                <g:form controller="species" action="speciesOrigin">
                                    <input name="taxid" type="hidden" value="${taxid}">
                                    <input name="exportKOs" type="hidden" value="1">
                                    <button type="submit" class="btn btn-primary ">
                                        <span class="glyphicon glyphicon-download"></span> Download Full Report
                                    </button>
                                </g:form>
                            </div>

                        </div>
                    </g:if>

                </p>

            </div>
        </div>
    </div>

</div><!-- /.container -->

<footer>
    <div class="container">
        <div class="row">
            <div class="col-xs-6 text-left"><p>Copyright &copy; Henrique Velloso 2013</p></div>

            <div class="col-xs-6 text-right"><p><a href="mailto:hvmelo@gmail.com">hvmelo@gmail.com</a></p></div>

        </div>
    </div>
</footer>



</body>
</html>