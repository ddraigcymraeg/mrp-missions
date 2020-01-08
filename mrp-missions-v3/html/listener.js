$(function()
{
    window.addEventListener('message', function(event)
    {
        var item = event.data;
        var buf = $('#wrap');
        buf.find('table').append("<tr class=\"heading\"><th>Name</th><th>Mission Count</th><th>Total Money Earned</th><th>Money Per Mission</th></tr>");
        if (item.meta && item.meta == 'close')
        {
            document.getElementById("ptbl").innerHTML = "";
            $('#wrap').hide();
            return;
        }
        buf.find('table').append(item.text);
        $('#wrap').show();
    }, false);
});