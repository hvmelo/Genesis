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
                <p class="text-center text-info">We can determine the multiple origins of a given gene based on a positive and
                a negative list. The positive list must be formed by the NCBI taxonomy ids of the organisms which express the gene while
                    the ones that DO NOT express the gene.<br/><br/></p>
                <p class="text-center">
                    <g:form controller="multiLCATree" action="multiLCATree">
                        <div class="row">
                            <div id="lists">
                                <g:render template="/organismLists" model="[positiveList: positiveList, negativeList: negativeList]" />
                            </div>

                            <div class="col-sm-4 col-md-6">

                                <div class="row">
                                    <div class="col-xs-12">
                                        <br>
                                        <label  for="ko">Load organisms from KO:</label>
                                    </div>

                                </div>
                                <div class="row">

                                    <div class="col-xs-8 col-md-10" style="padding-right: 5px;">
                                        <input type="text" class="form-control input-lg"  name="ko" id="ko" placeholder="KO number" value="${ko}">
                                    </div>
                                    <div class="col-xs-4 col-md-2" style="padding-left: 5px; padding-right: 5px">
                                        <button onclick="${remoteFunction(controller: 'multiLCATree', action: 'ajaxRenderOrganisms', update: 'lists', params: '\'ko=\' + ko.value')};return false;"
                                                class="btn btn-primary btn-lg" style="width: 100%" id="btnLoad">Load</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="checkbox col-xs-12" style="margin-left: 16px;">
                                        <g:checkBox name="loadNegatives" value="${false}" /> Consider negative all complete genomes not present in the positive list

                                    </div>

                                </div>
                                <div class="row createMultiLCA">
                                    <div class="col-xs-12 text-center" style="position: absolute; bottom: 0">
                                        <button onclick="$('#mountingTreeModal').modal({keyboard: false, backdrop: 'static'});" type="submit" class="btn btn-primary btn-lg">Create MultiLCA Tree</button>
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



<!-- Modal Mounting Tree -->
<div class="modal fade" id="mountingTreeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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

                <p style="text-align: center;margin:15px 0 0px">Mounting the LCA Tree. Please wait...</p>
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