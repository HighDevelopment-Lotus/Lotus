lsinding = {}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            lsinding.Close();
            break;
    }
});

$(document).ready(function(){

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "openBinding") {
            lsinding.Open(eventData);
        }
    });
});

$(document).on('click', '.save-bindings', function(e){
    e.preventDefault();
    var keyData = {}
    keyData['F2'] = [$("#command-F2").val(), $("#argument-F2").val()]
    keyData['F3'] = [$("#command-F3").val(), $("#argument-F3").val()]
    keyData['F5'] = [$("#command-F5").val(), $("#argument-F5").val()]
    keyData['F6'] = [$("#command-F6").val(), $("#argument-F6").val()]
    keyData['F7'] = [$("#command-F7").val(), $("#argument-F7").val()]
    keyData['F9'] = [$("#command-F9").val(), $("#argument-F9").val()]
    keyData['F10'] = [$("#command-F10").val(), $("#argument-F10").val()]
    $.post('http://fw-cmd/save', JSON.stringify({
        keyData: keyData
    }));
    lsinding.Close();
});

lsinding.Open = function(data) {
    $(".container").fadeIn(150);

    $.each(data.keyData, function(id, keyData){
        var commandString = $(".keys").find("[data-key='" + id + "']").find('#command-'+id)
        var argumentString = $(".keys").find("[data-key='" + id + "']").find('#argument-'+id)

        if (keyData.command != null) {
            $(commandString).val(keyData.command)
        }
        if (keyData.argument != null) {
            $(argumentString).val(keyData.argument)
        }
    });
}

lsinding.Close = function() {
    $(".container").fadeOut(150);
    $.post('http://fw-cmd/close');
}