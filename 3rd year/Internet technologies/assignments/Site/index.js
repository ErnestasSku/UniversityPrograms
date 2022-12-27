
$(document).ready(() => {

    $("#font-small").click(() => {
        $('*').each(function() {
            let k = parseInt($(this).css('font-size'));
            $(this).css('font-size', k-1);
        })
    });

    $("#font-large").click(() => {
        $('*').each(function() {
            let k = parseInt($(this).css('font-size'));
            $(this).css('font-size', k+1);
        })
    });



});