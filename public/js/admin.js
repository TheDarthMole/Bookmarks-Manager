var tabs = document.querySelectorAll('a[data-toggle="tab"]');

for (let index = 0; index < tabs.length; index++) {
    tabs[index].onclick = function(event) {
        event.preventDefault();

        for (let inner = 0; inner < tabs.length; inner++) {
            tabs[inner].classList.value = "nav-link"
        }
        tabs[index].classList.value += " active";

        let tabPane = document.querySelectorAll('.tab-pane.fade');
        let currentTabPane = tabs[index].innerText;
        switch (currentTabPane) {
            case "Active":
                tabPane[0].classList.value += " show active";
                tabPane[1].classList.value = "tab-pane fade";
                tabPane[2].classList.value = "tab-pane fade";
                break;
            case "Suspended":
                tabPane[0].classList.value = "tab-pane fade";
                tabPane[1].classList.value += " show active";
                tabPane[2].classList.value = "tab-pane fade";
                break;
            case "Pending":
                tabPane[0].classList.value = "tab-pane fade";
                tabPane[1].classList.value = "tab-pane fade";
                tabPane[2].classList.value += " show active";
                break;
            default:
                break;
        }
    }
}