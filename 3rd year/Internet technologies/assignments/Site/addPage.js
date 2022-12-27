
let rowCount = 0;

$(document).ready(function() {
    $('input').first().prop('required',true);
    
    $('#allowGuest').click(() => {
        if ($('#allowGuest').prop('checked')) {
            $('#guestblock').css('display', 'inline');
        } else {
            $('#guestblock').css('display', 'none');
        }
    })


    $('#submitbtn').click(function(event) {
        console.log(event);
        let match = $('input').filter(function() {return $(this).prop('required')})
        let requiredCheck =  match.val() != '';

        let positiveCheck = $("#maintenenceDays").val() >= 0;

        let validDate = new Date($("#timeFrame").val()) != "InvalidDate";

        if (requiredCheck && positiveCheck && validDate) {
            return true;
        }
        return false;        
    });

    $("form").on("submit", function (e) {
        e.preventDefault();

        console.log('sub')
        let mac = $("#macId").val();
        let logo = $("#preferedLogo").val();
        let maint = $("#maintenenceDays").val();
        let guest = $("#allowGuest").prop('checked');
        let time = $("#timeFrame").val();
        let email = $("#email").val();
        let contact = $("#contantInfo").val();


        const data = {
            mac: mac,
            logo: logo,
            maint: maint,
            guest: guest,
            time: time,
            email: email,
            contact: contact
        };


        $.ajax({
            url: 'https://jsonblob.com/api/jsonBlob',
            type: 'post',
            data: JSON.stringify(data),
            headers : {
                "Content-Type" : "application/json",
                "Accept" : "application/json"
            },
            dataType: 'json',
            success: function(data, status, xhr) {
                let location = xhr.getResponseHeader('Location');
                console.log(location);
                $("#links").append("<p>" + location + "</p>");
            }
        })
    });

    $("#rssBtn").click(function() {
        let link = $("#rssInput").val();

        $.ajax({
            url: link,
            type: 'get',
            headers : {
                "Accept" : "application/json"
            },
            dataType: 'json',
            success: function(data, status, xhr) {

                $("table tr:last").after(`
                <tr>
                    <td>` + rowCount++ +`</td>
                    <td>`+ data.mac + `</td>
                    <td>`+ data.logo + `</td>
                    <td>`+ data.maint + `</td>
                    <td>`+ data.guest + `</td>
                    <td>`+ data.time + `</td>
                    <td>`+ data.email + `</td>
                    <td>`+ data.contact + `</td>
                <tr>
                `)
            }
        })
    });
});
