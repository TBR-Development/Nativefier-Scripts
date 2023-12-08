---
title: Home
layout: home
permalink: /
nav_order: 1
---
<head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"> </script> 
<script> 

    $(function() {


   var people = []; 

   $.getJSON('credits.json', function(data) {
       $.each(data.credits, function(i, f) {
          var tblRow = "<tr>" + "<td>" + f.contributors + "</td>" +
           "<td>" + f.contributions + "</td>" + "<td>" + f.platforms + "</td>"  + "</tr>"
           $(tblRow).appendTo("#userdata tbody");
     }); 

   }); 

});
</script>
</head> 
<body> 
<div class="wrapper">
<div class="profile">
  <table id= "userdata" border="2">
    <thead>
      <th>Contributors</th>
      <th>Contributions</th>
      <th>Platforms</th>
    </thead>
    <tbody> 
    </tbody>
  </table> 
</div>
</div> 
</body>
