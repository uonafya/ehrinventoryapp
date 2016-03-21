<script>
    var pDataString;
    jq(function () {

        // Store Status
        var storeStatuses = new Array();
        var statuses = "${listMainStoreStatus}";

        jQuery('.date-pick').datepicker({minDate: '-100y', dateFormat: 'dd/mm/yy'});
        var pData = getIndentList();
        pDataString = JSON.stringify(pData);
        function IndentListViewModel() {
            var self = this;
            self.statusId = ko.observableArray([]);

            // Fetched data
            self.indentItems = ko.observableArray([]);
            var mappedIndentItems = jQuery.map(pData, function (item) {
                return item;
            });

            self.viewDetails = function(item){
                window.location.replace("mainStoreDrugProcessIndent.page?indentId="+item.id);
            }
            self.indentItems(mappedIndentItems);
        }

        var list = new IndentListViewModel();
        ko.applyBindings(list, jq("#transferList")[0]);


    });//end of doc ready function


    function getIndentList(storeId, statusId, indentName, fromDate, toDate, viewIndent, indentId) {
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
                toDate: toDate,
                viewIndent: viewIndent
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

<table id="transferList">
    <select name="storeId" class="searchField" title="Select Drug Store">
        <option value="">Select Store</option>
        <% listStore.each { %>
        <option value="${it.id}" title="${it.name}">
            ${it.name}
        </option>
        <% } %>
    </select>

    <select name="statusId" class="searchField" title="Select Status">
        <option value="">Select Status</option>
        <% listMainStoreStatus.each { %>
        <option value="${it.id}" title="${it.name}">
            ${it.name}
        </option>
        <% } %>
    </select>

    <input type="text" id="indentName" name="indentName" placeholder="Drug Name" class="searchField"
           title="Enter Drug Name"/>
    <label for="fromDate">From</label>
    <input type="text" id="fromDate" class="date-pick searchField" readonly="readonly" name="fromDate"
           title="Double Click to Clear" ondblclick="this.value = '';"/>
    <label for="toDate">To</label>
    <input type="text" id="toDate" class="date-pick searchField" readonly="readonly" name="toDate"
           title="Double Click to Clear" ondblclick="this.value = '';"/>
    <thead>
    <th>S. No</th>
    <th>From Store</th>
    <th>Indent Name</th>
    <th>Created On</th>
    <th>Status Indent</th>
    <th>Action</th>
    </thead>
    <tbody data-bind="foreach: indentItems">
    <td data-bind="text: (\$index() + 1)"></td>
    <td data-bind="text: store.name"></td>
    <td data-bind="text: name"></td>
    <td data-bind="text: createdOn"></td>
    <td data-bind="text: mainStoreStatusName"></td>
    <td><a data-bind="html: mainStoreStatus,click:\$parent.viewDetails"></a></td>
    </tbody>
</table>