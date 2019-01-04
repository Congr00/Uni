#!/usr/bin/env bash

TITLE="WyboryApp :: NAuth"
export ACTUAL_PAGE="Głosowanie"

export LINK1="index.html"
export LINK1N="Start"
export LINK2="arch.html"
export LINK2N="Archiwum"
export LINK3="kand.html"
export LINK3N="Kandydaci"

export CONTENT=$(cat <<DOC

<div class="container">
    <div class="row red-text center"><h5>GŁOSOWANIE XXX</h5></div>
    <hr>
    <form action="#">
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 1</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 2</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 3</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 4</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 5</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 6</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 7</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s1 offset-s1">
                <p>
                <label>
                    <input type="checkbox" />
                            <span></span>
                </label>
                </p>            
            </div>
            <div class="col s2"><img src="img/profile.png" /></div>
            <div class="col s6"><a href="about.html"><h5>Pan Numer 8</h5></a></div>
            <div class="col s1"><a class="waves-effect waves-light btn-small" style="margin-top:2vh" href="about.html">Info</a></div>
        </div>
        <div class="row nkand2">
            <div class="col s12" style="text-align:center;">
            <button class="btn waves-effect waves-light" type="submit" name="action">Oddaj głos
            </button>
            </div>
        </div>
    </form>



</div>
DOC
)
