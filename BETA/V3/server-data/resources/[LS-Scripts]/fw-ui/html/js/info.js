ShowInfo = function(data) {
    $('.info-title').html(data['Title']);
    for (const [key, value] of Object.entries(data['Items'])) {
        var AddOption = `<div class="info-desc">${value['Text']}</div>`
        $('.info-desc-container').append(AddOption);
    }
    $('.main-info-container').slideDown(350)
}

EditInfo = function(data) {
    $('.info-title').html(data['Title']);
    for (const [key, value] of Object.entries(data['Items'])) {
        var AddOption = `<div class="info-desc">${value['Text']}</div>`
        $('.info-desc-container').append(AddOption);
    }
}

RemoveInfo = function() {
    $('.main-info-container').slideUp(350, function() {
        $('.info-title').html('');
        $('.info-desc-container').html('');
    })
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "ShowInfo":
            ShowInfo(event.data.data);
            break;
        case "EditInfo":
            ShowInfo(event.data.data);
            break;
        case "RemoveInfo":
            RemoveInfo();
            break;
    }
});