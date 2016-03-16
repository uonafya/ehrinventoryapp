<%
    def props = ["drug.name", "drug.category.name", "formulation.dozage", "currentQuantity", "reorderPoint", "action"]
%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.0/moment.js"></script>
<script>
    jq(function () {
        jq.getJSON('${ui.actionLink("inventoryapp", "StockBalanceExpiry", "viewStockBalanceExpiry")}',
                {
                    "currentPage": 1
                }).success(function (data) {
                    if (data.length === 0 && data != null) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                    } else {
                        updateQueueTable(data)
                    }
                });
    });
</script>
<script>
    //update the queue table
    function updateQueueTable(tests) {
        var jq = jQuery
        jq('#expiry-search-results-table > tbody > tr').remove();
        var tbody = jq('#expiry-search-results-table > tbody');
        var row = '<tr>';
        for (index in tests) {
            var item = tests[index];
            <% props.each {
              if(it == props.last()){ %>
            var pageLinkEdit = emr.pageLink("inventoryapp", "viewStockBalanceDetail", {
                drugId: item.drug.id,
                formulationId: item.formulation.id,
                expiry: 1
            });
            row += '<td> <a title="Detail all transactions of this drug" href="' + pageLinkEdit + '"><i class="icon-arrow-right small" ></i></a>';

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
                <label>Drug Category</label>
                <select name="categoryId" id="categoryId" style="width: 250px;">
                    <option value=""></option>
                </select>

                <label>Drug Name</label>
                <input type="text" name="drugName" id="drugName" value=""/>

                <input type="submit" class="ui-button ui-widget ui-state-default ui-corner-all" value="Search"/>

            </div>
            <br />




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

