var InputOpen = false;
var CurrentInputType = null;

OpenInput = function(Data) {
    $('.input-input').val('');
    $('.input-input').focus();
    $('.input-title').html(Data.Title);
    $('.input-logo').html(Data.Logo);
    if (Data.Type === 'number') {
        $('#remove-text').hide();
        CurrentInputType = 'Number';
    } else {
        $('#remove-number').hide();
        CurrentInputType = 'Text';
    }
    $('.main-input-container').show(0, function() {
        setTimeout(function(){
            $(".input-input").focus();
            InputOpen = true
        }, 500);
    }); 
}

CloseInput = function() {
    $('.main-input-container').fadeOut(215, function() {
        InputOpen = false;
        CurrentInputType = null;
        $('#remove-text').show();
        $('#remove-number').show();
        $('.main-input-container').hide(0); 
    }); 
    $.post('http://fw-ui/CloseMenuSecond', JSON.stringify({clear: false}))
}

$(document).on('click', '.input-button-cancel', function(e) {
    e.preventDefault();
    $.post('http://fw-ui/ClickSound', JSON.stringify({}))
    $.post('http://fw-ui/TriggerInput', JSON.stringify({Input: false}))
    CloseInput();
});

$(document).on('click', '.input-button-accept', function(e) {
    e.preventDefault();
    $.post('http://fw-ui/ClickSound', JSON.stringify({}))
    if (CurrentInputType === 'Number') {
        var NumberVal = $('#remove-number').val();
        if (NumberVal > 0) {
            $.post('http://fw-ui/TriggerInput', JSON.stringify({Input: NumberVal}))
            CloseInput();
        }
    } else {
        var TextVal = $('#remove-text').val();
        $.post('http://fw-ui/TriggerInput', JSON.stringify({Input: TextVal}))
        CloseInput();
    }
});

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "input":
            OpenInput(event.data)
            break;
    }
});