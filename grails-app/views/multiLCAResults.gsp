<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="main"/>
    <title>Genesis - The origin of genes</title>

    <g:javascript src="protovis.min.js" />

</head>

<body>





<div class="container">

    <div class="row">
        <div class="box">
            <div class="col-lg-12">
                <hr>
                <h4 class="text-center">MULTILCA <strong>RESULTS</strong></h4>
                <h5 class="text-center text-info">${positiveCount} positive tax ids. ${negativeCount} negative tax ids.</h5>
                <hr>

                <p class="text-center">
                    <g:if test="${lcaSet}">
                        <h5 class="text-left text-info">CANDIDATE GENE ORIGINS (or false positives)</h5>
                        <table class="table table-striped" style="background-color: #ffffff">
                            <tr>
                                <td><strong>#</strong></td>
                                <td><strong>Origin Txid</strong></td>
                                <td><strong>Clade of origin</strong></td>
                                <td><strong>Clade rank</strong></td>
                                <td><strong>Positive leaves</strong></td>
                                <td><strong>Negative leaves</strong></td>
                            </tr>
                            <g:each in="${lcaSet}" status="i" var="lca">
                                <tr>
                                    <td>${i+1}</td>
                                    <td>${lca.taxonEntry.taxId}</td>
                                    <td>${lca.taxonEntry.name}</td>
                                    <td>${lca.taxonEntry.rank}</td>
                                    <td>${lca.positiveGenomeCount}</td>
                                    <td>${lca.negativeGenomeCount}</td>

                                </tr>
                            </g:each>
                        </table>
                        <g:form controller="MultiLCATree" action="exportLCAs">
                            <input name="ko" type="hidden" value="${ko}">
                            <p class="text-right"><button type="submit" class="btn btn-primary ">
                                <span class="glyphicon glyphicon-download"></span> Download
                            </button></p>
                        </g:form>

                    </g:if>

                </p>
                <p class="text-center">
                    <g:if test="${geneLosses}">
                        <h5 class="text-left text-info">CANDIDATE GENE LOSSES (or false negatives)</h5>
                        <table class="table table-striped" style="background-color: #ffffff">
                            <tr>
                                <td><strong>#</strong></td>
                                <td><strong>Origin Txid</strong></td>
                                <td><strong>Clade of origin</strong></td>
                                <td><strong>Clade rank</strong></td>
                            </tr>
                            <g:each in="${geneLosses}" status="i" var="info">
                                <tr>
                                    <td>${i+1}</td>
                                    <td>${info.taxonEntry.taxId}</td>
                                    <td>${info.taxonEntry.name}</td>
                                    <td>${info.taxonEntry.rank}</td>
                                </tr>
                            </g:each>
                        </table>
                        <g:form controller="MultiLCATree" action="exportGeneLosses">
                            <input name="ko" type="hidden" value="${ko}">
                            <p class="text-right"><button type="submit" class="btn btn-primary ">
                                <span class="glyphicon glyphicon-download"></span> Download
                            </button></p>
                        </g:form>

                    </g:if>

                </p>
                <g:if test="${lcaSet}">
                    <hr>
                    <h4 class="text-center">MULTILCA <strong>TREE</strong></h4>
                    <hr>
                    <p class="text-center">
                    <div style="border : solid 2px #888888; background : #ffffff; color : #ffffff; padding : 4px; width : 100%; overflow-x : scroll; ">

                        <script type="text/javascript+protovis">

                                var rootString = $('<div />').html('${rootString}').text();
                                var jsonString = $('<div />').html('${treeJSON}').text();

                                var json = JSON.parse(jsonString);  // i have parsed my json string to json

                                var root = pv.dom(json)
                                    .root(rootString)
                                    .sort(function(a, b) pv.naturalOrder(a.nodeName, b.nodeName));

                                /* Recursively compute the package sizes. */
                                root.visitAfter(function(n) {
                                  if (n.firstChild) {
                                    n.nodeValue = pv.sum(n.childNodes, function(n) n.nodeValue);
                                  }
                                  nodeFont(n);
                                });

                                var vis = new pv.Panel()
                                    .width(1000)
                                    .height(function() (root.nodes().length + 1) * 30)
                                    .margin(5);

                                var layout = vis.add(pv.Layout.Indent)
                                    .nodes(function() root.nodes())
                                    .depth(80)
                                    .breadth(30);

                                layout.link.add(pv.Line);

                                var node = layout.node.add(pv.Panel)
                                    .top(function(n) n.y - 6)
                                    .height(12)
                                    .right(6)
                                    .strokeStyle(null)
                                    .fillStyle(null)
                                    .events("all");

                                node.anchor("left").add(pv.Dot)
                                    .strokeStyle("#1f77b4")
                                    .fillStyle(function(n) n.nodeName.split("@^")[1] == "NG" || n.nodeName.split("@^")[1] == "N"? "#ffffff" : "steelblue")
                                    .title(function t(d) d.parentNode ? (t(d.parentNode) + "." + d.nodeName) : d.nodeName)
                                  .anchor("right").add(pv.Label)
                                    .text(function(n) n.nodeName.split("@^")[0] )
                                    .font(function(n) nodeFont(n));

                                node.anchor("right").add(pv.Label)
                                    .textStyle(function(n) n.firstChild || n.toggled ? "#aaa" : "#000")
                                    .text(function(n) (n.nodeValue >> 10) + "KB");

                                vis.render();

                                /* Toggles the selected node, then updates the layout. */
                                function toggle(n) {
                                  n.toggle(pv.event.altKey);
                                  return layout.reset().root;
                                }

                                function nodeFont(n) {
                                    var bold = n.nodeName.split("@^")[2] == "Y" ? "bold " : "";
                                    var italic = n.nodeName.split("@^")[1] == "NG" || n.nodeName.split("@^")[1] == "PG"  ? "italic " : "";
                                    return  bold + italic + "12px sans-serif";
                                }

                                    </script>
                    </div>

                </g:if>

            </div>
        </div>
        <div class="box">
            <div class="col-lg-12">
                <hr>
                <h3 class="intro-text text-center">MULTILCA <strong>TREE</strong></h3>
                <hr>
                <p class="text-center text-info">We can determine the multiple origin of a given gene based on a positive and
                a negative genome list. The positive list must be formed by the NCBI tax ids of organisms which provenly have the gene while
                the negative list must be formed by NCBI tax ids of organisms which provenly DO NOT have the gene.<br/><br/></p>
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