window.addEventListener('message', function (event) {
    switch(event.data.action) {
        case 'showNotification':
            ShowAdNotif(event.data);
            break;
        default:
            ShowAdNotif(event.data);
            break;
    }
});

function ShowAdNotif(data) {
    var $notification = $('.notification.template').clone();
    $notification.removeClass('template');
    $notification.addClass('admin');
    $notification.append('<div class="notification-icon"><i class="fas fa-exclamation-circle"></i></div><div class="notification-text"> ' + data.text + ' </div>')
    $notification.fadeIn();
    $('.notif-container').append($notification);
    setTimeout(function() {
        $.when($notification.fadeOut()).done(function() {
            $notification.remove()
        });
    }, 5000);
}