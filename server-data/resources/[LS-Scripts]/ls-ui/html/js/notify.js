AddStickyNotify = function(data) {

}

AddNotify = function(data) {
    var RandomId = Math.floor(Math.random() * 100000)
    var SendNotify = ``
    if (data['Type'] == 'success') {
        SendNotify = `<div class="notify green" id="notify-${RandomId}">${data['Message']}</div>`
    } else if (data['Type'] == 'error') {
        SendNotify = `<div class="notify red" id="notify-${RandomId}">${data['Message']}</div>`
    } else if (data['Type'] == 'primary') {
        SendNotify = `<div class="notify blue" id="notify-${RandomId}">${data['Message']}</div>`
    } else if (data['Type'] == 'info') {
        SendNotify = `<div class="notify orange" id="notify-${RandomId}">${data['Message']}</div>`
    }
    $('.main-notify-container').prepend(SendNotify);
    $('#notify-'+RandomId).fadeOut(0, function() {
        $('#notify-'+RandomId).fadeIn(1500, function() {
            setTimeout(function() {
                $('#notify-'+RandomId).fadeOut(1000, function() {
                    $('#notify-'+RandomId).remove();
                });
            }, data['TimeOut'] != null ? data['TimeOut'] : 2500);
        });
    });
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "AddNotify":
            AddNotify(event.data.data)
            break;
        case "AddStickyNotify":
            AddStickyNotify(event.data)
            break;
    }
});