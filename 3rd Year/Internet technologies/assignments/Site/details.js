
let commentNum = 0;
$(document).ready(() => {

    $('#commentButton').click(() => {
        let text = $('#commentArea').val();
        $('#commentArea').val('');

        $('#commentSection').append("<p id=comment_"+ commentNum +"   onclick=delComment(" + commentNum + ")>" + text + "<p>");
        commentNum += 1;
    })

});

function delComment(args) {
    console.log("#comment_" + args);
    $("#comment_" + args).remove();
}