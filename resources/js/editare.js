window.addEventListener("DOMContentLoaded", function() {
    let btns_edit = document.getElementsByClassName("editare");

    for (let btn of btns_edit) {
        btn.addEventListener('click', function() {
            let rand = this.parentElement.parentElement;
            let id = Number(rand.getElementsByTagName("td")[0].innerHTML);
            let tabel = window.location.href.split("viz/")[1];


            let coloane = rand.getElementsByTagName("td");
            let inputuri = document.getElementsByClassName("formular")[0].getElementsByTagName("input");

            for(let i = 0; i < coloane.length-2; i++){
                inputuri[i].value = ""; // se reseteaza continutul inputurilor
                coloane[i].innerHTML = coloane[i].innerHTML.trim(); // html poate contine spatii

                if(inputuri[i].type == "number"){
                    if(coloane[i].innerHTML != "null")
                    inputuri[i].value = parseInt(coloane[i].innerHTML);}
                else inputuri[i].value = coloane[i].innerHTML;

            }
        });
    }
});