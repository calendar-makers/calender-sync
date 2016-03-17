

var setup_third_party = function() {
    /*Necessary because usually the panel's height depends on the calendar's height.
     Since we momentarily deactivate the calendar, then we reverse the relationship
     and we set the calendar div to the height of the panel.
     Once the calendar comes back, then it's all back to normal flow
     */
    $('#third_events_list_form').outerHeight($('#panel').outerHeight(true));

    var idRadio = $('#search_by_id');
    var groupRadio = $('#search_by_group');
    var idTextField = $('#id');
    var groupTextField = $('#group_urlname');
    var idLabel = $('#id_label');
    var groupLabel = $('#group_label');
    
    idRadio.prop('checked', true);
    idTextField.prop('disabled', false);
    groupTextField.prop('disabled', true);
    groupLabel.addClass('disabled');

    idRadio.on('click', function () {
        idTextField.prop('disabled', false);
        groupTextField.prop('disabled', true);
        groupTextField.val('');
        groupLabel.addClass('disabled');
        idLabel.removeClass('disabled');
    });

    groupRadio.on('click', function () {
        groupTextField.prop('disabled', false);
        idTextField.prop('disabled', true);
        idTextField.val('');
        groupLabel.removeClass('disabled');
        idLabel.addClass('disabled');
    });
};
