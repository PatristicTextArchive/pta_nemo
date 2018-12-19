   var sup = document.getElementById("ss-1");
    sup.onclick = function(event) {

      var footnoteText = this.parentElement.parentElement.getElementsByClassName('note-content');

      footnoteText[0].style.display = 'block';

      event.preventDefault();
    };
