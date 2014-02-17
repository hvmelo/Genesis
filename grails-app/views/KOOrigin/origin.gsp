<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="main"/>
    <title>Genesis - The origin of genes</title>

    <g:javascript src="raphael-min.js" />
    <g:javascript src="jsphylosvg-min.js" />


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
                        <h5 class="text-left text-info">CANDIDATE KO ORIGINS</h5>
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
                                    <td>${lca[2]}</td>
                                    <td>${lca[3]}</td>
                                    <td>${lca[5]}</td>
                                    <td>${lca[8]}</td>

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
                <p class="text-center">
                    <g:if test="${results}">
                        <div id="svgCanvas"> </div>
                    </g:if>

                </p>
            </div>
        </div>
        <div class="box">
            <div class="col-lg-12">
                <hr>
                <h2 class="intro-text text-center">Welcome to <strong>GENESIS</strong></h2>
                <hr>
                <p class="text-center text-info">This is the homepage of Biodados' gene origin project. Using a database of enriched Kegg orthologous
                groups (UEKO), the NCBI Taxonomy tree and LCA (lowest common ancestor) algorithms, we were able to
                assess the point in time where most of the genes have originated. <br/><br/></p>
                <p class="text-center">Enter a KO number below to find its origin...</p>
                <p class="text-center">
                <div class="row">
                    <div class="col-sm-2 col-md-3" ></div>
                    <div class="col-xs-12 col-sm-8 col-md-6">
                        <g:form controller="KOOrigin" action="origin">
                            <div class="form-group">
                                <label class="sr-only" for="ko">KO Number <em>(ex: K00343)</em></label>
                                <input type="text" class="form-control input-lg" name="ko" id="ko" placeholder="KO Number (ex: K00343)" value="${ko}">
                            </div>
                            <p class="text-center"><button type="submit" class="btn btn-primary btn-lg">Submit</button></p>
                        </g:form>
                    </div>
                    <div class="col-sm-2 col-md-3" /></div>
            </div>
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

<script type="text/javascript">
    $(document).ready(function(){
        var dataObject = { newick: '(((Espresso:2,(Milk Foam:2,Espresso Macchiato:5,((Steamed Milk:2,Cappuccino:2,(Whipped Cream:1,Chocolate Syrup:1,Cafe Mocha:3):5):5,Flat White:2):5):5):1,Coffee arabica:0.1,(Columbian:1.5,((Medium Roast:1,Viennese Roast:3,American Roast:5,Instant Coffee:9):2,Heavy Roast:0.1,French Roast:0.2,European Roast:1):5,Brazilian:0.1):1):1,Americano:10,Water:1);' };
        phylocanvas = new Smits.PhyloCanvas(
            dataObject,
            'svgCanvas',
            800, 800
        );
    });
</script>

</body>
</html>