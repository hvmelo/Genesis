<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="main"/>
    <title>Genesis - The origin of genes</title>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <g:javascript src="canvg.js" />
    <g:javascript src="rgbcolor.js" />
    <g:javascript src="StackBlur.js" />


    <script type="text/javascript">
        <g:if test="${levelKoCount}">
            google.load("visualization", "1", {packages:["corechart"]});
            google.setOnLoadCallback(drawChart);
            function drawChart() {
                var data = google.visualization.arrayToDataTable([
                    ['Clade', 'Gene Count'],
                    <g:each in="${levelKoCount}" var="entry">
                        ['${entry.key}',${entry.value}],
                    </g:each>
                ]);

                var options = {
                    legend: { position: 'top',alignment:'center' },
                    colors:['blue','#004411'],
                    backgroundColor: 'transparent',
                    hAxis: {slantedTextAngle:  90, titleTextStyle: {fontSize: 10}},
                    chartArea: {top: 50}
                };

                var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
                chart.draw(data, options);
            }
            function getImgData(chartContainer) {
                var chartArea = chartContainer.getElementsByTagName('svg')[0].parentNode;
                var svg = chartArea.innerHTML;
                var doc = chartContainer.ownerDocument;
                var canvas = doc.createElement('canvas');
                canvas.setAttribute('width', chartArea.offsetWidth);
                canvas.setAttribute('height', chartArea.offsetHeight);


                canvas.setAttribute(
                    'style',
                    'position: absolute; ' +
                        'top: ' + (-chartArea.offsetHeight * 2) + 'px;' +
                        'left: ' + (-chartArea.offsetWidth * 2) + 'px;');
                doc.body.appendChild(canvas);
                canvg(canvas, svg);
                var imgData = canvas.toDataURL('image/png');
                canvas.parentNode.removeChild(canvas);
                return imgData;
            }

            function saveAsImg(chartContainer) {
                var imgData = getImgData(chartContainer);

                // Replacing the mime-type will force the browser to trigger a download
                // rather than displaying the image in the browser window.
                window.location = imgData.replace('image/png', 'image/octet-stream');
            }
            function toImg(chartContainer, imgContainer) {
                var doc = chartContainer.ownerDocument;
                var img = doc.createElement('img');
                img.src = getImgData(chartContainer);

                while (imgContainer.firstChild) {
                    imgContainer.removeChild(imgContainer.firstChild);
                }
                imgContainer.appendChild(img);
            }
        </g:if>
    </script>

</head>

<body>



<div class="container">

    <div class="row">
        <div class="box">
            <div class="col-lg-12">
                <hr>
                <h4 class="text-center">RESULTS FOR <strong>${speciesName}</strong></h4>
                <h6 class="text-center"> TAX ID <strong>${taxid}</strong></h6>
                <hr>

                <p class="text-center">
                    <g:if test="${koLcas}">
                        <h5 class="text-left text-info">FULL GENE ORIGIN LIST</h5>
                        <table class="table table-striped ajax" style="background-color: aliceblue">
                            <thead>
                            <tr>
                                <td><strong>KO</strong></td>
                                <td><strong>KO Description</strong></td>
                                <td><strong>Gene Origin</strong></td>
                                <td><strong>Tax ID</strong></td>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${koLcas}" status="i" var="row">
                                <tr>
                                    <td>${row[0]}</td>
                                    <td>${row[1]}</td>
                                    <td>${row[2]}</td>
                                    <td>${row[3]}</td>
                                </tr>
                            </g:each>

                            </tbody>
                        </table>
                        <div class="row">

                            <div class="col-xs-8 text-left">
                                   <h5>Showing ${koLcas.size()} of ${totalKOs} rows</h5>
                            </div>

                            <div class="col-xs-4 text-right">
                                <g:form controller="species" action="speciesOrigin">
                                    <input name="taxid" type="hidden" value="${taxid}">
                                    <input name="exportKOs" type="hidden" value="1">
                                    <button type="submit" class="btn btn-primary ">
                                        <span class="glyphicon glyphicon-download"></span> Download Full Report
                                    </button>
                                </g:form>
                            </div>

                        </div>
                    </g:if>
                </p>
                <p class="text-center">
                    <g:if test="${lateralTransfers}">
                        <br><br>
                        <h5 class="text-left text-info"><strong>CANDIDATE LATERAL TRANSFERS</strong></h5>
                        <table class="table table-striped ajax" style="background-color: #ddf6dd">
                            <thead>
                            <tr>
                                <td><strong>KO</strong></td>
                                <td><strong>KO Description</strong></td>
                                <td><strong>Gene Origin</strong></td>
                                <td><strong>Tax ID</strong></td>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${lateralTransfers}" status="i" var="row">
                                <tr>
                                    <td>${row[0]}</td>
                                    <td>${row[1]}</td>
                                    <td>${row[2]}</td>
                                    <td>${row[3]}</td>
                                </tr>
                            </g:each>

                            </tbody>
                        </table>
                        <div class="row">

                            <div class="col-xs-8 text-left">
                                <h5>Showing ${lateralTransfers.size()} of ${totalLateral} rows</h5>
                            </div>

                            <div class="col-xs-4 text-right">
                                <g:form controller="species" action="speciesOrigin">
                                    <input name="taxid" type="hidden" value="${taxid}">
                                    <input name="exportLateral" type="hidden" value="1">
                                    <button type="submit" class="btn btn-primary ">
                                        <span class="glyphicon glyphicon-download"></span> Download Full Report
                                    </button>
                                </g:form>
                            </div>

                        </div>
                    </g:if>

                </p>
                <p class="text-right">
                    <g:if test="${levelKoCount}">
                        <br><br>
                        <h5 class="text-left text-info">LINEAGE ORIGIN GRAPH</h5>

                        <div class="row">
                            <div class="col-xs-12 text-center">

                                <div id="chart_div" style="width: 100%; height: 600px;"></div>
                            </div>
                        </div>


                    </g:if>
                </p>

                <p class="text-center">
                    <g:if test="${levelKoCount}">
                        <br><br>
                        <h5 class="text-left text-info">LINEAGE GENE COUNT</h5>
                        <table class="table table-striped ajax" style="background-color: seashell">
                            <thead>
                            <tr>
                                <td><strong>Level</strong></td>
                                <td><strong>Clade</strong></td>
                                <td><strong>Gene Count</strong></td>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${levelKoCount}" status="i" var="entry">
                                <tr>
                                    <td>${i+1}</td>
                                    <td>${entry.key}</td>
                                    <td>${entry.value}</td>
                                </tr>
                            </g:each>

                            </tbody>
                        </table>
                        <div class="row">

                            <div class="col-xs-12 text-right">
                                <g:form controller="species" action="speciesOrigin">
                                    <input name="taxid" type="hidden" value="${taxid}">
                                    <input name="exportLineage" type="hidden" value="1">
                                    <button type="submit" class="btn btn-primary ">
                                        <span class="glyphicon glyphicon-download"></span> Download Full Report
                                    </button>
                                </g:form>
                            </div>

                        </div>

                    </g:if>
                </p>


            </div>
        </div>
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



</body>
</html>