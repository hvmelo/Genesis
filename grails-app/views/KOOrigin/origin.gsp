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
                <h4 class="text-center">RESULTS FOR <strong>${ko}</strong></h4>
                <h5 class="text-center text-info">${koDescription}</h5>
                <hr>

                <p class="text-center">
                        <g:if test="${results}">
                            <table class="table table-striped" style="background-color: #ffffff">
                                <tr>
                                    <td><strong>#</strong></td>
                                    <td><strong>Origin Txid</strong></td>
                                    <td><strong>Clade of origin</strong></td>
                                    <td><strong>Clade rank</strong></td>
                                    <td><strong>Positive leaves</strong></td>
                                </tr>
                                <g:each in="${results}" status="i" var="lca">
                                    <tr>
                                        <td>${i+1}</td>
                                        <td>${lca[1]}</td>
                                        <td>${lca[2]}</td>
                                        <td>${lca[4]}</td>
                                        <td>${lca[7]}</td>

                                    </tr>
                                </g:each>
                            </table>
                            <g:form controller="KOOrigin" action="origin">
                                <input name="ko" type="hidden" value="${ko}">
                                <input name="export" type="hidden" value="1">
                                <p class="text-right"><button type="submit" class="btn btn-primary ">
                                    <span class="glyphicon glyphicon-download"></span> Download
                                </button></p>
                            </g:form>
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

<!-- JavaScript -->
<script>
    // Activates the Carousel
    $('.carousel').carousel({
        interval: 5000
    })
</script>

</body>
</html>