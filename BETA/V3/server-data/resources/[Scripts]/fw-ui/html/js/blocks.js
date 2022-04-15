var BlocksOpen = false;

window.timeBlocksShows = 4.5; //4.5sec
window.correctBlocksNum = 14;
window.maxIncorrectBlocksNum = 3;
window.allBlocksNum = 36;
$(document.body).on("click", ".block", onBlockClick);

function generateRandomNumberBetween(min=1,max=window.allBlocksNum,length = window.correctBlocksNum){
    var arr = [];
    while(arr.length < length){
        var r = Math.floor(Math.random() * (max+1-min)) + min;
        if(arr.indexOf(r) === -1) arr.push(r);
    }
    return arr;
}

function onBlockClick(e) {
    if(!activateClicking) {
      return;
    }
    let clickedBlock = e.target;
    let blockNum = clickedBlock.classList.value.match(/(?:block-)(\d+)/)[1];
    blockNum = Number(blockNum);
    let correctBlocks = window.gridCorrectBlocks;
    let correct = correctBlocks.indexOf(blockNum) !== -1;
    clickedBlock.classList.add("clicked");
    if (correct) {
      clickedBlock.classList.remove("incorrect");
      clickedBlock.classList.add("correct");
    } else {
      clickedBlock.classList.add("incorrect");
      clickedBlock.classList.remove("correct");
    }
    $.post('http://fw-ui/ClickSound', JSON.stringify({}))
    CheckWinLost();
}

ShowCorrectBlocks = function() {
    $(".block").each((i,ele)=>{
      let blockNum = ele.classList.value.match(/(?:block-)(\d+)/)[1];
      blockNum = Number(blockNum);
      let correctBlocks = window.gridCorrectBlocks;
      let correct = correctBlocks.indexOf(blockNum) !== -1;
      if (correct) {
        ele.classList.add("show");
      }
    });
}

HideAllBlocks = function() {
    $(".block").each((i,ele)=>{
      ele.classList.remove("show");
      ele.classList.remove("correct");
      ele.classList.remove("incorrect");
      ele.classList.remove("clicked");
    });
}

CheckWinLost = function() {
    if (WonGame()) {
        BlocksOpen = false;
        $(".grid").addClass("won");
        window.activateClicking = false;
        setTimeout(()=>{
            StopBlocks();
            $.post('http://fw-ui/WonBlocksGame', JSON.stringify({}))
        }, 2000);
    } else if (LostGame()) {
        BlocksOpen = false;
        $(".grid").addClass("lost");
        ShowCorrectBlocks();
        window.activateClicking = false;
        setTimeout(()=>{
            StopBlocks();
            $.post('http://fw-ui/LostBlocksGame', JSON.stringify({}))
        }, 2000);
    }
}

WonGame = function() {
    return $(".correct").length >= window.correctBlocksNum;
}

LostGame = function() {
    return $(".incorrect").length >= window.maxIncorrectBlocksNum;
}

StartBlocks = function() {
    $('.main-blocks-container').slideDown(350, function() {
        BlocksOpen = true;
        window.gridCorrectBlocks = generateRandomNumberBetween();
        window.activateClicking = false;
        ShowCorrectBlocks();
        setTimeout(() => {
            HideAllBlocks();
            window.activateClicking = true;
        }, timeBlocksShows * 1000);
    });
}

StopBlocks = function() {
    HideAllBlocks();
    $(".grid").removeClass("won");
    $(".grid").removeClass("lost");
    $('.main-blocks-container').slideUp(350);
}

StopBlocksGame = function() {
    $(".grid").addClass("lost");
    ShowCorrectBlocks();
    window.activateClicking = false;
    setTimeout(()=>{
        StopBlocks();
        BlocksOpen = false;
        $.post('http://fw-ui/LostBlocksGame', JSON.stringify({}))
    }, 2000);
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "blocks-start":
            StartBlocks()
            break;
    }
});