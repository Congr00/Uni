export TITLE="WyboryApp :: Start"
export ACTUAL_PAGE="Start"

export LINK1="auth.html"
export LINK1N="Głosuj"
export LINK2="arch.html"
export LINK2N="Archiwum"
export LINK3="kand.html"
export LINK3N="Kandydaci"


export CONTENT=$(cat <<DOC
<div class="container">
    <div class="row red-text center"><h5>UWAGA: Rozpoczęło się <a href="auth.html"><u><b>GŁOSOWANIE!</b></u></a></h5></div>
    <hr>
    <div class="row">
        <!-- https://materializecss.com/collections.html -->
        <ul class="collection">
            <li class="collection-item">[[2020-10-12]] Rozpoczęło się głosowanie, kliknij <u><a href="auth.html">tutaj</a></u>, aby zagłosować.</li>
            <li class="collection-item">[[2020-11-12]] <b>UWAGA</b>, rozpoczęła się cisza wyborcza!</li>
            <li class="collection-item">[[2020-10-05]] <b>PRZYPOMNIENIE</b> - już za tydzień odbędą się wybory samorządowe. W związku z tym, zakładka <i>Kandydaci</i>  jest już aktywna.</li>
            <li class="collection-item">[[2020-09-12]] Dziś pojawiła się nowa aktualizacja dla WyboryAPP, pamiętaj o zaktualizowaniu! Informacje o zmianach możesz przeczytać pod <u><a href="https://google.com">tym</a></u> linkiem.</li>
            <li class="collection-item">[[2000-00-00]] Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</li>
        </ul>
    </div>
</div>
DOC
)
