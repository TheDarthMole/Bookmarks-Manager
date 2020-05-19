var add_bookmark = document.getElementById('add-bookmark');
var edit_bookmark = document.getElementById('edit-bookmark');
var delete_bookmark = document.getElementById('delete-bookmark');
var report_bookmark = document.getElementById('report-bookmark');

var modalOpen = document.querySelectorAll('a[data-toggle="modal"], button[data-toggle="modal"]');

for (let index = 0; index < modalOpen.length; index++) {
    modalOpen[index].onclick = function(event) {
        event.preventDefault();
        let target = event.currentTarget.getAttribute('data-target');
        switch (target) {
            case "#add-bookmark":
                add_bookmark.style.display = "block";
                break;
            case "#edit-bookmark":
                edit_bookmark.style.display = "block";
                break;
            case "#delete-bookmark":
                delete_bookmark.style.display = "block";
                break;
            case "#report-bookmark":
                report_bookmark.style.display = "block";
            default:
                break;
        }
    }
}

var modalClose = document.querySelectorAll('.modal button[data-dismiss]');

for (let index = 0; index < modalClose.length; index++) {
    modalClose[index].onclick = function() {
        add_bookmark.style.display = "none";
        edit_bookmark.style.display = "none";
        delete_bookmark.style.display = "none";
        report_bookmark.style.display = "none";
    }
}