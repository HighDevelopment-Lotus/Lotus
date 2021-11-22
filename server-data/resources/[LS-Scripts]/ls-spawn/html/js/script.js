$(document).on({
  mousemove: function(e){
      e.preventDefault();
      var Image = $(this).data('text')
      if (Image != null && Image != undefined) {
          $('.spawn-text').html(Image)
          $('.spawn-text').show();
          $('.spawn-text').css({
              'top': e.pageY - ($(document).height() / 100) * 9.2,
              'left': e.pageX - ($(document).width() / 100) * 6.5,
          })
      }
  },
  mouseleave: function(e){
      $('.spawn-text').hide();
      $('.spawn-text').html("")
  },
}, ".spawn-dot");

$(document).on('click', '.spawn-dot', function(e){
    e.preventDefault();
    var Dot = $(this).data('dot')
    var Type = $(this).data('type')
    if (Type == 'spawn') {
      $.post('http://ls-spawn/SpawnPlayer', JSON.stringify({
          SpawnId: Dot
      }))
    } else if (Type == 'appartment') {
      $.post('http://ls-spawn/SpawnPlayer', JSON.stringify({
          SpawnId: 'Appartment'
      }))
    } else if (Type == 'jail') {
      $.post('http://ls-spawn/SpawnJail', JSON.stringify({}))
    }
    $.post('http://ls-spawn/Click', JSON.stringify({}))  
    CloseSpawn();
});

$(document).on('click', '.last-location-button', function(e){
    e.preventDefault();
    $.post('http://ls-spawn/SpawnPlayer', JSON.stringify({
      SpawnId: 'LastLocation'
    }))
    $.post('http://ls-spawn/Click', JSON.stringify({}))  
    CloseSpawn();
});

$(document).on('click', '.house-button', function(e){
    e.preventDefault();
    var HouseData = $(this).data('HouseData');
    $.post('http://ls-spawn/SpawnPlayer', JSON.stringify({
      SpawnId: 'House',
      HouseData:  HouseData   
    }))
    $.post('http://ls-spawn/Click', JSON.stringify({}))  
    CloseSpawn();
});

CloseSpawn = function() {
  $('.main-map-container').slideUp(700, function() {
      $('.main-map-container').hide(0);
      $(".jail-dot-container").hide(0);
      $(".spawn-dots-container").hide(0);
      $(".appartment-dot-container").hide(0);
      $(".last-location-container").hide(0);
      $(".houses-container").hide(0);
  });
}

OpenSpawn = function(data) {
    if (!data.injail) {
        $(".spawn-dots-container").show(0);
        $(".appartment-dot-container").show(0);
        $(".houses-container").show(0);
        $(".last-location-container").show(0);
    } else {
        $(".jail-dot-container").show(0);
    }
    $(".houses-container").html("");
    for (const [key, value] of Object.entries(data.housedata)) {   
        var HouseCard = `<div class="house-button" id="spawn-${key}"><i class="fas fa-home"></i> ${value['Label']}</div>`
        $('.houses-container').prepend(HouseCard);
        $("#spawn-"+key).data('HouseData', value);
    }
    $('.main-map-container').slideDown(700);
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "OpenSpawn":
            OpenSpawn(event.data);
            break;
    }
});