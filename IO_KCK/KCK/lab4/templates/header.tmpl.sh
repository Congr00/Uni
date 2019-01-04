#!/usr/bin/env bash

TITLE=${TITLE:-WyboryApp}
ACTUAL_PAGE=${ACTUAL_PAGE:-Start}

cat <<DOC
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <title>$TITLE</title>

        <link type="text/css" rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link type="text/css" rel="stylesheet" href="css/materialize.min.css"  media="screen,projection"/>
        <link type="text/css" rel="stylesheet" href="css/fix.css"/>        
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    </head>
    <body>


<!-- Dropdown Structure -->
<ul id="dropdown1" class="dropdown-content">
  <li><a href="$LINK1">$LINK1N</a></li>
  <li class="divider"></li>
  <li><a href="$LINK2">$LINK2N</a></li>
  <li class="divider"></li>
  <li><a href="$LINK3">$LINK3N</a></li> 
</ul>
<nav>
  <div class="nav-wrapper">
    <a href="#" data-target="slide-out" class="sidenav-trigger"><i class="material-icons">menu</i></a>
    <ul class="left">
      <!-- Dropdown Trigger -->
      <li><a class="dropdown-trigger" href="#!" data-target="dropdown1">$ACTUAL_PAGE<i class="material-icons right">arrow_drop_down</i></a></li>
    </ul>
  </div>
</nav>


  <ul id="slide-out" class="sidenav">
    <li><a class="waves-effect" href="#!"><i class="material-icons">account_circle</i>Konto</a></li>
    <li><a class="waves-effect" href="#!"><i class="material-icons">accessibility</i>Dostęp</a></li>
    <li><a class="waves-effect" href="#!"><i class="material-icons">assignment_ind</i>Informacje</a></li>
    <li><a class="waves-effect" href="#!"><i class="material-icons">alarm</i>Powiadomienia</a></li>    
    <li><a class="waves-effect" href="#!"><i class="material-icons">error</i>Zgłoś błąd</a></li>       
    <li><a class="waves-effect" href="#!"><i class="material-icons">settings</i>Ustawienia</a></li>            
  </ul>



DOC
