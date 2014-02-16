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
                <h3 class="intro-text text-center">MULTILCA <strong>TREE</strong></h3>
                <hr>
                <p class="text-center text-info">We can determine the multiple origin of a given gene based on a positive and
                a negative genome list. The positive list must be formed by the NCBI tax ids of organisms which provenly have the gene while
                    the negative list must be formed by NCBI tax ids of organisms which provenly DO NOT have the gene.<br/><br/></p>
                <p class="text-center">
                    <g:form controller="species" action="speciesOrigin">
                        <div class="row">
                            <div id="lists">
                                <g:render template="/organismLists" model="[positiveList: positiveList, negativeList: negativeList]" />
                            </div>

                            <div class="col-sm-4 col-md-6 col-lg-6">

                                <div class="row">
                                    <div class="col-xs-12">
                                        <br>
                                        <label  for="ko">Load organisms from KO:</label>
                                    </div>

                                </div>
                                <div class="row">

                                    <div class="col-xs-8 col-md-10" style="padding-right: 5px;">
                                        <input type="text" class="form-control input-lg"  name="ko" id="ko" placeholder="KO number">
                                    </div>
                                    <div class="col-xs-4 col-md-2" style="padding-left: 5px; padding-right: 5px">
                                        <button onclick="${remoteFunction(controller: 'multiLCATree', action: 'ajaxRenderOrganisms', update: 'lists', params: '\'ko=\' + ko.value')};return false;"
                                                class="btn btn-primary btn-lg" style="width: 100%" id="btnLoad">Load</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </g:form>

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