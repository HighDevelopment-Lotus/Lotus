var HistoryOpen = false
var ActiveAlerts = 0

SendAlert = function(data) {
    var Alert = '<div class="alert animatein" id="alert-'+data['AlertId']+'" data-id="'+data['AlertId']+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    if (data['Type'] == 'Danger') {
        Alert = '<div class="alert animatein" id="alert-'+data['AlertId']+'" data-id="'+data['AlertId']+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger emergency"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    } else if (data['Type'] == 'Almost') {
        Alert = '<div class="alert animatein" id="alert-'+data['AlertId']+'" data-id="'+data['AlertId']+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger almost"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    } else if (data['Type'] == 'Red') {
        Alert = '<div class="alert animatein" id="alert-'+data['AlertId']+'" data-id="'+data['AlertId']+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger red"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    } else {
        Alert = '<div class="alert animatein" id="alert-'+data['AlertId']+'" data-id="'+data['AlertId']+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger blue"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    }
    $('.alerts-container').prepend(Alert)
    $("#alert-"+data['AlertId']).data('AlertData', data);
    ActiveAlerts = ActiveAlerts + 1
    setTimeout(function() {
         $('#alert-'+data['AlertId']).removeClass('animatein');
         $('#alert-'+data['AlertId']).addClass('animateout');
         setTimeout(function() {
            $('#alert-'+data['AlertId']).remove();
            ActiveAlerts = ActiveAlerts - 1
            if (ActiveAlerts == 0 || ActiveAlerts < 0) {
                ActiveAlerts = 0
                if (!HistoryOpen) {
                    $.post('http://ls-alerts/NoActiveAlerts', JSON.stringify({}))
                }
            }
        },  485);
    },  7500);
}

AddHistory = function(data) {
    var RandomId = Math.floor(Math.random() * 100000)
    var Alert = '<div class="alert animatein" id="alert-'+RandomId+'" data-id="'+RandomId+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    if (data['Type'] == 'Danger') {
        Alert = '<div class="alert animatein" id="alert-'+RandomId+'" data-id="'+RandomId+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger emergency"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    } else if (data['Type'] == 'Almost') {
        Alert = '<div class="alert animatein" id="alert-'+RandomId+'" data-id="'+RandomId+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger almost"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    } else if (data['Type'] == 'Red') {
        Alert = '<div class="alert animatein" id="alert-'+RandomId+'" data-id="'+RandomId+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger red"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    } else {
        Alert = '<div class="alert animatein" id="alert-'+RandomId+'" data-id="'+RandomId+'"><div class="alert-title"><span class="alert-callsign">'+data['Code']+'</span>'+data['Title']+'<div class="alert-danger blue"></div><span class="alert-marker"><i class="fas fa-map-marked-alt"></i></span></div><div class="alert-data">'+data['Desc']+'</div></div>'
    }
    $('.alerts-history-container').prepend(Alert)
    $("#alert-"+RandomId).data('AlertData', data);
}

OpenPreviousAlerts = function() {
    $('.alerts-container').hide(250, function() {
        $('.alerts-history-container').show(250);
        $('.alerts-history-container').animate({scrollTop: 1}, 150);
        HistoryOpen = true
    });
}

RemovePreviousAlerts = function() {
    $('.alerts-history-container ').hide(250, function() {
        $('.alerts-container').show(250);
        HistoryOpen = false
    });
}

$(document).on('click', '.alert-marker', function(e) {
    e.preventDefault();
    var AlertId = $(this).parent().parent().data('id');
    var AlertData = $("#alert-"+AlertId).data('AlertData');
    $.post('http://ls-alerts/SetGps', JSON.stringify({Coords: AlertData['Coords']}))
});

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "SendAlert":
            SendAlert(event.data.alertdata)
            AddHistory(event.data.alertdata)
            break;
        case "OpenPrevious":
            OpenPreviousAlerts();
            break;
    }
});

document.onkeyup = function (data) {
    if (data.which == 27) { // Escape
        $.post('http://ls-alerts/CloseAlerts', JSON.stringify({}))
        RemovePreviousAlerts()
    }
};