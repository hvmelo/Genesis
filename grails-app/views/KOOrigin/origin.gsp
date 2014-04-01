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
                        <div class="treeCanvas"> </div>
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


    });

    var width = $(window).width() > 900 ? ($(window).width() > 1300 ? $(window).width() * 0.55 : $(window).width() * 0.7) : $(window).width() * 0.8,
        height = 800;

    var tree = d3.layout.tree()
        .size([height, width - 220]);

    var diagonal = d3.svg.diagonal()
        .projection(function(d) { return [d.y, d.x]; });

    var svg = d3.select(".treeCanvas").append("svg")
        .attr("width", "100%")
        .attr("height", height)
        .append("g")
        .attr("transform", "translate(128,0)");

    var jsonString = '{"name":"[LCA] cellular organisms","type":"P","lca":"Y","children":[{"name":"Bacteria","type":"M","lca":"N","children":[{"name":"Mycoplasmataceae","type":"N","lca":"N","children":[{"name":"[LCA] Mycoplasma","type":"M","lca":"Y","children":[{"name":"Mycoplasma iowae 695","type":"P","lca":"N"},{"name":"Mycoplasma penetrans HF-2","type":"P","lca":"N"},{"name":"Mycoplasma gallisepticum","type":"N","lca":"N","children":[{"name":"Mycoplasma gallisepticum str. R(low)","type":"N","lca":"N"}]},{"name":"Mycoplasma mycoides group","type":"N","lca":"N","children":[{"name":"Mycoplasma capricolum subsp. capricolum ATCC 27343","type":"N","lca":"N"}]}]},{"name":"Ureaplasma","type":"N","lca":"N","children":[{"name":"Ureaplasma urealyticum serovar 10 str. ATCC 33699","type":"N","lca":"N"}]}]},{"name":"Proteobacteria","type":"P","lca":"N","children":[{"name":"Azorhizobium caulinodans ORS 571","type":"P","lca":"N"}]},{"name":"Firmicutes","type":"P","lca":"N","children":[{"name":"Planococcus antarcticus DSM 14505","type":"P","lca":"N"}]},{"name":"Chlamydiae/Verrucomicrobia group","type":"M","lca":"N","children":[{"name":"Chlamydia trachomatis","type":"N","lca":"N"}]}]},{"name":"Archaea","type":"M","lca":"N","children":[{"name":"Euryarchaeota","type":"P","lca":"N","children":[{"name":"Methanobacterium formicicum DSM 3637","type":"P","lca":"N"}]},{"name":"Thermoprotei","type":"P","lca":"N","children":[{"name":"Thermoproteus tenax Kra 1","type":"P","lca":"N"}]},{"name":"Nanoarchaeum equitans Kin4-M","type":"N","lca":"N"}]},{"name":"Eukaryota","type":"M","lca":"N","children":[{"name":"Endopterygota","type":"M","lca":"N","children":[{"name":"[LCA] Tribolium castaneum","type":"P","lca":"Y"},{"name":"Drosophila","type":"N","lca":"N","children":[{"name":"Drosophila pseudoobscura pseudoobscura","type":"N","lca":"N"}]},{"name":"Apocrita","type":"N","lca":"N","children":[{"name":"Nasonia vitripennis","type":"N","lca":"N"}]}]},{"name":"Alveolata","type":"P","lca":"N","children":[{"name":"Amphidinium carterae","type":"P","lca":"N"}]},{"name":"Kinetoplastida","type":"P","lca":"N","children":[{"name":"Leishmania amazonensis","type":"P","lca":"N"}]},{"name":"Viridiplantae","type":"M","lca":"N","children":[{"name":"Arabidopsis thaliana","type":"N","lca":"N"}]},{"name":"Cryptophyta","type":"N","lca":"N","children":[{"name":"Cryptomonas paramecium","type":"N","lca":"N"}]}]}]}';

    var json = JSON.parse(jsonString);  // i have parsed my json string to json

    //d3.json("https://dl.dropboxusercontent.com/u/1661277/tree2.json", function(error, json) {
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
                if (d.type == "P") {
                    return "positiveNode"
                } else if (d.type == "N") {
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
                else if (d.children) {
                    return "notLeaf"
                }
                return "leaf"
            })
            .attr("text-anchor", function(d) { return d.children ? "end" : "start"; })
            .text(function(d) { return d.name; });

    //});

    d3.select(self.frameElement).style("height", height + "px");


</script>

</body>
</html>