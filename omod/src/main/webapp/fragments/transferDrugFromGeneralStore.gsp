<script>
    var pDataString;
    jq(function(){
        var pData = getIndentList();
        pDataString = JSON.stringify(pData);
        function IndentListView(){
            var self = this;
            // Fetched data
            self.indentItems = ko.observableArray([]);
            var mappedIndentItems = jQuery.map(pData, function (item) {
                return item;
            });
            self.indentItems(mappedIndentItems);
        }

        var list = new IndentListView();
        ko.applyBindings(list, jq("#transferList")[0]);

    });//end of doc ready function


    function getIndentList(indentId, storeId, statusId, indentName, fromDate,toDate,viewIndent) {
        var toReturn;
        jQuery.ajax({
            type: "GET",
            url: '${ui.actionLink("inventoryapp", "transferDrugFromGeneralStore", "getIndentList")}',
            dataType: "json",
            global: false,
            async: false,
            data: {
                indentId: indentId,
                storeId: storeId,
                statusId: statusId,
                indentName: indentName,
                fromDate: fromDate,
                toDate:toDate,
                viewIndent:viewIndent
            },
            success: function (data) {
                if (data.length === 0 && data != null) {
                    jq().toastmessage('showNoticeToast', "No drug found!");
                } else {
                    toReturn = data;
                }

            },
            error: function () {
                jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
                jq('#transferList > tbody > tr').remove();
                var tbody = jq('#transferList > tbody');
                var row = '<tr align="center"><td colspan="6">No Drugs found</td></tr>';
                tbody.append(row);
            }
        });
        return toReturn;
    }
</script>
<select name="storeId">
    <option value="">Select Store</option>
    <% listStore.each { %>
    <option value="${it.id}" title="${it.name}">
        ${it.name}
    </option>
    <% } %>
</select>

<select name="statusId">
    <option value="">Select Status</option>
    <% listMainStoreStatus.each { %>
    <option value="${it.id}" title="${it.name}">
        ${it.name}
    </option>
    <% } %>
</select>

<input type="text" id="indentName" name="indentName" placeholder="Drug Name"/>
${ui.includeFragment("uicommons", "field/datetimepicker", [id: 'fromDate', label: 'From', formFieldName: 'date picker', useTime: false])}
${ui.includeFragment("uicommons", "field/datetimepicker", [id: 'toDate', label: 'To', formFieldName: 'date picker', useTime: false])}
<table id="transferList">
    <thead>
    <th>S. No</th>
    <th>From Store</th>
    <th>Indent Name</th>
    <th>Created On</th>
    <th>Status Indent</th>
    <th>Action</th>
    </thead>
    <tbody data-bind="foreach: indentItems">
    <td data-bind="text: \$index"></td>
    <td data-bind="text: store.name"></td>
    <td data-bind="text: name"></td>
    <td data-bind="text: createdOn"></td>
    <td data-bind="text: mainStoreStatusName"></td>
    <td data-bind="text: mainStoreStatus"></td>
    </tbody>
</table>