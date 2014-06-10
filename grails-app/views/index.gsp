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
                <h2 class="intro-text text-center">Welcome to <strong>GENESIS</strong></h2>
                <hr>
                <p class="text-center text-info">This is the homepage of Biodados' gene origin project. Using a database of enriched Kegg orthologous
                groups (UEKO), the NCBI Taxonomy tree and LCA (lowest common ancestor) algorithms, we were able to
                assess the taxonomic clades where most of the genes have originated. We can also detect possible lateral transfers.<br/><br/></p>
                <p class="text-center">Enter a KO number below to find its origin...</p>
                <p class="text-center">
                    <div class="row">
                        <div class="col-sm-2 col-md-3" ></div>
                        <div class="col-xs-12 col-sm-8 col-md-6">
                            <g:form controller="KOOrigin" action="origin">
                                <div class="form-group">
                                    <label class="sr-only" for="ko">KO Number <em>(ex: K00343)</em></label>
                                    <input type="text" class="form-control input-lg" name="ko" id="ko" placeholder="KO Number (ex: K00343)" value="${ko}">
                                    <g:if test="${flash.message && from == "ko"}">
                                        <div class="alert alert-danger">${flash.message}</div>
                                    </g:if>
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

<!-- JavaScript -->
<script>
    // Activates the Carousel
    $('.carousel').carousel({
        interval: 5000
    })
</script>

</body>
</html>