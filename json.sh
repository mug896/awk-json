#!/usr/bin/env -S gawk -E

BEGIN {
    RS="(.)"
    INDENT = 2;
    keyword["true"]; keyword["false"]; keyword["null"]
    token[0] = opt1 = opt2 = ""
    idx = sdx = 0
}

BEGINFILE {
    if ( FILENAME ~ /^-k$|^-s$/ ) { opt1 = FILENAME; nextfile }
    if ( opt1 == "-s" && opt2 == "" ) { opt2 = FILENAME; nextfile }
}

{ tokenize(RT) }

END { 
    if (opt1) search(0, ""); else pretty_print(0)
}


function search (start, path, sblock,       ckey, key, val) {
    for (sdx = start; sdx < idx; sdx++) { 
        switch (token[sdx]) {
            case "{" :
            case "[" : 
                search( sdx + 1, path "/" ckey, sdx)
                break
            case "}" :
            case "]" : return
            case ":" : 
                ckey = gensub( /^"(.*)"$/, "\\1", "g", token[sdx - 1])
                key  = gensub( /\/{2,}/, "/", "g", path "/" ckey)
                if ( opt1 == "-k" ) print key 
                else if ( opt1 == "-s" ) {
                    if ( opt2 == key ) {
                        switch( token[sdx + 1] ) {
                            case "[" :
                            case "{" : pretty_print(sdx + 1); break
                            default  : print token[sdx + 1]
                        }
                    } else {
                        val = gensub( /^"(.*)"$/, "\\1", "g", token[sdx + 1])
                        if ( opt2 == key "=" val ) pretty_print(sblock)
                    }
                }
        }
    }
}

function tokenize (char) {
    switch (char) {
        case /{|}|\[|]|:|,/  : token[idx++] = char; break
        case "\""            : t_string(); break
        case /[0-9-]/        : t_number(char); break
        case /[a-z]/         : t_keyword(char); break
    }
}

function t_keyword (str) {
    while (getline) {
        if ( RT ~ /[a-z]/ ) str = str RT
        else {
            if ( str in keyword ) token[idx++] = str
            break
        }
    }
    tokenize(RT)
}

function t_number (str) {
    while (getline) {
        if ( RT ~ /[0-9.eE+-]/ ) str = str RT
        else {
            token[idx++] = str
            break
        }
    }
    tokenize(RT)
}

function t_string (    str, prev) {
    while (getline) {
        if ( RT != "\"" ) str = str RT
        else {
            if ( prev == "\\" ) str = str RT
            else {
                token[idx++] = "\"" str "\""
                break
            }
        }
        prev = RT
    }
}

function space (depth,   i, sp) { 
    depth = depth * INDENT
    for (i=0; i < depth; i++) sp = sp " "
    return sp
}

function pretty_print (start,    i, depth, prev, cur) {
    for (i = start; i < idx; i++) {
        prev = cur; cur = token[i]
        switch (cur) {
            case "{" : 
                printf (prev == ":" ? "" : "\n" space(depth)) "{"
                depth++; break
            case "}" : 
                depth--
                printf (prev == "{" ? " " : "\n" space(depth)) "}"
                break
            case "[" : 
                printf (prev == ":" ? "" : "\n" space(depth)) "["
                depth++; break
            case "]" : 
                depth--
                printf (prev == "[" ? " " : "\n" space(depth)) "]"
                break
            case "," : printf ","; break
            case ":" : printf ": "; break
            default : 
                printf (prev == ":" ? "" : "\n" space(depth)) cur
        }
        if (depth == 0) break
    }
    print
}
