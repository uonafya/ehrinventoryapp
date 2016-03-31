<%
	ui.includeJavascript("billingui", "moment.js")
	
    def props = ["drug.name", "drug.category.name", "formulation.dozage", "currentQuantity", "reorderPoint", "action"]
%>

<script>
    jq(function () {

        loadExpiredDrugs();

        //action when the drug category is selected
        jq("#categoryId").on("change", function () {
            var categoryId = jq("#categoryId").val();
            var drugName = jq("#drugName").val();
            loadExpiredDrugs(1, categoryId, drugName);

        });

        jq("#drugName").on("blur", function () {
            var categoryId = jq("#categoryId").val();
            var drugName = jq("#drugName").val();
//            TODO check fragment action for search functionality
            loadExpiredDrugs(1, categoryId, drugName);
        });


    });//end of doc ready

    function loadExpiredDrugs(currentPage, categoryId, drugName) {
        jq.getJSON('${ui.actionLink("inventoryapp", "StockBalanceExpiry", "viewStockBalanceExpiry")}',
                {
                    currentPage: currentPage,
                    categoryId: categoryId,
                    drugName: drugName
                }).success(function (data) {
                    if (data.length === 0 && data != null) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                    } else {
                        updateQueueTable(data);
                    }
                }).error(function () {
                    jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
                    jq('#expiry-search-results-table > tbody > tr').remove();
                    var tbody = jq('#expiry-search-results-table > tbody');
                    var row = '<tr align="center"><td colspan="6">No Drugs found</td></tr>';
                    tbody.append(row);
                });
    }
    //update the queue table
    function updateQueueTable(tests) {
        jq('#expiry-search-results-table > tbody > tr').remove();
        var tbody = jq('#expiry-search-results-table > tbody');

        for (index in tests) {
            var row = '<tr>';
            var item = tests[index];
            <% props.each {
                if(it == props.last()){ %>
                    var pageLinkEdit = emr.pageLink("inventoryapp", "viewStockBalanceDetail", {
                        drugId: item.drug.id,
                        formulationId: item.formulation.id,
                        expiry: 1
                    });
                row += '<td> <a title="Detail all transactions of this drug" href="' + pageLinkEdit + '"><i class="icon-arrow-right small" ></i></a></td>';

            <% } else {%>
                row += '<td>' + item.${ it } + '</td>';
            <% }
              } %>
            row += '</tr>';
            tbody.append(row);
        }
    }
</script>

<div id="expiry-search-results" style="display: block; margin-top:3px;">
    <div role="grid" class="dataTables_wrapper" id="expiry-search-results-table_wrapper">
        <table id="expiry-search-results-table" class="dataTable" aria-describedby="expiry-search-results-table_info">
            <thead>

            <div>
                <label for="categoryId">Drug Category</label>
                <select name="categoryId" id="categoryId" style="width: 250px;">
                    <option value=""></option>
                    <% listCategory.each { %>
                    <option value="${it.id}" title="${it.name}">
                        ${it.name}
                    </option>
                    <% } %>
                </select>

                <label for="drugName">Drug Name</label>
                <input type="text" name="drugName" id="drugName"/>

            </div>
            <br/>




            <tr role="row">
                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">Drug Name<span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">Category<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">Formulation<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">Current Qty<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">Reorder Point<span class="DataTables_sort_icon"></span></div>
                </th>

                <th class="ui-state-default" role="columnheader">
                    <div class="DataTables_sort_wrapper">action<span class="DataTables_sort_icon"></span></div>
                </th>

            </tr>
            </thead>
            <tbody role="alert" aria-live="polite" aria-relevant="all">
            <tr align="center">
                <td colspan="6">No Drugs found</td>
            </tr>
            </tbody>
        </table>

    </div>
</div>

