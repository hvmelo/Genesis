<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="main"/>
    <title>Genesis - The origin of genes</title>

    <g:javascript src="d3.min.js" />

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
                        <h5 class="text-left text-info">CANDIDATE KO ORIGINS</h5>
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
                        <g:form controller="KOOrigin" action="origin">
                            <input name="ko" type="hidden" value="${ko}">
                            <input name="export" type="hidden" value="1">
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
                        <div class="treeCanvas"> </div>
                        <p class="text-right"><button type="button" id="save" class="btn btn-primary ">
                            <span class="glyphicon glyphicon-download"></span> Save SVG
                        </button></p>
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

<script type="text/javascript">
    $(document).ready(function(){

        var width = $(window).width() > 900 ? ($(window).width() > 1300 ? $(window).width() * 0.55 : $(window).width() * 0.7) : $(window).width() * 0.8,
            height = 800;

        var tree = d3.layout.tree()
            .size([height, width - 220])
            .separation(function(a, b) { return 2; });


        var diagonal = d3.svg.diagonal()
            .projection(function(d) { return [d.y, d.x]; });

        var svg = d3.select(".treeCanvas").append("svg")
            .attr("width", "100%")
            .attr("height", height)
            .append("g")
            .attr("transform", "translate(128,0)");

        var jsonString = $('<div />').html('${treeJSON}').text();

        var json = JSON.parse(jsonString);  // i have parsed my json string to json

        var nodes = tree.nodes(json),
            links = tree.links(nodes);

        var link = svg.selectAll("path.link")
            .data(links)
            .enter().append("path")
            .attr("class", "link")
            .attr("d", diagonal);

        var node = svg.selectAll("g.node")
            .data(nodes)
            .enter().append("g")
            .attr("class", function(d) {
                if (d.type == "P" || d.type == "PG") {
                    return "positiveNode"
                } else if (d.type == "N" || d.type == "NG") {
                    return "negativeNode"
                }
                return "mixedNode"
            })
            .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })

        var grad = node.append("defs")
            .append("linearGradient").attr("id", "grad")
            .attr("x1", "0%").attr("x2", "100%").attr("y1", "0%").attr("y2", "0%");

        grad.append("stop").attr("offset", "50%").style("stop-color", "steelblue");
        grad.append("stop").attr("offset", "50%").style("stop-color", "white");

        node.append("circle")
            .attr("r", 4.5);

        node.append("text")
            .attr("dx", function(d) { return d.children ? -8 : 8; })
            .attr("dy", 3)
            .attr("class", function(d) {
                if (d.lca == "Y") {
                    return "lca"
                }
                else if (d.type != "PG" && d.type != "NG") {
                    return "notLeaf"
                }
                return "leaf"
            })
            .attr("text-anchor", function(d) { return d.children ? "end" : "start"; })
            .text(function(d) { return d.name; });

        d3.select(self.frameElement).style("height", height + "px");

    });


</script>



</body>
</html>