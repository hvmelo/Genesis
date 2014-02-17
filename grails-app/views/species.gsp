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
                                </div>
                                <p class="text-center"><button onclick="$('#findOriginModal').modal({keyboard: false, backdrop: 'static'});" type="submit" class="btn btn-primary btn-lg">Submit</button></p>
                            </g:form>
                        </div>
                        <div class="col-sm-2 col-md-3" /></div>
                    </div>
                </p>

            </div>
        </div>
    </div>

</div><!-- /.container -->


!-- Modal Mounting Tree -->
<div class="modal fade" id="findOriginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width: 400px; padding-top: 250px;">
        <div class="modal-content">

            <div class="modal-body">
                <div id="circularG" style="margin-left: 136px;">
                    <div id="circularG_1" class="circularG">
                    </div>

                    <div id="circularG_2" class="circularG"> </div>

                    <div id="circularG_3" class="circularG"> </div>
                    <div id="circularG_4" class="circularG">
                    </div>
                    <div id="circularG_5" class="circularG">
                    </div>
                    <div id="circularG_6" class="circularG">
                    </div>
                    <div id="circularG_7" class="circularG">
                    </div>
                    <div id="circularG_8" class="circularG">
                    </div>
                </div>

                <p style="text-align: center;margin:15px 0 0px">Please wait, finding species origin...</p>
            </div>

        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->


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