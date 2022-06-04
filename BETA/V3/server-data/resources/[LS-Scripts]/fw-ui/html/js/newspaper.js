var NewspaperOpen = false;

OpenNewsPaper = function() {
    $('.main-newspaper-container').show(125, function() {
        NewspaperOpen = true;
        setTimeout(function(){
            $('.newspaper-container').show(750);
        }, 1400);
    });
}

CloseNewsPaper = function() {
    $('.newspaper-container').hide(250, function() {
        NewspaperOpen = false;
        $('.main-newspaper-container').hide(250);
        $.post('http://fw-ui/CloseMenuSecond', JSON.stringify({clear: true}))
    });
}

AddJailPlayer = function(data) {
    var AddOption = '<div class="recent-arrest-card">'+data.name+' heeft recent een cel straf gekregen van '+data.jailtime+' maand(en)</div>'
    $('.recent-arrests').prepend(AddOption);
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "AddJail":
            AddJailPlayer(event.data)
            break;
        case "OpenPaper":
            OpenNewsPaper()
            break;
    }
});