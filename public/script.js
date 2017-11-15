function openTime(timeName) {
    var i, content;
    var content = document.getElementsByClassName("tabcontent");
    for (i = 0; i < content.length; i++) {
        content[i].style.display = "none";
    }
    document.getElementById(timeName).style.display = "block";
}


// function openTime(evt, cityName) {
//     var i, tabcontent, timetabs;
//     tabcontent = document.getElementsByClassName("tabcontent");
//     for (i = 0; i < tabcontent.length; i++) {
//         tabcontent[i].style.display = "none";
//     }
//     timetabs = document.getElementsByClassName("timetabs");
//     for (i = 0; i < timetabs.length; i++) {
//         timetabs[i].className = timetabs[i].className.replace(" active", "");
//     }
//     document.getElementById(cityName).style.display = "block";
//     evt.currentTarget.className += " active";
// }