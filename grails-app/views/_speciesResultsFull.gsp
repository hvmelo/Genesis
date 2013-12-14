<g:if test="${results}">
    <table class="table table-striped ajax" style="background-color: #ffffff">
        <thead>
        <tr>
            <g:sortableColumn property="ko" title="KO" />
            <g:sortableColumn property="ko_description" title="KO Description" />
            <g:sortableColumn property="lca_name" title="Clade of origin" />
            <g:sortableColumn property="lca_txid" title="Taxid of origin " />
        </tr>
        </thead>
        <tbody>
        <g:each in="${results}" status="i" var="row">
            <tr>
                <td>${row[0]}</td>
                <td>${row[1]}</td>
                <td>${row[2]}</td>
                <td>${row[3]}</td>
            </tr>
        </g:each>
        </tbody>
    </table>

    <div class="pagination">
        <g:paginate total="${totalRows}" />
    </div>

    <g:form controller="KOOrigin" action="origin">
        <input name="ko" type="hidden" value="${ko}">
        <input name="export" type="hidden" value="1">
        <p class="text-right"><button type="submit" class="btn btn-primary ">
            <span class="glyphicon glyphicon-download"></span> Download
        </button></p>
    </g:form>
</g:if>