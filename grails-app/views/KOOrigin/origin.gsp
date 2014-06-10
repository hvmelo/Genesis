<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="main"/>
    <title>Genesis - The origin of genes</title>

    <g:javascript src="protovis.min.js" />
    <g:javascript src="flare.js" />



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
                        <hr>
                        <h4 class="text-center">MULTILCA <strong>TREE</strong></h4>
                        <hr>
                        <p class="text-center">
                        <div style="border : solid 2px #888888; background : #ffffff; color : #ffffff; padding : 4px; width : 100%; overflow-x : scroll; ">

                        <script type="text/javascript+protovis">

                                var jsonString = $('<div />').html('{&quot;Eukaryota@^N@^N&quot;:{&quot;Alveolata@^N@^N&quot;:{&quot;[LCA] Paramecium tetraurelia@^PG@^Y&quot;:null,&quot;Cryptosporidium parvum@^NG@^N&quot;:null},&quot;Metazoa@^N@^N&quot;:{&quot;Bilateria@^N@^N&quot;:{&quot;Protostomia@^N@^N&quot;:{&quot;[LCA] Aplysia californica@^PG@^Y&quot;:null,&quot;Neoptera@^N@^N&quot;:{&quot;[LCA] Pediculus humanus@^PG@^Y&quot;:null,&quot;Tribolium castaneum@^NG@^N&quot;:null}},&quot;[LCA] Deuterostomia@^P@^Y&quot;:{&quot;Branchiostoma floridae@^PG@^N&quot;:null,&quot;Patiria pectinifera@^PG@^N&quot;:null},&quot;Schistosoma mansoni@^NG@^N&quot;:null},&quot;[LCA] Trichoplax adhaerens@^PG@^Y&quot;:null}}}').text();

                                var json = JSON.parse(jsonString);  // i have parsed my json string to json

                                var root = pv.dom(json)
                                    .root("teste")
                                    .sort(function(a, b) pv.naturalOrder(a.nodeName, b.nodeName));

                                /* Recursively compute the package sizes. */
                                root.visitAfter(function(n) {
                                  if (n.firstChild) {
                                    n.nodeValue = pv.sum(n.childNodes, function(n) n.nodeValue);
                                  }
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

                </p>

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
    $(document).ready(function() {

        var jsonString = $('<div />').html('{&quot;Eukaryota@^N@^N&quot;:{&quot;Alveolata@^N@^N&quot;:{&quot;[LCA] Paramecium tetraurelia@^PG@^Y&quot;:null,&quot;Cryptosporidium parvum@^NG@^N&quot;:null},&quot;Metazoa@^N@^N&quot;:{&quot;Bilateria@^N@^N&quot;:{&quot;Protostomia@^N@^N&quot;:{&quot;[LCA] Aplysia californica@^PG@^Y&quot;:null,&quot;Neoptera@^N@^N&quot;:{&quot;[LCA] Pediculus humanus@^PG@^Y&quot;:null,&quot;Tribolium castaneum@^NG@^N&quot;:null}},&quot;[LCA] Deuterostomia@^P@^Y&quot;:{&quot;Branchiostoma floridae@^PG@^N&quot;:null,&quot;Patiria pectinifera@^PG@^N&quot;:null},&quot;Schistosoma mansoni@^NG@^N&quot;:null},&quot;[LCA] Trichoplax adhaerens@^PG@^Y&quot;:null}}}').text();

        var json = JSON.parse(jsonString);  // i have parsed my json string to json

        var root = pv.dom(json);
    });
</script>



</body>
</html>