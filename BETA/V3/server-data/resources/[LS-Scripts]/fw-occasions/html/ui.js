QBOccasions = {}

$(document).ready(function(){
    $('.sell-container').hide();
    $('.buy-container').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "sellVehicle") {
            $('.sell-container').fadeIn(150);
            QBOccasions.setupSellContract(eventData)
        }

        if (eventData.action == "buyVehicle") {
            $('.buy-container').fadeIn(150);
            QBOccasions.setupBuyContract(eventData, eventData.vehicleData)
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            $('.sell-container').fadeOut(100);
            $('.buy-container').fadeOut(100);
            $.post('https://fw-occasions/close');
            break;
    }
});

$(document).on('click', '#sell-vehicle', function(){
    if ($('.vehicle-sell-price').val() != "") {
        if (!isNaN($('.vehicle-sell-price').val())) {
            $.post('https://fw-occasions/sellVehicle', JSON.stringify({
                price: $('.vehicle-sell-price').val(),
                desc: $('.vehicle-description').val()
            }));
        
            $('.sell-container').fadeOut(100);
            $.post('https://fw-occasions/close');
        } else {
            $.post('https://fw-occasions/error', JSON.stringify({
                message: "Bedrag moet bestaan uit cijfers.."
            }))
        }
    } else {
        $.post('https://fw-occasions/error', JSON.stringify({
            message: "Vul een bedrag in.."
        }))
    }
});

$(document).on('click', '#buy-vehicle', function(){
    $.post('https://fw-occasions/buyVehicle');
    $('.buy-container').fadeOut(100);
    $.post('https://fw-occasions/close');
});

QBOccasions.setupSellContract = function(data) {
    $("#seller-name").html(data.pData.charinfo.firstname + " " + data.pData.charinfo.lastname);
    $("#seller-banknr").html(data.pData.charinfo.account);
    $("#seller-telnr").html(data.pData.charinfo.phone);
    $("#vehicle-plate").html(data.plate);
}

QBOccasions.setupBuyContract = function(data, vData) {
    $("#buy-seller-name").html(data.sellerData.charinfo.firstname + " " + data.sellerData.charinfo.lastname);
    $("#buy-seller-banknr").html(data.sellerData.charinfo.account);
    $("#buy-seller-telnr").html(data.sellerData.charinfo.phone);
    $("#buy-vehicle-plate").html(vData.plate);
    $("#buy-vehicle-desc").html(vData.desc);
    $("#buy-price").html("&euro;" + vData.price);
}

function calculatePrice() {
    var priceVal = $('.vehicle-sell-price').val();
    
    $('#tax').html("&euro; " + (priceVal / 100 * 19).toFixed(0));
    $('#mosley-cut').html("&euro; " + (priceVal / 100 * 4).toFixed(0));
    $('#total-money').html("&euro; " + (priceVal / 100 * 77).toFixed(0));
}