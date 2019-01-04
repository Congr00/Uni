#!/usr/bin/env bash

TITLE="WyboryApp :: Start"

export ACTUAL_PAGE="Rozpocznij"

export CONTENT=$(cat <<DOC
<div class="start">
    <center><h1> WyboryAPP </h1></center>
    <center>
        <a class="waves-effect waves-light btn-large" href="index.html">Rozpocznij</a>
    </center>
</div>
DOC
)