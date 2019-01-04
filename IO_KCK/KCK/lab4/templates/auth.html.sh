#!/usr/bin/env bash

TITLE="WyboryApp :: Auth"
export ACTUAL_PAGE="Głosowanie"

export LINK1="index.html"
export LINK1N="Start"
export LINK2="arch.html"
export LINK2N="Archiwum"
export LINK3="kand.html"
export LINK3N="Kandydaci"

export CONTENT=$(cat <<DOC
<div class="start">
    <center><h5> Przybliż swój dowód osobisty do czytnika NFC po prawej, aby kontynuować. </h5></center>
    <center style="margin-top:10vh;">
        <div class="preloader-wrapper big active">
            <div class="spinner-layer spinner-blue-only">
            <div class="circle-clipper left">
                <div class="circle"></div>
            </div><div class="gap-patch">
                <div class="circle"></div>
            </div><div class="circle-clipper right">
                <div class="circle"></div>
            </div>
            </div>
        </div>
    </center>
    <center style="margin-top:10vh">
        <a class="waves-effect waves-light btn-small" href="nauth.html">Skip</a>
    </center>    
</div>
DOC
)