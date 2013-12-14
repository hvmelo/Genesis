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
                <h3 class="intro-text text-center">GENE ORIGIN <strong>PER SPECIES</strong></h3>
                <hr>
                <p class="text-center text-info">Using our algorithm, we can also find the origin of the genes of a given species. Some
                    genes have been inserted into a species DNA by lateral transfers. In our results, we also try to assess those genes.<br/><br/></p>
                <p class="text-center">Enter a taxid below to find the origin of the genes of a given species.</p>
                <p class="text-center">
                    <div class="row">
                        <div class="col-sm-2 col-md-3" ></div>
                        <div class="col-xs-12 col-sm-8 col-md-6">
                            <g:form controller="species" action="speciesOrigin">
                                <div class="form-group">
                                    <label class="sr-only" for="taxid">Tax Id</label>
                                    <input type="text" class="form-control input-lg" name="taxid" id="taxid" placeholder="Species tax id (ex: 9606)">
                                    <g:if test="${flash.message}">
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